/*
 * Placeholder PetaLinux user application.
 * Author: VUX
 * WavegenTool is application used for creating sine wave and controlling data transfer in FPGA
 */
#include <stdio.h>
#include <string.h>
#include <math.h>
#include <sys/mman.h>
#include <stdint.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

/*FPGA CORE ADDRESS*/
#define BRAM_BASE_ADDR 0x40000000
#define BRAM_SIZE 0x2000 /*8 KB*/

#define GPIO_BASE_ADDR 0x50000000
#define GPIO_SIZE 0x1000

/*More Parameters*/
#define SAMPLE_RATE 50000000
#define OUTPUT_DIR 	"/tmp/"

/*For Logger*/
#define ANSI_COLOR_RED     "\x1b[31m"
#define ANSI_COLOR_GREEN   "\x1b[32m"
#define ANSI_COLOR_YELLOW  "\x1b[33m"
#define ANSI_COLOR_BLUE    "\x1b[34m"
#define ANSI_COLOR_MAGENTA "\x1b[35m"
#define ANSI_COLOR_CYAN    "\x1b[36m"
#define ANSI_COLOR_RESET   "\x1b[0m"

/*Logger*/
/*ERROR: Red string, INFO: GREEN string, WARN: Yellow string*/
#define pri_err(message, fp, line, ...) \
   	fprintf(fp, ANSI_COLOR_RED "[ERROR] " "#%d-" message " " ANSI_COLOR_RESET "\n", line, ##__VA_ARGS__);
#define pri_info(message, fp, line, ...) \
	fprintf(fp, ANSI_COLOR_GREEN "[INFO] " "#%d-" message " " ANSI_COLOR_RESET "\n", line, ##__VA_ARGS__);
#define pri_warn(message, fp, line, ...) \
   	fprintf(fp, ANSI_COLOR_YELLOW "[WARNING] " "#%d-" message " " ANSI_COLOR_RESET "\n", line, ##__VA_ARGS__);

/*Create a sine wave and then store date in a file*/
int create_sin_wave(int freq) {
	
	char filename[1024];
	FILE *fp;
	int i;

	/*Valid range for freq: (0, SAMPLE_RATE/2] as Nyquist requirement*/
	if ((freq > SAMPLE_RATE/2) || (freq <= 0)) {
		pri_err("%d Hz is out of valid range", stdout, __LINE__, freq);
		return -1;
	}
	/*Get filename*/
	sprintf(filename, "%ssine_%0.2fkhz.csv", OUTPUT_DIR, (float) freq/1000.0);

	/*Open file for storage*/
	fp = fopen(filename, "w");
	if (fp == NULL) {
		pri_err("Fail to create file %s", stdout, __LINE__, filename);
		return -1;
	}
	else {
		pri_info("Create file %s", stdout, __LINE__, filename);
	}
	fprintf(fp, "%d\n", freq);

	/*x = sin(2*pi*f)*/
	while ( ((float) i * freq / SAMPLE_RATE) < 1) {
		fprintf(fp, "%0.5f\n", sin((float) 2 * M_PI * freq * i / SAMPLE_RATE));
		i++;
	}
	pri_info("%d samples are storage in %s", stdout, __LINE__, i, filename);
	fclose(fp);
	return 0;
}

/*Load data from file to BRAM in FPGA*/
int set_bram_dat(char *filename) {
	pri_info("Input data will load from %s", stdout, __LINE__, filename);
	FILE *fp;
	int freq, sample_b, i = 0, fd, ret;
	float sample;
	volatile uint32_t* bram_ptr;
	uint32_t paddr = BRAM_BASE_ADDR;
    paddr &= ~(getpagesize() - 1);

	fp = fopen(filename, "r");
	if (fp == NULL) {
		pri_err("Fail to open file %s", stdout, __LINE__, filename);
		return -1;
	}
	else {
		pri_info("Open file %s", stdout, __LINE__, filename);
	}

	fscanf(fp, "%d\n", &freq);
	pri_info("Frequency: %d Hz", stdout, __LINE__, freq);

	/*Use /dev/mem and mmap() for accessing a memory region from userspace*/
	fd = open("/dev/mem", O_RDWR);
    if (fd < 0) {
        pri_err("could not open /dev/mem!", stdout, __LINE__);
        return -1;
    }

    /*bram_ptr holds BRAM's virtual memory*/
	bram_ptr = (uint32_t *) mmap(NULL, BRAM_SIZE, 
								PROT_READ | PROT_WRITE, MAP_SHARED, fd, paddr);
	if (bram_ptr == MAP_FAILED) {
		close(fd);
		pri_err("could not map memory for axilite bus", stdout, __LINE__);
		return -1;
	}

	while ((fscanf(fp, "%f\n", &sample) != EOF) && (i < BRAM_SIZE)) {
		sample_b = sample * pow(2,12);
		/*Write to BRAM*/
		printf("%d: %f 0x%08x\n", i, sample, sample_b);
		*bram_ptr = sample_b; /*Write to BRAM*/
		i++;
	}
	fclose(fp);

	ret = munmap((void*) bram_ptr, BRAM_SIZE);
	if (ret < 0) {
        pri_err("could not unmap memory region for axilite bus", stdout, __LINE__);
		return -1;
		close(fd);
	}
	return 0;
}

/*Send command to start transfer data*/
int start_transfer(int n) {
	volatile uint32_t* gpio_ptr;
	uint32_t paddr = GPIO_BASE_ADDR;
    paddr &= ~(getpagesize() - 1);
    int fd, ret;

    /*Use /dev/mem and mmap to accessing GPIO Core in FPGA*/
    fd = open("/dev/mem", O_RDWR);
    if (fd < 0) {
        pri_err("could not open /dev/mem!", stdout, __LINE__);
        return -1;
    }
    gpio_ptr = (uint32_t *) mmap(NULL, GPIO_SIZE, 
								PROT_READ | PROT_WRITE, MAP_SHARED, fd, paddr);

    if (gpio_ptr == MAP_FAILED) {
		close(fd);
		pri_err("could not map memory for axilite bus", stdout, __LINE__);
		return -1;
	}

    *(gpio_ptr + 8) = n;

    /*Trigger start*/
    *gpio_ptr = 1;
    usleep(1000);
    *gpio_ptr = 0;

    ret = munmap((void*) gpio_ptr, BRAM_SIZE);
	if (ret < 0) {
        pri_err("could not unmap memory region for axilite bus", stdout, __LINE__);
		return -1;
		close(fd);
	}
	return 0;
}

/*Show usage information*/
void usage(int argc, char *argv[]) {
	printf("Usage:\n");
	printf("\t%s -c <freq>:\tcreate sine wave with frequency <freq> Hz\n", argv[0]);
	printf("\t%s -l <dir>: \tdata from <dir> will be load into BRAM>\n", argv[0]);
	printf("\t%s -r N: \tstart transfer N samples\n", argv[0]);
	printf("\t%s -h/--help:\thelp\n", argv[0]);
}

int main(int argc, char *argv[]) {

	int arg, ret;
	/*Decode commands*/
	/*-c <F>*/
	if (!strcmp(argv[1], "-c")) {
		if (argc != 3) goto error_systax;
		arg = strtol(argv[2],NULL,0);
		ret = create_sin_wave(arg);
	}
	/*-l <input file>*/
	else if (!strcmp(argv[1], "-l")) {
		if (argc != 3) goto error_systax;
		ret = set_bram_dat(argv[2]);
	}
	/*-r <N>*/
	else if (!strcmp(argv[1], "-r")) {
		if (argc != 3) goto error_systax;
		arg = strtol(argv[2],NULL,0);
		ret = start_transfer(arg);
	}
	/*-h or --help*/
	else if (!strcmp(argv[1], "-h") || !strcmp(argv[1], "--help")) {
		usage(argc, argv);
	}

	return ret;

error_systax:
	printf("Syntax Error\n");
	printf("Use: %s -h or %s --help\n", argv[0], argv[0]);
	return -1;
}
