Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753744Ab1DIHhh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Apr 2011 03:37:37 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:51627 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412Ab1DIHhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Apr 2011 03:37:34 -0400
Date: Sat, 9 Apr 2011 09:37:30 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Build regressions/improvements in v2.6.39-rc2
Message-ID: <alpine.DEB.2.00.1104090936570.7873@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is the list of build error/warning regressions/improvements in
v2.6.39-rc2[1] compared to v2.6.38[2].

Summarized:
  - build errors: +63/-19
  - build warnings: +488/-99

JFYI, when comparing v2.6.39-rc2 to v2.6.39-rc1[3], the summaries are:
  - build errors: +47/-35
  - build warnings: +203/-126

In addition, I put the verbose summary at
http://www.kernel.org/pub/linux/kernel/people/geert/linux-log/v2.6.39-rc2.summary.gz
so you can easily find out for which configs and architectures the
errors/warnings you're interested in are happening.

Happy fixing! ;-)

Thanks to the linux-next team for providing the build service.

[1] http://kisskb.ellerman.id.au/kisskb/head/3885/ (all 108 configs)
[2] http://kisskb.ellerman.id.au/kisskb/head/3816/ (all 108 configs)
[3] http://kisskb.ellerman.id.au/kisskb/head/3864/ (all 108 configs)


*** ERRORS ***

63 regressions:
  + build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/ethtool.h: error: expected specifier-qualifier-list before '__u32': 104, 90, 21, 282, 389, 460, 521, 444, 96, 297, 82, 57, 291, 258, 231, 482, 209, 510, 265, 113 => 104, 538, 90, 21, 523, 552, 266, 445, 292, 96, 82, 512, 563, 57, 259, 283, 298, 484, 390, 231, 209, 462, 574, 113
  + build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/types.h: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__le16'*** [Documentation/accounting/getdelays] Error 1:  => 27
  + src/Documentation/accounting/getdelays.c: error: 'struct nlattr' has no member named 'nla_len'/scratch/kisskb/build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/types.h:34: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__sum16':  => 508
  + src/Documentation/networking/ifenslave.c: error: 'struct ethtool_drvinfo' has no member named 'fw_version': 617 => 630, 617
  + src/Documentation/spi/spidev_fdx.c: error: 'bits' undeclared (first use in this function):  => 92
  + src/arch/avr32/mach-at32ap/extint.c: error: 'data' undeclared (first use in this function):  => 85, 72, 66, 91, 78
  + src/arch/avr32/mach-at32ap/extint.c: error: 'struct irq_chip' has no member named 'irq':  => 92, 67, 73, 86, 80, 79
  + src/arch/avr32/mach-at32ap/extint.c: error: (Each undeclared identifier is reported only once:  => 66
  + src/arch/avr32/mach-at32ap/extint.c: error: for each function it appears in.):  => 66
  + src/arch/avr32/mach-at32ap/pio.c: error: 'gpio' undeclared here (not in a function):  => 263
  + src/arch/avr32/mach-at32ap/pio.c: error: 'gpio_irq_unmask' undeclared here (not in a function):  => 279
  + src/arch/avr32/mach-at32ap/pio.c: error: syntax error before '(' token:  => 265
  + src/arch/avr32/mach-at32ap/pio.c: error: syntax error before ')' token:  => 260
  + src/arch/powerpc/kernel/crash.c: error: implicit declaration of function 'crash_kexec_wait_realmode':  => 349
  + src/arch/xtensa/kernel/irq.c: error: 'struct irq_chip' has no member named 'irq':  => 104, 80, 92, 109, 98, 99, 93, 86
  + src/drivers/block/paride/bpck.c: error: implicit declaration of function 'inb':  => 57
  + src/drivers/block/paride/bpck.c: error: implicit declaration of function 'inl':  => 188
  + src/drivers/block/paride/bpck.c: error: implicit declaration of function 'inw':  => 181
  + src/drivers/block/paride/bpck.c: error: implicit declaration of function 'outb':  => 56
  + src/drivers/block/paride/bpck.c: error: implicit declaration of function 'outl':  => 142
  + src/drivers/block/paride/bpck.c: error: implicit declaration of function 'outw':  => 135
  + src/drivers/char/ipmi/ipmi_si_intf.c: error: implicit declaration of function 'inb':  => 1368
  + src/drivers/char/ipmi/ipmi_si_intf.c: error: implicit declaration of function 'inl':  => 1398
  + src/drivers/char/ipmi/ipmi_si_intf.c: error: implicit declaration of function 'inw':  => 1383
  + src/drivers/char/ipmi/ipmi_si_intf.c: error: implicit declaration of function 'outb':  => 1376
  + src/drivers/char/ipmi/ipmi_si_intf.c: error: implicit declaration of function 'outl':  => 1406
  + src/drivers/char/ipmi/ipmi_si_intf.c: error: implicit declaration of function 'outw':  => 1391
  + src/drivers/char/ipmi/ipmi_si_intf.c: error: invalid operands to binary << (have 'void *' and 'int'):  => 1406, 1391
  + src/drivers/char/pcmcia/cm4000_cs.c: error: implicit declaration of function 'inb':  => 312
  + src/drivers/char/pcmcia/cm4000_cs.c: error: implicit declaration of function 'outb':  => 429
  + src/drivers/char/pcmcia/cm4040_cs.c: error: implicit declaration of function 'inb':  => 110
  + src/drivers/char/pcmcia/cm4040_cs.c: error: implicit declaration of function 'outb':  => 178
  + src/drivers/char/pcmcia/synclink_cs.c: error: implicit declaration of function 'inb':  => 683
  + src/drivers/char/pcmcia/synclink_cs.c: error: implicit declaration of function 'inw':  => 860
  + src/drivers/char/pcmcia/synclink_cs.c: error: implicit declaration of function 'outb':  => 694
  + src/drivers/char/pcmcia/synclink_cs.c: error: implicit declaration of function 'outw':  => 342
  + src/drivers/char/tpm/tpm.h: error: invalid operands to binary & (have 'void *' and 'int'):  => 130
  + src/drivers/char/tpm/tpm_tis.c: error: implicit declaration of function 'ioread32':  => 413
  + src/drivers/char/tpm/tpm_tis.c: error: implicit declaration of function 'ioread8':  => 104
  + src/drivers/char/tpm/tpm_tis.c: error: implicit declaration of function 'iowrite32':  => 422
  + src/drivers/char/tpm/tpm_tis.c: error: implicit declaration of function 'iowrite8':  => 117
  + src/drivers/gpu/drm/radeon/radeon_gart.c: error: 'DMA_ERROR_CODE' undeclared (first use in this function):  => 186
  + src/drivers/gpu/drm/radeon/radeon_gart.c: error: (Each undeclared identifier is reported only once:  => 186
  + src/drivers/gpu/drm/radeon/radeon_gart.c: error: for each function it appears in.):  => 186
  + src/drivers/hwmon/f71805f.c: error: implicit declaration of function 'inb':  => 78
  + src/drivers/hwmon/f71805f.c: error: implicit declaration of function 'outb':  => 77
  + src/drivers/hwmon/w83627hf.c: error: implicit declaration of function 'inb':  => 123
  + src/drivers/hwmon/w83627hf.c: error: implicit declaration of function 'inb_p':  => 1486
  + src/drivers/hwmon/w83627hf.c: error: implicit declaration of function 'outb':  => 115
  + src/drivers/hwmon/w83627hf.c: error: implicit declaration of function 'outb_p':  => 1460
  + src/drivers/input/touchscreen/mk712.c: error: implicit declaration of function 'inb':  => 91
  + src/drivers/input/touchscreen/mk712.c: error: implicit declaration of function 'inw':  => 114
  + src/drivers/input/touchscreen/mk712.c: error: implicit declaration of function 'outb':  => 127
  + src/drivers/pcmcia/electra_cf.c: error: implicit declaration of function '__ioremap_at':  => 226
  + src/drivers/pcmcia/electra_cf.c: error: implicit declaration of function '__iounmap_at':  => 316
  + src/drivers/pcmcia/electra_cf.c: error: implicit declaration of function 'in_le32':  => 70
  + src/drivers/pcmcia/electra_cf.c: error: implicit declaration of function 'ioremap':  => 213
  + src/drivers/pcmcia/electra_cf.c: error: implicit declaration of function 'iounmap':  => 318
  + src/drivers/pcmcia/electra_cf.c: error: implicit declaration of function 'out_le32':  => 147
  + src/drivers/usb/host/ohci-hcd.c: error: #error "missing bus glue for ohci-hcd":  => 1118:2
  + src/drivers/video/backlight/hp680_bl.c: error: implicit declaration of function 'inw':  => 48
  + src/drivers/video/backlight/hp680_bl.c: error: implicit declaration of function 'outw':  => 50
  + src/kernel/fork.c: error: implicit declaration of function 'alloc_thread_info_node':  => 267

19 improvements:
  - build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/types.h: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__be32'/scratch/kisskb/build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/types.h:29: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__le32': 30 => 
  - build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/types.h: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__be32'/scratch/kisskb/build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/types.h:31: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__le64': 30 => 
  - build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/types.h: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__le32'/scratch/kisskb/build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/types.h:28: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__be16': 29 => 
  - error: vsprintf.c: relocation truncated to fit: R_AVR32_11H_PCREL against `.text'+71c: (.text+0xb22) => 
  - src/Documentation/accounting/getdelays.c: error: 'struct nlattr' has no member named 'nla_len': 464, 495, 142, 508, 187, 140, 469 => 464, 495, 142, 187, 140, 469
  - src/Documentation/spi/spidev_fdx.c: error: 'bits' undeclared (first use in this function)In file included from /scratch/kisskb/build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/netlink.h:5,: 92 => 
  - src/arch/cris/arch-v10/kernel/irq.c: error: implicit declaration of function 'set_irq_desc_and_handler': 202 => 
  - src/arch/powerpc/kernel/exceptions-64s.S: Error: attempt to move .org backwards: 999, 989, 1008 => 
  - src/drivers/char/specialix.c: error: implicit declaration of function 'inb': 228 => 
  - src/drivers/char/specialix.c: error: implicit declaration of function 'outb': 227 => 
  - src/drivers/char/specialix.c: error: invalid operands to binary | (have 'void *' and 'int'): 237, 227 => 
  - src/drivers/dma/pch_dma.c: error: implicit declaration of function 'kfree': 920 => 
  - src/drivers/dma/pch_dma.c: error: implicit declaration of function 'kzalloc': 785 => 
  - src/drivers/i2c/busses/i2c-xiic.c: error: implicit declaration of function 'ioread32': 198 => 
  - src/drivers/i2c/busses/i2c-xiic.c: error: implicit declaration of function 'ioread8': 183 => 
  - src/drivers/i2c/busses/i2c-xiic.c: error: implicit declaration of function 'iowrite16': 188 => 
  - src/drivers/i2c/busses/i2c-xiic.c: error: implicit declaration of function 'iowrite32': 193 => 
  - src/drivers/i2c/busses/i2c-xiic.c: error: implicit declaration of function 'iowrite8': 178 => 
  - src/fs/ntfs/file.c: error: insn does not satisfy its constraints:: 2068 => 


*** WARNINGS ***

488 regressions:
  + /tmp/ccqcdWCQ.s: Warning: source register same as write-back base:  => 104
  + <stdin>: warning: #warning syscall clock_adjtime not implemented:  => 1546:2
  + <stdin>: warning: #warning syscall name_to_handle_at not implemented:  => 1538:2
  + <stdin>: warning: #warning syscall open_by_handle_at not implemented:  => 1542:2
  + <stdin>: warning: #warning syscall syncfs not implemented:  => 1550:2
  + arch/powerpc/configs/pmac32_defconfig: warning: symbol value 'm' invalid for BT_L2CAP:  => 115
  + arch/powerpc/configs/pmac32_defconfig: warning: symbol value 'm' invalid for BT_SCO:  => 116
  + arch/powerpc/configs/ppc6xx_defconfig: warning: symbol value 'm' invalid for BT_L2CAP:  => 354
  + arch/powerpc/configs/ppc6xx_defconfig: warning: symbol value 'm' invalid for BT_SCO:  => 355
  + arch/powerpc/configs/ps3_defconfig: warning: symbol value 'm' invalid for BT_L2CAP:  => 55
  + arch/powerpc/configs/ps3_defconfig: warning: symbol value 'm' invalid for BT_SCO:  => 56
  + modpost: WARNING: modpost: Found 3 section mismatch(es).:  => N/A
  + src/arch/avr32/mach-at32ap/extint.c: warning: initialization from incompatible pointer type:  => 142, 144, 141, 140, 143
  + src/arch/avr32/mach-at32ap/extint.c: warning: passing argument 1 of 'irqd_set_trigger_type' from incompatible pointer type:  => 129
  + src/arch/m68k/kernel/setup_mm.c: warning: unused variable 'i':  => 219
  + src/arch/parisc/kernel/cache.c: warning: format '%s' expects type 'char *', but argument 4 has type 'void * const':  => 310
  + src/arch/parisc/kernel/cache.c: warning: pointer type mismatch in conditional expression:  => 310
  + src/arch/s390/mm/extmem.c: warning: 'end_addr' may be used uninitialized in this function: 573 => 411, 573
  + src/arch/s390/mm/extmem.c: warning: 'start_addr' may be used uninitialized in this function: 573 => 411, 573
  + src/arch/sh/oprofile/../../../drivers/oprofile/buffer_sync.c: warning: 'code' may be used uninitialized in this function:  => 328
  + src/arch/sh/oprofile/../../../drivers/oprofile/buffer_sync.c: warning: 'pc' may be used uninitialized in this function:  => 328
  + src/arch/sh/oprofile/../../../drivers/oprofile/buffer_sync.c: warning: 'val' may be used uninitialized in this function:  => 503
  + src/arch/x86/kernel/cpu/perf_event.c: warning: 'emptyconstraint' defined but not used:  => 1408
  + src/arch/x86/kernel/cpu/perf_event.c: warning: 'x86_get_event_constraints' defined but not used:  => 1411
  + src/arch/x86/kernel/cpu/perf_event.c: warning: 'x86_pmu_disable_all' defined but not used:  => 701
  + src/arch/x86/kernel/cpu/perf_event.c: warning: 'x86_pmu_enable_all' defined but not used:  => 744
  + src/arch/x86/kernel/cpu/perf_event.c: warning: 'x86_pmu_enable_event' defined but not used:  => 1083
  + src/arch/x86/kernel/cpu/perf_event.c: warning: 'x86_pmu_handle_irq' defined but not used:  => 1275
  + src/arch/x86/kernel/cpu/perf_event.c: warning: 'x86_pmu_hw_config' defined but not used:  => 628
  + src/arch/x86/kernel/cpu/perf_event.c: warning: 'x86_schedule_events' defined but not used:  => 766
  + src/arch/x86/kernel/reboot_32.S: Warning: shift count out of range (32 is not between 0 and 31):  => 134
  + src/arch/x86/kernel/reboot_32.S: Warning: shift count out of range (40 is not between 0 and 31):  => 134
  + src/arch/x86/kvm/emulate.c: warning: 'cs_sel' may be used uninitialized in this function:  => 1706
  + src/arch/x86/kvm/emulate.c: warning: 'ss_sel' may be used uninitialized in this function:  => 1706
  + src/arch/xtensa/include/asm/regs.h: warning: this is the location of the previous definition:  => 59:1
  + src/arch/xtensa/kernel/irq.c: warning: initialization from incompatible pointer type:  => 119, 120, 116, 118, 117, 121
  + src/block/blk-merge.c: warning: 'bbio' may be used uninitialized in this function:  => 18
  + src/crypto/algif_hash.c: warning: 'err' may be used uninitialized in this function:  => 47
  + src/drivers/acpi/power_meter.c: warning: 'val' may be used uninitialized in this function:  => 380
  + src/drivers/ata/pata_legacy.c: warning: 'r' is used uninitialized in this function:  => 1098
  + src/drivers/ata/sata_sil.c: warning: 'serror' may be used uninitialized in this function:  => 441
  + src/drivers/base/memory.c: warning: 'ret' may be used uninitialized in this function:  => 404
  + src/drivers/base/power/sysfs.c: warning: 'dev_attr_async' defined but not used:  => 431
  + src/drivers/base/power/sysfs.c: warning: 'dev_attr_wakeup' defined but not used:  => 249
  + src/drivers/block/drbd/drbd_int.h: warning: comparison is always false due to limited range of data type:  => 2226
  + src/drivers/block/drbd/drbd_receiver.c: warning: 'rl' may be used uninitialized in this function:  => 3400
  + src/drivers/bluetooth/btwilink.c: warning: overflow in implicit constant conversion:  => 178
  + src/drivers/char/ipmi/ipmi_msghandler.c: warning: 'ipmb_seq' may be used uninitialized in this function:  => 1684, 1553
  + src/drivers/char/ipmi/ipmi_msghandler.c: warning: 'lun' may be used uninitialized in this function:  => 1875, 1843
  + src/drivers/char/ipmi/ipmi_msghandler.c: warning: 'saddr' may be used uninitialized in this function:  => 1875, 1843
  + src/drivers/char/ipmi/ipmi_msghandler.c: warning: 'seqid' may be used uninitialized in this function:  => 1554, 1685
  + src/drivers/char/tpm/tpm.c: warning: format '%zd' expects type 'signed size_t', but argument 3 has type 'ssize_t':  => 433, 400
  + src/drivers/dma/fsldma.c: warning: initialization from incompatible pointer type:  => 1457
  + src/drivers/dma/fsldma.c: warning: passing argument 1 of 'platform_driver_register' from incompatible pointer type:  => 1468
  + src/drivers/dma/fsldma.c: warning: passing argument 1 of 'platform_driver_unregister' from incompatible pointer type:  => 1473
  + src/drivers/dma/pch_dma.c: warning: 'i' may be used uninitialized in this function:  => 406
  + src/drivers/gpu/drm/radeon/ni.c: warning: 'chip_name' may be used uninitialized in this function:  => 275
  + src/drivers/gpu/drm/radeon/ni.c: warning: 'mc_req_size' may be used uninitialized in this function:  => 277
  + src/drivers/gpu/drm/radeon/ni.c: warning: 'me_req_size' may be used uninitialized in this function:  => 277
  + src/drivers/gpu/drm/radeon/ni.c: warning: 'pfp_req_size' may be used uninitialized in this function:  => 277
  + src/drivers/gpu/drm/radeon/ni.c: warning: 'rlc_chip_name' may be used uninitialized in this function:  => 276
  + src/drivers/gpu/drm/radeon/ni.c: warning: 'rlc_req_size' may be used uninitialized in this function:  => 277
  + src/drivers/gpu/drm/radeon/r600.c: warning: 'chip_name' may be used uninitialized in this function:  => 1948
  + src/drivers/gpu/drm/radeon/r600.c: warning: 'rlc_chip_name' may be used uninitialized in this function:  => 1949
  + src/drivers/infiniband/hw/mlx4/qp.c: warning: 'vlan' may be used uninitialized in this function:  => 1304
  + src/drivers/infiniband/hw/nes/nes.c: warning: ignoring return value of 'kstrtoul', declared with attribute warn_unused_result:  => 1141
  + src/drivers/infiniband/ulp/srp/ib_srp.c: warning: cast to pointer from integer of different size:  => 1150, 1234
  + src/drivers/input/input.c: warning: 'index' may be used uninitialized in this function:  => 724
  + src/drivers/input/misc/hp_sdc_rtc.c: warning: 'hp_sdc_rtc_set_fhs' defined but not used: 320 => 320, 321
  + src/drivers/input/misc/hp_sdc_rtc.c: warning: 'hp_sdc_rtc_set_i8042timer' defined but not used: 360 => 360, 361
  + src/drivers/input/misc/hp_sdc_rtc.c: warning: 'hp_sdc_rtc_set_rt' defined but not used: 280 => 281, 280
  + src/drivers/input/touchscreen/htcpen.c: warning: 'pnp_ids' defined but not used:  => 50
  + src/drivers/isdn/hardware/mISDN/mISDNipac.c: warning: unsupported argument to '__builtin_return_address':  => 754
  + src/drivers/isdn/hardware/mISDN/netjet.c: warning: comparison is always false due to limited range of data type:  => 318
  + src/drivers/isdn/hardware/mISDN/w6692.c: warning: unsupported argument to '__builtin_return_address':  => 1188
  + src/drivers/isdn/sc/init.c: warning: passing argument 1 of 'readl' makes pointer from integer without a cast:  => 497, 487, 507
  + src/drivers/media/radio/wl128x/fmdrv_common.c: warning: comparison is always false due to limited range of data type:  => 745
  + src/drivers/media/radio/wl128x/fmdrv_common.c: warning: large integer implicitly truncated to unsigned type:  => 1512
  + src/drivers/media/radio/wl128x/fmdrv_rx.c: warning: comparison is always false due to limited range of data type:  => 307
  + src/drivers/media/video/gspca/sonixj.c: warning: comparison is always false due to limited range of data type:  => 2905
  + src/drivers/memstick/host/r592.c: warning: 'r592_clear_interrupts' defined but not used:  => 192, 193
  + src/drivers/mfd/wl1273-core.c: warning: unused variable 'val':  => 156
  + src/drivers/misc/apds990x.c: warning: 'apds990x_chip_on' defined but not used: 612 => 613, 612
  + src/drivers/misc/apds990x.c: warning: comparison is always false due to limited range of data type:  => 701
  + src/drivers/misc/pch_phub.c: warning: 'pch_phub_restore_reg_conf' defined but not used: 180 => 201, 202
  + src/drivers/misc/pch_phub.c: warning: 'pch_phub_save_reg_conf' defined but not used: 121 => 142, 143
  + src/drivers/misc/vmw_balloon.c: warning: 'hv_status' may be used uninitialized in this function:  => 414
  + src/drivers/mtd/mtdswap.c: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'unsigned int':  => 1456
  + src/drivers/net/pcmcia/smc91c92_cs.c: warning: 'j' may be used uninitialized in this function:  => 812
  + src/drivers/net/rionet.c: warning: cast from pointer to integer of different size:  => 166
  + src/drivers/net/sh_eth.c: warning: 'mdp' may be used uninitialized in this function:  => 1773
  + src/drivers/net/wireless/ath/ath5k/reset.c: warning: 'txf2txs' may be used uninitialized in this function:  => 100
  + src/drivers/net/wireless/b43/phy_n.c: warning: 'save_regs_phy$7' may be used uninitialized in this function:  => 2270
  + src/drivers/net/wireless/b43/phy_n.c: warning: 'save_regs_phy$8' may be used uninitialized in this function:  => 2270
  + src/drivers/net/wireless/b43/phy_n.c: warning: 'tabent_r2' may be used uninitialized in this function:  => 3848
  + src/drivers/net/wireless/b43/phy_n.c: warning: 'tabent_r3' may be used uninitialized in this function:  => 3849
  + src/drivers/net/wireless/mwl8k.c: warning: 'ap_legacy_rates' may be used uninitialized in this function:  => 3983
  + src/drivers/net/wireless/p54/eeprom.c: warning: 'freq' may be used uninitialized in this function:  => 494
  + src/drivers/net/wireless/rt2x00/rt2800lib.c: warning: 'comp_value' may be used uninitialized in this function:  => 1822
  + src/drivers/net/wireless/rtlwifi/efuse.c: warning: 'hworden' may be used uninitialized in this function:  => 710
  + src/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c: warning: 'cck_index' may be used uninitialized in this function:  => 637
  + src/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c: warning: 'cck_index_old' may be used uninitialized in this function:  => 637
  + src/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c: warning: 'box_extreg' may be used uninitialized in this function:  => 303
  + src/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c: warning: 'box_reg' may be used uninitialized in this function:  => 303
  + src/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c: warning: 'buf_index' may be used uninitialized in this function:  => 416
  + src/drivers/net/wireless/rtlwifi/rtl8192ce/rf.c: warning: 'chnlgroup' may be used uninitialized in this function:  => 205
  + src/drivers/net/wireless/rtlwifi/rtl8192ce/rf.c: warning: 'u4_regvalue' may be used uninitialized in this function:  => 450
  + src/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c: warning: 'hq_sele' may be used uninitialized in this function:  => 924
  + src/drivers/net/wireless/wl3501_cs.c: warning: 'next_addr1' is used uninitialized in this function:  => 786
  + src/drivers/pci/intel-iommu.c: warning: no return statement in function returning non-void:  => 3220
  + src/drivers/pci/pci-driver.c: warning: 'pci_pm_default_resume_early' defined but not used:  => 457
  + src/drivers/pci/pcie/aer/aer_inject.c: warning: 'cor_mask_orig' may be used uninitialized in this function:  => 329
  + src/drivers/pci/pcie/aer/aer_inject.c: warning: 'uncor_mask_orig' may be used uninitialized in this function:  => 329
  + src/drivers/pcmcia/electra_cf.c: warning: assignment makes pointer from integer without a cast:  => 213, 222
  + src/drivers/pcmcia/electra_cf.c: warning: comparison between pointer and integer:  => 227
  + src/drivers/platform/x86/ibm_rtl.c: warning: cast from pointer to integer of different size:  => 278, 290
  + src/drivers/power/bq27x00_battery.c: warning: 'bq27x00_powersupply_init' defined but not used:  => 520
  + src/drivers/power/bq27x00_battery.c: warning: 'bq27x00_powersupply_unregister' defined but not used:  => 546
  + src/drivers/regulator/wm831x-dcdc.c: warning: unused variable 'wm831x':  => 779, 603
  + src/drivers/scsi/aic94xx/aic94xx_sds.c: warning: 'offs' may be used uninitialized in this function:  => 985
  + src/drivers/scsi/fcoe/fcoe.c: warning: label 'out_nodev' defined but not used:  => 1855, 1812
  + src/drivers/scsi/scsi_pm.c: warning: 'scsi_dev_type_resume' defined but not used:  => 33
  + src/drivers/scsi/scsi_pm.c: warning: 'scsi_dev_type_suspend' defined but not used:  => 18
  + src/drivers/tty/cyclades.c: warning: 'cyz_interrupt' defined but not used:  => 1200
  + src/drivers/tty/n_gsm.c: warning: zero-length gnu_printf format string:  => 535
  + src/drivers/tty/n_gsm.c: warning: zero-length printf format string:  => 535
  + src/drivers/tty/rocket.c: warning: 'rmSpeakerReset' defined but not used:  => 3166
  + src/drivers/tty/rocket.c: warning: 'sPCIInitController' defined but not used:  => 2625
  + src/drivers/usb/core/hcd-pci.c: warning: 'resume_common' defined but not used:  => 436
  + src/drivers/usb/core/hcd-pci.c: warning: 'suspend_common' defined but not used:  => 381
  + src/drivers/usb/gadget/fusb300_udc.c: warning: 'fusb300_ep0_complete' defined but not used:  => 983
  + src/drivers/usb/gadget/fusb300_udc.c: warning: 'fusb300_set_ep_bycnt' defined but not used:  => 1032
  + src/drivers/usb/gadget/fusb300_udc.c: warning: 'fusb300_wrfifo' defined but not used:  => 771
  + src/drivers/usb/gadget/fusb300_udc.c: warning: cast from pointer to integer of different size:  => 1079
  + src/drivers/usb/gadget/fusb300_udc.c: warning: cast to pointer from integer of different size:  => 1134
  + src/drivers/usb/host/xhci-ring.c: warning: 'event_trb' may be used uninitialized in this function:  => 1895
  + src/drivers/usb/host/xhci-ring.c: warning: 'hcd' may be used uninitialized in this function:  => 1229
  + src/drivers/usb/misc/usbtest.c: warning: cast from pointer to integer of different size:  => 273
  + src/drivers/usb/otg/twl6030-usb.c: warning: ISO C90 forbids mixed declarations and code:  => 183
  + src/drivers/usb/storage/realtek_cr.c: warning: 'config_autodelink_before_power_down' defined but not used:  => 493
  + src/drivers/video/aty/radeon_pm.c: warning: 'radeon_reinitialize_M10' defined but not used:  => 1718
  + src/drivers/video/aty/radeon_pm.c: warning: 'radeon_reinitialize_M9P' defined but not used:  => 1971
  + src/drivers/video/intelfb/intelfbhw.c: warning: 'm1' may be used uninitialized in this function:  => 938
  + src/drivers/video/intelfb/intelfbhw.c: warning: 'm2' may be used uninitialized in this function:  => 938
  + src/drivers/video/via/viafbdev.c: warning: ignoring return value of 'kstrtoul', declared with attribute warn_unused_result:  => 1214, 1962, 1144, 1974, 1950, 1380, 1991, 1947, 1956, 1959, 1981, 1968, 1988, 1965, 1985, 1417, 1311, 1977, 1953, 1272
  + src/drivers/video/via/viafbdev.c: warning: unused variable 'iga1_entry':  => 1626
  + src/drivers/video/via/viafbdev.c: warning: unused variable 'iga2_entry':  => 1627
  + src/fs/9p/acl.c: warning: 'full_name' may be used uninitialized in this function:  => 240, 287
  + src/fs/btrfs/extent-tree.c: warning: 'ret' may be used uninitialized in this function:  => 2039
  + src/fs/cifs/asn1.c: warning: 'ch' may be used uninitialized in this function:  => 170
  + src/fs/exec.c: warning: 'len' may be used uninitialized in this function:  => 443
  + src/fs/ext4/namei.c: warning: 'bh' may be used uninitialized in this function:  => 1892
  + src/fs/fuse/file.c: warning: 'parent' may be used uninitialized in this function:  => 2052
  + src/fs/isofs/namei.c: warning: 'i' may be used uninitialized in this function:  => 70
  + src/fs/locks.c: warning: 'lock' may be used uninitialized in this function:  => 1597
  + src/fs/minix/bitmap.c: warning: 'bh' may be used uninitialized in this function:  => 26
  + src/fs/nfs/nfs4filelayout.c: warning: comparison of distinct pointer types lacks a cast:  => 56
  + src/fs/nfs/nfs4filelayout.c: warning: control reaches end of non-void function:  => 77
  + src/fs/nfsd/nfsctl.c: warning: 'bsize' may be used uninitialized in this function:  => 1229
  + src/fs/nfsd/nfsctl.c: warning: 'fd' may be used uninitialized in this function:  => 991
  + src/fs/nfsd/nfsctl.c: warning: 'newthreads' may be used uninitialized in this function:  => 731
  + src/fs/omfs/file.c: warning: 'remain' may be used uninitialized in this function:  => 232
  + src/fs/reiserfs/bitmap.c: warning: 'next' may be used uninitialized in this function:  => 142
  + src/fs/reiserfs/fix_node.c: warning: 'l' may be used uninitialized in this function:  => 856
  + src/fs/reiserfs/fix_node.c: warning: 'r' may be used uninitialized in this function:  => 878
  + src/fs/sysfs/dir.c: warning: 'sysfs_pathname' defined but not used: 415 => 414, 415
  + src/fs/udf/inode.c: warning: 'adsize' may be used uninitialized in this function:  => 496
  + src/fs/xfs/linux-2.6/xfs_buf.c: warning: unused variable 'bdi':  => 660
  + src/include/net/ip_vs.h: warning: control reaches end of non-void function:  => 92, 70
  + src/include/trace/events/btrfs.h: warning: large integer implicitly truncated to unsigned type:  => 365, 197, 332, 273, 626, 68, 420, 47, 591, 144, 459, 541
  + src/kernel/fork.c: warning: assignment makes pointer from integer without a cast:  => 267
  + src/kernel/futex.c: warning: 'curval' may be used uninitialized in this function:  => 1549
  + src/kernel/futex.c: warning: 'entry' may be used uninitialized in this function:  => 2526
  + src/kernel/futex.c: warning: 'nval' may be used uninitialized in this function:  => 2454
  + src/kernel/futex.c: warning: 'pending' may be used uninitialized in this function:  => 2526
  + src/kernel/futex.c: warning: 'pi' may be used uninitialized in this function:  => 2527
  + src/kernel/futex.c: warning: 'pip' may be used uninitialized in this function:  => 2527
  + src/kernel/irq/debug.h: warning: "PS" redefined:  => 8:1
  + src/kernel/profile.c: warning: 'profile_cpu_callback' defined but not used:  => 359
  + src/kernel/profile.c: warning: 'profile_discard_flip_buffers' defined but not used:  => 293
  + src/kernel/profile.c: warning: 'profile_flip_buffers' defined but not used:  => 270
  + src/kernel/trace/ring_buffer.c: warning: unused variable 'local_clock_stable':  => 2175
  + src/kernel/watchdog.c: warning: 'watchdog_disable_all_cpus' defined but not used:  => 486
  + src/kernel/watchdog.c: warning: 'watchdog_enable_all_cpus' defined but not used:  => 469
  + src/kernel/workqueue.c: warning: 'last_gcwq' may be used uninitialized in this function:  => 999
  + src/lib/debugobjects.c: warning: 'obj_states' defined but not used:  => 73
  + src/lib/debugobjects.c: warning: unused variable 'hint':  => 256
  + src/lib/test-kstrtox.c: warning: integer constant is too large for 'long' type:  => 376, 323, 322, 377
  + src/lib/test-kstrtox.c: warning: this decimal constant is unsigned only in ISO C90:  => 373, 424, 374, 421, 319, 375, 320, 318, 321, 372, 423, 422
  + src/mm/swapfile.c: warning: 'span' may be used uninitialized in this function:  => 2026
  + src/net/batman-adv/vis.c: warning: passing argument 2 of 'compare_eth' discards qualifiers from pointer target type:  => 146
  + src/net/bridge/netfilter/ebtables.c: warning: 'off' may be used uninitialized in this function:  => 1885
  + src/net/bridge/netfilter/ebtables.c: warning: 'size_kern' may be used uninitialized in this function:  => 1886
  + src/net/core/dev.c: warning: 'err' may be used uninitialized in this function:  => 1849
  + src/net/core/ethtool.c: warning: control reaches end of non-void function:  => 421
  + src/net/core/neighbour.c: warning: 'error' may be used uninitialized in this function:  => 463
  + src/net/core/neighbour.c: warning: 'neigh' may be used uninitialized in this function:  => 1303
  + src/net/core/scm.c: warning: 'file' may be used uninitialized in this function:  => 96
  + src/net/core/skbuff.c: warning: 'err' may be used uninitialized in this function:  => 1076
  + src/net/ipv4/inet_connection_sock.c: warning: 'head' may be used uninitialized in this function:  => 94
  + src/net/ipv4/ip_output.c: warning: 'left' may be used uninitialized in this function:  => 978
  + src/net/ipv4/raw.c: warning: 'node' may be used uninitialized in this function:  => 113
  + src/net/ipv4/syncookies.c: warning: 'mss' may be used uninitialized in this function:  => 276
  + src/net/ipv4/tcp.c: warning: 'chunk' may be used uninitialized in this function:  => 1738
  + src/net/ipv4/tcp.c: warning: 'copy' may be used uninitialized in this function:  => 786
  + src/net/ipv4/tcp_ipv4.c: warning: 'node' may be used uninitialized in this function:  => 1968, 2120
  + src/net/netfilter/ipvs/ip_vs_proto_tcp.c: warning: 'svc' may be used uninitialized in this function:  => 39
  + src/net/netfilter/xt_connlimit.c: warning: value computed is not used:  => 234
  + src/net/sunrpc/auth_gss/svcauth_gss.c: warning: 'N' may be used uninitialized in this function:  => 458
  + src/net/sunrpc/auth_gss/svcauth_gss.c: warning: 'tmpobj.data' may be used uninitialized in this function:  => 1000
  + src/net/sunrpc/auth_gss/svcauth_gss.c: warning: 'tmpobj.len' may be used uninitialized in this function:  => 1000
  + src/net/sunrpc/stats.c: warning: 'proc' may be used uninitialized in this function:  => 82
  + src/net/sunrpc/svcauth.c: warning: 'aops' may be used uninitialized in this function:  => 40
  + src/net/sunrpc/svcauth_unix.c: warning: 'gid' may be used uninitialized in this function:  => 611
  + src/net/sunrpc/svcauth_unix.c: warning: 'gids' may be used uninitialized in this function:  => 582
  + src/net/sunrpc/svcauth_unix.c: warning: 'uid' may be used uninitialized in this function:  => 581
  + src/net/sunrpc/svcsock.c: warning: 'level' may be used uninitialized in this function:  => 700
  + src/net/sunrpc/svcsock.c: warning: 'optname' may be used uninitialized in this function:  => 700
  + src/net/xfrm/xfrm_policy.c: warning: 'dst_ops' may be used uninitialized in this function:  => 1333
  + src/net/xfrm/xfrm_state.c: warning: 'x0' may be used uninitialized in this function:  => 797
  + src/security/selinux/hooks.c: warning: 'prefix' may be used uninitialized in this function:  => 964
  + src/security/selinux/hooks.c: warning: 'sclass' may be used uninitialized in this function:  => 1426
  + src/security/selinux/netnode.c: warning: 'idx' may be used uninitialized in this function: 132 => 173, 132
  + src/sound/isa/sb/sb16.c: warning: 'err' may be used uninitialized in this function:  => 526
  + src/sound/pci/rme9652/hdspm.c: warning: 'freq_const' may be used uninitialized in this function:  => 1308
  + src/sound/pci/rme9652/hdspm.c: warning: 'n' may be used uninitialized in this function:  => 1332
  + src/sound/soc/codecs/wl1273.c: warning: initialization discards qualifiers from pointer target type:  => 212, 250
  + src/sound/soc/codecs/wm2000.c: warning: 'wm2000_i2c_resume' defined but not used:  => 848
  + src/sound/soc/codecs/wm2000.c: warning: 'wm2000_i2c_suspend' defined but not used:  => 840
  + warning: (ACPI_APEI) selects PSTORE which has unmet direct dependencies (MISC_FILESYSTEMS):  => N/A
  + warning: (ACPI_HOTPLUG_CPU) selects ACPI_CONTAINER which has unmet direct dependencies (ACPI && EXPERIMENTAL):  => N/A
  + warning: (CPU_SUBTYPE_SH7720 && CPU_SUBTYPE_SH7721 && CPU_SUBTYPE_SH7757 && CPU_SUBTYPE_SH7763 && CPU_SUBTYPE_SH7786) selects USB_ARCH_HAS_OHCI which has unmet direct dependencies (USB_SUPPORT):  => N/A
  + warning: (DRM_I915 && STUB_POULSBO) selects ACPI_VIDEO which has unmet direct dependencies (ACPI && X86 && BACKLIGHT_CLASS_DEVICE && VIDEO_OUTPUT_CONTROL && INPUT):  => N/A
  + warning: (IA64) selects PM which has unmet direct dependencies (PM_SLEEP || PM_RUNTIME):  => N/A
  + warning: (IWLAGN && IWLWIFI_LEGACY && ATH5K && ATH9K && ATH9K_HTC && CARL9170_LEDS) selects MAC80211_LEDS which has unmet direct dependencies (NET && WIRELESS && MAC80211 && LEDS_CLASS):  => N/A
  + warning: (MEDIA_TUNER) selects MEDIA_TUNER_TEA5761 which has unmet direct dependencies (MEDIA_SUPPORT && VIDEO_MEDIA && I2C && EXPERIMENTAL):  => N/A
  + warning: (MMC_TIFM_SD && MEMSTICK_TIFM_MS) selects TIFM_CORE which has unmet direct dependencies (MISC_DEVICES && EXPERIMENTAL && PCI):  => N/A
  + warning: (PPC_PS3 && 440EP) selects USB_ARCH_HAS_OHCI which has unmet direct dependencies (USB_SUPPORT):  => N/A
  + warning: (PPC_PS3 && PPC_CELLEB && USB_EHCI_HCD_PMC_MSP && XPS_USB_HCD_XILINX && USB_OCTEON_EHCI) selects USB_EHCI_BIG_ENDIAN_MMIO which has unmet direct dependencies (USB_SUPPORT && USB_EHCI_HCD && (PPC_CELLEB || PPC_PS3 || 440EPX || ARCH_IXP4XX || XPS_USB_HCD_XILINX || PPC_MPC512x || CPU_CAVIUM_OCTEON || PMC_MSP)):  => N/A
  + warning: (PPC_PS3 && PPC_CELLEB) selects USB_OHCI_BIG_ENDIAN_MMIO which has unmet direct dependencies (USB_SUPPORT && USB_OHCI_HCD):  => N/A
  + warning: (PPC_PS3) selects USB_ARCH_HAS_EHCI which has unmet direct dependencies (USB_SUPPORT):  => N/A
  + warning: (PPC_PS3) selects USB_OHCI_LITTLE_ENDIAN which has unmet direct dependencies (USB_SUPPORT && USB_OHCI_HCD):  => N/A
  + warning: 1 bad relocations:  => N/A
  + warning: arch/powerpc/kernel/built-in.o(.text+0x56584): Section mismatch in reference from the function .register_power_pmu() to the function .cpuinit.text:.power_pmu_notifier():  => N/A
  + warning: arch/powerpc/kernel/built-in.o(.text+0x565a0): Section mismatch in reference from the function .register_power_pmu() to the function .cpuinit.text:.power_pmu_notifier():  => N/A
  + warning: arch/powerpc/kernel/built-in.o(.text+0x565bc): Section mismatch in reference from the function .register_power_pmu() to the function .cpuinit.text:.power_pmu_notifier():  => N/A
  + warning: arch/powerpc/kernel/built-in.o(.text+0x580e4): Section mismatch in reference from the function .register_power_pmu() to the function .cpuinit.text:.power_pmu_notifier():  => N/A
  + warning: arch/powerpc/kernel/built-in.o(.text+0x58100): Section mismatch in reference from the function .register_power_pmu() to the function .cpuinit.text:.power_pmu_notifier():  => N/A
  + warning: arch/powerpc/kernel/built-in.o(.text+0x5811c): Section mismatch in reference from the function .register_power_pmu() to the function .cpuinit.text:.power_pmu_notifier():  => N/A
  + warning: arch/powerpc/mm/built-in.o(.text+0xb1d0): Section mismatch in reference from the function .mark_reserved_regions_for_nid() to the function .init.text:.get_node_active_region():  => N/A
  + warning: arch/powerpc/mm/built-in.o(.text+0xb2b4): Section mismatch in reference from the function .mark_reserved_regions_for_nid() to the function .init.text:.get_node_active_region():  => N/A
  + warning: drivers/built-in.o(.text+0x25d7574): Section mismatch in reference from the function .usb_add_config() to the function .devinit.text:.usb_ep_autoconfig_reset():  => N/A
  + warning: drivers/built-in.o(.text+0x25ddb14): Section mismatch in reference from the function .rndis_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/built-in.o(.text+0x25ddb60): Section mismatch in reference from the function .rndis_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/built-in.o(.text+0x25ddb94): Section mismatch in reference from the function .rndis_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/built-in.o(.text+0x25de308): Section mismatch in reference from the function .ecm_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/built-in.o(.text+0x25de354): Section mismatch in reference from the function .ecm_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/built-in.o(.text+0x25de388): Section mismatch in reference from the function .ecm_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/built-in.o(.text+0x25e0224): Section mismatch in reference from the function .composite_bind() to the function .devinit.text:.usb_ep_autoconfig_reset():  => N/A
  + warning: drivers/built-in.o(.text+0x261c480): Section mismatch in reference from the function .tc3589x_keypad_open() to the function .devinit.text:.tc3589x_keypad_init_key_hardware():  => N/A
  + warning: drivers/built-in.o(.text+0x324e284): Section mismatch in reference from the function .lp5521_probe() to the function .init.text:.lp5521_init_led():  => N/A
  + warning: drivers/built-in.o(.text+0x3251014): Section mismatch in reference from the function .lp5523_probe() to the function .init.text:.lp5523_init_led():  => N/A
  + warning: drivers/built-in.o(.text+0x63d11c): Section mismatch in reference from the function .radeon_get_clock_info() to the function .devinit.text:.radeon_read_clocks_OF():  => N/A
  + warning: drivers/gpu/built-in.o(.text+0x13724c): Section mismatch in reference from the function .radeon_get_clock_info() to the function .devinit.text:.radeon_read_clocks_OF():  => N/A
  + warning: drivers/gpu/drm/built-in.o(.text+0x13724c): Section mismatch in reference from the function .radeon_get_clock_info() to the function .devinit.text:.radeon_read_clocks_OF():  => N/A
  + warning: drivers/gpu/drm/radeon/built-in.o(.text+0xd2440): Section mismatch in reference from the function .radeon_get_clock_info() to the function .devinit.text:.radeon_read_clocks_OF():  => N/A
  + warning: drivers/gpu/drm/radeon/radeon.o(.text+0x47ca8): Section mismatch in reference from the function radeon_get_clock_info() to the function .devinit.text:radeon_read_clocks_OF():  => N/A
  + warning: drivers/gpu/drm/radeon/radeon.o(.text+0xd1868): Section mismatch in reference from the function .radeon_get_clock_info() to the function .devinit.text:.radeon_read_clocks_OF():  => N/A
  + warning: drivers/gpu/drm/radeon/radeon.o(.text+0xd2440): Section mismatch in reference from the function .radeon_get_clock_info() to the function .devinit.text:.radeon_read_clocks_OF():  => N/A
  + warning: drivers/input/built-in.o(.text+0x26e54): Section mismatch in reference from the function .tc3589x_keypad_open() to the function .devinit.text:.tc3589x_keypad_init_key_hardware():  => N/A
  + warning: drivers/input/keyboard/built-in.o(.text+0xf8c4): Section mismatch in reference from the function .tc3589x_keypad_open() to the function .devinit.text:.tc3589x_keypad_init_key_hardware():  => N/A
  + warning: drivers/leds/built-in.o(.text+0xb2dc): Section mismatch in reference from the function .lp5521_probe() to the function .init.text:.lp5521_init_led():  => N/A
  + warning: drivers/leds/built-in.o(.text+0xe06c): Section mismatch in reference from the function .lp5523_probe() to the function .init.text:.lp5523_init_led():  => N/A
  + warning: drivers/leds/leds-lp5521.o(.text+0x1093): Section mismatch in reference from the function lp5521_probe() to the function .init.text:lp5521_init_led():  => N/A
  + warning: drivers/leds/leds-lp5521.o(.text+0x1dd8): Section mismatch in reference from the function .lp5521_probe() to the function .init.text:.lp5521_init_led():  => N/A
  + warning: drivers/leds/leds-lp5521.o(.text+0xa6a): Section mismatch in reference from the function lp5521_probe() to the function .init.text:lp5521_init_led():  => N/A
  + warning: drivers/leds/leds-lp5523.o(.text+0x17bb): Section mismatch in reference from the function lp5523_probe() to the function .init.text:lp5523_init_led():  => N/A
  + warning: drivers/leds/leds-lp5523.o(.text+0x29fc): Section mismatch in reference from the function .lp5523_probe() to the function .init.text:.lp5523_init_led():  => N/A
  + warning: drivers/leds/leds-lp5523.o(.text+0xfd2): Section mismatch in reference from the function lp5523_probe() to the function .init.text:lp5523_init_led():  => N/A
  + warning: drivers/mfd/cs5535-mfd.o(.data+0x20): Section mismatch in reference from the variable cs5535_mfd_drv to the function .devinit.text:cs5535_mfd_probe():  => N/A
  + warning: drivers/mfd/cs5535-mfd.o(.data+0x28): Section mismatch in reference from the variable cs5535_mfd_drv to the function .devexit.text:cs5535_mfd_remove():  => N/A
  + warning: drivers/misc/cs5535-mfgpt.o(.data+0x0): Section mismatch in reference from the variable cs5535_mfgpt_drv to the function .devinit.text:cs5535_mfgpt_probe():  => N/A
  + warning: drivers/misc/ioc4.o(.data+0x18): Section mismatch in reference from the variable ioc4_load_modules_work to the function .devinit.text:ioc4_load_modules():  => N/A
  + warning: drivers/mtd/devices/sst25l.o(.devinit.text+0xaa): Section mismatch in reference from the function sst25l_match_device() to the variable .init.data:sst25l_flash_info:  => N/A
  + warning: drivers/mtd/devices/sst25l.o(.devinit.text+0xb0): Section mismatch in reference from the function sst25l_match_device() to the variable .init.data:sst25l_flash_info:  => N/A
  + warning: drivers/mtd/devices/sst25l.o(.devinit.text+0xbc): Section mismatch in reference from the function sst25l_match_device() to the (unknown reference) .init.data:(unknown):  => N/A
  + warning: drivers/mtd/devices/sst25l.o(.devinit.text+0xc4): Section mismatch in reference from the function sst25l_match_device() to the variable .init.data:sst25l_flash_info:  => N/A
  + warning: drivers/mtd/devices/sst25l.o(.devinit.text+0xc6): Section mismatch in reference from the function sst25l_match_device() to the variable .init.data:sst25l_flash_info:  => N/A
  + warning: drivers/mtd/devices/sst25l.o(.devinit.text+0xe9): Section mismatch in reference from the function sst25l_match_device() to the (unknown reference) .init.data:(unknown):  => N/A
  + warning: drivers/net/depca.o(.devinit.text+0x18): Section mismatch in reference from the function depca_isa_probe() to the function .init.text:depca_common_init():  => N/A
  + warning: drivers/net/depca.o(.devinit.text+0x40): Section mismatch in reference from the function depca_isa_probe() to the function .init.text:DepcaSignature():  => N/A
  + warning: drivers/net/depca.o(.devinit.text+0xa0): Section mismatch in reference from the function depca_isa_probe() to the function .init.text:depca_hw_init():  => N/A
  + warning: drivers/net/irda/smsc-ircc2.o(.devinit.text+0x1ac): Section mismatch in reference from the function smsc_ircc_pnp_probe() to the function .init.text:smsc_ircc_open():  => N/A
  + warning: drivers/platform/x86/asus-wmi.o(.text+0x235e): Section mismatch in reference from the function asus_wmi_add() to the function .init.text:asus_wmi_platform_init():  => N/A
  + warning: drivers/platform/x86/msi-laptop.o(.text+0xf11): Section mismatch in reference from the function load_scm_model_init() to the function .init.text:msi_laptop_input_setup():  => N/A
  + warning: drivers/sbus/char/bbc.o(.devinit.text+0xc): Section mismatch in reference from the function bbc_i2c_probe() to the function .init.text:T.316():  => N/A
  + warning: drivers/usb/gadget/built-in.o(.text+0x109e8): Section mismatch in reference from the function .composite_bind() to the function .devinit.text:.usb_ep_autoconfig_reset():  => N/A
  + warning: drivers/usb/gadget/built-in.o(.text+0x7d38): Section mismatch in reference from the function .usb_add_config() to the function .devinit.text:.usb_ep_autoconfig_reset():  => N/A
  + warning: drivers/usb/gadget/built-in.o(.text+0xe2d8): Section mismatch in reference from the function .rndis_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/built-in.o(.text+0xe324): Section mismatch in reference from the function .rndis_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/built-in.o(.text+0xe358): Section mismatch in reference from the function .rndis_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/built-in.o(.text+0xeacc): Section mismatch in reference from the function .ecm_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/built-in.o(.text+0xeb18): Section mismatch in reference from the function .ecm_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/built-in.o(.text+0xeb4c): Section mismatch in reference from the function .ecm_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_audio.o(.text+0x2b74): Section mismatch in reference from the function .usb_add_config() to the function .devinit.text:.usb_ep_autoconfig_reset():  => N/A
  + warning: drivers/usb/gadget/g_audio.o(.text+0x5c80): Section mismatch in reference from the function .composite_bind() to the function .devinit.text:.usb_ep_autoconfig_reset():  => N/A
  + warning: drivers/usb/gadget/g_cdc.o(.text+0x311c): Section mismatch in reference from the function ecm_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_cdc.o(.text+0x3442): Section mismatch in reference from the function acm_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_cdc.o(.text+0x3b28): Section mismatch in reference from the function ecm_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_cdc.o(.text+0x3b48): Section mismatch in reference from the function ecm_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_cdc.o(.text+0x3b68): Section mismatch in reference from the function ecm_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_cdc.o(.text+0x3d14): Section mismatch in reference from the function .usb_add_config() to the function .devinit.text:.usb_ep_autoconfig_reset():  => N/A
  + warning: drivers/usb/gadget/g_cdc.o(.text+0x3f84): Section mismatch in reference from the function acm_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_cdc.o(.text+0x3fa4): Section mismatch in reference from the function acm_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_cdc.o(.text+0x3fc4): Section mismatch in reference from the function acm_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_cdc.o(.text+0x4a17): Section mismatch in reference from the function ecm_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_cdc.o(.text+0x4a56): Section mismatch in reference from the function ecm_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_cdc.o(.text+0x4a87): Section mismatch in reference from the function ecm_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_cdc.o(.text+0x4f7f): Section mismatch in reference from the function acm_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_cdc.o(.text+0x4fbe): Section mismatch in reference from the function acm_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_cdc.o(.text+0x4fef): Section mismatch in reference from the function acm_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_cdc.o(.text+0x82b8): Section mismatch in reference from the function .ecm_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_cdc.o(.text+0x8304): Section mismatch in reference from the function .ecm_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_cdc.o(.text+0x8338): Section mismatch in reference from the function .ecm_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_cdc.o(.text+0x89f8): Section mismatch in reference from the function .acm_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_cdc.o(.text+0x8a40): Section mismatch in reference from the function .acm_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_cdc.o(.text+0x8a74): Section mismatch in reference from the function .acm_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_cdc.o(.text+0xb2ec): Section mismatch in reference from the function .composite_bind() to the function .devinit.text:.usb_ep_autoconfig_reset():  => N/A
  + warning: drivers/usb/gadget/g_ether.o(.text+0x3d40): Section mismatch in reference from the function .usb_add_config() to the function .devinit.text:.usb_ep_autoconfig_reset():  => N/A
  + warning: drivers/usb/gadget/g_ether.o(.text+0x3e1c): Section mismatch in reference from the function rndis_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_ether.o(.text+0x419a): Section mismatch in reference from the function ecm_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_ether.o(.text+0x5170): Section mismatch in reference from the function rndis_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_ether.o(.text+0x5190): Section mismatch in reference from the function rndis_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_ether.o(.text+0x51b0): Section mismatch in reference from the function rndis_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_ether.o(.text+0x5640): Section mismatch in reference from the function ecm_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_ether.o(.text+0x5660): Section mismatch in reference from the function ecm_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_ether.o(.text+0x5680): Section mismatch in reference from the function ecm_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_ether.o(.text+0x58e0): Section mismatch in reference from the function rndis_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_ether.o(.text+0x591f): Section mismatch in reference from the function rndis_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_ether.o(.text+0x5950): Section mismatch in reference from the function rndis_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_ether.o(.text+0x5ea3): Section mismatch in reference from the function ecm_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_ether.o(.text+0x5ee2): Section mismatch in reference from the function ecm_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_ether.o(.text+0x5f13): Section mismatch in reference from the function ecm_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_ether.o(.text+0xa2e0): Section mismatch in reference from the function .rndis_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_ether.o(.text+0xa32c): Section mismatch in reference from the function .rndis_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_ether.o(.text+0xa360): Section mismatch in reference from the function .rndis_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_ether.o(.text+0xaad4): Section mismatch in reference from the function .ecm_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_ether.o(.text+0xab20): Section mismatch in reference from the function .ecm_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_ether.o(.text+0xab54): Section mismatch in reference from the function .ecm_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_ether.o(.text+0xc9ec): Section mismatch in reference from the function .composite_bind() to the function .devinit.text:.usb_ep_autoconfig_reset():  => N/A
  + warning: drivers/usb/gadget/g_ether.o(.text+0xc9f0): Section mismatch in reference from the function .composite_bind() to the function .devinit.text:.usb_ep_autoconfig_reset():  => N/A
  + warning: drivers/usb/gadget/g_ffs.o(.text+0x1263c): Section mismatch in reference from the function .composite_bind() to the function .devinit.text:.usb_ep_autoconfig_reset():  => N/A
  + warning: drivers/usb/gadget/g_ffs.o(.text+0x53a0): Section mismatch in reference from the function __ffs_func_bind_do_descs() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_ffs.o(.text+0x546c): Section mismatch in reference from the function rndis_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_ffs.o(.text+0x57ea): Section mismatch in reference from the function ecm_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_ffs.o(.text+0x74d6): Section mismatch in reference from the function __ffs_func_bind_do_descs() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_ffs.o(.text+0x75f9): Section mismatch in reference from the function rndis_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_ffs.o(.text+0x7638): Section mismatch in reference from the function rndis_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_ffs.o(.text+0x7669): Section mismatch in reference from the function rndis_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_ffs.o(.text+0x7bba): Section mismatch in reference from the function ecm_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_ffs.o(.text+0x7bf9): Section mismatch in reference from the function ecm_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_ffs.o(.text+0x7c2a): Section mismatch in reference from the function ecm_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_ffs.o(.text+0x9978): Section mismatch in reference from the function .usb_add_config() to the function .devinit.text:.usb_ep_autoconfig_reset():  => N/A
  + warning: drivers/usb/gadget/g_ffs.o(.text+0xe0ec): Section mismatch in reference from the function .__ffs_func_bind_do_descs() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_ffs.o(.text+0xe2cc): Section mismatch in reference from the function .rndis_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_ffs.o(.text+0xe318): Section mismatch in reference from the function .rndis_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_ffs.o(.text+0xe34c): Section mismatch in reference from the function .rndis_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_ffs.o(.text+0xeac0): Section mismatch in reference from the function .ecm_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_ffs.o(.text+0xeb0c): Section mismatch in reference from the function .ecm_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_ffs.o(.text+0xeb40): Section mismatch in reference from the function .ecm_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_hid.o(.text+0x3e64): Section mismatch in reference from the function .usb_add_config() to the function .devinit.text:.usb_ep_autoconfig_reset():  => N/A
  + warning: drivers/usb/gadget/g_hid.o(.text+0x5aa4): Section mismatch in reference from the function .composite_bind() to the function .devinit.text:.usb_ep_autoconfig_reset():  => N/A
  + warning: drivers/usb/gadget/g_mass_storage.o(.text+0x42a6): Section mismatch in reference from the function fsg_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_mass_storage.o(.text+0x5860): Section mismatch in reference from the function fsg_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_mass_storage.o(.text+0x5884): Section mismatch in reference from the function fsg_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_mass_storage.o(.text+0x6855): Section mismatch in reference from the function fsg_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_mass_storage.o(.text+0x68a6): Section mismatch in reference from the function fsg_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_mass_storage.o(.text+0xab18): Section mismatch in reference from the function .fsg_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_mass_storage.o(.text+0xab74): Section mismatch in reference from the function .fsg_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_mass_storage.o(.text+0xb48c): Section mismatch in reference from the function .composite_bind() to the function .devinit.text:.usb_ep_autoconfig_reset():  => N/A
  + warning: drivers/usb/gadget/g_mass_storage.o(.text+0xbc7c): Section mismatch in reference from the function .usb_add_config() to the function .devinit.text:.usb_ep_autoconfig_reset():  => N/A
  + warning: drivers/usb/gadget/g_multi.o(.text+0x15bb8): Section mismatch in reference from the function .fsg_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_multi.o(.text+0x15c14): Section mismatch in reference from the function .fsg_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_multi.o(.text+0x15e28): Section mismatch in reference from the function .rndis_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_multi.o(.text+0x15e74): Section mismatch in reference from the function .rndis_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_multi.o(.text+0x15ea8): Section mismatch in reference from the function .rndis_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_multi.o(.text+0x1661c): Section mismatch in reference from the function .ecm_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_multi.o(.text+0x16668): Section mismatch in reference from the function .ecm_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_multi.o(.text+0x1669c): Section mismatch in reference from the function .ecm_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_multi.o(.text+0x16d5c): Section mismatch in reference from the function .acm_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_multi.o(.text+0x16da4): Section mismatch in reference from the function .acm_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_multi.o(.text+0x16dd8): Section mismatch in reference from the function .acm_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_multi.o(.text+0x8780): Section mismatch in reference from the function fsg_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_multi.o(.text+0x889a): Section mismatch in reference from the function rndis_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_multi.o(.text+0x8c1a): Section mismatch in reference from the function ecm_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_multi.o(.text+0x8f40): Section mismatch in reference from the function acm_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_multi.o(.text+0xae48): Section mismatch in reference from the function fsg_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_multi.o(.text+0xae6c): Section mismatch in reference from the function fsg_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_multi.o(.text+0xaf98): Section mismatch in reference from the function rndis_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_multi.o(.text+0xafb8): Section mismatch in reference from the function rndis_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_multi.o(.text+0xafd8): Section mismatch in reference from the function rndis_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_multi.o(.text+0xb468): Section mismatch in reference from the function ecm_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_multi.o(.text+0xb488): Section mismatch in reference from the function ecm_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_multi.o(.text+0xb4a8): Section mismatch in reference from the function ecm_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_multi.o(.text+0xb8c4): Section mismatch in reference from the function acm_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_multi.o(.text+0xb8e4): Section mismatch in reference from the function acm_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_multi.o(.text+0xb904): Section mismatch in reference from the function acm_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_multi.o(.text+0xc896): Section mismatch in reference from the function fsg_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_multi.o(.text+0xc8e7): Section mismatch in reference from the function fsg_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_multi.o(.text+0xca5f): Section mismatch in reference from the function rndis_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_multi.o(.text+0xca9e): Section mismatch in reference from the function rndis_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_multi.o(.text+0xcacf): Section mismatch in reference from the function rndis_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_multi.o(.text+0xd020): Section mismatch in reference from the function ecm_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_multi.o(.text+0xd05f): Section mismatch in reference from the function ecm_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_multi.o(.text+0xd090): Section mismatch in reference from the function ecm_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_multi.o(.text+0xd586): Section mismatch in reference from the function acm_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_multi.o(.text+0xd5c5): Section mismatch in reference from the function acm_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_multi.o(.text+0xd5f6): Section mismatch in reference from the function acm_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_multi.o(.text+0xe1c0): Section mismatch in reference from the function .composite_bind() to the function .devinit.text:.usb_ep_autoconfig_reset():  => N/A
  + warning: drivers/usb/gadget/g_multi.o(.text+0xf37c): Section mismatch in reference from the function .usb_add_config() to the function .devinit.text:.usb_ep_autoconfig_reset():  => N/A
  + warning: drivers/usb/gadget/g_ncm.o(.text+0x30ec): Section mismatch in reference from the function .usb_add_config() to the function .devinit.text:.usb_ep_autoconfig_reset():  => N/A
  + warning: drivers/usb/gadget/g_ncm.o(.text+0x82a8): Section mismatch in reference from the function .composite_bind() to the function .devinit.text:.usb_ep_autoconfig_reset():  => N/A
  + warning: drivers/usb/gadget/g_nokia.o(.text+0x38b2): Section mismatch in reference from the function ecm_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_nokia.o(.text+0x3bd8): Section mismatch in reference from the function acm_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_nokia.o(.text+0x4024): Section mismatch in reference from the function .usb_add_config() to the function .devinit.text:.usb_ep_autoconfig_reset():  => N/A
  + warning: drivers/usb/gadget/g_nokia.o(.text+0x439c): Section mismatch in reference from the function ecm_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_nokia.o(.text+0x43bc): Section mismatch in reference from the function ecm_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_nokia.o(.text+0x43dc): Section mismatch in reference from the function ecm_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_nokia.o(.text+0x47f8): Section mismatch in reference from the function acm_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_nokia.o(.text+0x4818): Section mismatch in reference from the function acm_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_nokia.o(.text+0x4838): Section mismatch in reference from the function acm_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_nokia.o(.text+0x546b): Section mismatch in reference from the function ecm_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_nokia.o(.text+0x54aa): Section mismatch in reference from the function ecm_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_nokia.o(.text+0x54db): Section mismatch in reference from the function ecm_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_nokia.o(.text+0x59d1): Section mismatch in reference from the function acm_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_nokia.o(.text+0x5a10): Section mismatch in reference from the function acm_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_nokia.o(.text+0x5a41): Section mismatch in reference from the function acm_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_nokia.o(.text+0x97a4): Section mismatch in reference from the function .ecm_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_nokia.o(.text+0x97f0): Section mismatch in reference from the function .ecm_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_nokia.o(.text+0x9824): Section mismatch in reference from the function .ecm_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_nokia.o(.text+0x9ee4): Section mismatch in reference from the function .acm_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_nokia.o(.text+0x9f2c): Section mismatch in reference from the function .acm_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_nokia.o(.text+0x9f60): Section mismatch in reference from the function .acm_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_nokia.o(.text+0xc7d8): Section mismatch in reference from the function .composite_bind() to the function .devinit.text:.usb_ep_autoconfig_reset():  => N/A
  + warning: drivers/usb/gadget/g_serial.o(.text+0x2436): Section mismatch in reference from the function acm_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_serial.o(.text+0x24e0): Section mismatch in reference from the function acm_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_serial.o(.text+0x251f): Section mismatch in reference from the function acm_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_serial.o(.text+0x2550): Section mismatch in reference from the function acm_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_serial.o(.text+0x2970): Section mismatch in reference from the function acm_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_serial.o(.text+0x2990): Section mismatch in reference from the function acm_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_serial.o(.text+0x29b0): Section mismatch in reference from the function acm_bind() to the function .devinit.text:usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_serial.o(.text+0x4d14): Section mismatch in reference from the function .usb_add_config() to the function .devinit.text:.usb_ep_autoconfig_reset():  => N/A
  + warning: drivers/usb/gadget/g_serial.o(.text+0x627c): Section mismatch in reference from the function .acm_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_serial.o(.text+0x62c4): Section mismatch in reference from the function .acm_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_serial.o(.text+0x62f8): Section mismatch in reference from the function .acm_bind() to the function .devinit.text:.usb_ep_autoconfig():  => N/A
  + warning: drivers/usb/gadget/g_serial.o(.text+0x8b70): Section mismatch in reference from the function .composite_bind() to the function .devinit.text:.usb_ep_autoconfig_reset():  => N/A
  + warning: drivers/usb/gadget/g_webcam.o(.text+0x68f4): Section mismatch in reference from the function .usb_add_config() to the function .devinit.text:.usb_ep_autoconfig_reset():  => N/A
  + warning: drivers/usb/gadget/g_webcam.o(.text+0x83e4): Section mismatch in reference from the function .composite_bind() to the function .devinit.text:.usb_ep_autoconfig_reset():  => N/A
  + warning: drivers/usb/gadget/g_zero.o(.text+0x5c08): Section mismatch in reference from the function .composite_bind() to the function .devinit.text:.usb_ep_autoconfig_reset():  => N/A
  + warning: drivers/usb/gadget/g_zero.o(.text+0x62a8): Section mismatch in reference from the function .usb_add_config() to the function .devinit.text:.usb_ep_autoconfig_reset():  => N/A
  + warning: drivers/video/geode/gx1fb.o(.data+0x70): Section mismatch in reference from the variable gx1fb_driver to the function .init.text:gx1fb_probe():  => N/A
  + warning: drivers/video/sm501fb.o(.text+0x180c): Section mismatch in reference from the function sm501fb_init_fb() to the variable .devinit.data:sm501_default_mode:  => N/A
  + warning: drivers/video/sm501fb.o(.text+0x21bc): Section mismatch in reference from the function sm501fb_init_fb() to the variable .devinit.data:sm501_default_mode:  => N/A
  + warning: mm/built-in.o(.text+0x14678): Section mismatch in reference from the function build_all_zonelists() to the function .meminit.text:setup_zone_pageset():  => N/A
  + warning: mm/built-in.o(.text+0x14dc8): Section mismatch in reference from the function .build_all_zonelists() to the function .meminit.text:.setup_zone_pageset():  => N/A
  + warning: mm/built-in.o(.text+0xaeb8): Section mismatch in reference from the function build_all_zonelists() to the function .meminit.text:setup_zone_pageset():  => N/A
  + warning: vmlinux.o(.devinit.text+0x9340): Section mismatch in reference from the function cnb20le_res() to the function .init.text:acpi_os_get_root_pointer():  => N/A
  + warning: vmlinux.o(.text+0x16f64c): Section mismatch in reference from the function build_all_zonelists() to the function .meminit.text:setup_zone_pageset():  => N/A
  + warning: vmlinux.o(.text+0x24723c): Section mismatch in reference from the function build_all_zonelists() to the function .meminit.text:setup_zone_pageset():  => N/A
  + warning: vmlinux.o(.text+0x2700f8): Section mismatch in reference from the function build_all_zonelists() to the function .meminit.text:setup_zone_pageset():  => N/A
  + warning: vmlinux.o(.text+0x2e6a3c): Section mismatch in reference from the function .build_all_zonelists() to the function .meminit.text:.setup_zone_pageset():  => N/A
  + warning: vmlinux.o(.text+0x33cc4): Section mismatch in reference from the function .early_setup_secondary() to the function .cpuinit.text:.early_init_mmu_secondary():  => N/A
  + warning: vmlinux.o(.text+0x5b820): Section mismatch in reference from the function .wake_offline_cpus() to the function .cpuinit.text:.cpu_up():  => N/A
  + warning: vmlinux.o(.text+0x61a24): Section mismatch in reference from the function .register_power_pmu() to the function .cpuinit.text:.power_pmu_notifier():  => N/A
  + warning: vmlinux.o(.text+0x61a40): Section mismatch in reference from the function .register_power_pmu() to the function .cpuinit.text:.power_pmu_notifier():  => N/A
  + warning: vmlinux.o(.text+0x61a5c): Section mismatch in reference from the function .register_power_pmu() to the function .cpuinit.text:.power_pmu_notifier():  => N/A
  + warning: vmlinux.o(.text+0x740a8): Section mismatch in reference from the function .mark_reserved_regions_for_nid() to the function .init.text:.get_node_active_region():  => N/A
  + warning: vmlinux.o(.text+0x74158): Section mismatch in reference from the function .mark_reserved_regions_for_nid() to the function .init.text:.reserve_bootmem_node():  => N/A
  + warning: vmlinux.o(.text+0x7418c): Section mismatch in reference from the function .mark_reserved_regions_for_nid() to the function .init.text:.get_node_active_region():  => N/A
  + warning: vmlinux.o(.text+0x7d46): Section mismatch in reference from the function atari_stram_alloc() to the function .init.text:__alloc_bootmem_low():  => N/A
  + warning: vmlinux.o(.text+0x92f0): Section mismatch in reference from the function .start_secondary_prolog() to the function .devinit.text:.start_secondary():  => N/A
  + warning: vmlinux.o(.text+0x9304): Section mismatch in reference from the function .start_secondary_resume() to the function .devinit.text:.start_secondary():  => N/A
  + warning: vmlinux.o(.text+0xa28f0): Section mismatch in reference from the function .pci_dn_reconfig_notifier() to the function .devinit.text:.update_dn_pci_info():  => N/A
  + warning: vmlinux.o(.text+0xa86b0): Section mismatch in reference from the function .dlpar_online_cpu() to the function .cpuinit.text:.cpu_up():  => N/A
  + warning: vmlinux.o(.text+0xb3138): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.of_rescan_bus():  => N/A
  + warning: vmlinux.o(.text+0xb31c8): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.pcibios_setup_bus_devices():  => N/A
  + warning: vmlinux.o(.text+0xb3220): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.pci_scan_bridge():  => N/A
  + warning: vmlinux.o(.text+0xb88e6): Section mismatch in reference from the variable system_reset_iSeries to the variable .init.data:boot_paca:  => N/A

99 improvements:
  - .config: warning: symbol value '' invalid for X86_INTERNODE_CACHE_SHIFT: 249 => 
  - modpost: WARNING: modpost: Found 28 section mismatch(es).: N/A => 
  - modpost: WARNING: modpost: Found 55 section mismatch(es).: N/A => 
  - modpost: WARNING: modpost: Found 8 section mismatch(es).: N/A => 
  - modpost: WARNING: modpost: Found 9 section mismatch(es).: N/A => 
  - src/arch/ia64/kernel/mca.c: warning: assignment makes pointer from integer without a cast: 1862 => 
  - src/arch/ia64/sn/pci/tioca_provider.c: warning: initialization from incompatible pointer type: 660, 659 => 
  - src/arch/m68k/include/asm/atarihw.h: warning: this is the location of the previous definition: 403:1, 402:1 => 
  - src/arch/m68k/kernel/setup.c: warning: unused variable 'i': 218 => 
  - src/arch/s390/kvm/../../../virt/kvm/kvm_main.c: warning: 'kvm_create_dirty_bitmap' defined but not used: 597 => 
  - src/arch/x86/platform/scx200/scx200_32.c: warning: 'base' may be used uninitialized in this function: 82 => 
  - src/drivers/block/xd.c: warning: 'address' may be used uninitialized in this function: 159 => 
  - src/drivers/block/xd.c: warning: 'controller' may be used uninitialized in this function: 158 => 
  - src/drivers/char/cyclades.c: warning: 'cyz_interrupt' defined but not used: 1200, 1201 => 
  - src/drivers/char/rocket.c: warning: 'rmSpeakerReset' defined but not used: 3167, 3166 => 
  - src/drivers/char/rocket.c: warning: 'sPCIInitController' defined but not used: 2625, 2630 => 
  - src/drivers/dma/pch_dma.c: warning: 'pch_dma_resume' defined but not used: 755 => 
  - src/drivers/dma/pch_dma.c: warning: 'pch_dma_suspend' defined but not used: 741 => 
  - src/drivers/dma/pch_dma.c: warning: assignment makes pointer from integer without a cast: 786 => 
  - src/drivers/edac/i7300_edac.c: warning: 'nr_pages' may be used uninitialized in this function: 780 => 
  - src/drivers/gpio/pch_gpio.c: warning: 'pch_gpio_restore_reg_conf' defined but not used: 140 => 
  - src/drivers/gpio/pch_gpio.c: warning: 'pch_gpio_save_reg_conf' defined but not used: 131 => 
  - src/drivers/gpu/drm/drm_pci.c: warning: passing argument 1 of 'virt_to_phys' makes pointer from integer without a cast: 109, 84 => 
  - src/drivers/gpu/drm/drm_vm.c: warning: passing argument 1 of 'virt_to_phys' makes pointer from integer without a cast: 308 => 
  - src/drivers/gpu/drm/radeon/radeon_gart.c: warning: passing argument 3 of 'pci_free_consistent' discards qualifiers from pointer target type: 69 => 
  - src/drivers/infiniband/hw/ipath/ipath_driver.c: warning: 'pnum' may be used uninitialized in this function: 1635 => 
  - src/drivers/infiniband/hw/nes/nes.c: warning: ignoring return value of 'strict_strtoul', declared with attribute warn_unused_result: 1140 => 
  - src/drivers/input/keyboard/tc3589x-keypad.c: warning: 'tc3589x_keypad_resume' defined but not used: 425 => 
  - src/drivers/input/keyboard/tc3589x-keypad.c: warning: 'tc3589x_keypad_suspend' defined but not used: 406 => 
  - src/drivers/isdn/i4l/isdn_common.c: warning: unused variable 's': 1285 => 
  - src/drivers/media/dvb/b2c2/flexcop-fe-tuner.c: warning: 'flexcop_set_voltage' defined but not used: 31 => 
  - src/drivers/media/dvb/b2c2/flexcop-fe-tuner.c: warning: 'flexcop_sleep' defined but not used: 59 => 
  - src/drivers/mfd/mc13xxx-core.c: warning: 'id' may be used uninitialized in this function: 716 => 
  - src/drivers/mfd/tc3589x.c: warning: 'tc3589x_resume' defined but not used: 374 => 
  - src/drivers/mfd/tc3589x.c: warning: 'tc3589x_suspend' defined but not used: 360 => 
  - src/drivers/misc/sgi-gru/grufault.c: warning: 'paddr' may be used uninitialized in this function: 265 => 
  - src/drivers/misc/sgi-gru/grufault.c: warning: 'ps' may be used uninitialized in this function: 266 => 
  - src/drivers/net/qlcnic/qlcnic_main.c: warning: 'pci_using_dac' may be used uninitialized in this function: 1469 => 
  - src/drivers/net/s2io.c: warning: 'tcp_len' may be used uninitialized in this function: 7559 => 
  - src/drivers/net/sky2.c: warning: 'sky2_resume' defined but not used: 4988 => 
  - src/drivers/net/wireless/rtlwifi/pci.c: warning: unused variable 'rtlpci': 1435 => 
  - src/drivers/net/wireless/rtlwifi/rtl8192ce/reg.h: warning: "GPIO_IN" redefined: 353:1 => 
  - src/drivers/net/wireless/rtlwifi/rtl8192ce/reg.h: warning: "GPIO_OUT" redefined: 354:1 => 
  - src/drivers/rtc/rtc-cmos.c: warning: 'cmos_resume' defined but not used: 907 => 
  - src/drivers/tty/serial/pch_uart.c: warning: cast from pointer to integer of different size: 779 => 
  - src/drivers/usb/gadget/u_ether.c: warning: comparison of distinct pointer types lacks a cast: 244 => 
  - src/drivers/usb/host/ehci-hub.c: warning: 'ehci_adjust_port_wakeup_flags' defined but not used: 109 => 
  - src/drivers/usb/host/ehci-lpm.c: warning: 'ehci_lpm_check' defined but not used: 40 => 
  - src/drivers/usb/host/ehci-lpm.c: warning: 'ehci_lpm_set_da' defined but not used: 20 => 
  - src/drivers/usb/host/ohci-hub.c: warning: 'ohci_finish_controller_resume' defined but not used: 318 => 
  - src/drivers/video/via/via_i2c.c: warning: 'id' is deprecated (declared at /scratch/kisskb/src/include/linux/i2c.h:359): 212 => 
  - src/drivers/video/via/viafbdev.c: warning: ignoring return value of 'strict_strtoul', declared with attribute warn_unused_result: 1380, 1214, 1417, 1311, 1144, 1272 => 
  - src/fs/cifs/cifssmb.c: warning: 'pdata' may be used uninitialized in this function: 3141 => 
  - src/fs/eventpoll.c: warning: 'slack' may be used uninitialized in this function: 1143 => 
  - src/fs/fat/namei_vfat.c: warning: 'lcase' may be used uninitialized in this function: 605 => 
  - src/fs/fat/namei_vfat.c: warning: 'ulen' may be used uninitialized in this function: 610 => 
  - src/fs/freevxfs/vxfs_lookup.c: warning: 'pp' may be used uninitialized in this function: 178 => 
  - src/fs/ocfs2/cluster/tcp.c: warning: 'o2net_get_func_run_time' defined but not used: 213 => 
  - src/fs/qnx4/namei.c: warning: 'ino' may be used uninitialized in this function: 103 => 
  - src/include/linux/mtd/cfi.h: warning: #warning No CONFIG_MTD_CFI_Ix selected. No NOR chip support can work.: 75:2 => 
  - src/kernel/trace/trace_events.c: warning: enumeration value 'TRACE_REG_PERF_REGISTER' not handled in switch: 152 => 
  - src/kernel/trace/trace_events.c: warning: enumeration value 'TRACE_REG_PERF_UNREGISTER' not handled in switch: 152 => 
  - src/net/batman-adv/vis.c: warning: passing argument 2 of 'compare_orig' discards qualifiers from pointer target type: 117 => 
  - src/net/mac80211/tx.c: warning: unused variable 'mppath': 1753 => 
  - src/net/netfilter/xt_socket.c: warning: 'daddr' may be used uninitialized in this function: 262 => 
  - src/net/netfilter/xt_socket.c: warning: 'dport' may be used uninitialized in this function: 263 => 
  - src/net/netfilter/xt_socket.c: warning: 'saddr' may be used uninitialized in this function: 262 => 
  - src/net/netfilter/xt_socket.c: warning: 'sport' may be used uninitialized in this function: 263 => 
  - src/net/packet/af_packet.c: warning: 'vnet_hdr_len' may be used uninitialized in this function: 1119 => 
  - src/net/sctp/socket.c: warning: 'newsock' may be used uninitialized in this function: 4074 => 
  - src/net/sctp/tsnmap.c: warning: 'end' may be used uninitialized in this function: 347 => 
  - src/net/sctp/tsnmap.c: warning: 'start' may be used uninitialized in this function: 347 => 
  - src/sound/drivers/serial-u16550.c: warning: 'uart' may be used uninitialized in this function: 905 => 
  - src/sound/oss/dmabuf.c: warning: passing argument 1 of 'virt_to_phys' makes pointer from integer without a cast: 139 => 
  - src/sound/pci/atiixp.c: warning: 'chip' may be used uninitialized in this function: 1652 => 
  - src/sound/pci/atiixp_modem.c: warning: 'chip' may be used uninitialized in this function: 1288 => 
  - src/sound/pci/ctxfi/ctvmem.c: warning: 'entry' may be used uninitialized in this function: 34, 80 => 
  - src/sound/pci/via82xx.c: warning: 'chip' may be used uninitialized in this function: 2503 => 
  - src/sound/pci/via82xx_modem.c: warning: 'chip' may be used uninitialized in this function: 1168 => 
  - src/sound/soc/codecs/wm8900.c: warning: 'fll_div.fll_ratio' may be used uninitialized in this function: 744 => 
  - src/sound/soc/codecs/wm8900.c: warning: 'fll_div.fll_slow_lock_ref' may be used uninitialized in this function: 744 => 
  - src/sound/soc/codecs/wm8900.c: warning: 'fll_div.fllclk_div' may be used uninitialized in this function: 744 => 
  - src/sound/soc/codecs/wm8900.c: warning: 'fll_div.k' may be used uninitialized in this function: 744 => 
  - src/sound/soc/codecs/wm8900.c: warning: 'fll_div.n' may be used uninitialized in this function: 744 => 
  - src/sound/soc/codecs/wm8985.c: warning: 'pll_div.div2' may be used uninitialized in this function: 785 => 
  - src/sound/soc/codecs/wm8985.c: warning: 'pll_div.k' may be used uninitialized in this function: 785 => 
  - src/sound/soc/codecs/wm8985.c: warning: 'pll_div.n' may be used uninitialized in this function: 785 => 
  - src/sound/soc/soc-core.c: warning: 'compress_type' may be used uninitialized in this function: 1719 => 
  - warning: "cause_of_death" [vmlinux] is COMMON symbol: N/A => 
  - warning: (ATH5K && ATH9K && ATH9K_HTC && CARL9170_LEDS) selects MAC80211_LEDS which has unmet direct dependencies (NET && WIRELESS && MAC80211 && LEDS_CLASS): N/A => 
  - warning: (CPU_SUBTYPE_SH7720 && CPU_SUBTYPE_SH7721 && CPU_SUBTYPE_SH7763 && CPU_SUBTYPE_SH7786) selects USB_ARCH_HAS_OHCI which has unmet direct dependencies (USB_SUPPORT): N/A => 
  - warning: (IA32_EMULATION) selects COMPAT_BINFMT_ELF which has unmet direct dependencies (COMPAT && BINFMT_ELF): N/A => 
  - warning: (LOCKDEP && FAULT_INJECTION_STACKTRACE_FILTER && LATENCYTOP && DWARF_UNWINDER && FUNCTION_TRACER && KMEMCHECK) selects FRAME_POINTER which has unmet direct dependencies (DEBUG_KERNEL && (CRIS || M68K || FRV || UML || AVR32 || SUPERH || BLACKFIN || MN10300) || ARCH_WANT_FRAME_POINTERS): N/A => 
  - warning: (NETFILTER_XT_MATCH_REALM) selects NET_CLS_ROUTE which has unmet direct dependencies (NET && NET_SCHED): N/A => 
  - warning: (PAGE_POISONING) selects DEBUG_PAGEALLOC which has unmet direct dependencies (DEBUG_KERNEL && ARCH_SUPPORTS_DEBUG_PAGEALLOC && (!HIBERNATION || !PPC && !SPARC) && !KMEMCHECK): N/A => 
  - warning: (PPC_PS3 && SPU_FS) selects MEMORY_HOTPLUG which has unmet direct dependencies ((SPARSEMEM || X86_64_ACPI_NUMA) && HOTPLUG && ARCH_ENABLE_MEMORY_HOTPLUG && (IA64 || X86 || PPC_BOOK3S_64 || SUPERH || S390)): N/A => 
  - warning: (SERIAL_PCH_UART) selects PCH_DMA which has unmet direct dependencies (DMADEVICES && PCI && X86): N/A => 
  - warning: (STUB_POULSBO && DRM_I915) selects ACPI_VIDEO which has unmet direct dependencies (ACPI && X86 && BACKLIGHT_CLASS_DEVICE && VIDEO_OUTPUT_CONTROL && INPUT): N/A => 
  - warning: 3 bad relocations: N/A => 

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
