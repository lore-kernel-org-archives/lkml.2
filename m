Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325Ab0HXMtI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 08:49:08 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:40432 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab0HXMtD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 08:49:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type:content-transfer-encoding;
        b=SNfp8N50IGEbXTR3PVb2zjgVfwqyJ8pggio7m03Q4Zw0n54fIqwns9/3LBhZ1ZGZ9h
         NojcROcNom7mcmtVapSkbZ14P6cDQL2pSHPl0EMdnUJnWVhxZNsZMnehCQGczZagnYD2
         uVT0RhkFVeTeNuoufuoM0DklxAPDH9s5KJXtk=
MIME-Version: 1.0
Date: Tue, 24 Aug 2010 14:49:01 +0200
X-Google-Sender-Auth: 3zsteH8Tg0r1rsF4pqOLf0TF0Jk
Message-ID: <AANLkTim5MuJp9d0hL9EKPpaTSG6+LhF4UKwSiLLzsv_e@mail.gmail.com>
Subject: Recent linux-next regressions/improvements (was: Re: Build log scripts)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-kernel@vger.kernel.org, Linux-Next <linux-next@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 13, 2010 at 22:50, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>  o I want to know if there are any regressions/improvements since the previous
>    version.

>  o linux-log-diff.pl
>
>    Compare two build logs and display a summary of all regressions and
>    improvements.

Below is the list of all build error/warning regressions/improvements
in linux-next
between July 13 and August 23.

In addition, I put the verbose summary at
http://www.kernel.org/pub/linux/kernel/people/geert/linux-log/summary-all-v.out-2010-08-23,
so you can easily find out where the errors/warnings you're interested
in are happening.

Happy fixing! ;-)

*** ERRORS ***

40 regressions:
	../../sh4-linux/bin/ld: error in
arch/sh/kernel/vsyscall/vsyscall-trapa.o(.eh_frame); no .eh_frame_hdr
table will be created.:  => N/A
	error: No rule to make target include/config/auto.conf:  => N/A
	error: compr_lzo.c: undefined reference to `svc_gss_principal':  =>
.text+0x800e4)
	error: fbmem.c: undefined reference to `vm_get_page_prot':  => .text+0x5d4)
	scratch/kisskb/src/arch/alpha/kernel/osf_sys.c: error: expected ')'
before 'buffer':  => 255
	scratch/kisskb/src/arch/alpha/kernel/osf_sys.c: error: too few
arguments to function 'do_osf_statfs':  => 255
	scratch/kisskb/src/arch/arm/mach-ixp4xx/common-pci.c: error:
redefinition of 'dma_needs_bounce':  => 340
	scratch/kisskb/src/arch/arm/mach-omap2/board-rx51-peripherals.c:
error: redefinition of 'rx51_aic3x_data':  => 741
	scratch/kisskb/src/arch/arm/mach-omap2/board-zoom2.c: error:
'zoom2_bci_data' undeclared here (not in a function):  => 65
	scratch/kisskb/src/arch/arm/mach-omap2/board-zoom2.c: error:
'zoom2_gpio_data' undeclared here (not in a function):  => 68
	scratch/kisskb/src/arch/arm/mach-omap2/board-zoom2.c: error:
'zoom2_kp_twl4030_data' undeclared here (not in a function):  => 69
	scratch/kisskb/src/arch/arm/mach-omap2/board-zoom2.c: error:
'zoom2_usb_data' undeclared here (not in a function):  => 67
	scratch/kisskb/src/arch/arm/mach-omap2/board-zoom2.c: error:
'zoom2_vmmc1' undeclared here (not in a function):  => 71
	scratch/kisskb/src/arch/arm/mach-omap2/board-zoom2.c: error:
'zoom2_vmmc2' undeclared here (not in a function):  => 72
	scratch/kisskb/src/arch/arm/mach-omap2/board-zoom2.c: error:
'zoom2_vsim' undeclared here (not in a function):  => 73
	scratch/kisskb/src/arch/avr32/include/asm/syscalls.h: error: previous
declaration of ‘sys_execve’ was here:  => 25
	scratch/kisskb/src/arch/avr32/kernel/process.c: error: conflicting
types for ‘sys_execve’:  => 390
	scratch/kisskb/src/arch/powerpc/platforms/85xx/mpc85xx_mds.c: error:
'np' undeclared (first use in this function):  => 367
	scratch/kisskb/src/arch/powerpc/platforms/85xx/mpc85xx_mds.c: error:
(Each undeclared identifier is reported only once:  => 367
	scratch/kisskb/src/arch/powerpc/platforms/85xx/mpc85xx_mds.c: error:
for each function it appears in.):  => 367
	scratch/kisskb/src/arch/powerpc/platforms/85xx/p1022_ds.c: error:
'udbg_progress' undeclared here (not in a function):  => 147
	scratch/kisskb/src/arch/powerpc/platforms/85xx/p1022_ds.c: error:
implicit declaration of function 'lmb_end_of_DRAM':  => 100
	scratch/kisskb/src/arch/powerpc/platforms/85xx/p1022_ds.c: error:
linux/lmb.h: No such file or directory:  => 22:23
	scratch/kisskb/src/arch/powerpc/sysdev/fsl_rio.c: error:
'MCSR_BUS_RBERR' undeclared (first use in this function):  => 250
	scratch/kisskb/src/drivers/block/hd.c: error: implicit declaration of
function 'inb_p':  => 257
	scratch/kisskb/src/drivers/block/hd.c: error: implicit declaration of
function 'outb_p':  => 298
	scratch/kisskb/src/drivers/block/paride/bpck.c: error: invalid
operands to binary & (have 'void *' and 'int'):  => 56, 62
	scratch/kisskb/src/drivers/char/specialix.c: error: invalid operands
to binary | (have 'void *' and 'int'):  => 238, 228
	scratch/kisskb/src/drivers/mmc/host/tmio_mmc.h: error: negative width
in bit-field '<anonymous>':  => 192
	scratch/kisskb/src/drivers/serial/mfd.c: error: implicit declaration
of function 'kfree':  => 175
	scratch/kisskb/src/drivers/serial/mfd.c: error: implicit declaration
of function 'kzalloc':  => 144
	scratch/kisskb/src/drivers/serial/mrst_max3110.c: error:
'IRQ_TYPE_EDGE_FALLING' undeclared (first use in this function):  =>
470
	scratch/kisskb/src/drivers/serial/mrst_max3110.c: error: (Each
undeclared identifier is reported only once:  => 470
	scratch/kisskb/src/drivers/serial/mrst_max3110.c: error: for each
function it appears in.):  => 470
	scratch/kisskb/src/fs/fcntl.c: error: negative width in bit-field
'<anonymous>':  => 773
	scratch/kisskb/src/fs/ntfs/file.c: error: insn does not satisfy its
constraints::  => 2069
	scratch/kisskb/src/include/sound/sh_fsi.h: error: previous
declaration of 'fsi_soc_dai' was here:  => 117
	scratch/kisskb/src/include/sound/sh_fsi.h: error: previous
declaration of 'fsi_soc_platform' was here:  => 118
	scratch/kisskb/src/sound/soc/sh/fsi.c: error: static declaration of
'fsi_soc_dai' follows non-static declaration:  => 1031
	scratch/kisskb/src/sound/soc/sh/fsi.c: error: static declaration of
'fsi_soc_platform' follows non-static declaration:  => 1066

70 improvements:
	./sh4-linux/bin/ld: error in
arch/sh/kernel/vsyscall/vsyscall-trapa.o(.eh_frame); no .eh_frame_hdr
table will be created.: N/A =>
	error: "of_i8042_aux_irq" [drivers/input/serio/i8042.ko] undefined!: N/A =>
	error: "of_i8042_kbd_irq" [drivers/input/serio/i8042.ko] undefined!: N/A =>
	error: init.c: relocation truncated to fit: R_MIPS_26 against
`prom_meminit': (.init.text+0xa4) =>
	error: init.c: undefined reference to `prom_meminit': .init.text+0xa4) =>
	error: reboot.c: undefined reference to `__flush_tlb_global':
.text+0x1bb8), .text+0x182c), .text+0x15d8) =>
	error: relocation truncated to fit: R_MIPS_26 against
`arch_init_irq': (.init.text+0x31c) =>
	error: relocation truncated to fit: R_MIPS_26 against
`ip22_eeprom_read': (.cpuinit.text+0x82c8) =>
	error: relocation truncated to fit: R_MIPS_26 against
`plat_irq_dispatch': (.text+0x3a4) =>
	error: relocation truncated to fit: R_MIPS_26 against
`plat_mem_setup': (.init.text+0x6ec) =>
	error: relocation truncated to fit: R_MIPS_26 against
`plat_time_init': (.init.text+0xba4) =>
	error: relocation truncated to fit: R_MIPS_26 against
`prom_free_prom_memory': (.ref.text+0x18) =>
	error: vsprintf.c: relocation truncated to fit: R_AVR32_11H_PCREL
against `.text'+718: (.text+0xb1e) =>
	scratch/kisskb/src/arch/parisc/include/asm/spinlock.h: error: 'asm'
operand has impossible constraints: 25 =>
	scratch/kisskb/src/arch/parisc/include/asm/spinlock.h: error: can't
find a register in class 'R1_REGS' while reloading 'asm': 25 =>
	scratch/kisskb/src/arch/sparc/include/asm/uaccess_64.h: error: call
to 'copy_from_user_overflow' declared with attribute error:
copy_from_user() buffer size is not provably correct: 232 =>
	scratch/kisskb/src/drivers/crypto/n2_core.c: error: 'struct
platform_device' has no member named 'irqs': 1606 =>
	scratch/kisskb/src/drivers/crypto/n2_core.c: error: 'struct
platform_device' has no member named 'num_irqs': 1583 =>
	scratch/kisskb/src/drivers/gpio/gpiolib.c: error: 'ARCH_NR_GPIOS'
undeclared here (not in a function): 69 =>
	scratch/kisskb/src/drivers/gpio/gpiolib.c: error: 'GPIOF_DIR_IN'
undeclared (first use in this function): 1303 =>
	scratch/kisskb/src/drivers/gpio/gpiolib.c: error: 'GPIOF_INIT_HIGH'
undeclared (first use in this function): 1307 =>
	scratch/kisskb/src/drivers/gpio/gpiolib.c: error: (Each undeclared
identifier is reported only once: 1303 =>
	scratch/kisskb/src/drivers/gpio/gpiolib.c: error: arithmetic on
pointer to an incomplete type: 1322, 1344, 1331 =>
	scratch/kisskb/src/drivers/gpio/gpiolib.c: error: decrement of
pointer to unknown structure: 1331 =>
	scratch/kisskb/src/drivers/gpio/gpiolib.c: error: dereferencing
pointer to incomplete type: 1238, 942, 943, 1592, 599, 1757, 1399,
1755, 1666, 1013, 986, 1646, 1750, 744, 1402, 1275, 1679, 1401, 1363,
1072, 113, 1630, 1081, 1454, 1510, 1523, 1525, 1233, 751, 1749, 750,
1762, 949, 1077, 101, 1272, 1574, 1214, 1756, 1573, 1063, 1141, 1088,
1097, 1274, 1452, 979, 1279, 1412, 1670, 957, 1230, 1415, 1656, 590,
1763, 1148, 1612, 1468, 145, 1470, 1512, 1323, 1226, 1455, 962, 756,
1465, 1479, 1344, 1513, 105, 1331, 1426, 1678, 745, 1118, 608, 1417,
1593, 1061 =>
	scratch/kisskb/src/drivers/gpio/gpiolib.c: error: for each function
it appears in.): 1303 =>
	scratch/kisskb/src/drivers/gpio/gpiolib.c: error: increment of
pointer to unknown structure: 1322, 1344 =>
	scratch/kisskb/src/drivers/gpio/gpiolib.c: error: redefinition of
'gpio_direction_input': 1388 =>
	scratch/kisskb/src/drivers/gpio/gpiolib.c: error: redefinition of
'gpio_direction_output': 1441 =>
	scratch/kisskb/src/drivers/gpio/gpiolib.c: error: redefinition of
'gpio_export': 722 =>
	scratch/kisskb/src/drivers/gpio/gpiolib.c: error: redefinition of
'gpio_export_link': 808 =>
	scratch/kisskb/src/drivers/gpio/gpiolib.c: error: redefinition of
'gpio_free': 1253 =>
	scratch/kisskb/src/drivers/gpio/gpiolib.c: error: redefinition of
'gpio_get_value_cansleep': 1641 =>
	scratch/kisskb/src/drivers/gpio/gpiolib.c: error: redefinition of
'gpio_request': 1199 =>
	scratch/kisskb/src/drivers/gpio/gpiolib.c: error: redefinition of
'gpio_set_debounce': 1499 =>
	scratch/kisskb/src/drivers/gpio/gpiolib.c: error: redefinition of
'gpio_set_value_cansleep': 1651 =>
	scratch/kisskb/src/drivers/gpio/gpiolib.c: error: redefinition of
'gpio_sysfs_set_active_low': 855 =>
	scratch/kisskb/src/drivers/gpio/gpiolib.c: error: redefinition of
'gpio_unexport': 895 =>
	scratch/kisskb/src/drivers/gpio/langwell_gpio.c: error: dereferencing
pointer to incomplete type: 70 =>
	scratch/kisskb/src/drivers/gpio/langwell_gpio.c: error: field 'chip'
has incomplete type: 60 =>
	scratch/kisskb/src/drivers/gpio/langwell_gpio.c: error: implicit
declaration of function 'gpiochip_add': 270 =>
	scratch/kisskb/src/drivers/net/davinci_emac.c: error: 'dev'
undeclared (first use in this function): 1185 =>
	scratch/kisskb/src/drivers/net/davinci_emac.c: error: (Each
undeclared identifier is reported only once: 1185 =>
	scratch/kisskb/src/drivers/net/davinci_emac.c: error: for each
function it appears in.): 1185 =>
	scratch/kisskb/src/drivers/serial/max3107.h: error: field 'chip' has
incomplete type: 372 =>
	scratch/kisskb/src/fs/xfs/linux-2.6/xfs_trace.h: error:
'check_trace_callback_type_' declared as function returning a
function: 571 =>
	scratch/kisskb/src/fs/xfs/linux-2.6/xfs_trace.h: error:
'register_trace_' declared as function returning a function: 571 =>
	scratch/kisskb/src/fs/xfs/linux-2.6/xfs_trace.h: error: 'trace_'
declared as function returning a function: 571 =>
	scratch/kisskb/src/fs/xfs/linux-2.6/xfs_trace.h: error:
'unregister_trace_' declared as function returning a function: 571 =>
	scratch/kisskb/src/fs/xfs/linux-2.6/xfs_trace.h: error: expected
declaration specifiers or '...' before '(' token: 571 =>
	scratch/kisskb/src/fs/xfs/linux-2.6/xfs_trace.h: error: pasting
"check_trace_callback_type_" and "(" does not give a valid
preprocessing token: 571:1 =>
	scratch/kisskb/src/fs/xfs/linux-2.6/xfs_trace.h: error: pasting
"register_trace_" and "(" does not give a valid preprocessing token:
571:1 =>
	scratch/kisskb/src/fs/xfs/linux-2.6/xfs_trace.h: error: pasting
"trace_" and "(" does not give a valid preprocessing token: 571:1 =>
	scratch/kisskb/src/fs/xfs/linux-2.6/xfs_trace.h: error: pasting
"unregister_trace_" and "(" does not give a valid preprocessing token:
571:1 =>
	scratch/kisskb/src/include/linux/gpio.h: error: previous definition
of 'gpio_direction_input' was here: 45 =>
	scratch/kisskb/src/include/linux/gpio.h: error: previous definition
of 'gpio_direction_output' was here: 50 =>
	scratch/kisskb/src/include/linux/gpio.h: error: previous definition
of 'gpio_export' was here: 93 =>
	scratch/kisskb/src/include/linux/gpio.h: error: previous definition
of 'gpio_export_link' was here: 101 =>
	scratch/kisskb/src/include/linux/gpio.h: error: previous definition
of 'gpio_free' was here: 37 =>
	scratch/kisskb/src/include/linux/gpio.h: error: previous definition
of 'gpio_get_value_cansleep' was here: 80 =>
	scratch/kisskb/src/include/linux/gpio.h: error: previous definition
of 'gpio_request' was here: 32 =>
	scratch/kisskb/src/include/linux/gpio.h: error: previous definition
of 'gpio_set_debounce' was here: 55 =>
	scratch/kisskb/src/include/linux/gpio.h: error: previous definition
of 'gpio_set_value_cansleep' was here: 87 =>
	scratch/kisskb/src/include/linux/gpio.h: error: previous definition
of 'gpio_sysfs_set_active_low' was here: 108 =>
	scratch/kisskb/src/include/linux/gpio.h: error: previous definition
of 'gpio_unexport' was here: 115 =>
	scratch/kisskb/src/include/linux/vgaarb.h: error: asm/vga.h: No such
file or directory: 33:21 =>
	scratch/kisskb/src/include/trace/events/writeback.h: error: implicit
declaration of function 'dev_name': 12 =>
	scratch/kisskb/src/sound/oss/msnd_pinnacle.c: error: 'inode'
undeclared (first use in this function): 644 =>
	scratch/kisskb/src/sound/oss/msnd_pinnacle.c: error: (Each undeclared
identifier is reported only once: 644 =>
	scratch/kisskb/src/sound/oss/msnd_pinnacle.c: error: for each
function it appears in.): 644 =>


*** WARNINGS ***

137 regressions:
	.config: warning: symbol value '' invalid for
X86_INTERNODE_CACHE_SHIFT:  => 269
	.config: warning: symbol value '' invalid for ZRELADDR:  => 312, 310
	<stdin>: warning: #warning syscall prlimit64 not implemented:  => 1534:2
	modpost: WARNING: modpost: Found 13 section mismatch(es).:  => N/A
	modpost: WARNING: modpost: Found 16 section mismatch(es).:  => N/A
	modpost: WARNING: modpost: Found 25 section mismatch(es).:  => N/A
	modpost: WARNING: modpost: Found 5 section mismatch(es).:  => N/A
	modpost: WARNING: modpost: Found 58 section mismatch(es).:  => N/A
	modpost: WARNING: modpost: Found 75 section mismatch(es).:  => N/A
	scratch/kisskb/src/arch/arm/include/asm/domain.h: warning: this is
the location of the previous definition:  => 86:1
	scratch/kisskb/src/arch/arm/mach-at91/board-1arm.c: warning:
'at91_init_serial' is deprecated (declared at
/scratch/kisskb/src/arch/arm/mach-at91/include/mach/board.h:146):  =>
59
	scratch/kisskb/src/arch/arm/mach-at91/board-kafa.c: warning:
'at91_init_serial' is deprecated (declared at
/scratch/kisskb/src/arch/arm/mach-at91/include/mach/board.h:146):  =>
62
	scratch/kisskb/src/arch/arm/mach-at91/board-picotux200.c: warning:
'at91_init_serial' is deprecated (declared at
/scratch/kisskb/src/arch/arm/mach-at91/include/mach/board.h:146):  =>
63
	scratch/kisskb/src/arch/cris/mm/fault.c: warning: ISO C90 forbids
mixed declarations and code:  => 205
	scratch/kisskb/src/arch/m68k/include/asm/io_mm.h: warning: this is
the location of the previous definition:  => 274:1, 271:1
	scratch/kisskb/src/arch/m68k/include/asm/parport.h: warning: "insl"
redefined:  => 14:1
	scratch/kisskb/src/arch/m68k/include/asm/parport.h: warning: "outsl"
redefined:  => 15:1
	scratch/kisskb/src/arch/mips/sibyte/bcm1480/smp.c: warning: passing
argument 1 of '__cpus_clear' discards qualifiers from pointer target
type:  => 149
	scratch/kisskb/src/arch/sh/boards/mach-kfr2r09/setup.c: warning:
initialization from incompatible pointer type:  => 156
	scratch/kisskb/src/arch/um/kernel/exec.c: warning: passing argument 2
of 'execve1' from incompatible pointer type:  => 69, 85
	scratch/kisskb/src/arch/um/kernel/exec.c: warning: passing argument 3
of 'execve1' from incompatible pointer type:  => 69, 85
	scratch/kisskb/src/arch/x86/include/asm/mrst.h: warning: 'struct
sfi_table_header' declared inside parameter list:  => 14
	scratch/kisskb/src/arch/x86/include/asm/mrst.h: warning: its scope is
only this definition or declaration, which is probably not what you
want:  => 14
	scratch/kisskb/src/arch/x86/kernel/cpu/perf_event.c: warning:
'perf_callchain_entry_nmi' defined but not used:  => 1607
	scratch/kisskb/src/drivers/acpi/sysfs.c: warning: passing argument 1
of '__check_old_set_param' from incompatible pointer type:  => 152,
154
	scratch/kisskb/src/drivers/block/hd.c: warning: statement with no
effect:  => 468
	scratch/kisskb/src/drivers/block/rbd.c: warning: passing argument 1
of 'bvec_kunmap_irq' from incompatible pointer type:  => 557
	scratch/kisskb/src/drivers/char/n_gsm.c: warning: ignoring return
value of '__kfifo_must_check_helper', declared with attribute
warn_unused_result:  => 1580
	scratch/kisskb/src/drivers/gpu/drm/radeon/radeon_gart.c: warning:
passing argument 3 of 'pci_free_consistent' discards qualifiers from
pointer target type:  => 69
	scratch/kisskb/src/drivers/i2c/busses/i2c-cpm.c: warning: passing
argument 3 of 'dma_alloc_coherent' from incompatible pointer type:  =>
536, 543
	scratch/kisskb/src/drivers/infiniband/hw/amso1100/c2_qp.c: warning:
'actual_sge_count' may be used uninitialized in this function:  =>
799, 961
	scratch/kisskb/src/drivers/infiniband/hw/amso1100/c2_qp.c: warning:
'tot_len' may be used uninitialized in this function:  => 798
	scratch/kisskb/src/drivers/input/keyboard/jornada680_kbd.c: warning:
'ctrl_inb' is deprecated (declared at
/scratch/kisskb/src/arch/sh/include/asm/io.h:94):  => 170, 158, 169,
157
	scratch/kisskb/src/drivers/input/keyboard/jornada680_kbd.c: warning:
'ctrl_inw' is deprecated (declared at
/scratch/kisskb/src/arch/sh/include/asm/io.h:99):  => 142, 143
	scratch/kisskb/src/drivers/input/keyboard/jornada680_kbd.c: warning:
'ctrl_outb' is deprecated (declared at
/scratch/kisskb/src/arch/sh/include/asm/io.h:114):  => 152, 161, 162,
153
	scratch/kisskb/src/drivers/input/keyboard/jornada680_kbd.c: warning:
'ctrl_outw' is deprecated (declared at
/scratch/kisskb/src/arch/sh/include/asm/io.h:119):  => 147, 166, 165,
148
	scratch/kisskb/src/drivers/input/misc/hp_sdc_rtc.c: warning:
'hp_sdc_rtc_set_fhs' defined but not used: 319 => 319, 320
	scratch/kisskb/src/drivers/input/misc/hp_sdc_rtc.c: warning:
'hp_sdc_rtc_set_i8042timer' defined but not used: 359 => 360, 359
	scratch/kisskb/src/drivers/input/misc/hp_sdc_rtc.c: warning:
'hp_sdc_rtc_set_rt' defined but not used: 279 => 280, 279
	scratch/kisskb/src/drivers/input/touchscreen/hp680_ts_input.c:
warning: 'ctrl_inb' is deprecated (declared at
/scratch/kisskb/src/arch/sh/include/asm/io.h:94):  => 32, 53, 40, 31,
48
	scratch/kisskb/src/drivers/input/touchscreen/hp680_ts_input.c:
warning: 'ctrl_outb' is deprecated (declared at
/scratch/kisskb/src/arch/sh/include/asm/io.h:114):  => 35, 51, 43
	scratch/kisskb/src/drivers/isdn/hardware/mISDN/mISDNipac.c: warning:
unsupported argument to '__builtin_return_address':  => 754
	scratch/kisskb/src/drivers/isdn/hardware/mISDN/netjet.c: warning:
comparison is always false due to limited range of data type:  => 318
	scratch/kisskb/src/drivers/isdn/hardware/mISDN/w6692.c: warning:
unsupported argument to '__builtin_return_address':  => 1188
	scratch/kisskb/src/drivers/leds/leds-gpio.c: warning: 'flags' may be
used uninitialized in this function:  => 251
	scratch/kisskb/src/drivers/media/dvb/ngene/ngene-core.c: warning:
unused variable 'flags':  => 1308
	scratch/kisskb/src/drivers/media/video/sh_mobile_ceu_camera.c:
warning: 'sd' is used uninitialized in this function:  => 1245
	scratch/kisskb/src/drivers/media/video/sh_mobile_ceu_camera.c:
warning: 'sd' may be used uninitialized in this function:  => 1707,
1683, 943
	scratch/kisskb/src/drivers/media/video/sh_mobile_ceu_camera.c:
warning: unused variable 'sd':  => 1648
	scratch/kisskb/src/drivers/message/fusion/mptsas.c: warning: unused
variable 'log_info':  => 5010
	scratch/kisskb/src/drivers/mtd/chips/cfi_cmdset_0001.c: warning: the
frame size of 1044 bytes is larger than 1024 bytes:  => 860
	scratch/kisskb/src/drivers/mtd/chips/cfi_cmdset_0001.c: warning: the
frame size of 1412 bytes is larger than 1024 bytes:  => 1802
	scratch/kisskb/src/drivers/mtd/chips/cfi_cmdset_0020.c: warning: the
frame size of 1132 bytes is larger than 1024 bytes:  => 419
	scratch/kisskb/src/drivers/mtd/chips/cfi_cmdset_0020.c: warning: the
frame size of 1376 bytes is larger than 1024 bytes:  => 982
	scratch/kisskb/src/drivers/mtd/chips/cfi_cmdset_0020.c: warning: the
frame size of 1672 bytes is larger than 1024 bytes:  => 657
	scratch/kisskb/src/drivers/mtd/chips/cfi_cmdset_0020.c: warning: the
frame size of 2288 bytes is larger than 2048 bytes:  => 657
	scratch/kisskb/src/drivers/mtd/devices/slram.c: warning: "T"
redefined:  => 52:1
	scratch/kisskb/src/drivers/net/irda/w83977af_ir.c: warning:
'bus_to_virt' is deprecated (declared at
/scratch/kisskb/src/arch/arm/include/asm/memory.h:226):  => 747
	scratch/kisskb/src/drivers/net/macvtap.c: warning: control reaches
end of non-void function:  => 102
	scratch/kisskb/src/drivers/net/pcmcia/ibmtr_cs.c: warning:
'pcmcia_request_exclusive_irq' is deprecated (declared at
/scratch/kisskb/src/include/pcmcia/ds.h:200):  => 224
	scratch/kisskb/src/drivers/net/pcmcia/ibmtr_cs.c: warning:
'pcmcia_request_exclusive_irq' is deprecated (declared at
/scratch/kisskb/src/include/pcmcia/ds.h:202):  => 224
	scratch/kisskb/src/drivers/net/pcmcia/nmclan_cs.c: warning:
'pcmcia_request_exclusive_irq' is deprecated (declared at
/scratch/kisskb/src/include/pcmcia/ds.h:200):  => 652
	scratch/kisskb/src/drivers/net/pcmcia/nmclan_cs.c: warning:
'pcmcia_request_exclusive_irq' is deprecated (declared at
/scratch/kisskb/src/include/pcmcia/ds.h:202):  => 652
	scratch/kisskb/src/drivers/net/seeq8005.c: warning: integer overflow
in expression:  => 701, 544
	scratch/kisskb/src/drivers/net/sh_eth.c: warning: 'ctrl_inl' is
deprecated (declared at
/scratch/kisskb/src/arch/sh/include/asm/io.h:104): 365, 860, 660, 63,
288, 1128, 814, 937, 891, 366, 1258, 286, 848, 361, 906, 664, 1266,
1256, 394, 842, 48, 363, 830, 857, 364, 388, 50, 1003, 60, 362, 382,
855, 1199, 1254, 852 => 365, 860, 660, 63, 288, 1128, 814, 937, 891,
366, 1258, 286, 848, 361, 906, 664, 1298, 1266, 1256, 1302, 394, 842,
48, 363, 830, 857, 364, 388, 50, 1003, 60, 362, 382, 855, 1199, 1254,
852
	scratch/kisskb/src/drivers/net/sh_eth.c: warning: 'ctrl_outl' is
deprecated (declared at
/scratch/kisskb/src/arch/sh/include/asm/io.h:124): 892, 643, 685, 860,
673, 660, 63, 942, 831, 288, 1218, 647, 1200, 667, 650, 640, 661, 918,
286, 339, 690, 676, 848, 655, 531, 1259, 687, 633, 1267, 1257, 815,
1255, 342, 626, 48, 857, 639, 683, 388, 1215, 1219, 50, 636, 1003,
509, 60, 629, 652, 382, 855, 852, 658 => 892, 643, 685, 660, 63, 1330,
1314, 942, 831, 288, 1332, 1218, 647, 1200, 667, 918, 690, 676, 1310,
1312, 633, 1267, 1311, 1257, 1315, 815, 1319, 342, 1333, 48, 1324,
857, 683, 1215, 1219, 50, 60, 1328, 382, 1318, 658, 1329, 673, 860,
1327, 640, 650, 661, 1317, 339, 286, 655, 848, 531, 687, 1259, 1313,
1298, 1325, 1255, 1302, 626, 639, 1316, 1331, 388, 636, 509, 1003,
652, 629, 855, 852
	scratch/kisskb/src/drivers/net/smc91x.c: warning: cast from pointer
to integer of different size:  => 1913
	scratch/kisskb/src/drivers/net/tehuti.c: warning: passing argument 2
of 'bdx_tx_push_desc_safe' discards qualifiers from pointer target
type:  => 330
	scratch/kisskb/src/drivers/net/wireless/libertas/cfg.c: warning:
passing argument 3 of 'lbs_deb_hex' discards qualifiers from pointer
target type:  => 535, 274
	scratch/kisskb/src/drivers/net/wireless/mwl8k.c: warning:
'ap_legacy_rates' may be used uninitialized in this function:  => 3403
	scratch/kisskb/src/drivers/net/wireless/p54/p54usb.c: warning:
'p54u_device_reset' defined but not used:  => 406, 407
	scratch/kisskb/src/drivers/parport/parport_pc.c: warning:
'bus_to_virt' is deprecated (declared at
/scratch/kisskb/src/arch/arm/include/asm/memory.h:226):  => 670
	scratch/kisskb/src/drivers/rtc/rtc-m41t80.c: warning: passing
argument 1 of 'rtc_valid_tm' from incompatible pointer type:  => 367
	scratch/kisskb/src/drivers/scsi/hpsa.c: warning: 'cp' may be used
uninitialized in this function:  => 2335, 2299
	scratch/kisskb/src/drivers/scsi/mpt2sas/mpt2sas_base.c: warning:
right shift count >= width of type:  => 3022, 3020
	scratch/kisskb/src/drivers/scsi/mpt2sas/mpt2sas_ctl.c: warning:
'_ctl_sas_device_find_by_handle' defined but not used:  => 94
	scratch/kisskb/src/drivers/scsi/mpt2sas/mpt2sas_scsih.c: warning:
unused variable 'mpi_reply':  => 2718
	scratch/kisskb/src/drivers/scsi/pmcraid.c: warning: passing argument
2 of 'access_ok' makes pointer from integer without a cast:  => 3800
	scratch/kisskb/src/drivers/scsi/stex.c: warning: passing argument 2
of 'scsi_sg_copy_from_buffer' discards qualifiers from pointer target
type:  => 636
	scratch/kisskb/src/drivers/serial/8250_hp300.c: warning: #warning
CONFIG_8250 defined but neither CONFIG_HPDCA nor CONFIG_HPAPCI
defined, are you sure?:  => 24:2
	scratch/kisskb/src/drivers/serial/mfd.c: warning: assignment makes
pointer from integer without a cast:  => 144, 1361, 818, 187
	scratch/kisskb/src/drivers/serial/ucc_uart.c: warning: format '%x'
expects type 'unsigned int', but argument 3 has type 'dma_addr_t':  =>
238
	scratch/kisskb/src/drivers/usb/gadget/storage_common.c: warning:
'fsg_show_nofua' defined but not used:  => 718
	scratch/kisskb/src/drivers/usb/gadget/storage_common.c: warning:
'fsg_store_nofua' defined but not used:  => 782
	scratch/kisskb/src/drivers/video/aty/atyfb_base.c: warning:
'aty_bl_exit' defined but not used:  => 2270
	scratch/kisskb/src/drivers/video/aty/atyfb_base.c: warning:
'store_video_par' defined but not used:  => 2792
	scratch/kisskb/src/drivers/video/mb862xx/mb862xxfb.c: warning:
'dev_attr_dispregs' defined but not used:  => 464
	scratch/kisskb/src/drivers/video/mb862xx/mb862xxfb.c: warning:
'mb862xxfb_init_fbinfo' defined but not used:  => 327, 326
	scratch/kisskb/src/fs/9p/xattr.c: warning: format '%zd' expects type
'signed size_t', but argument 3 has type 'ssize_t':  => 52
	scratch/kisskb/src/fs/9p/xattr.c: warning: format '%zd' expects type
'signed size_t', but argument 4 has type 'ssize_t':  => 52
	scratch/kisskb/src/fs/autofs/root.c: warning:
'autofs_root_compat_ioctl' declared 'static' but never defined:  => 30
	scratch/kisskb/src/fs/autofs4/root.c: warning:
'autofs4_root_compat_ioctl' declared 'static' but never defined:  =>
31
	scratch/kisskb/src/fs/ceph/locks.c: warning: cast from pointer to
integer of different size:  => 238, 85, 95, 144, 135
	scratch/kisskb/src/fs/cifs/cifsencrypt.c: warning:
'CalcNTLMv2_response' uses dynamic stack allocation:  => 475
	scratch/kisskb/src/fs/cifs/cifsencrypt.c: warning: 'calc_ntlmv2_hash'
uses dynamic stack allocation:  => 388
	scratch/kisskb/src/fs/cifs/cifsencrypt.c: warning:
'cifs_calc_signature2' uses dynamic stack allocation:  => 167
	scratch/kisskb/src/fs/cifs/cifsencrypt.c: warning:
'cifs_calculate_signature' uses dynamic stack allocation:  => 81
	scratch/kisskb/src/fs/cifs/cifsencrypt.c: warning: 'setup_ntlmv2_rsp'
uses dynamic stack allocation:  => 536
	scratch/kisskb/src/fs/cifs/sess.c: warning: unused variable
'ntlmsspblob':  => 620
	scratch/kisskb/src/fs/nfsd/nfs4state.c: warning: control reaches end
of non-void function:  => 452
	scratch/kisskb/src/fs/notify/fanotify/fanotify.c: warning:
'marks_ignored_mask' may be used uninitialized in this function:  =>
165
	scratch/kisskb/src/fs/notify/fanotify/fanotify.c: warning:
'marks_mask' may be used uninitialized in this function:  => 165
	scratch/kisskb/src/fs/notify/fanotify/fanotify_user.c: warning:
unused variable 'lre':  => 370
	scratch/kisskb/src/fs/notify/fanotify/fanotify_user.c: warning:
unused variable 're':  => 370
	scratch/kisskb/src/fs/ocfs2/file.c: warning: unused variable 'dentry':  => 177
	scratch/kisskb/src/fs/sysfs/dir.c: warning: 'sysfs_pathname' defined
but not used: 410 => 411, 410
	scratch/kisskb/src/include/linux/gpio_keys.h: warning: 'struct
device' declared inside parameter list:  => 21, 20
	scratch/kisskb/src/include/linux/gpio_keys.h: warning: its scope is
only this definition or declaration, which is probably not what you
want:  => 20
	scratch/kisskb/src/include/linux/mmc/sh_mmcif.h: warning:
'outer_sync' is static but used in inline function 'sh_mmcif_writel'
which is not static:  => 68
	scratch/kisskb/src/kernel/debug/debug_core.c: warning: initialization
from incompatible pointer type:  => 763
	scratch/kisskb/src/lib/radix-tree.c: warning:
'radix_tree_range_tag_if_tagged' uses dynamic stack allocation:  =>
704
	scratch/kisskb/src/mm/memory.c: warning: passing argument 1 of
'kunmap' from incompatible pointer type: 1325, 772, 2330, 2039, 2739,
1635, 2178, 1316, 2132, 1632, 1797, 1393, 3299, 2744, 986, 2233, 3014,
2776, 1402, 1946, 1321, 1697, 774, 3328, 3112, 2973, 2804 => 772,
1643, 1319, 1314, 3153, 1410, 1391, 770, 3369, 1403, 984, 3055, 3340,
2845, 1705, 2749, 1954, 2337, 3014, 2802, 2185, 1640, 2754, 2240,
1805, 2139, 2046, 1323
	scratch/kisskb/src/net/ceph/messenger.c: warning: 'proto' may be used
uninitialized in this function:  => 644
	scratch/kisskb/src/net/ipv4/af_inet.c: warning: value computed is not
used:  => 239
	scratch/kisskb/src/net/irda/irda_device.c: warning: 'bus_to_virt' is
deprecated (declared at
/scratch/kisskb/src/arch/arm/include/asm/memory.h:226):  => 317
	scratch/kisskb/src/net/mac80211/tx.c: warning: unused variable
'mesh_hdr':  => 1704
	scratch/kisskb/src/net/sunrpc/auth_gss/auth_gss.c: warning: format
'%Zd' expects type 'signed size_t', but argument 2 has type 'ssize_t':
 => 706
	scratch/kisskb/src/net/sunrpc/auth_gss/auth_gss.c: warning: format
'%zd' expects type 'signed size_t', but argument 3 has type 'ssize_t':
 => 688
	scratch/kisskb/src/sound/oss/dmabuf.c: warning: 'bus_to_virt' is
deprecated (declared at
/scratch/kisskb/src/arch/arm/include/asm/memory.h:226):  => 160
	scratch/kisskb/src/sound/oss/dmabuf.c: warning: 'virt_to_bus' is
deprecated (declared at
/scratch/kisskb/src/arch/arm/include/asm/memory.h:221):  => 117
	scratch/kisskb/src/sound/pcmcia/pdaudiocf/pdaudiocf.c: warning:
'pcmcia_request_exclusive_irq' is deprecated (declared at
/scratch/kisskb/src/include/pcmcia/ds.h:200):  => 226
	scratch/kisskb/src/sound/pcmcia/pdaudiocf/pdaudiocf.c: warning:
'pcmcia_request_exclusive_irq' is deprecated (declared at
/scratch/kisskb/src/include/pcmcia/ds.h:202):  => 226
	scratch/kisskb/src/sound/pcmcia/vx/vxpocket.c: warning:
'pcmcia_request_exclusive_irq' is deprecated (declared at
/scratch/kisskb/src/include/pcmcia/ds.h:200):  => 233
	scratch/kisskb/src/sound/pcmcia/vx/vxpocket.c: warning:
'pcmcia_request_exclusive_irq' is deprecated (declared at
/scratch/kisskb/src/include/pcmcia/ds.h:202):  => 233
	tmp/ccES6x3c.s: Warning: register range not in ascending order:  => 1113
	warning: (CPU_S3C2440 && ARCH_S3C2410 && S3C2410_DMA) selects
S3C2440_DMA which has unmet direct dependencies (ARCH_S3C2410 &&
CPU_S3C24405B):  => N/A
	warning: (CPU_S3C2440 && ARCH_S3C2410 || CPU_S3C2442 && ARCH_S3C2410)
selects CPU_S3C244X which has unmet direct dependencies
(!ARCH_S3C2410):  => N/A
	warning: (IA32_EMULATION && X86_64) selects COMPAT_BINFMT_ELF which
has unmet direct dependencies (COMPAT && BINFMT_ELF):  => N/A
	warning: (IMA && SECURITY && !S390) selects TCG_TPM which has unmet
direct dependencies (HAS_IOMEM && EXPERIMENTAL):  => N/A
	warning: (IRQSOFF_TRACER && TRACING_SUPPORT && FTRACE &&
TRACE_IRQFLAGS_SUPPORT && !ARCH_USES_GETTIMEOFFSET) selects
TRACE_IRQFLAGS which has unmet direct dependencies (DEBUG_KERNEL &&
TRACE_IRQFLAGS_SUPPORT && PROVE_LOCKING):  => N/A
	warning: (LOCKDEP && DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT &&
STACKTRACE_SUPPORT && LOCKDEP_SUPPORT && !MIPS && !PPC && !ARM_UNWIND
&& !S390 && !MICROBLAZE || FAULT_INJECTION_STACKTRACE_FILTER &&
FAULT_INJECTION_DEBUG_FS && STACKTRACE_SUPPORT && !X86_64 && !PPC &&
!S390 && !MICROBLAZE || LATENCYTOP && HAVE_LATENCYTOP_SUPPORT &&
DEBUG_KERNEL && STACKTRACE_SUPPORT && PROC_FS && !MIPS && !PPC &&
!S390 && !MICROBLAZE || DWARF_UNWINDER || FUNCTION_TRACER &&
TRACING_SUPPORT && FTRACE && HAVE_FUNCTION_TRACER || KMEMCHECK &&
HAVE_ARCH_KMEMCHECK && DEBUG_KERNEL && !X86_USE_3DNOW && (SLUB ||
SLAB) && !CC_OPTIMIZE_FOR_SIZE && !FUNCTION_TRACER) selects
FRAME_POINTER which has unmet direct dependencies (DEBUG_KERNEL &&
(CRIS || M68K || M68KNOMMU || FRV || UML || AVR32 || SUPERH ||
BLACKFIN || MN10300) || ARCH_WANT_FRAME_POINTERS):  => N/A
	warning: (LOCKDEP && DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT &&
STACKTRACE_SUPPORT && LOCKDEP_SUPPORT && !MIPS && !PPC && !ARM_UNWIND
&& !S390 && !MICROBLAZE || FAULT_INJECTION_STACKTRACE_FILTER &&
FAULT_INJECTION_DEBUG_FS && STACKTRACE_SUPPORT && !X86_64 && !PPC &&
!S390 && !MICROBLAZE || LATENCYTOP && HAVE_LATENCYTOP_SUPPORT &&
DEBUG_KERNEL && STACKTRACE_SUPPORT && PROC_FS && !MIPS && !PPC &&
!S390 && !MICROBLAZE || FUNCTION_TRACER && TRACING_SUPPORT && FTRACE
&& HAVE_FUNCTION_TRACER || KMEMCHECK && HAVE_ARCH_KMEMCHECK &&
DEBUG_KERNEL && !X86_USE_3DNOW && (SLUB || SLAB) &&
!CC_OPTIMIZE_FOR_SIZE && !FUNCTION_TRACER) selects FRAME_POINTER which
has unmet direct dependencies (DEBUG_KERNEL && (CRIS || M68K ||
M68KNOMMU || FRV || UML || AVR32 || SUPERH || BLACKFIN || MN10300) ||
ARCH_WANT_FRAME_POINTERS):  => N/A
	warning: (MEDIA_TUNER && MEDIA_SUPPORT && VIDEO_MEDIA && I2C &&
!MEDIA_TUNER_CUSTOMISE) selects MEDIA_TUNER_TEA5761 which has unmet
direct dependencies (VIDEO_MEDIA && I2C && EXPERIMENTAL):  => N/A
	warning: (OPTPROBES && KPROBES && HAVE_OPTPROBES && !PREEMPT ||
MTD_UBI_DEBUG && MTD && SYSFS && MTD_UBI || UBIFS_FS_DEBUG &&
MISC_FILESYSTEMS && UBIFS_FS || LOCKDEP && DEBUG_KERNEL &&
TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT ||
LATENCYTOP && HAVE_LATENCYTOP_SUPPORT && DEBUG_KERNEL &&
STACKTRACE_SUPPORT && PROC_FS) selects KALLSYMS_ALL which has unmet
direct dependencies (DEBUG_KERNEL && KALLSYMS):  => N/A
	warning: (PCMCIA_LOAD_CIS && PCCARD && PCMCIA && EXPERIMENTAL ||
USB_IRDA && NET && IRDA && USB || BT_HCIBCM203X && NET && BT && USB ||
BT_HCIBFUSB && NET && BT && USB || BT_HCIBT3C && NET && BT && PCMCIA
|| BT_MRVL_SDIO && NET && BT && BT_MRVL && MMC || BT_ATH3K && NET &&
BT && BT_HCIBTUSB || IWMC3200TOP && MISC_DEVICES && MMC &&
EXPERIMENTAL || SCSI_AIC94XX && SCSI_LOWLEVEL && SCSI && PCI ||
SCSI_MVSAS && SCSI_LOWLEVEL && SCSI && PCI || SCSI_IPR &&
SCSI_LOWLEVEL && PCI && SCSI && ATA || SCSI_QLA_FC && SCSI_LOWLEVEL &&
PCI && SCSI || BNX2 && NETDEVICES && NETDEV_1000 && PCI || SPIDER_NET
&& NETDEVICES && NETDEV_1000 && PCI && (PPC_IBM_CELL_BLADE ||
PPC_CELLEB) || CHELSIO_T3 && NETDEVICES && NETDEV_10000 &&
CHELSIO_T3_DEPENDS || CHELSIO_T4 && NETDEVICES && NETDEV_10000 &&
CHELSIO_T4_DEPENDS || MYRI10GE && NETDEVICES && NETDEV_10000 && PCI &&
INET || NETXEN_NIC && NETDEVICES && NETDEV_10000 && PCI || BNX2X &&
NETDEVICES && NETDEV_10000 && PCI || QLCNIC && NETDEVICES &&
NETDEV_10000 && PCI || TMS380TR && NETDEVICES && TR && (PCI || ISA &&
ISA_DMA_API || MCA) || LIBERTAS_THINFIRM && NETDEVICES && WLAN &&
MAC80211 || ATMEL && NETDEVICES && WLAN && (PCI || PCMCIA) ||
PCMCIA_ATMEL && NETDEVICES && WLAN && ATMEL && PCMCIA || AT76C50X_USB
&& NETDEVICES && WLAN && MAC80211 && USB || PRISM54 && NETDEVICES &&
WLAN && PCI && EXPERIMENTAL || USB_ZD1201 && NETDEVICES && WLAN && USB
|| B43 && NETDEVICES && WLAN && SSB_POSSIBLE && MAC80211 && HAS_DMA ||
B43LEGACY && NETDEVICES && WLAN && SSB_POSSIBLE && MAC80211 && HAS_DMA
|| IPW2100 && NETDEVICES && WLAN && PCI && CFG80211 || IPW2200 &&
NETDEVICES && WLAN && PCI && CFG80211 && CFG80211_WEXT || IWLWIFI &&
NETDEVICES && WLAN && PCI && MAC80211 || IWM && NETDEVICES && WLAN &&
MMC && EXPERIMENTAL && CFG80211 || LIBERTAS && NETDEVICES && WLAN &&
CFG80211 || HERMES && NETDEVICES && WLAN && (PPC_PMAC || PCI ||
PCMCIA) && CFG80211 && CFG80211_WEXT || ORINOCO_USB && NETDEVICES &&
WLAN && USB && HERMES || P54_COMMON && NETDEVICES && WLAN && MAC80211
&& EXPERIMENTAL || WL1251 && NETDEVICES && WLAN && WL12XX &&
GENERIC_HARDIRQS || WL1271 && NETDEVICES && WLAN && WL12XX &&
GENERIC_HARDIRQS && INET || ZD1211RW && NETDEVICES && WLAN && USB &&
MAC80211 && EXPERIMENTAL || AR9170_USB && NETDEVICES && WLAN &&
ATH_COMMON && USB && MAC80211 || RT2X00_LIB_FIRMWARE && NETDEVICES &&
WLAN && RT2X00 || WIMAX_I2400M && NETDEVICES && WIMAX || ATM_FORE200E
&& ATM_DRIVERS && NETDEVICES && ATM && (PCI || SBUS) || ATM_SOLOS &&
ATM_DRIVERS && NETDEVICES && ATM && PCI || CYCLADES &&
SERIAL_NONSTANDARD && (PCI || ISA) || MOXA_INTELLIO &&
SERIAL_NONSTANDARD && (ISA || EISA || PCI) || ISI &&
SERIAL_NONSTANDARD && PCI || SERIAL_ICOM && HAS_IOMEM && PCI &&
(PPC_ISERIES || PPC_PSERIES) || SERIAL_QE && HAS_IOMEM && QUICC_ENGINE
|| VIDEO_SAA7164 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS &&
VIDEO_V4L2 && DVB_CORE && PCI && I2C || DVB_LGS8GXX && MEDIA_SUPPORT
&& DVB_CAPTURE_DRIVERS && DVB_FE_CUSTOMISE && DVB_CORE && I2C ||
DRM_R128 && HAS_IOMEM && DRM && PCI || DRM_RADEON && HAS_IOMEM && DRM
&& PCI || DRM_MGA && HAS_IOMEM && DRM && PCI || SND_SB16_CSP && SOUND
&& !M68K && SND && SND_ISA && (SND_SB16 || SND_SBAWE) && (BROKEN ||
!PPC) || SND_SSCAPE && SOUND && !M68K && SND && SND_ISA ||
SND_WAVEFRONT && SOUND && !M68K && SND && SND_ISA || SND_MSND_PINNACLE
&& SOUND && !M68K && SND && SND_ISA && X86 && EXPERIMENTAL ||
SND_MSND_CLASSIC && SOUND && !M68K && SND && SND_ISA && X86 &&
EXPERIMENTAL || SND_ASIHPI && SOUND && !M68K && SND && SND_PCI && X86
|| SND_DARLA20 && SOUND && !M68K && SND && SND_PCI || SND_GINA20 &&
SOUND && !M68K && SND && SND_PCI || SND_LAYLA20 && SOUND && !M68K &&
SND && SND_PCI || SND_DARLA24 && SOUND && !M68K && SND && SND_PCI ||
SND_GINA24 && SOUND && !M68K && SND && SND_PCI || SND_LAYLA24 && SOUND
&& !M68K && SND && SND_PCI || SND_MONA && SOUND && !M68K && SND &&
SND_PCI || SND_MIA && SOUND && !M68K && SND && SND_PCI || SND_ECHO3G
&& SOUND && !M68K && SND && SND_PCI || SND_INDIGO && SOUND && !M68K &&
SND && SND_PCI || SND_INDIGOIO && SOUND && !M68K && SND && SND_PCI ||
SND_INDIGODJ && SOUND && !M68K && SND && SND_PCI || SND_INDIGOIOX &&
SOUND && !M68K && SND && SND_PCI || SND_INDIGODJX && SOUND && !M68K &&
SND && SND_PCI || SND_EMU10K1 && SOUND && !M68K && SND && SND_PCI ||
SND_RIPTIDE && SOUND && !M68K && SND && SND_PCI ||
SND_HDA_PATCH_LOADER && SOUND && !M68K && SND && SND_PCI &&
SND_HDA_INTEL && EXPERIMENTAL || SND_SOC_SH4_SIU && SOUND && !M68K &&
SND && SND_SOC && (SUPERH || ARCH_SHMOBILE) && HAVE_CLK ||
USB_ISIGHTFW && USB_SUPPORT && USB || USB_SPEEDTOUCH && USB_SUPPORT &&
USB_ATM || USB_CXACRU && USB_SUPPORT && USB_ATM || USB_UEAGLEATM &&
USB_SUPPORT && USB_ATM || UWB_I1480U && UWB && UWB_HWA || RT2860 &&
STAGING && !STAGING_EXCLUDE_BUILD && PCI && X86 && WLAN || RT2870 &&
STAGING && !STAGING_EXCLUDE_BUILD && USB && (X86 || ARM) && WLAN ||
DRM_NOUVEAU && STAGING && !STAGING_EXCLUDE_BUILD && DRM && PCI ||
TI_ST && STAGING && !STAGING_EXCLUDE_BUILD && RFKILL) selects
FW_LOADER which has unmet direct dependencies (HOTPLUG):  => N/A
	warning: (PS3_PS3AV && PPC_PS3 || PS3_SYS_MANAGER && PPC_PS3) selects
PS3_VUART which has unmet direct dependencies (PPC_PS3 &&
PS3_ADVANCED):  => N/A
	warning: (SCSI_SRP && SCSI_LOWLEVEL && SCSI && PCI) selects SCSI_TGT
which has unmet direct dependencies (SCSI && EXPERIMENTAL):  => N/A

211 improvements:
	arch/arm/mach-mx25/Kconfig: warning: choice value used outside its
choice group: 23 =>
	arch/cris/configs/etrax-100lx_defconfig: warning: override:
reassigning to symbol MTD: 120 =>
	arch/cris/configs/etrax-100lx_defconfig: warning: override:
reassigning to symbol MTD_BLOCK: 173 =>
	arch/cris/configs/etrax-100lx_defconfig: warning: override:
reassigning to symbol MTD_CFI: 143 =>
	arch/cris/configs/etrax-100lx_defconfig: warning: override:
reassigning to symbol MTD_CFI_AMDSTD: 146 =>
	arch/cris/configs/etrax-100lx_defconfig: warning: override:
reassigning to symbol MTD_CFI_INTELEXT: 145 =>
	arch/cris/configs/etrax-100lx_defconfig: warning: override:
reassigning to symbol MTD_CHAR: 172 =>
	arch/cris/configs/etrax-100lx_defconfig: warning: override:
reassigning to symbol NET_ETHERNET: 301 =>
	arch/cris/configs/etrax-100lx_defconfig: warning: override:
reassigning to symbol USB: 497 =>
	arch/ia64/configs/generic_defconfig: warning: symbol value 'm'
invalid for INET_LRO: 317 =>
	arch/m68k/configs/multi_defconfig: warning: symbol value 'm' invalid
for INET_LRO: 222 =>
	arch/m68k/configs/sun3_defconfig: warning: symbol value 'm' invalid
for INET_LRO: 207 =>
	arch/mips/configs/ip22_defconfig: warning: symbol value 'm' invalid
for RFKILL_INPUT: 611 =>
	arch/parisc/configs/a500_defconfig: warning: symbol value 'm' invalid
for PCCARD_NONSTATIC: 199 =>
	arch/powerpc/configs/iseries_defconfig: warning: symbol value 'm'
invalid for GFS2_FS_LOCKING_DLM: 953 =>
	arch/powerpc/configs/pmac32_defconfig: warning: symbol value 'm'
invalid for PCCARD_NONSTATIC: 332 =>
	arch/powerpc/configs/ppc6xx_defconfig: warning: symbol value 'm'
invalid for GFS2_FS_LOCKING_DLM: 3021 =>
	arch/powerpc/configs/ppc6xx_defconfig: warning: symbol value 'm'
invalid for IP_DCCP_CCID3: 683 =>
	arch/powerpc/configs/ppc6xx_defconfig: warning: symbol value 'm'
invalid for IP_DCCP_TFRC_LIB: 686 =>
	modpost: WARNING: modpost: Found 11 section mismatch(es).: N/A =>
	modpost: WARNING: modpost: Found 15 section mismatch(es).: N/A =>
	modpost: WARNING: modpost: Found 21 section mismatch(es).: N/A =>
	modpost: WARNING: modpost: Found 33 section mismatch(es).: N/A =>
	modpost: WARNING: modpost: Found 42 section mismatch(es).: N/A =>
	modpost: WARNING: modpost: Found 55 section mismatch(es).: N/A =>
	scratch/kisskb/src/arch/arm/include/asm/elf.h: warning: 'struct
mm_struct' declared inside parameter list: 124 =>
	scratch/kisskb/src/arch/arm/include/asm/elf.h: warning: its scope is
only this definition or declaration, which is probably not what you
want: 124 =>
	scratch/kisskb/src/arch/arm/include/asm/irq.h: warning:
"NR_IRQS_LEGACY" redefined: 10:1 =>
	scratch/kisskb/src/arch/arm/mach-at91/board-1arm.c: warning:
'at91_init_serial' is deprecated (declared at
/scratch/kisskb/src/arch/arm/mach-at91/include/mach/board.h:144): 59
=>
	scratch/kisskb/src/arch/arm/mach-at91/board-kafa.c: warning:
'at91_init_serial' is deprecated (declared at
/scratch/kisskb/src/arch/arm/mach-at91/include/mach/board.h:144): 62
=>
	scratch/kisskb/src/arch/arm/mach-at91/board-picotux200.c: warning:
'at91_init_serial' is deprecated (declared at
/scratch/kisskb/src/arch/arm/mach-at91/include/mach/board.h:144): 63
=>
	scratch/kisskb/src/arch/arm/mach-omap2/board-omap4panda.c: warning:
unused variable 'status': 277 =>
	scratch/kisskb/src/arch/arm/mach-shmobile/include/mach/irqs.h:
warning: this is the location of the previous definition: 5:1 =>
	scratch/kisskb/src/arch/arm/mm/ioremap.c: warning: control reaches
end of non-void function: 67 =>
	scratch/kisskb/src/arch/arm/plat-iop/time.c: warning: format '%#lx'
expects type 'long unsigned int', but argument 4 has type 'u32': 151
=>
	scratch/kisskb/src/arch/cris/boot/compressed/misc.c: warning:
conflicting types for built-in function 'puts': 109 =>
	scratch/kisskb/src/arch/cris/boot/compressed/misc.c: warning: value
computed is not used: 182 =>
	scratch/kisskb/src/arch/cris/kernel/profile.c: warning: no return
statement in function returning non-void: 57 =>
	scratch/kisskb/src/arch/s390/appldata/appldata_net_sum.c: warning:
initialization from incompatible pointer type: 89 =>
	scratch/kisskb/src/arch/sh/oprofile/../../../drivers/oprofile/buffer_sync.c:
warning: 'val' may be used uninitialized in this function: 502 =>
	scratch/kisskb/src/arch/sparc/include/asm/uaccess_32.h: warning: call
to 'copy_from_user_overflow' declared with attribute warning:
copy_from_user() buffer size is not provably correct: 276 =>
	scratch/kisskb/src/arch/sparc/include/asm/uaccess_64.h: warning: call
to 'copy_from_user_overflow' declared with attribute warning:
copy_from_user() buffer size is not provably correct: 232 =>
	scratch/kisskb/src/crypto/testmgr.c: warning: 'alg_test_crc32c' uses
dynamic stack allocation: 1499 =>
	scratch/kisskb/src/drivers/char/consolemap.c: warning: 'h' may be
used uninitialized in this function: 699 =>
	scratch/kisskb/src/drivers/char/hw_random/n2-drv.c: warning:
initialization makes pointer from integer without a cast: 390 =>
	scratch/kisskb/src/drivers/char/ipmi/ipmi_msghandler.c: warning:
'ipmb_seq' may be used uninitialized in this function: 1657, 1526 =>
	scratch/kisskb/src/drivers/char/ipmi/ipmi_msghandler.c: warning:
'lun' may be used uninitialized in this function: 1816, 1848 =>
	scratch/kisskb/src/drivers/char/ipmi/ipmi_msghandler.c: warning:
'saddr' may be used uninitialized in this function: 1816, 1848 =>
	scratch/kisskb/src/drivers/char/ipmi/ipmi_msghandler.c: warning:
'seqid' may be used uninitialized in this function: 1527, 1658 =>
	scratch/kisskb/src/drivers/char/vt_ioctl.c: warning: 'cc' may be used
uninitialized in this function: 1121 =>
	scratch/kisskb/src/drivers/gpio/gpiolib.c: warning: 'struct gpio'
declared inside parameter list: 1341, 1318 =>
	scratch/kisskb/src/drivers/gpio/gpiolib.c: warning: passing argument
1 of 'of_gpiochip_add' from incompatible pointer type: 1103 =>
	scratch/kisskb/src/drivers/gpio/gpiolib.c: warning: passing argument
1 of 'of_gpiochip_remove' from incompatible pointer type: 1139 =>
	scratch/kisskb/src/drivers/gpio/langwell_gpio.c: warning:
initialization from incompatible pointer type: 69, 131, 116, 100 =>
	scratch/kisskb/src/drivers/gpio/langwell_gpio.c: warning: type
defaults to 'int' in declaration of '__mptr': 69, 131, 116, 100 =>
	scratch/kisskb/src/drivers/gpio/wm8994-gpio.c: warning:
'wm8994_gpio_to_irq' defined but not used: 84 =>
	scratch/kisskb/src/drivers/gpu/drm/drm_edid.c: warning: array
subscript is above array bounds: 1525, 1577 => 1294
	scratch/kisskb/src/drivers/hid/usbhid/hid-core.c: warning: 'field'
may be used uninitialized in this function: 757 =>
	scratch/kisskb/src/drivers/hwmon/pc87360.c: warning: 'res_count' may
be used uninitialized in this function: 1614 =>
	scratch/kisskb/src/drivers/hwmon/smsc47b397.c: warning: 'address' may
be used uninitialized in this function: 380 =>
	scratch/kisskb/src/drivers/i2c/busses/i2c-pxa.c: warning:
initialization discards qualifiers from pointer target type: 1004 =>
	scratch/kisskb/src/drivers/infiniband/hw/cxgb4/cm.c: warning: cast to
pointer from integer of different size: 2317 =>
	scratch/kisskb/src/drivers/infiniband/hw/cxgb4/cq.c: warning: cast
from pointer to integer of different size: 58, 135 =>
	scratch/kisskb/src/drivers/infiniband/hw/cxgb4/mem.c: warning: cast
from pointer to integer of different size: 74 =>
	scratch/kisskb/src/drivers/infiniband/hw/cxgb4/qp.c: warning: cast
from pointer to integer of different size: 147, 1052, 977 =>
	scratch/kisskb/src/drivers/infiniband/hw/nes/nes_verbs.c: warning:
cast to pointer from integer of different size: 477, 3488 =>
	scratch/kisskb/src/drivers/input/input.c: warning: 'scancode' may be
used uninitialized in this function: 664 =>
	scratch/kisskb/src/drivers/media/video/gspca/jpeg.h: warning:
'jpeg_set_qual' defined but not used: 152, 154 =>
	scratch/kisskb/src/drivers/media/video/sh_mobile_ceu_camera.c:
warning: 'ceu_sub_height' may be used uninitialized in this function:
1517 =>
	scratch/kisskb/src/drivers/media/video/sh_mobile_ceu_camera.c:
warning: 'ceu_sub_width' may be used uninitialized in this function:
1517 =>
	scratch/kisskb/src/drivers/misc/enclosure.c: warning: ignoring return
value of 'ERR_PTR', declared with attribute warn_unused_result: 289 =>
	scratch/kisskb/src/drivers/misc/hpilo.c: warning: cast to pointer
from integer of different size: 275 =>
	scratch/kisskb/src/drivers/mtd/devices/phram.c: warning: 'name' may
be used uninitialized in this function: 239 =>
	scratch/kisskb/src/drivers/mtd/nand/atmel_nand.c: warning:
'part_probes' defined but not used: 368 =>
	scratch/kisskb/src/drivers/net/82596.c: warning: label 'err_irq_dev'
defined but not used: 1044 =>
	scratch/kisskb/src/drivers/net/bonding/bond_main.c: warning:
'disable_netpoll' defined but not used: 179 =>
	scratch/kisskb/src/drivers/net/irda/w83977af_ir.c: warning:
'bus_to_virt' is deprecated (declared at
/scratch/kisskb/src/arch/arm/include/asm/memory.h:217): 747 =>
	scratch/kisskb/src/drivers/net/pcmcia/ibmtr_cs.c: warning:
'pcmcia_request_exclusive_irq' is deprecated (declared at
/scratch/kisskb/src/include/pcmcia/ds.h:186): 237 =>
	scratch/kisskb/src/drivers/net/pcmcia/ibmtr_cs.c: warning:
'pcmcia_request_exclusive_irq' is deprecated (declared at
/scratch/kisskb/src/include/pcmcia/ds.h:188): 237 =>
	scratch/kisskb/src/drivers/net/pcmcia/nmclan_cs.c: warning:
'pcmcia_request_exclusive_irq' is deprecated (declared at
/scratch/kisskb/src/include/pcmcia/ds.h:186): 651 =>
	scratch/kisskb/src/drivers/net/pcmcia/nmclan_cs.c: warning:
'pcmcia_request_exclusive_irq' is deprecated (declared at
/scratch/kisskb/src/include/pcmcia/ds.h:188): 651 =>
	scratch/kisskb/src/drivers/net/qlcnic/qlcnic_main.c: warning: the
frame size of 1048 bytes is larger than 1024 bytes: 523 =>
	scratch/kisskb/src/drivers/net/qlcnic/qlcnic_main.c: warning: the
frame size of 1160 bytes is larger than 1024 bytes: 3221 =>
	scratch/kisskb/src/drivers/net/wan/farsync.c: warning: cast to
pointer from integer of different size: 1312, 1407 => 1408
	scratch/kisskb/src/drivers/net/wireless/ipw2x00/ipw2100.c: warning:
cast to pointer from integer of different size: 3063 =>
	scratch/kisskb/src/drivers/net/wireless/iwmc3200wifi/rx.c: warning:
comparison is always true due to limited range of data type: 1198 =>
	scratch/kisskb/src/drivers/parport/parport_pc.c: warning:
'bus_to_virt' is deprecated (declared at
/scratch/kisskb/src/arch/arm/include/asm/memory.h:217): 670 =>
	scratch/kisskb/src/drivers/regulator/wm831x-dcdc.c: warning: control
reaches end of non-void function: 124 =>
	scratch/kisskb/src/drivers/rtc/rtc-msm6242.c: warning: 'return' with
a value, in function returning void: 85 =>
	scratch/kisskb/src/drivers/rtc/rtc-rp5c01.c: warning: 'return' with a
value, in function returning void: 77 =>
	scratch/kisskb/src/drivers/scsi/advansys.c: warning: 'ret' may be
used uninitialized in this function: 11891 =>
	scratch/kisskb/src/drivers/scsi/advansys.c: warning: 'share_irq' may
be used uninitialized in this function: 11891 =>
	scratch/kisskb/src/drivers/ssb/driver_mipscore.c: warning: unused
variable 'irq_name': 158 =>
	scratch/kisskb/src/drivers/usb/core/inode.c: warning: 'dentry' may be
used uninitialized in this function: 532 =>
	scratch/kisskb/src/drivers/usb/gadget/f_fs.c: warning: 'rem_type1'
may be used uninitialized in this function: 1987 =>
	scratch/kisskb/src/drivers/usb/gadget/file_storage.c: warning: unused
variable 'i': 3207 =>
	scratch/kisskb/src/drivers/usb/gadget/file_storage.c: warning: unused
variable ‘i’: 3207 =>
	scratch/kisskb/src/drivers/usb/mon/mon_text.c: warning: 'ep' may be
used uninitialized in this function: 190, 265 =>
	scratch/kisskb/src/drivers/usb/wusbcore/devconnect.c: warning: 'port'
may be used uninitialized in this function: 307 =>
	scratch/kisskb/src/drivers/video/aty/radeon_pm.c: warning:
'radeon_reinitialize_M10' defined but not used: 1718 =>
	scratch/kisskb/src/drivers/video/aty/radeon_pm.c: warning:
'radeon_reinitialize_M9P' defined but not used: 1971 =>
	scratch/kisskb/src/drivers/video/sis/osdef.h: warning: #warning
Neither CONFIG_FB_SIS_300 nor CONFIG_FB_SIS_315 is set: 100:2 =>
	scratch/kisskb/src/drivers/video/sis/osdef.h: warning: #warning sisfb
will not work!: 101:2 =>
	scratch/kisskb/src/drivers/video/sis/sis_main.c: warning:
'sisfb_post_map_vram' defined but not used: 4178 =>
	scratch/kisskb/src/drivers/video/via/via-gpio.c: warning: assignment
from incompatible pointer type: 216 =>
	scratch/kisskb/src/drivers/virtio/virtio_ring.c: warning: cast to
pointer from integer of different size: 273 =>
	scratch/kisskb/src/fs/binfmt_som.c: warning: cast from pointer to
integer of different size: 99, 93, 102, 96 =>
	scratch/kisskb/src/fs/ceph/messenger.c: warning: 'proto' may be used
uninitialized in this function: 641 =>
	scratch/kisskb/src/fs/cifs/asn1.c: warning: 'ch' may be used
uninitialized in this function: 170 =>
	scratch/kisskb/src/fs/cifs/readdir.c: warning: 'current_entry' may be
used uninitialized in this function: 771 =>
	scratch/kisskb/src/fs/coda/sysctl.c: warning: 'coda_table' defined
but not used: 18 =>
	scratch/kisskb/src/fs/exec.c: warning: 'len' may be used
uninitialized in this function: 400 =>
	scratch/kisskb/src/fs/fuse/cuse.c: warning: 'key' may be used
uninitialized in this function: 268 =>
	scratch/kisskb/src/fs/fuse/cuse.c: warning: 'val' may be used
uninitialized in this function: 268 =>
	scratch/kisskb/src/fs/nfs/callback.c: warning: 'rqstp' may be used
uninitialized in this function: 245 =>
	scratch/kisskb/src/fs/nfs/callback.c: warning: ISO C90 forbids mixed
declarations and code: 353 =>
	scratch/kisskb/src/fs/nfs/file.c: warning: unused variable 'count': 258 =>
	scratch/kisskb/src/fs/nfs/file.c: warning: unused variable 'dentry': 138 =>
	scratch/kisskb/src/fs/nfs/nfs4xdr.c: warning: 'attrlen' may be used
uninitialized in this function: 3875, 3751 =>
	scratch/kisskb/src/fs/nfs/nfs4xdr.c: warning: 'savep' may be used
uninitialized in this function: 3874, 3750 =>
	scratch/kisskb/src/fs/nfsd/nfsctl.c: warning: 'bsize' may be used
uninitialized in this function: 1184 =>
	scratch/kisskb/src/fs/nfsd/nfsctl.c: warning: 'newthreads' may be
used uninitialized in this function: 682 =>
	scratch/kisskb/src/fs/omfs/file.c: warning: 'new_block' may be used
uninitialized in this function: 225 =>
	scratch/kisskb/src/fs/quota/quota_tree.c: warning: format '%zd'
expects type 'signed size_t', but argument 2 has type 'ssize_t': 376
=>
	scratch/kisskb/src/fs/quota/quota_v2.c: warning: format '%zd' expects
type 'signed size_t', but argument 3 has type 'ssize_t': 66 =>
	scratch/kisskb/src/fs/squashfs/xattr.c: warning:
'squashfs_xattr_handler' declared inline after being called: 37 =>
	scratch/kisskb/src/fs/squashfs/xattr.c: warning: previous declaration
of 'squashfs_xattr_handler' was here: 37 =>
	scratch/kisskb/src/fs/xfs/linux-2.6/xfs_trace.h: warning: function
declaration isn't a prototype: 571 =>
	scratch/kisskb/src/fs/xfs/linux-2.6/xfs_trace.h: warning: no return
statement in function returning non-void: 571 =>
	scratch/kisskb/src/include/trace/events/writeback.h: warning: passing
argument 2 of 'strncpy' makes pointer from integer without a cast: 88,
64, 139, 76, 43, 12 =>
	scratch/kisskb/src/ipc/mqueue.c: warning: 'msg_ptr' may be used
uninitialized in this function: 938 =>
	scratch/kisskb/src/kernel/cgroup.c: warning: 'l' may be used
uninitialized in this function: 2937 =>
	scratch/kisskb/src/kernel/watchdog.c: warning:
'watchdog_disable_all_cpus' defined but not used: 473 =>
	scratch/kisskb/src/kernel/watchdog.c: warning:
'watchdog_enable_all_cpus' defined but not used: 460 =>
	scratch/kisskb/src/lib/decompress_bunzip2.c: warning: the frame size
of 1824 bytes is larger than 1024 bytes: 511 =>
	scratch/kisskb/src/lib/decompress_bunzip2.c: warning: the frame size
of 1840 bytes is larger than 1024 bytes: 511 =>
	scratch/kisskb/src/lib/decompress_bunzip2.c: warning: the frame size
of 1876 bytes is larger than 1024 bytes: 511 =>
	scratch/kisskb/src/lib/decompress_bunzip2.c: warning: the frame size
of 1880 bytes is larger than 1024 bytes: 511 =>
	scratch/kisskb/src/lib/decompress_bunzip2.c: warning: the frame size
of 1888 bytes is larger than 1024 bytes: 511 =>
	scratch/kisskb/src/lib/decompress_bunzip2.c: warning: the frame size
of 1924 bytes is larger than 1024 bytes: 511 =>
	scratch/kisskb/src/mm/nommu.c: warning: 'capabilities' may be used
uninitialized in this function: 1181 =>
	scratch/kisskb/src/net/bluetooth/hci_core.c: warning: 'skb' may be
used uninitialized in this function: 1637 =>
	scratch/kisskb/src/net/bridge/netfilter/ebt_among.c: warning: 'err'
may be used uninitialized in this function: 182 =>
	scratch/kisskb/src/net/bridge/netfilter/ebtables.c: warning: 'repl'
may be used uninitialized in this function: 1139 =>
	scratch/kisskb/src/net/core/dev.c: warning: 'err' may be used
uninitialized in this function: 1762 =>
	scratch/kisskb/src/net/core/neighbour.c: warning: 'error' may be used
uninitialized in this function: 412 =>
	scratch/kisskb/src/net/core/neighbour.c: warning: 'neigh' may be used
uninitialized in this function: 1199 =>
	scratch/kisskb/src/net/core/skbuff.c: warning: 'err' may be used
uninitialized in this function: 1073 =>
	scratch/kisskb/src/net/ipv4/inet_connection_sock.c: warning: 'head'
may be used uninitialized in this function: 96 =>
	scratch/kisskb/src/net/ipv4/ip_output.c: warning: 'left' may be used
uninitialized in this function: 1027 =>
	scratch/kisskb/src/net/ipv4/ipmr.c: warning: 'vif' may be used
uninitialized in this function: 1964 =>
	scratch/kisskb/src/net/ipv4/raw.c: warning: 'node' may be used
uninitialized in this function: 112 =>
	scratch/kisskb/src/net/ipv4/tcp.c: warning: 'chunk' may be used
uninitialized in this function: 1730 =>
	scratch/kisskb/src/net/ipv6/ip6_output.c: warning: 'left' may be used
uninitialized in this function: 1376 =>
	scratch/kisskb/src/net/ipv6/ip6mr.c: warning: 'vif' may be used
uninitialized in this function: 2070 =>
	scratch/kisskb/src/net/ipv6/raw.c: warning: 'node' may be used
uninitialized in this function: 72 =>
	scratch/kisskb/src/net/ipv6/udp.c: warning: 'node' may be used
uninitialized in this function: 540 =>
	scratch/kisskb/src/net/irda/irda_device.c: warning: 'bus_to_virt' is
deprecated (declared at
/scratch/kisskb/src/arch/arm/include/asm/memory.h:217): 317 =>
	scratch/kisskb/src/net/netfilter/ipvs/ip_vs_ctl.c: warning: 'svc' may
be used uninitialized in this function: 455 =>
	scratch/kisskb/src/net/netfilter/ipvs/ip_vs_proto_sctp.c: warning:
'svc' may be used uninitialized in this function: 64 =>
	scratch/kisskb/src/net/netfilter/ipvs/ip_vs_proto_tcp.c: warning:
'svc' may be used uninitialized in this function: 80 =>
	scratch/kisskb/src/net/sched/sch_cbq.c: warning: 'len' may be used
uninitialized in this function: 1185 =>
	scratch/kisskb/src/net/sched/sch_htb.c: warning: 'len' may be used
uninitialized in this function: 919 =>
	scratch/kisskb/src/net/sched/sch_netem.c: warning: 'skb2' may be used
uninitialized in this function: 160 =>
	scratch/kisskb/src/net/sched/sch_prio.c: warning: 'len' may be used
uninitialized in this function: 132 =>
	scratch/kisskb/src/net/sctp/socket.c: warning: 'head' may be used
uninitialized in this function: 5412 =>
	scratch/kisskb/src/net/sunrpc/auth_gss/svcauth_gss.c: warning: 'N'
may be used uninitialized in this function: 460 =>
	scratch/kisskb/src/net/sunrpc/rpcb_clnt.c: warning: unused variable
'task': 796, 747, 870, 838, 771 =>
	scratch/kisskb/src/net/sunrpc/svcauth.c: warning: 'aops' may be used
uninitialized in this function: 40 =>
	scratch/kisskb/src/net/sunrpc/svcauth_unix.c: warning: 'gid' may be
used uninitialized in this function: 579 =>
	scratch/kisskb/src/net/sunrpc/svcauth_unix.c: warning: 'gids' may be
used uninitialized in this function: 550 =>
	scratch/kisskb/src/net/sunrpc/svcauth_unix.c: warning: 'uid' may be
used uninitialized in this function: 549 =>
	scratch/kisskb/src/net/xfrm/xfrm_state.c: warning: 'x0' may be used
uninitialized in this function: 788 =>
	scratch/kisskb/src/sound/oss/dmabuf.c: warning: 'bus_to_virt' is
deprecated (declared at
/scratch/kisskb/src/arch/arm/include/asm/memory.h:217): 160 =>
	scratch/kisskb/src/sound/oss/dmabuf.c: warning: 'virt_to_bus' is
deprecated (declared at
/scratch/kisskb/src/arch/arm/include/asm/memory.h:212): 117 =>
	scratch/kisskb/src/sound/pcmcia/pdaudiocf/pdaudiocf.c: warning:
'pcmcia_request_exclusive_irq' is deprecated (declared at
/scratch/kisskb/src/include/pcmcia/ds.h:186): 226 =>
	scratch/kisskb/src/sound/pcmcia/pdaudiocf/pdaudiocf.c: warning:
'pcmcia_request_exclusive_irq' is deprecated (declared at
/scratch/kisskb/src/include/pcmcia/ds.h:188): 226 =>
	scratch/kisskb/src/sound/pcmcia/vx/vxpocket.c: warning:
'pcmcia_request_exclusive_irq' is deprecated (declared at
/scratch/kisskb/src/include/pcmcia/ds.h:186): 233 =>
	scratch/kisskb/src/sound/pcmcia/vx/vxpocket.c: warning:
'pcmcia_request_exclusive_irq' is deprecated (declared at
/scratch/kisskb/src/include/pcmcia/ds.h:188): 233 =>
	scratch/kisskb/src/sound/soc/soc-dapm.c: warning: unused variable
'codec': 440 =>
	scratch/kisskb/src/sound/usb/format.c: warning: 'ret' may be used
uninitialized in this function: 354 =>
	tmp/ccWP8cFl.s: Warning: register range not in ascending order: 1116 =>
	warning: "saved_config" [vmlinux] is COMMON symbol: N/A =>
	warning: (ARCH_REQUIRE_GPIOLIB || FB_VIA && HAS_IOMEM && FB && PCI)
selects GPIOLIB which has unmet direct dependencies
(ARCH_WANT_OPTIONAL_GPIOLIB || ARCH_REQUIRE_GPIOLIB): N/A =>
	warning: (ARCH_SMDK2410 && ARCH_S3C2410 || ARCH_H1940 && ARCH_S3C2410
|| MACH_N30 && ARCH_S3C2410 || ARCH_BAST && ARCH_S3C2410 || MACH_OTOM
&& ARCH_S3C2410 || MACH_AML_M5900 && ARCH_S3C2410 || MACH_TCT_HAMMER
&& ARCH_S3C2410 || MACH_VR1000 && ARCH_S3C2410 || MACH_QT2410 &&
ARCH_S3C2410) selects CPU_S3C2410 which has unmet direct dependencies
(CPU_S3C2410): N/A =>
	warning: (COMPACTION && EXPERIMENTAL && HUGETLB_PAGE && MMU) selects
MIGRATION which has unmet direct dependencies (NUMA ||
ARCH_ENABLE_MEMORY_HOTREMOVE): N/A =>
	warning: (CPU_V7 && !ARCH_OMAP2 || CPU_MMP2 && ARCH_MMP) selects
CPU_32v6K which has unmet direct dependencies (CPU_V6): N/A =>
	warning: (FSL_ULI1575) selects GENERIC_ISA_DMA which has unmet direct
dependencies (PPC64 || POWER4 || 6xx && !CPM2): N/A =>
	warning: (GELIC_NET && NETDEVICES && NETDEV_1000 && PPC_PS3) selects
PS3_SYS_MANAGER which has unmet direct dependencies (PPC_PS3 &&
PS3_ADVANCED): N/A =>
	warning: (GFS2_FS && BLOCK && EXPERIMENTAL && (64BIT || LBDAF))
selects QUOTACTL which has unmet direct dependencies (XFS_QUOTA ||
QUOTA): N/A =>
	warning: (IP_VS_PROTO_ESP && NET && NETFILTER && IP_VS ||
IP_VS_PROTO_AH && NET && NETFILTER && IP_VS) selects
IP_VS_PROTO_AH_ESP which has unmet direct dependencies (UNDEFINED):
N/A =>
	warning: (IRQSOFF_TRACER && TRACING_SUPPORT && FTRACE &&
TRACE_IRQFLAGS_SUPPORT && GENERIC_TIME) selects TRACE_IRQFLAGS which
has unmet direct dependencies (DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT
&& PROVE_LOCKING): N/A =>
	warning: (LATENCYTOP && HAVE_LATENCYTOP_SUPPORT) selects SCHEDSTATS
which has unmet direct dependencies (DEBUG_KERNEL && PROC_FS): N/A =>
	warning: (LATENCYTOP && HAVE_LATENCYTOP_SUPPORT) selects SCHED_DEBUG
which has unmet direct dependencies (DEBUG_KERNEL && PROC_FS): N/A =>
	warning: (LOCKDEP && DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT &&
STACKTRACE_SUPPORT && LOCKDEP_SUPPORT && !MIPS && !PPC && !ARM_UNWIND
&& !S390 && !MICROBLAZE || FAULT_INJECTION_STACKTRACE_FILTER &&
FAULT_INJECTION_DEBUG_FS && STACKTRACE_SUPPORT && !X86_64 && !PPC &&
!S390 && !MICROBLAZE || LATENCYTOP && HAVE_LATENCYTOP_SUPPORT && !MIPS
&& !PPC && !S390 && !MICROBLAZE || DWARF_UNWINDER || FUNCTION_TRACER
&& TRACING_SUPPORT && FTRACE && HAVE_FUNCTION_TRACER || KMEMCHECK &&
HAVE_ARCH_KMEMCHECK && DEBUG_KERNEL && !X86_USE_3DNOW && (SLUB ||
SLAB) && !CC_OPTIMIZE_FOR_SIZE && !FUNCTION_TRACER) selects
FRAME_POINTER which has unmet direct dependencies (DEBUG_KERNEL &&
(CRIS || M68K || M68KNOMMU || FRV || UML || AVR32 || SUPERH ||
BLACKFIN || MN10300) || ARCH_WANT_FRAME_POINTERS): N/A =>
	warning: (LOCKDEP && DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT &&
STACKTRACE_SUPPORT && LOCKDEP_SUPPORT && !MIPS && !PPC && !ARM_UNWIND
&& !S390 && !MICROBLAZE || FAULT_INJECTION_STACKTRACE_FILTER &&
FAULT_INJECTION_DEBUG_FS && STACKTRACE_SUPPORT && !X86_64 && !PPC &&
!S390 && !MICROBLAZE || LATENCYTOP && HAVE_LATENCYTOP_SUPPORT && !MIPS
&& !PPC && !S390 && !MICROBLAZE || FUNCTION_TRACER && TRACING_SUPPORT
&& FTRACE && HAVE_FUNCTION_TRACER || KMEMCHECK && HAVE_ARCH_KMEMCHECK
&& DEBUG_KERNEL && !X86_USE_3DNOW && (SLUB || SLAB) &&
!CC_OPTIMIZE_FOR_SIZE && !FUNCTION_TRACER) selects FRAME_POINTER which
has unmet direct dependencies (DEBUG_KERNEL && (CRIS || M68K ||
M68KNOMMU || FRV || UML || AVR32 || SUPERH || BLACKFIN || MN10300) ||
ARCH_WANT_FRAME_POINTERS): N/A =>
	warning: (MACH_ANUBIS && ARCH_S3C2410 || MACH_OSIRIS && ARCH_S3C2410
|| MACH_RX3715 && ARCH_S3C2410 || ARCH_S3C2440 && ARCH_S3C2410 ||
MACH_NEXCODER_2440 && ARCH_S3C2410 || SMDK2440_CPU2440 && ARCH_S3C2410
|| MACH_AT2440EVB && ARCH_S3C2410 || MACH_MINI2440 && ARCH_S3C2410)
selects CPU_S3C2440 which has unmet direct dependencies (CPU_S3C2440):
N/A =>
	warning: (MACH_JIVE && ARCH_S3C2410 || MACH_SMDK2413 && ARCH_S3C2410
|| MACH_VSTMS && ARCH_S3C2410) selects CPU_S3C2412 which has unmet
direct dependencies (CPU_S3C2412): N/A =>
	warning: (MACH_NEO1973_GTA02 && ARCH_S3C2410 || SMDK2440_CPU2442 &&
ARCH_S3C2410 || MACH_RX1950 && ARCH_S3C2410) selects CPU_S3C2442 which
has unmet direct dependencies (CPU_S3C2442): N/A =>
	warning: (MACH_SMDK2416 && ARCH_S3C2410) selects CPU_S3C2416 which
has unmet direct dependencies (CPU_S3C2416): N/A =>
	warning: (OPTPROBES && KPROBES && HAVE_OPTPROBES && !PREEMPT ||
MTD_UBI_DEBUG && MTD && SYSFS && MTD_UBI || UBIFS_FS_DEBUG &&
MISC_FILESYSTEMS && UBIFS_FS || LOCKDEP && DEBUG_KERNEL &&
TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT ||
LATENCYTOP && HAVE_LATENCYTOP_SUPPORT) selects KALLSYMS_ALL which has
unmet direct dependencies (DEBUG_KERNEL && KALLSYMS): N/A =>
	warning: (PPC_PS3 && PPC64 && PPC_BOOK3S || PPC_CELLEB && PPC64 &&
PPC_BOOK3S || USB_OHCI_HCD_PPC_SOC && USB_SUPPORT && USB_OHCI_HCD &&
(STB03xxx || PPC_MPC52xx) || USB_OHCI_HCD_PPC_OF_BE && USB_SUPPORT &&
USB_OHCI_HCD && PPC_OF) selects USB_OHCI_BIG_ENDIAN_MMIO which has
unmet direct dependencies (USB_OHCI_HCD): N/A =>
	warning: (PPC_PS3 && PPC64 && PPC_BOOK3S || PPC_CELLEB && PPC64 &&
PPC_BOOK3S || XPS_USB_HCD_XILINX && USB_SUPPORT && USB_EHCI_HCD &&
(PPC32 || MICROBLAZE)) selects USB_EHCI_BIG_ENDIAN_MMIO which has
unmet direct dependencies (USB_EHCI_HCD && (PPC_CELLEB || PPC_PS3 ||
440EPX || ARCH_IXP4XX || XPS_USB_HCD_XILINX)): N/A =>
	warning: (PPC_PS3 && PPC64 && PPC_BOOK3S || USB_OHCI_HCD_PPC_OF_LE &&
USB_SUPPORT && USB_OHCI_HCD && PPC_OF || USB_OHCI_HCD_PCI &&
USB_SUPPORT && USB_OHCI_HCD && PCI && (STB03xxx || PPC_MPC52xx ||
USB_OHCI_HCD_PPC_OF)) selects USB_OHCI_LITTLE_ENDIAN which has unmet
direct dependencies (USB_OHCI_HCD): N/A =>
	warning: (SCSI_AHA152X && SCSI_LOWLEVEL && ISA && SCSI && !64BIT ||
SCSI_AIC7XXX && SCSI_LOWLEVEL && (PCI || EISA) && SCSI || SCSI_AIC79XX
&& SCSI_LOWLEVEL && PCI && SCSI || SCSI_DMX3191D && SCSI_LOWLEVEL &&
PCI && SCSI || SCSI_DTC3280 && SCSI_LOWLEVEL && ISA && SCSI ||
SCSI_GENERIC_NCR5380 && SCSI_LOWLEVEL && ISA && SCSI ||
SCSI_GENERIC_NCR5380_MMIO && SCSI_LOWLEVEL && ISA && SCSI ||
SCSI_NCR_D700 && SCSI_LOWLEVEL && MCA && SCSI || SCSI_LASI700 &&
SCSI_LOWLEVEL && GSC && SCSI || SCSI_SNI_53C710 && SCSI_LOWLEVEL &&
SNI_RM && SCSI || SCSI_SYM53C8XX_2 && SCSI_LOWLEVEL && PCI && SCSI ||
SCSI_ZALON && SCSI_LOWLEVEL && GSC && SCSI || SCSI_NCR_Q720 &&
SCSI_LOWLEVEL && MCA && SCSI || SCSI_PAS16 && SCSI_LOWLEVEL && ISA &&
SCSI || SCSI_SIM710 && SCSI_LOWLEVEL && (EISA || MCA) && SCSI ||
SCSI_T128 && SCSI_LOWLEVEL && ISA && SCSI || SCSI_ACORNSCSI_3 &&
SCSI_LOWLEVEL && ARCH_ACORN && SCSI || SCSI_CUMANA_1 && SCSI_LOWLEVEL
&& ARCH_ACORN && EXPERIMENTAL && SCSI || SCSI_OAK1 && SCSI_LOWLEVEL &&
ARCH_ACORN && EXPERIMENTAL && SCSI || JAZZ_ESP && SCSI_LOWLEVEL &&
MACH_JAZZ && SCSI || SCSI_A4000T && SCSI_LOWLEVEL && AMIGA && SCSI &&
EXPERIMENTAL || SCSI_ZORRO7XX && SCSI_LOWLEVEL && ZORRO && SCSI &&
EXPERIMENTAL || ATARI_SCSI && SCSI_LOWLEVEL && ATARI && SCSI ||
MAC_SCSI && SCSI_LOWLEVEL && MAC && SCSI=y || SCSI_MAC_ESP &&
SCSI_LOWLEVEL && MAC && SCSI || MVME147_SCSI && SCSI_LOWLEVEL &&
MVME147 && SCSI=y || MVME16x_SCSI && SCSI_LOWLEVEL && MVME16x && SCSI
|| BVME6000_SCSI && SCSI_LOWLEVEL && BVME6000 && SCSI || SUN3_SCSI &&
SCSI_LOWLEVEL && SUN3 && SCSI || SUN3X_ESP && SCSI_LOWLEVEL && SUN3X
&& SCSI=y || SCSI_SUNESP && SCSI_LOWLEVEL && SBUS && SCSI ||
PCMCIA_AHA152X && SCSI_LOWLEVEL_PCMCIA && SCSI && PCMCIA && m &&
<choice> && !64BIT || FUSION_SPI && FUSION && PCI && SCSI) selects
SCSI_SPI_ATTRS which has unmet direct dependencies (SCSI_FC_ATTRS):
N/A =>
	warning: (SCx200_GPIO && SCx200 || PC8736x_GPIO && X86) selects
NSC_GPIO which has unmet direct dependencies (X86_32): N/A =>
	warning: (SUPERH32) selects HAVE_HW_BREAKPOINT which has unmet direct
dependencies (PERF_EVENTS): N/A =>
	warning: (TREE_RCU_TRACE || MTD_UBI_DEBUG && MTD && SYSFS && MTD_UBI
|| UBIFS_FS_DEBUG && MISC_FILESYSTEMS && UBIFS_FS || DEBUG_KMEMLEAK &&
DEBUG_KERNEL && EXPERIMENTAL && !MEMORY_HOTPLUG && (X86 || ARM || PPC
|| S390 || SPARC64 || SUPERH || MICROBLAZE) && SYSFS || TRACING ||
BLK_DEV_IO_TRACE && TRACING_SUPPORT && FTRACE && SYSFS && BLOCK)
selects DEBUG_FS which has unmet direct dependencies (SYSFS): N/A =>
	warning: (XFRM_IPCOMP && NET || NET_KEY && NET || INET_AH && NET &&
INET || INET_ESP && NET && INET || INET_XFRM_MODE_TRANSPORT && NET &&
INET || INET_XFRM_MODE_TUNNEL && NET && INET || INET_XFRM_MODE_BEET &&
NET && INET || INET6_AH && NET && INET && IPV6 || INET6_ESP && NET &&
INET && IPV6 || IPV6_MIP6 && NET && INET && IPV6 && EXPERIMENTAL ||
INET6_XFRM_MODE_TRANSPORT && NET && INET && IPV6 ||
INET6_XFRM_MODE_TUNNEL && NET && INET && IPV6 || INET6_XFRM_MODE_BEET
&& NET && INET && IPV6 || INET6_XFRM_MODE_ROUTEOPTIMIZATION && NET &&
INET && IPV6 && EXPERIMENTAL) selects XFRM which has unmet direct
dependencies (XFRM): N/A =>
	warning: (ZCRYPT && CRYPTO && CRYPTO_HW && S390 && ZCRYPT=y) selects
ZCRYPT_MONOLITHIC which has unmet direct dependencies (ZCRYPT=m): N/A
=>
	warning: 1 bad relocations: N/A =>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
