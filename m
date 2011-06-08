Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729Ab1FHHu2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 03:50:28 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:40020 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470Ab1FHHuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 03:50:22 -0400
Date: Wed, 8 Jun 2011 09:50:18 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Build regressions/improvements in v3.0-rc2
Message-ID: <alpine.DEB.2.00.1106080949550.29624@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is the list of build error/warning regressions/improvements in
v3.0-rc2[1] compared to v2.6.39[2].

Summarized:
  - build errors: +46/-66
  - build warnings: +197/-407

JFYI, when comparing v3.0-rc2 to v3.0-rc1[3], the summaries are:
  - build errors: +68/-8
  - build warnings: +147/-70

Note that there may be false regressions, as some logs are incomplete.
Still, they're build errors/warnings.

In addition, I put the verbose summary at
http://www.kernel.org/pub/linux/kernel/people/geert/linux-log/v3.0-rc2.summary.gz
so you can easily find out for which configs and architectures the
errors/warnings you're interested in are happening.

Happy fixing! ;-)

Thanks to the linux-next team for providing the build service.

[1] http://kisskb.ellerman.id.au/kisskb/head/4085/ (107 out of 108 configs)
[2] http://kisskb.ellerman.id.au/kisskb/head/4019/ (all 108 configs)
[3] http://kisskb.ellerman.id.au/kisskb/head/4063/ (107 out of 108 configs)


*** ERRORS ***

46 regressions:
  + build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/hidraw.h: error: expected specifier-qualifier-list before '__u32':  => 27, 22
  + build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/input.h: error: expected specifier-qualifier-list before '__s16':  => 956, 967
  + build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/input.h: error: expected specifier-qualifier-list before '__s32':  => 65
  + build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/input.h: error: expected specifier-qualifier-list before '__u16':  => 39, 1012, 917, 944, 927, 23, 983, 1061, 1033
  + build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/input.h: error: expected specifier-qualifier-list before '__u8':  => 90
  + build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/types.h: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__be16':  => 28
  + build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/types.h: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__be32':  => 30
  + build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/types.h: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__be64':  => 32
  + build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/types.h: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__le16':  => 27
  + build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/types.h: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__le32':  => 29
  + build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/types.h: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__le64':  => 31
  + build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/types.h: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__sum16':  => 34
  + build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/types.h: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__wsum':  => 35
  + error: hotplug-memory.c: undefined reference to `.__remove_pages':  => .text+0x1255c)
  + error: mm.c: undefined reference to `.online_pages':  => .init.text+0x4914)
  + src/arch/avr32/mach-at32ap/at32ap700x.c: error: 'portnr' undeclared (first use in this function):  => 1047
  + src/arch/avr32/mach-at32ap/at32ap700x.c: error: (Each undeclared identifier is reported only once:  => 1047
  + src/arch/avr32/mach-at32ap/at32ap700x.c: error: for each function it appears in.):  => 1047
  + src/arch/mips/kernel/i8259.c: error: unknown field 'resume' specified in initializer:  => 240
  + src/arch/mips/kernel/i8259.c: error: unknown field 'shutdown' specified in initializer:  => 241
  + src/arch/x86/include/asm/uaccess_32.h: error: call to 'copy_from_user_overflow' declared with attribute error: copy_from_user() buffer size is not provably correct:  => 211
  + src/arch/xtensa/include/asm/uaccess.h: error: implicit declaration of function 'prefetch':  => 403
  + src/arch/xtensa/include/asm/uaccess.h: error: implicit declaration of function 'prefetchw':  => 412
  + src/drivers/bluetooth/bluecard_cs.c: error: implicit declaration of function 'inb':  => 348
  + src/drivers/bluetooth/bluecard_cs.c: error: implicit declaration of function 'outb':  => 168
  + src/drivers/bluetooth/bluecard_cs.c: error: implicit declaration of function 'outb_p':  => 209
  + src/drivers/parisc/iommu-helpers.h: error: implicit declaration of function 'prefetchw':  => 62
  + src/drivers/video/sh_mobile_lcdcfb.c: error: 'ret' undeclared (first use in this function):  => 640
  + src/drivers/video/sh_mobile_lcdcfb.c: error: (Each undeclared identifier is reported only once:  => 640
  + src/drivers/video/sh_mobile_lcdcfb.c: error: for each function it appears in.):  => 640
  + src/drivers/w1/masters/ds1wm.c: error: 'IRQ_TYPE_EDGE_FALLING' undeclared (first use in this function):  => 497
  + src/drivers/w1/masters/ds1wm.c: error: 'IRQ_TYPE_EDGE_RISING' undeclared (first use in this function):  => 495
  + src/drivers/w1/masters/ds1wm.c: error: (Each undeclared identifier is reported only once:  => 495
  + src/drivers/w1/masters/ds1wm.c: error: for each function it appears in.):  => 495
  + src/drivers/w1/masters/ds1wm.c: error: implicit declaration of function '__raw_readb':  => 122
  + src/drivers/w1/masters/ds1wm.c: error: implicit declaration of function '__raw_writeb':  => 117
  + src/drivers/w1/masters/ds1wm.c: error: implicit declaration of function 'ioremap':  => 465
  + src/drivers/w1/masters/ds1wm.c: error: implicit declaration of function 'iounmap':  => 518
  + src/drivers/w1/masters/ds1wm.c: error: implicit declaration of function 'irq_set_irq_type':  => 495
  + src/include/linux/parport_pc.h: error: implicit declaration of function 'inb':  => 72
  + src/include/linux/parport_pc.h: error: implicit declaration of function 'outb':  => 67
  + src/samples/hidraw/hid-example.c: error: 'struct hidraw_devinfo' has no member named 'bustype':  => 104
  + src/samples/hidraw/hid-example.c: error: 'struct hidraw_devinfo' has no member named 'product':  => 106
  + src/samples/hidraw/hid-example.c: error: 'struct hidraw_devinfo' has no member named 'vendor':  => 105
  + src/samples/hidraw/hid-example.c: error: 'struct hidraw_report_descriptor' has no member named 'size':  => 72, 78
  + src/samples/hidraw/hid-example.c: error: 'struct hidraw_report_descriptor' has no member named 'value':  => 79

66 improvements:
  - error: hung_task.c: undefined reference to `ack_bad_irq': .text+0x1fec8) => 
  - error: vsprintf.c: relocation truncated to fit: R_AVR32_11H_PCREL against `.text'+61c: (.text+0xa22) => 
  - src/arch/cris/arch-v10/drivers/sync_serial.c: error: 'ret' undeclared (first use in this function): 628 => 
  - src/arch/cris/arch-v10/drivers/sync_serial.c: error: (Each undeclared identifier is reported only once: 628 => 
  - src/arch/cris/arch-v10/drivers/sync_serial.c: error: conflicting types for 'sync_serial_ioctl': 961 => 
  - src/arch/cris/arch-v10/drivers/sync_serial.c: error: for each function it appears in.): 628 => 
  - src/arch/cris/arch-v10/drivers/sync_serial.c: error: previous declaration of 'sync_serial_ioctl' was here: 161 => 
  - src/arch/cris/arch-v10/kernel/kgdb.c: error: expected string literal before '.' token: 1274 => 
  - src/arch/cris/arch-v10/kernel/kgdb.c: error: missing terminating " character: 1457, 1273, 1359, 1370 => 
  - src/arch/powerpc/sysdev/mv64x60_dev.c: error: implicit declaration of function 'of_get_mac_address': 253 => 
  - src/arch/sh/boards/board-shmin.c: error: implicit declaration of function '__set_io_port_base': 27 => 
  - src/drivers/block/paride/bpck.c: error: implicit declaration of function 'inb': 57 => 
  - src/drivers/block/paride/bpck.c: error: implicit declaration of function 'inl': 188 => 
  - src/drivers/block/paride/bpck.c: error: implicit declaration of function 'inw': 181 => 
  - src/drivers/block/paride/bpck.c: error: implicit declaration of function 'outb': 56 => 
  - src/drivers/block/paride/bpck.c: error: implicit declaration of function 'outl': 142 => 
  - src/drivers/block/paride/bpck.c: error: implicit declaration of function 'outw': 135 => 
  - src/drivers/block/paride/bpck.c: error: invalid operands to binary & (have 'void *' and 'int'): 56, 62 => 
  - src/drivers/char/ipmi/ipmi_si_intf.c: error: invalid operands to binary << (have 'void *' and 'int'): 1406, 1391 => 
  - src/drivers/char/tpm/tpm.h: error: implicit declaration of function 'inb': 124 => 
  - src/drivers/char/tpm/tpm.h: error: implicit declaration of function 'outb': 123 => 
  - src/drivers/char/tpm/tpm.h: error: invalid operands to binary & (have 'void *' and 'int'): 130 => 
  - src/drivers/char/tpm/tpm_tis.c: error: implicit declaration of function 'ioread32': 413 => 
  - src/drivers/char/tpm/tpm_tis.c: error: implicit declaration of function 'ioread8': 104 => 
  - src/drivers/char/tpm/tpm_tis.c: error: implicit declaration of function 'iowrite32': 422 => 
  - src/drivers/char/tpm/tpm_tis.c: error: implicit declaration of function 'iowrite8': 117 => 
  - src/drivers/hwmon/pc87360.c: error: implicit declaration of function 'inb': 97 => 
  - src/drivers/hwmon/pc87360.c: error: implicit declaration of function 'inb_p': 1300 => 
  - src/drivers/hwmon/pc87360.c: error: implicit declaration of function 'outb': 90 => 
  - src/drivers/hwmon/pc87360.c: error: implicit declaration of function 'outb_p': 1299 => 
  - src/drivers/hwmon/sch5627.c: error: implicit declaration of function 'inb': 115 => 
  - src/drivers/hwmon/sch5627.c: error: implicit declaration of function 'outb': 114 => 
  - src/drivers/tty/serial/pch_uart.c: error: implicit declaration of function 'kfree': 670 => 
  - src/drivers/tty/serial/pch_uart.c: error: implicit declaration of function 'kzalloc': 869 => 
  - src/drivers/usb/host/xhci-pci.c: error: implicit declaration of function 'kfree': 157 => 
  - src/drivers/usb/host/xhci-pci.c: error: implicit declaration of function 'kzalloc': 61 => 
  - src/drivers/video/backlight/hp680_bl.c: error: implicit declaration of function 'inw': 48 => 
  - src/drivers/video/backlight/hp680_bl.c: error: implicit declaration of function 'outw': 50 => 
  - src/include/linux/gameport.h: error: implicit declaration of function 'inb': 189 => 
  - src/include/linux/gameport.h: error: implicit declaration of function 'outb': 181 => 
  - src/lib/atomic64_test.c: error: 'atomic64_t' undeclared (first use in this function): 24 => 
  - src/lib/atomic64_test.c: error: 'v' undeclared (first use in this function): 26 => 
  - src/lib/atomic64_test.c: error: (Each undeclared identifier is reported only once: 24 => 
  - src/lib/atomic64_test.c: error: expected ';' before 'v': 24 => 
  - src/lib/atomic64_test.c: error: for each function it appears in.): 24 => 
  - src/lib/atomic64_test.c: error: implicit declaration of function 'atomic64_add': 34 => 
  - src/lib/atomic64_test.c: error: implicit declaration of function 'atomic64_add_return': 45 => 
  - src/lib/atomic64_test.c: error: implicit declaration of function 'atomic64_add_unless': 108 => 
  - src/lib/atomic64_test.c: error: implicit declaration of function 'atomic64_cmpxchg': 99 => 
  - src/lib/atomic64_test.c: error: implicit declaration of function 'atomic64_dec': 84 => 
  - src/lib/atomic64_test.c: error: implicit declaration of function 'atomic64_dec_return': 90 => 
  - src/lib/atomic64_test.c: error: implicit declaration of function 'atomic64_inc': 74 => 
  - src/lib/atomic64_test.c: error: implicit declaration of function 'atomic64_inc_not_zero': 135 => 
  - src/lib/atomic64_test.c: error: implicit declaration of function 'atomic64_inc_return': 80 => 
  - src/lib/atomic64_test.c: error: implicit declaration of function 'atomic64_read': 31 => 
  - src/lib/atomic64_test.c: error: implicit declaration of function 'atomic64_set': 28 => 
  - src/lib/atomic64_test.c: error: implicit declaration of function 'atomic64_sub': 54 => 
  - src/lib/atomic64_test.c: error: implicit declaration of function 'atomic64_sub_return': 65 => 
  - src/lib/atomic64_test.c: error: implicit declaration of function 'atomic64_xchg': 94 => 
  - src/net/mac80211/ieee80211_i.h: error: field 'trig' has incomplete type: 639 => 
  - src/sound/pcmcia/pdaudiocf/pdaudiocf.h: error: implicit declaration of function 'inw': 127 => 
  - src/sound/pcmcia/pdaudiocf/pdaudiocf.h: error: implicit declaration of function 'outw': 122 => 
  - src/sound/soc/fsl/mpc5200_dma.c: error: (near initialization for 'mpc5200_hpcd_of_driver.shutdown'): 524, 523, 522 => 
  - src/sound/soc/fsl/mpc5200_dma.c: error: dereferencing pointer to incomplete type: 384, 389, 491, 401, 427, 495, 413, 474, 382, 383, 507, 477, 493 => 
  - src/sound/soc/fsl/mpc5200_dma.c: error: field name not in record or union initializer: 524, 523, 522 => 
  - src/sound/soc/fsl/mpc5200_dma.c: error: unknown field 'dev' specified in initializer: 521 => 


*** WARNINGS ***

197 regressions:
  + /tmp/ccGXWwDk.s: Warning: source register same as write-back base:  => 104
  + <stdin>: warning: #warning syscall sendmmsg not implemented:  => 1554:2
  + arch/powerpc/configs/ps3_defconfig: warning: symbol value 'm' invalid for RTC_CLASS:  => 144
  + arch/powerpc/configs/pseries_defconfig: warning: override: reassigning to symbol SCSI_BNX2_ISCSI:  => 151
  + arch/sh/configs/titan_defconfig: warning: symbol value 'm' invalid for RTC_CLASS:  => 230
  + modpost: WARNING: modpost: Found 10 section mismatch(es).:  => N/A
  + modpost: WARNING: modpost: Found 16 section mismatch(es).:  => N/A
  + modpost: WARNING: modpost: Found 17 section mismatch(es).:  => N/A
  + modpost: WARNING: modpost: Found 3 section mismatch(es).:  => N/A
  + modpost: WARNING: modpost: Found 8 section mismatch(es).:  => N/A
  + src/arch/avr32/mach-at32ap/intc.c: warning: initialization from incompatible pointer type:  => 186
  + src/arch/ia64/kernel/perfmon.c: warning: 'task' may be used uninitialized in this function:  => 4201
  + src/arch/ia64/kernel/traps.c: warning: 'rv.arg1' is used uninitialized in this function:  => 399
  + src/arch/ia64/kernel/traps.c: warning: 'rv.arg2' is used uninitialized in this function:  => 399
  + src/arch/ia64/kernel/traps.c: warning: 'rv.arg3' is used uninitialized in this function:  => 399
  + src/arch/m68k/include/asm/atarihw.h: warning: this is the location of the previous definition:  => 403:1, 402:1
  + src/arch/mips/kernel/i8259.c: warning: (near initialization for 'i8259_sysdev_class.drivers'):  => 240
  + src/arch/mips/kernel/i8259.c: warning: initialization from incompatible pointer type:  => 240, 241
  + src/arch/mips/kernel/i8259.c: warning: missing braces around initializer:  => 240
  + src/arch/parisc/include/asm/pdc.h: warning: this is the location of the previous definition:  => 680:1
  + src/arch/x86/kernel/apic/x2apic_uv_x.c: warning: passing argument 1 of 'pci_register_set_vga_state' from incompatible pointer type:  => 882
  + src/arch/x86/kvm/paging_tmpl.h: warning: 'ptep_user' may be used uninitialized in this function:  => 124
  + src/arch/x86/kvm/vmx.c: warning: 'save' may be used uninitialized in this function:  => 2164
  + src/arch/x86/kvm/x86.c: warning: 'exchanged' may be used uninitialized in this function:  => 4034
  + src/drivers/ata/pata_atiixp.c: warning: 'wanted_pio' may be used uninitialized in this function:  => 115
  + src/drivers/edac/i82975x_edac.c: warning: integer constant is too large for 'unsigned long' type:  => 298
  + src/drivers/isdn/i4l/isdn_common.c: warning: unused variable 's':  => 1279
  + src/drivers/media/video/m5mols/m5mols_capture.c: warning: 'timeout' may be used uninitialized in this function:  => 126
  + src/drivers/media/video/saa7164/saa7164-encoder.c: warning: 'tsport' may be used uninitialized in this function:  => 345
  + src/drivers/media/video/saa7164/saa7164-vbi.c: warning: 'tsport' may be used uninitialized in this function:  => 317
  + src/drivers/media/video/soc_camera.c: warning: initialization discards qualifiers from pointer target type:  => 1515
  + src/drivers/media/video/uvc/uvc_entity.c: warning: 'ret' may be used uninitialized in this function:  => 33
  + src/drivers/memstick/core/mspro_block.c: warning: control reaches end of non-void function:  => 664
  + src/drivers/message/fusion/mptbase.c: warning: 'seq_mpt_print_ioc_summary' defined but not used:  => 6810
  + src/drivers/mmc/card/block.c: warning: 'err' may be used uninitialized in this function:  => 286
  + src/drivers/mtd/maps/physmap.c: warning: assignment from incompatible pointer type:  => 255
  + src/drivers/net/cnic.c: warning: large integer implicitly truncated to unsigned type:  => 1380, 1368, 1395, 1410
  + src/drivers/net/phy/dp83640_reg.h: warning: "PAGE0" redefined:  => 7:1
  + src/drivers/net/wireless/iwlwifi/iwl-tx.c: warning: passing argument 2 of 'pci_map_single' discards qualifiers from pointer target type:  => 702
  + src/drivers/net/wireless/mwifiex/cmdevt.c: warning: format '%lu' expects type 'long unsigned int', but argument 5 has type '__kernel_suseconds_t':  => 830, 742, 169, 396
  + src/drivers/net/wireless/mwifiex/sta_event.c: warning: comparison of distinct pointer types lacks a cast:  => 382
  + src/drivers/net/wireless/rtlwifi/core.c: warning: passing argument 3 of 'get_sta' discards qualifiers from pointer target type:  => 688, 653
  + src/drivers/net/wireless/rtlwifi/rtl8192c/../rtl8192ce/reg.h: warning: "GPIO_IN" redefined:  => 369:1
  + src/drivers/net/wireless/rtlwifi/rtl8192c/../rtl8192ce/reg.h: warning: "GPIO_OUT" redefined:  => 370:1
  + src/drivers/net/wireless/rtlwifi/rtl8192se/reg.h: warning: "GPIO_IN" redefined:  => 252:1
  + src/drivers/net/wireless/rtlwifi/rtl8192se/reg.h: warning: "GPIO_OUT" redefined:  => 253:1
  + src/drivers/rtc/rtc-m41t93.c: warning: passing argument 1 of 'platform_get_drvdata' from incompatible pointer type:  => 192
  + src/drivers/scsi/bnx2i/bnx2i_iscsi.c: warning: large integer implicitly truncated to unsigned type:  => 550
  + src/drivers/scsi/lpfc/lpfc_bsg.c: warning: 'mbxstatus' may be used uninitialized in this function:  => 1744, 1570
  + src/drivers/scsi/lpfc/lpfc_debugfs.c: warning: 'reg_val' may be used uninitialized in this function:  => 2259
  + src/drivers/target/tcm_fc/tfc_cmd.c: warning: 'data_dir' may be used uninitialized in this function:  => 566
  + src/drivers/target/tcm_fc/tfc_conf.c: warning: 'ft_init' defined but not used:  => 641, 642
  + src/drivers/target/tcm_fc/tfc_io.c: warning: comparison of distinct pointer types lacks a cast:  => 160
  + src/drivers/target/tcm_fc/tfc_io.c: warning: format '%x' expects type 'unsigned int', but argument 5 has type 'size_t':  => 209
  + src/drivers/tty/serial/8250_pci.c: warning: initialization from incompatible pointer type:  => 1457
  + src/drivers/vhost/vhost.c: warning: unused variable 'a':  => 460
  + src/drivers/vhost/vhost.c: warning: unused variable 's':  => 502
  + src/drivers/video/aty/aty128fb.c: warning: 'backlight' defined but not used:  => 362
  + src/drivers/video/via/viafbdev.c: warning: unused variable 'r':  => 2019
  + src/drivers/virtio/virtio_balloon.c: warning: 'events[10]' is used uninitialized in this function:  => 166
  + src/drivers/virtio/virtio_balloon.c: warning: 'events[11]' is used uninitialized in this function:  => 166
  + src/drivers/virtio/virtio_balloon.c: warning: 'events[2]' is used uninitialized in this function:  => 180
  + src/drivers/virtio/virtio_balloon.c: warning: 'events[3]' is used uninitialized in this function:  => 182
  + src/drivers/w1/masters/ds1wm.c: warning: assignment makes pointer from integer without a cast:  => 465
  + src/fs/btrfs/delayed-inode.c: warning: 'root' may be used uninitialized in this function:  => 424
  + src/fs/btrfs/sysfs.c: warning: 'btrfs_root_attrs' defined but not used:  => 76
  + src/fs/btrfs/sysfs.c: warning: 'btrfs_root_release' defined but not used:  => 161, 160
  + src/fs/btrfs/sysfs.c: warning: 'btrfs_super_attrs' defined but not used:  => 97
  + src/fs/btrfs/sysfs.c: warning: 'btrfs_super_release' defined but not used:  => 154, 153
  + src/fs/btrfs/volumes.c: warning: 'max_chunk_size' may be used uninitialized in this function:  => 2314
  + src/fs/btrfs/volumes.c: warning: 'max_stripe_size' may be used uninitialized in this function:  => 2313
  + src/fs/cifs/connect.c: warning: 'mountdata_copy' may be used uninitialized in this function:  => 787
  + src/fs/cifs/connect.c: warning: 'pSesInfo' may be used uninitialized in this function:  => 2976
  + src/fs/cifs/connect.c: warning: 'tcon' may be used uninitialized in this function:  => 2977
  + src/fs/cifs/connect.c: warning: 'xid' may be used uninitialized in this function:  => 2975
  + src/fs/lockd/svclock.c: warning: 'nlmdbg_cookie2a' declared 'static' but never defined:  => 49
  + src/fs/nfs/file.c: warning: unused variable 'count':  => 234
  + src/fs/nfs/file.c: warning: unused variable 'dentry':  => 140
  + src/fs/nfs/objlayout/objlayout.c: warning: format '%ld' expects type 'long int', but argument 3 has type 'ssize_t':  => 294
  + src/fs/read_write.c: warning: unused variable 'buf':  => 625
  + src/kernel/events/core.c: warning: initialization from incompatible pointer type:  => 7445
  + src/kernel/sched.c: warning: initialization from incompatible pointer type:  => 7191
  + src/kernel/trace/ftrace.c: warning: 'ret' may be used uninitialized in this function:  => 2743
  + src/kernel/trace/trace_printk.c: warning: 'fmt' may be used uninitialized in this function:  => 52
  + src/net/mac80211/util.c: warning: label 'wake_up' defined but not used:  => 1279
  + src/net/sunrpc/rpcb_clnt.c: warning: unused variable 'task':  => 836, 764, 804, 858, 781
  + src/sound/pci/ctxfi/ctvmem.c: warning: 'entry' may be used uninitialized in this function:  => 34, 79
  + src/sound/soc/soc-cache.c: warning: 'ret' may be used uninitialized in this function:  => 299
  + warning: (ACPI_HOTPLUG_CPU) selects ACPI_CONTAINER which has unmet direct dependencies (ACPI && EXPERIMENTAL):  => N/A
  + warning: (BATTERY_DS2780) selects W1 which has unmet direct dependencies (HAS_IOMEM):  => N/A
  + warning: (CAVIUM_OCTEON_REFERENCE_BOARD && SOC_AR71XX && SOC_AR724X && BCM63XX_CPU_6338) selects USB_ARCH_HAS_OHCI which has unmet direct dependencies (USB_SUPPORT):  => N/A
  + warning: (CAVIUM_OCTEON_REFERENCE_BOARD && SOC_AR71XX && SOC_AR724X && SOC_AR913X) selects USB_ARCH_HAS_EHCI which has unmet direct dependencies (USB_SUPPORT):  => N/A
  + warning: (IMA) selects TCG_TPM which has unmet direct dependencies (HAS_IOMEM && EXPERIMENTAL):  => N/A
  + warning: (ISDN_PPP) selects SLHC which has unmet direct dependencies (NETDEVICES):  => N/A
  + warning: (LOCKDEP && FAULT_INJECTION_STACKTRACE_FILTER && LATENCYTOP && DWARF_UNWINDER && FUNCTION_TRACER && KMEMCHECK) selects FRAME_POINTER which has unmet direct dependencies (DEBUG_KERNEL && (CRIS || M68K || FRV || UML || AVR32 || SUPERH || BLACKFIN || MN10300) || ARCH_WANT_FRAME_POINTERS):  => N/A
  + warning: (PPC_PS3 && PPC_CELLEB && USB_EHCI_HCD_PMC_MSP && XPS_USB_HCD_XILINX && USB_OCTEON_EHCI) selects USB_EHCI_BIG_ENDIAN_MMIO which has unmet direct dependencies (USB_SUPPORT && USB_EHCI_HCD && (PPC_CELLEB || PPC_PS3 || 440EPX || ARCH_IXP4XX || XPS_USB_HCD_XILINX || PPC_MPC512x || CPU_CAVIUM_OCTEON || PMC_MSP || SPARC_LEON)):  => N/A
  + warning: (PPC_PS3 && PPC_CELLEB) selects USB_OHCI_BIG_ENDIAN_MMIO which has unmet direct dependencies (USB_SUPPORT && USB_OHCI_HCD):  => N/A
  + warning: (PPC_PS3 && SPU_FS) selects MEMORY_HOTPLUG which has unmet direct dependencies ((SPARSEMEM || X86_64_ACPI_NUMA) && HOTPLUG && ARCH_ENABLE_MEMORY_HOTPLUG && (IA64 || X86 || PPC_BOOK3S_64 || SUPERH || S390)):  => N/A
  + warning: (PPC_PS3) selects USB_OHCI_LITTLE_ENDIAN which has unmet direct dependencies (USB_SUPPORT && USB_OHCI_HCD):  => N/A
  + warning: (RADIO_WL128X) selects TI_ST which has unmet direct dependencies (MISC_DEVICES && NET && GPIOLIB):  => N/A
  + warning: (VIDEO_CX88_DVB && VIDEO_CX23885 && VIDEO_CX18 && VIDEO_SAA7164 && VIDEO_PVRUSB2_DVB && DVB_USB_DIB0700) selects DVB_S5H1411 which has unmet direct dependencies (MEDIA_SUPPORT && DVB_CAPTURE_DRIVERS && DVB_CORE && I2C):  => N/A
  + warning: (VIDEO_SAA7134_DVB && VIDEO_CX23885 && VIDEO_SAA7164 && VIDEO_PVRUSB2_DVB) selects DVB_TDA10048 which has unmet direct dependencies (MEDIA_SUPPORT && DVB_CAPTURE_DRIVERS && DVB_CORE && I2C):  => N/A
  + warning: 3 bad relocations:  => N/A
  + warning: You need at binutils >= 2.19 to build a CONFIG_RELCOATABLE kernel:  => N/A
  + warning: arch/powerpc/kernel/built-in.o(.text+0x5bc88): Section mismatch in reference from the function .register_power_pmu() to the function .cpuinit.text:.power_pmu_notifier():  => N/A
  + warning: arch/powerpc/kernel/built-in.o(.text+0x5bca4): Section mismatch in reference from the function .register_power_pmu() to the function .cpuinit.text:.power_pmu_notifier():  => N/A
  + warning: arch/powerpc/kernel/built-in.o(.text+0x5bcc0): Section mismatch in reference from the function .register_power_pmu() to the function .cpuinit.text:.power_pmu_notifier():  => N/A
  + warning: arch/powerpc/kernel/built-in.o(.text+0x5d800): Section mismatch in reference from the function .register_power_pmu() to the function .cpuinit.text:.power_pmu_notifier():  => N/A
  + warning: arch/powerpc/kernel/built-in.o(.text+0x5d81c): Section mismatch in reference from the function .register_power_pmu() to the function .cpuinit.text:.power_pmu_notifier():  => N/A
  + warning: arch/powerpc/kernel/built-in.o(.text+0x5d838): Section mismatch in reference from the function .register_power_pmu() to the function .cpuinit.text:.power_pmu_notifier():  => N/A
  + warning: arch/powerpc/mm/built-in.o(.text+0xb4fc): Section mismatch in reference from the function .mark_reserved_regions_for_nid() to the function .init.text:.get_node_active_region():  => N/A
  + warning: arch/powerpc/mm/built-in.o(.text+0xb5e0): Section mismatch in reference from the function .mark_reserved_regions_for_nid() to the function .init.text:.get_node_active_region():  => N/A
  + warning: arch/powerpc/sysdev/built-in.o(.text+0x101c4): Section mismatch in reference from the function .icp_native_init() to the function .init.text:.icp_native_init_one_node():  => N/A
  + warning: arch/powerpc/sysdev/built-in.o(.text+0x10274): Section mismatch in reference from the function .icp_native_init() to the function .init.text:.icp_native_init_one_node():  => N/A
  + warning: arch/powerpc/sysdev/built-in.o(.text+0x10c74): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics():  => N/A
  + warning: arch/powerpc/sysdev/built-in.o(.text+0xe72c): Section mismatch in reference from the function .icp_native_init() to the function .init.text:.icp_native_init_one_node():  => N/A
  + warning: arch/powerpc/sysdev/built-in.o(.text+0xe7dc): Section mismatch in reference from the function .icp_native_init() to the function .init.text:.icp_native_init_one_node():  => N/A
  + warning: arch/powerpc/sysdev/built-in.o(.text+0xf1dc): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics():  => N/A
  + warning: arch/powerpc/sysdev/xics/built-in.o(.text+0x16d0): Section mismatch in reference from the function .icp_native_init() to the function .init.text:.icp_native_init_one_node():  => N/A
  + warning: arch/powerpc/sysdev/xics/built-in.o(.text+0x1780): Section mismatch in reference from the function .icp_native_init() to the function .init.text:.icp_native_init_one_node():  => N/A
  + warning: arch/powerpc/sysdev/xics/built-in.o(.text+0x2180): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics():  => N/A
  + warning: drivers/built-in.o(.text+0x2676ee0): Section mismatch in reference from the function .tc3589x_keypad_open() to the function .devinit.text:.tc3589x_keypad_init_key_hardware():  => N/A
  + warning: drivers/built-in.o(.text+0x32c378c): Section mismatch in reference from the function .lp5521_probe() to the function .init.text:.lp5521_init_led():  => N/A
  + warning: drivers/built-in.o(.text+0x32c651c): Section mismatch in reference from the function .lp5523_probe() to the function .init.text:.lp5523_init_led():  => N/A
  + warning: drivers/built-in.o(.text+0x6510ac): Section mismatch in reference from the function .radeon_get_clock_info() to the function .devinit.text:.radeon_read_clocks_OF():  => N/A
  + warning: drivers/gpu/built-in.o(.text+0x137ca0): Section mismatch in reference from the function .radeon_get_clock_info() to the function .devinit.text:.radeon_read_clocks_OF():  => N/A
  + warning: drivers/gpu/drm/built-in.o(.text+0x137ca0): Section mismatch in reference from the function .radeon_get_clock_info() to the function .devinit.text:.radeon_read_clocks_OF():  => N/A
  + warning: drivers/gpu/drm/radeon/built-in.o(.text+0xd3cc0): Section mismatch in reference from the function .radeon_get_clock_info() to the function .devinit.text:.radeon_read_clocks_OF():  => N/A
  + warning: drivers/gpu/drm/radeon/radeon.o(.text+0x48fa0): Section mismatch in reference from the function radeon_get_clock_info() to the function .devinit.text:radeon_read_clocks_OF():  => N/A
  + warning: drivers/gpu/drm/radeon/radeon.o(.text+0xd3cc0): Section mismatch in reference from the function .radeon_get_clock_info() to the function .devinit.text:.radeon_read_clocks_OF():  => N/A
  + warning: drivers/gpu/drm/radeon/radeon.o(.text+0xd3cc4): Section mismatch in reference from the function .radeon_get_clock_info() to the function .devinit.text:.radeon_read_clocks_OF():  => N/A
  + warning: drivers/input/built-in.o(.text+0x279ec): Section mismatch in reference from the function .tc3589x_keypad_open() to the function .devinit.text:.tc3589x_keypad_init_key_hardware():  => N/A
  + warning: drivers/input/keyboard/built-in.o(.text+0x10860): Section mismatch in reference from the function .tc3589x_keypad_open() to the function .devinit.text:.tc3589x_keypad_init_key_hardware():  => N/A
  + warning: drivers/leds/built-in.o(.text+0x2e46): Section mismatch in reference from the function lp5521_probe() to the function .init.text:lp5521_init_led():  => N/A
  + warning: drivers/leds/built-in.o(.text+0xb830): Section mismatch in reference from the function .lp5521_probe() to the function .init.text:.lp5521_init_led():  => N/A
  + warning: drivers/leds/built-in.o(.text+0xe5c0): Section mismatch in reference from the function .lp5523_probe() to the function .init.text:.lp5523_init_led():  => N/A
  + warning: drivers/mfd/built-in.o(.data+0x3b20): Section mismatch in reference from the variable ab3550_driver to the function .init.text:ab3550_probe():  => N/A
  + warning: drivers/mfd/built-in.o(.data+0x4d9c): Section mismatch in reference from the variable cs5535_mfd_drv to the function .devinit.text:cs5535_mfd_probe():  => N/A
  + warning: drivers/mfd/built-in.o(.data+0x4da0): Section mismatch in reference from the variable cs5535_mfd_drv to the function .devexit.text:cs5535_mfd_remove():  => N/A
  + warning: drivers/net/irda/smsc-ircc2.o(.devinit.text+0x1a7): Section mismatch in reference from the function smsc_ircc_pnp_probe() to the function .init.text:smsc_ircc_open():  => N/A
  + warning: drivers/sbus/char/bbc.o(.devinit.text+0x8): Section mismatch in reference from the function bbc_i2c_probe() to the function .init.text:T.356():  => N/A
  + warning: drivers/video/sm501fb.o(.text+0x21d4): Section mismatch in reference from the function sm501fb_init_fb() to the variable .devinit.data:sm501_default_mode:  => N/A
  + warning: sound/built-in.o(.text+0x1fba28): Section mismatch in reference from the function .lola_parse_tree() to the function .devinit.text:.lola_init_pcm():  => N/A
  + warning: sound/built-in.o(.text+0x1fba64): Section mismatch in reference from the function .lola_parse_tree() to the function .devinit.text:.lola_init_pcm():  => N/A
  + warning: sound/built-in.o(.text+0x1fbaa0): Section mismatch in reference from the function .lola_parse_tree() to the function .devinit.text:.lola_init_pins():  => N/A
  + warning: sound/built-in.o(.text+0x1fbadc): Section mismatch in reference from the function .lola_parse_tree() to the function .devinit.text:.lola_init_pins():  => N/A
  + warning: sound/built-in.o(.text+0x1fbb2c): Section mismatch in reference from the function .lola_parse_tree() to the function .devinit.text:.lola_init_clock_widget():  => N/A
  + warning: sound/built-in.o(.text+0x1fbb8c): Section mismatch in reference from the function .lola_parse_tree() to the function .devinit.text:.lola_init_mixer_widget():  => N/A
  + warning: sound/pci/built-in.o(.text+0x13951c): Section mismatch in reference from the function .lola_parse_tree() to the function .devinit.text:.lola_init_pcm():  => N/A
  + warning: sound/pci/built-in.o(.text+0x139558): Section mismatch in reference from the function .lola_parse_tree() to the function .devinit.text:.lola_init_pcm():  => N/A
  + warning: sound/pci/built-in.o(.text+0x139594): Section mismatch in reference from the function .lola_parse_tree() to the function .devinit.text:.lola_init_pins():  => N/A
  + warning: sound/pci/built-in.o(.text+0x1395d0): Section mismatch in reference from the function .lola_parse_tree() to the function .devinit.text:.lola_init_pins():  => N/A
  + warning: sound/pci/built-in.o(.text+0x139620): Section mismatch in reference from the function .lola_parse_tree() to the function .devinit.text:.lola_init_clock_widget():  => N/A
  + warning: sound/pci/built-in.o(.text+0x139680): Section mismatch in reference from the function .lola_parse_tree() to the function .devinit.text:.lola_init_mixer_widget():  => N/A
  + warning: sound/pci/lola/built-in.o(.text+0x2ebc): Section mismatch in reference from the function .lola_parse_tree() to the function .devinit.text:.lola_init_pcm():  => N/A
  + warning: sound/pci/lola/built-in.o(.text+0x2ef8): Section mismatch in reference from the function .lola_parse_tree() to the function .devinit.text:.lola_init_pcm():  => N/A
  + warning: sound/pci/lola/built-in.o(.text+0x2f34): Section mismatch in reference from the function .lola_parse_tree() to the function .devinit.text:.lola_init_pins():  => N/A
  + warning: sound/pci/lola/built-in.o(.text+0x2f70): Section mismatch in reference from the function .lola_parse_tree() to the function .devinit.text:.lola_init_pins():  => N/A
  + warning: sound/pci/lola/built-in.o(.text+0x2fc0): Section mismatch in reference from the function .lola_parse_tree() to the function .devinit.text:.lola_init_clock_widget():  => N/A
  + warning: sound/pci/lola/built-in.o(.text+0x3020): Section mismatch in reference from the function .lola_parse_tree() to the function .devinit.text:.lola_init_mixer_widget():  => N/A
  + warning: sound/pci/lola/snd-lola.o(.text+0x2ebc): Section mismatch in reference from the function .lola_parse_tree() to the function .devinit.text:.lola_init_pcm():  => N/A
  + warning: sound/pci/lola/snd-lola.o(.text+0x2ef8): Section mismatch in reference from the function .lola_parse_tree() to the function .devinit.text:.lola_init_pcm():  => N/A
  + warning: sound/pci/lola/snd-lola.o(.text+0x2f34): Section mismatch in reference from the function .lola_parse_tree() to the function .devinit.text:.lola_init_pins():  => N/A
  + warning: sound/pci/lola/snd-lola.o(.text+0x2f70): Section mismatch in reference from the function .lola_parse_tree() to the function .devinit.text:.lola_init_pins():  => N/A
  + warning: sound/pci/lola/snd-lola.o(.text+0x2fc0): Section mismatch in reference from the function .lola_parse_tree() to the function .devinit.text:.lola_init_clock_widget():  => N/A
  + warning: sound/pci/lola/snd-lola.o(.text+0x3020): Section mismatch in reference from the function .lola_parse_tree() to the function .devinit.text:.lola_init_mixer_widget():  => N/A
  + warning: sound/pci/lola/snd-lola.o(.text+0xae4): Section mismatch in reference from the function lola_parse_tree() to the function .devinit.text:lola_init_pcm():  => N/A
  + warning: sound/pci/lola/snd-lola.o(.text+0xafc): Section mismatch in reference from the function lola_parse_tree() to the function .devinit.text:lola_init_pcm():  => N/A
  + warning: sound/pci/lola/snd-lola.o(.text+0xb14): Section mismatch in reference from the function lola_parse_tree() to the function .devinit.text:lola_init_pins():  => N/A
  + warning: sound/pci/lola/snd-lola.o(.text+0xb2c): Section mismatch in reference from the function lola_parse_tree() to the function .devinit.text:lola_init_pins():  => N/A
  + warning: sound/pci/lola/snd-lola.o(.text+0xb5c): Section mismatch in reference from the function lola_parse_tree() to the function .devinit.text:lola_init_clock_widget():  => N/A
  + warning: sound/pci/lola/snd-lola.o(.text+0xb94): Section mismatch in reference from the function lola_parse_tree() to the function .devinit.text:lola_init_mixer_widget():  => N/A
  + warning: sound/pci/lola/snd-lola.o(.text+0xda4): Section mismatch in reference from the function lola_parse_tree() to the function .devinit.text:lola_init_pcm():  => N/A
  + warning: sound/pci/lola/snd-lola.o(.text+0xdcb): Section mismatch in reference from the function lola_parse_tree() to the function .devinit.text:lola_init_pcm():  => N/A
  + warning: sound/pci/lola/snd-lola.o(.text+0xdf5): Section mismatch in reference from the function lola_parse_tree() to the function .devinit.text:lola_init_pins():  => N/A
  + warning: sound/pci/lola/snd-lola.o(.text+0xe1d): Section mismatch in reference from the function lola_parse_tree() to the function .devinit.text:lola_init_pins():  => N/A
  + warning: sound/pci/lola/snd-lola.o(.text+0xe52): Section mismatch in reference from the function lola_parse_tree() to the function .devinit.text:lola_init_clock_widget():  => N/A
  + warning: sound/pci/lola/snd-lola.o(.text+0xe8a): Section mismatch in reference from the function lola_parse_tree() to the function .devinit.text:lola_init_mixer_widget():  => N/A
  + warning: vmlinux.o(.devinit.text+0x9269): Section mismatch in reference from the function cnb20le_res() to the function .init.text:acpi_os_get_root_pointer():  => N/A
  + warning: vmlinux.o(.text+0x35424): Section mismatch in reference from the function .early_setup_secondary() to the function .cpuinit.text:.early_init_mmu_secondary():  => N/A
  + warning: vmlinux.o(.text+0x5d5bc): Section mismatch in reference from the function .wake_offline_cpus() to the function .cpuinit.text:.cpu_up():  => N/A
  + warning: vmlinux.o(.text+0x671a8): Section mismatch in reference from the function .register_power_pmu() to the function .cpuinit.text:.power_pmu_notifier():  => N/A
  + warning: vmlinux.o(.text+0x671c4): Section mismatch in reference from the function .register_power_pmu() to the function .cpuinit.text:.power_pmu_notifier():  => N/A
  + warning: vmlinux.o(.text+0x671e0): Section mismatch in reference from the function .register_power_pmu() to the function .cpuinit.text:.power_pmu_notifier():  => N/A
  + warning: vmlinux.o(.text+0x79b54): Section mismatch in reference from the function .mark_reserved_regions_for_nid() to the function .init.text:.get_node_active_region():  => N/A
  + warning: vmlinux.o(.text+0x79c04): Section mismatch in reference from the function .mark_reserved_regions_for_nid() to the function .init.text:.reserve_bootmem_node():  => N/A
  + warning: vmlinux.o(.text+0x79c38): Section mismatch in reference from the function .mark_reserved_regions_for_nid() to the function .init.text:.get_node_active_region():  => N/A
  + warning: vmlinux.o(.text+0x9082): Section mismatch in reference from the variable generic_secondary_common_init to the variable .init.data:boot_cpu_count:  => N/A
  + warning: vmlinux.o(.text+0x90be8): Section mismatch in reference from the function .icp_native_init() to the function .init.text:.icp_native_init_one_node():  => N/A
  + warning: vmlinux.o(.text+0x90c98): Section mismatch in reference from the function .icp_native_init() to the function .init.text:.icp_native_init_one_node():  => N/A
  + warning: vmlinux.o(.text+0x91698): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics():  => N/A
  + warning: vmlinux.o(.text+0xab818): Section mismatch in reference from the function .pci_dn_reconfig_notifier() to the function .devinit.text:.update_dn_pci_info():  => N/A
  + warning: vmlinux.o(.text+0xb16bc): Section mismatch in reference from the function .dlpar_online_cpu() to the function .cpuinit.text:.cpu_up():  => N/A
  + warning: vmlinux.o(.text+0xba0c0): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.of_rescan_bus():  => N/A
  + warning: vmlinux.o(.text+0xba150): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.pcibios_setup_bus_devices():  => N/A
  + warning: vmlinux.o(.text+0xba1a8): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.pci_scan_bridge():  => N/A
  + warning: vmlinux.o(.text+0xbfa6e): Section mismatch in reference from the variable system_reset_iSeries to the variable .init.data:boot_paca:  => N/A

407 improvements:
  - .config: warning: override: HIGHMEM4G changes choice state: 337 => 
  - /tmp/cckVNE3Z.s: Warning: source register same as write-back base: 104 => 
  - <stdin>: warning: #warning syscall sync_file_range not implemented: 1430:2 => 
  - <stdin>: warning: #warning syscall umount2 not implemented: 394:2 => 
  - arch/mips/configs/malta_defconfig: warning: symbol value 'm' invalid for LEDS_CLASS: 377 => 
  - arch/powerpc/configs/pmac32_defconfig: warning: symbol value 'm' invalid for BT_L2CAP: 115 => 
  - arch/powerpc/configs/pmac32_defconfig: warning: symbol value 'm' invalid for BT_SCO: 116 => 
  - arch/powerpc/configs/ppc6xx_defconfig: warning: symbol value 'm' invalid for BT_L2CAP: 354 => 
  - arch/powerpc/configs/ppc6xx_defconfig: warning: symbol value 'm' invalid for BT_SCO: 355 => 
  - arch/powerpc/configs/ps3_defconfig: warning: symbol value 'm' invalid for BT_L2CAP: 55 => 
  - arch/powerpc/configs/ps3_defconfig: warning: symbol value 'm' invalid for BT_SCO: 56 => 
  - modpost: WARNING: modpost: Found 12 section mismatch(es).: N/A => 
  - modpost: WARNING: modpost: Found 13 section mismatch(es).: N/A => 
  - modpost: WARNING: modpost: Found 14 section mismatch(es).: N/A => 
  - modpost: WARNING: modpost: Found 15 section mismatch(es).: N/A => 
  - modpost: WARNING: modpost: Found 4 section mismatch(es).: N/A => 
  - src/arch/cris/arch-v10/drivers/sync_serial.c: warning: initialization from incompatible pointer type: 252 => 
  - src/arch/cris/arch-v10/drivers/sync_serial.c: warning: passing argument 1 of 'memcpy' discards qualifiers from pointer target type: 1353, 1343 => 
  - src/arch/cris/arch-v10/drivers/sync_serial.c: warning: passing argument 1 of 'virt_to_phys' discards qualifiers from pointer target type: 1224 => 
  - src/arch/cris/arch-v10/kernel/kgdb.c: warning: missing terminating " character: 1359:1, 1273:6, 1457:1, 1370:6 => 
  - src/arch/cris/arch-v10/kernel/kgdb.c: warning: type defaults to 'int' in declaration of 'write_stack_register': 267 => 
  - src/arch/parisc/kernel/cache.c: warning: format '%s' expects type 'char *', but argument 4 has type 'void * const': 310 => 
  - src/arch/parisc/kernel/cache.c: warning: pointer type mismatch in conditional expression: 310 => 
  - src/arch/powerpc/sysdev/mv64x60_dev.c: warning: assignment makes pointer from integer without a cast: 253 => 
  - src/arch/s390/mm/extmem.c: warning: 'end_addr' may be used uninitialized in this function: 411, 573 => 
  - src/arch/s390/mm/extmem.c: warning: 'start_addr' may be used uninitialized in this function: 411, 573 => 
  - src/arch/x86/include/asm/uaccess_32.h: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct: 212 => 
  - src/arch/xtensa/include/asm/regs.h: warning: this is the location of the previous definition: 59:1 => 
  - src/arch/xtensa/kernel/entry.S: Warning: value 0xffffffff30000000 truncated to 0x30000000: 1545 => 
  - src/arch/xtensa/kernel/irq.c: warning: passing argument 1 of 'xtensa_irq_mask' makes pointer from integer without a cast: 92 => 
  - src/arch/xtensa/kernel/irq.c: warning: passing argument 1 of 'xtensa_irq_unmask' makes pointer from integer without a cast: 87 => 
  - src/arch/xtensa/kernel/process.c: warning: unused variable 'ti': 180 => 
  - src/arch/xtensa/kernel/time.c: warning: initialization from incompatible pointer type: 42 => 
  - src/arch/xtensa/mm/tlb.c: warning: comparison of distinct pointer types lacks a cast: 71, 68 => 
  - src/block/elevator.c: warning: 'elevator_get' uses dynamic stack allocation: 175 => 
  - src/drivers/base/memory.c: warning: 'ret' may be used uninitialized in this function: 404 => 
  - src/drivers/base/power/sysfs.c: warning: 'dev_attr_wakeup' defined but not used: 249 => 
  - src/drivers/block/xd.c: warning: 'address' may be used uninitialized in this function: 159 => 
  - src/drivers/block/xd.c: warning: 'controller' may be used uninitialized in this function: 158 => 
  - src/drivers/char/tpm/tpm.c: warning: format '%zd' expects type 'signed size_t', but argument 3 has type 'ssize_t': 433, 400 => 
  - src/drivers/dma/pch_dma.c: warning: 'i' may be used uninitialized in this function: 406 => 
  - src/drivers/gpio/bt8xxgpio.c: warning: ignoring return value of 'gpiochip_remove', declared with attribute warn_unused_result: 247 => 
  - src/drivers/gpio/ml_ioh_gpio.c: warning: 'ioh_gpio_restore_reg_conf' defined but not used: 153 => 
  - src/drivers/gpio/ml_ioh_gpio.c: warning: 'ioh_gpio_save_reg_conf' defined but not used: 144 => 
  - src/drivers/infiniband/hw/nes/nes.c: warning: ignoring return value of 'kstrtoul', declared with attribute warn_unused_result: 1141 => 
  - src/drivers/infiniband/ulp/srp/ib_srp.c: warning: cast to pointer from integer of different size: 1150, 1234 => 
  - src/drivers/input/keyboard/matrix_keypad.c: warning: 'matrix_keypad_resume' defined but not used: 284 => 
  - src/drivers/input/keyboard/matrix_keypad.c: warning: 'matrix_keypad_suspend' defined but not used: 271 => 
  - src/drivers/input/misc/adxl34x-i2c.c: warning: 'adxl34x_i2c_resume' defined but not used: 119 => 
  - src/drivers/input/misc/adxl34x-i2c.c: warning: 'adxl34x_i2c_suspend' defined but not used: 109 => 
  - src/drivers/input/touchscreen/htcpen.c: warning: 'pnp_ids' defined but not used: 50 => 
  - src/drivers/input/touchscreen/mcs5000_ts.c: warning: 'mcs5000_ts_resume' defined but not used: 274 => 
  - src/drivers/input/touchscreen/mcs5000_ts.c: warning: 'mcs5000_ts_suspend' defined but not used: 264 => 
  - src/drivers/message/fusion/mptsas.c: warning: unused variable 'log_info': 5015 => 
  - src/drivers/mfd/wl1273-core.c: warning: unused variable 'val': 156 => 
  - src/drivers/misc/hpilo.c: warning: 'ilo_remove' defined but not used: 722 => 
  - src/drivers/mtd/chips/cfi_cmdset_0001.c: warning: the frame size of 1044 bytes is larger than 1024 bytes: 861 => 
  - src/drivers/mtd/maps/latch-addr-flash.c: warning: 'latch_addr_flash_remove' defined but not used: 102 => 
  - src/drivers/net/atl1c/atl1c_main.c: warning: 'atl1c_resume' defined but not used: 2539, 2540 => 
  - src/drivers/net/atlx/atl1.c: warning: 'atl1_resume' defined but not used: 2823 => 
  - src/drivers/net/jme.c: warning: 'jme_resume' defined but not used: 3216 => 
  - src/drivers/net/jme.c: warning: 'jme_suspend' defined but not used: 3177 => 
  - src/drivers/net/macvtap.c: warning: control reaches end of non-void function: 102 => 
  - src/drivers/net/rionet.c: warning: cast from pointer to integer of different size: 166 => 
  - src/drivers/net/skge.c: warning: 'skge_resume' defined but not used: 4067 => 
  - src/drivers/net/skge.c: warning: 'skge_suspend' defined but not used: 4042 => 
  - src/drivers/net/stmmac/stmmac_main.c: warning: ignoring return value of 'kstrtoul', declared with attribute warn_unused_result: 1984, 1980, 1987, 1975, 1968, 1978, 1970, 1972, 1982 => 
  - src/drivers/net/wireless/ath/ath5k/reset.c: warning: 'txf2txs' may be used uninitialized in this function: 100 => 
  - src/drivers/net/wireless/b43/phy_n.c: warning: 'last' may be used uninitialized in this function: 3093 => 
  - src/drivers/net/wireless/b43/phy_n.c: warning: 'save_regs_phy$7' may be used uninitialized in this function: 2270 => 
  - src/drivers/net/wireless/b43/phy_n.c: warning: 'save_regs_phy$8' may be used uninitialized in this function: 2270 => 
  - src/drivers/net/wireless/b43/phy_n.c: warning: 'save_regs_phy[7]' may be used uninitialized in this function: 2270 => 
  - src/drivers/net/wireless/b43/phy_n.c: warning: 'save_regs_phy[8]' may be used uninitialized in this function: 2270 => 
  - src/drivers/net/wireless/b43/phy_n.c: warning: 'tabent_r2' may be used uninitialized in this function: 3848 => 
  - src/drivers/net/wireless/b43/phy_n.c: warning: 'tabent_r3' may be used uninitialized in this function: 3849 => 
  - src/drivers/net/wireless/mwl8k.c: warning: 'ap_legacy_rates' may be used uninitialized in this function: 3990 => 
  - src/drivers/net/wireless/p54/eeprom.c: warning: 'freq' may be used uninitialized in this function: 494 => 
  - src/drivers/net/wireless/rt2x00/rt2800lib.c: warning: 'comp_value' may be used uninitialized in this function: 1822 => 
  - src/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c: warning: 'cck_index' may be used uninitialized in this function: 637 => 
  - src/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c: warning: 'cck_index_old' may be used uninitialized in this function: 637 => 
  - src/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c: warning: 'box_extreg' may be used uninitialized in this function: 303 => 
  - src/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c: warning: 'box_reg' may be used uninitialized in this function: 303 => 
  - src/drivers/net/wireless/rtlwifi/rtl8192ce/rf.c: warning: 'chnlgroup' may be used uninitialized in this function: 205 => 
  - src/drivers/net/wireless/rtlwifi/rtl8192ce/rf.c: warning: 'u4_regvalue' may be used uninitialized in this function: 450 => 
  - src/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c: warning: 'hq_sele' may be used uninitialized in this function: 924 => 
  - src/drivers/pci/pcie/aer/aer_inject.c: warning: 'cor_mask_orig' may be used uninitialized in this function: 329 => 
  - src/drivers/pci/pcie/aer/aer_inject.c: warning: 'uncor_mask_orig' may be used uninitialized in this function: 329 => 
  - src/drivers/platform/x86/ibm_rtl.c: warning: cast from pointer to integer of different size: 278, 290 => 
  - src/drivers/platform/x86/sony-laptop.c: warning: unused variable 'handle': 976, 964 => 
  - src/drivers/power/bq27x00_battery.c: warning: 'bq27x00_powersupply_init' defined but not used: 520 => 
  - src/drivers/power/bq27x00_battery.c: warning: 'bq27x00_powersupply_unregister' defined but not used: 546 => 
  - src/drivers/regulator/wm831x-dcdc.c: warning: unused variable 'wm831x': 779, 603 => 
  - src/drivers/rtc/rtc-ds1374.c: warning: 'ds1374_resume' defined but not used: 422 => 
  - src/drivers/rtc/rtc-ds1374.c: warning: 'ds1374_suspend' defined but not used: 413 => 
  - src/drivers/scsi/aic7xxx_old.c: warning: passing argument 3 of 'pci_free_consistent' discards qualifiers from pointer target type: 8484 => 
  - src/drivers/scsi/fcoe/fcoe.c: warning: label 'out_nodev' defined but not used: 1855, 1812 => 
  - src/drivers/scsi/stex.c: warning: passing argument 2 of 'scsi_sg_copy_from_buffer' discards qualifiers from pointer target type: 636 => 
  - src/drivers/staging/iio/magnetometer/ak8975.c: warning: 'ak8975_remove' defined but not used: 513 => 
  - src/drivers/tty/n_gsm.c: warning: zero-length gnu_printf format string: 535 => 
  - src/drivers/tty/n_gsm.c: warning: zero-length printf format string: 535 => 
  - src/drivers/tty/serial/mfd.c: warning: 'serial_hsu_remove' defined but not used: 1406 => 
  - src/drivers/tty/serial/pch_uart.c: warning: 'pch_uart_pci_remove' defined but not used: 1476 => 
  - src/drivers/tty/serial/pch_uart.c: warning: assignment makes pointer from integer without a cast: 1399, 869 => 
  - src/drivers/usb/core/devio.c: warning: cast from pointer to integer of different size: 1380 => 
  - src/drivers/usb/gadget/fusb300_udc.c: warning: 'fusb300_ep0_complete' defined but not used: 985, 983 => 983
  - src/drivers/usb/gadget/fusb300_udc.c: warning: 'fusb300_set_ep_bycnt' defined but not used: 1032, 1033 => 1032
  - src/drivers/usb/gadget/fusb300_udc.c: warning: 'fusb300_wrfifo' defined but not used: 773, 771 => 771
  - src/drivers/usb/host/xhci-pci.c: warning: assignment makes pointer from integer without a cast: 61 => 
  - src/drivers/usb/misc/usbtest.c: warning: cast from pointer to integer of different size: 273 => 
  - src/drivers/usb/otg/ab8500-usb.c: warning: 'event' may be used uninitialized in this function: 156 => 
  - src/drivers/usb/otg/twl6030-usb.c: warning: ISO C90 forbids mixed declarations and code: 183 => 
  - src/drivers/usb/storage/realtek_cr.c: warning: 'config_autodelink_before_power_down' defined but not used: 494, 493 => 493
  - src/drivers/video/efifb.c: warning: cast to pointer from integer of different size: 247 => 
  - src/drivers/video/mb862xx/mb862xxfb.c: warning: 'dev_attr_dispregs' defined but not used: 464 => 
  - src/drivers/video/mb862xx/mb862xxfb.c: warning: 'mb862xxfb_init_fbinfo' defined but not used: 326 => 
  - src/drivers/video/udlfb.c: warning: ignoring return value of 'device_create_bin_file', declared with attribute warn_unused_result: 1592 => 
  - src/drivers/video/udlfb.c: warning: ignoring return value of 'device_create_file', declared with attribute warn_unused_result: 1590 => 
  - src/drivers/video/udlfb.c: warning: passing argument 1 of 'prefetch_range' discards qualifiers from pointer target type: 421 => 
  - src/fs/cifs/file.c: warning: 'rc' may be used uninitialized in this function: 1776 => 
  - src/fs/ext4/balloc.c: warning: passing argument 2 of 'test_and_clear_bit' from incompatible pointer type: 443 => 
  - src/fs/ncpfs/dir.c: warning: unused variable 'sb': 128 => 
  - src/include/net/ipx.h: warning: 'packed' attribute ignored for field of type '__be16': 32, 30 => 
  - src/include/net/ipx.h: warning: 'packed' attribute ignored for field of type 'struct ipx_address': 42, 41 => 
  - src/include/trace/events/btrfs.h: warning: large integer implicitly truncated to unsigned type: 365, 197, 332, 273, 626, 68, 420, 47, 591, 144, 459, 541 => 
  - src/kernel/irq/debug.h: warning: "PS" redefined: 8:1 => 
  - src/lib/atomic64_test.c: warning: ISO C90 forbids mixed declarations and code: 25 => 
  - src/lib/debugobjects.c: warning: 'obj_states' defined but not used: 73 => 
  - src/lib/debugobjects.c: warning: unused variable 'hint': 256 => 
  - src/net/bridge/netfilter/ebtables.c: warning: 'off' may be used uninitialized in this function: 1885 => 
  - src/net/bridge/netfilter/ebtables.c: warning: 'size_kern' may be used uninitialized in this function: 1886 => 
  - src/net/irda/irnet/irnet_ppp.c: warning: format '%Zd' expects type 'signed size_t', but argument 3 has type 'ssize_t': 334 => 
  - src/security/selinux/hooks.c: warning: 'prefix' may be used uninitialized in this function: 964 => 
  - src/security/selinux/hooks.c: warning: 'sclass' may be used uninitialized in this function: 1426 => 
  - src/security/selinux/netnode.c: warning: 'idx' may be used uninitialized in this function: 173, 132 => 174
  - src/security/selinux/selinuxfs.c: warning: passing argument 2 of 'security_read_policy' from incompatible pointer type: 400 => 
  - src/sound/soc/codecs/alc5623.c: warning: 'alc5623_i2c_remove' defined but not used: 1067 => 
  - src/sound/soc/codecs/wl1273.c: warning: initialization discards qualifiers from pointer target type: 212, 250 => 
  - src/sound/soc/codecs/wm2000.c: warning: 'wm2000_i2c_resume' defined but not used: 847 => 
  - src/sound/soc/codecs/wm2000.c: warning: 'wm2000_i2c_suspend' defined but not used: 839 => 
  - src/sound/soc/fsl/mpc5200_dma.c: warning: 'struct of_device' declared inside parameter list: 371, 489 => 
  - src/sound/soc/fsl/mpc5200_dma.c: warning: (near initialization for 'mpc5200_hpcd_of_driver.shutdown'): 521, 524, 523 => 
  - src/sound/soc/fsl/mpc5200_dma.c: warning: braces around scalar initializer: 521 => 
  - src/sound/soc/fsl/mpc5200_dma.c: warning: excess elements in scalar initializer: 524, 523 => 
  - src/sound/soc/fsl/mpc5200_dma.c: warning: initialization from incompatible pointer type: 519, 522, 520 => 
  - src/sound/soc/fsl/mpc5200_dma.c: warning: its scope is only this definition or declaration, which is probably not what you want: 371 => 
  - warning: (CAVIUM_OCTEON_REFERENCE_BOARD && BCM63XX_CPU_6338) selects USB_ARCH_HAS_OHCI which has unmet direct dependencies (USB_SUPPORT): N/A => 
  - warning: (CAVIUM_OCTEON_REFERENCE_BOARD) selects USB_ARCH_HAS_EHCI which has unmet direct dependencies (USB_SUPPORT): N/A => 
  - warning: (GFS2_FS) selects DLM which has unmet direct dependencies (EXPERIMENTAL && INET && SYSFS && CONFIGFS_FS && (IPV6 || IPV6=n)): N/A => 
  - warning: (SCHED_AUTOGROUP) selects CGROUP_SCHED which has unmet direct dependencies (CGROUPS && EXPERIMENTAL): N/A => 
  - warning: 1 bad relocations: N/A => 
  - warning: arch/powerpc/kernel/built-in.o(.text+0x567ac): Section mismatch in reference from the function .register_power_pmu() to the function .cpuinit.text:.power_pmu_notifier(): N/A => 
  - warning: arch/powerpc/kernel/built-in.o(.text+0x567c8): Section mismatch in reference from the function .register_power_pmu() to the function .cpuinit.text:.power_pmu_notifier(): N/A => 
  - warning: arch/powerpc/kernel/built-in.o(.text+0x567e4): Section mismatch in reference from the function .register_power_pmu() to the function .cpuinit.text:.power_pmu_notifier(): N/A => 
  - warning: arch/powerpc/kernel/built-in.o(.text+0x5830c): Section mismatch in reference from the function .register_power_pmu() to the function .cpuinit.text:.power_pmu_notifier(): N/A => 
  - warning: arch/powerpc/kernel/built-in.o(.text+0x58328): Section mismatch in reference from the function .register_power_pmu() to the function .cpuinit.text:.power_pmu_notifier(): N/A => 
  - warning: arch/powerpc/kernel/built-in.o(.text+0x58344): Section mismatch in reference from the function .register_power_pmu() to the function .cpuinit.text:.power_pmu_notifier(): N/A => 
  - warning: arch/powerpc/mm/built-in.o(.text+0xb1d0): Section mismatch in reference from the function .mark_reserved_regions_for_nid() to the function .init.text:.get_node_active_region(): N/A => 
  - warning: arch/powerpc/mm/built-in.o(.text+0xb2b4): Section mismatch in reference from the function .mark_reserved_regions_for_nid() to the function .init.text:.get_node_active_region(): N/A => 
  - warning: drivers/built-in.o(.text+0x25dae54): Section mismatch in reference from the function .usb_add_config() to the function .devinit.text:.usb_ep_autoconfig_reset(): N/A => 
  - warning: drivers/built-in.o(.text+0x25e13f8): Section mismatch in reference from the function .rndis_bind() to the function .devinit.text:.usb_ep_autoconfig(): N/A => 
  - warning: drivers/built-in.o(.text+0x25e1444): Section mismatch in reference from the function .rndis_bind() to the function .devinit.text:.usb_ep_autoconfig(): N/A => 
  - warning: drivers/built-in.o(.text+0x25e1478): Section mismatch in reference from the function .rndis_bind() to the function .devinit.text:.usb_ep_autoconfig(): N/A => 
  - warning: drivers/built-in.o(.text+0x25e1bec): Section mismatch in reference from the function .ecm_bind() to the function .devinit.text:.usb_ep_autoconfig(): N/A => 
  - warning: drivers/built-in.o(.text+0x25e1c38): Section mismatch in reference from the function .ecm_bind() to the function .devinit.text:.usb_ep_autoconfig(): N/A => 
  - warning: drivers/built-in.o(.text+0x25e1c6c): Section mismatch in reference from the function .ecm_bind() to the function .devinit.text:.usb_ep_autoconfig(): N/A => 
  - warning: drivers/built-in.o(.text+0x25e3b08): Section mismatch in reference from the function .composite_bind() to the function .devinit.text:.usb_ep_autoconfig_reset(): N/A => 
  - warning: drivers/built-in.o(.text+0x261ff38): Section mismatch in reference from the function .tc3589x_keypad_open() to the function .devinit.text:.tc3589x_keypad_init_key_hardware(): N/A => 
  - warning: drivers/built-in.o(.text+0x3252268): Section mismatch in reference from the function .lp5521_probe() to the function .init.text:.lp5521_init_led(): N/A => 
  - warning: drivers/built-in.o(.text+0x3254ff8): Section mismatch in reference from the function .lp5523_probe() to the function .init.text:.lp5523_init_led(): N/A => 
  - warning: drivers/built-in.o(.text+0x63e09c): Section mismatch in reference from the function .radeon_get_clock_info() to the function .devinit.text:.radeon_read_clocks_OF(): N/A => 
  - warning: drivers/gpu/built-in.o(.text+0x1377b4): Section mismatch in reference from the function .radeon_get_clock_info() to the function .devinit.text:.radeon_read_clocks_OF(): N/A => 
  - warning: drivers/gpu/drm/built-in.o(.text+0x1377b4): Section mismatch in reference from the function .radeon_get_clock_info() to the function .devinit.text:.radeon_read_clocks_OF(): N/A => 
  - warning: drivers/gpu/drm/radeon/built-in.o(.text+0xd27b4): Section mismatch in reference from the function .radeon_get_clock_info() to the function .devinit.text:.radeon_read_clocks_OF(): N/A => 
  - warning: drivers/gpu/drm/radeon/radeon.o(.text+0x48270): Section mismatch in reference from the function radeon_get_clock_info() to the function .devinit.text:radeon_read_clocks_OF(): N/A => 
  - warning: drivers/gpu/drm/radeon/radeon.o(.text+0xd27b4): Section mismatch in reference from the function .radeon_get_clock_info() to the function .devinit.text:.radeon_read_clocks_OF(): N/A => 
  - warning: drivers/gpu/drm/radeon/radeon.o(.text+0xd27b8): Section mismatch in reference from the function .radeon_get_clock_info() to the function .devinit.text:.radeon_read_clocks_OF(): N/A => 
  - warning: drivers/input/built-in.o(.text+0x27028): Section mismatch in reference from the function .tc3589x_keypad_open() to the function .devinit.text:.tc3589x_keypad_init_key_hardware(): N/A => 
  - warning: drivers/input/keyboard/built-in.o(.text+0xf8c4): Section mismatch in reference from the function .tc3589x_keypad_open() to the function .devinit.text:.tc3589x_keypad_init_key_hardware(): N/A => 
  - warning: drivers/leds/built-in.o(.text+0xb2dc): Section mismatch in reference from the function .lp5521_probe() to the function .init.text:.lp5521_init_led(): N/A => 
  - warning: drivers/leds/built-in.o(.text+0xe06c): Section mismatch in reference from the function .lp5523_probe() to the function .init.text:.lp5523_init_led(): N/A => 
  - warning: drivers/leds/leds-lp5521.o(.text+0xa6a): Section mismatch in reference from the function lp5521_probe() to the function .init.text:lp5521_init_led(): N/A => 
  - warning: drivers/leds/leds-lp5521.o(.text+0xc50): Section mismatch in reference from the function lp5521_probe() to the function .init.text:lp5521_init_led(): N/A => 
  - warning: drivers/leds/leds-lp5523.o(.text+0x12f8): Section mismatch in reference from the function lp5523_probe() to the function .init.text:lp5523_init_led(): N/A => 
  - warning: drivers/leds/leds-lp5523.o(.text+0xfd2): Section mismatch in reference from the function lp5523_probe() to the function .init.text:lp5523_init_led(): N/A => 
  - warning: drivers/misc/cs5535-mfgpt.o(.data+0x0): Section mismatch in reference from the variable cs5535_mfgpt_drv to the function .devinit.text:cs5535_mfgpt_probe(): N/A => 
  - warning: drivers/mtd/devices/sst25l.o(.devinit.text+0xaa): Section mismatch in reference from the function sst25l_match_device() to the variable .init.data:sst25l_flash_info: N/A => 
  - warning: drivers/mtd/devices/sst25l.o(.devinit.text+0xac): Section mismatch in reference from the function sst25l_match_device() to the variable .init.data:sst25l_flash_info: N/A => 
  - warning: drivers/mtd/devices/sst25l.o(.devinit.text+0xb0): Section mismatch in reference from the function sst25l_match_device() to the variable .init.data:sst25l_flash_info: N/A => 
  - warning: drivers/mtd/devices/sst25l.o(.devinit.text+0xb8): Section mismatch in reference from the function sst25l_match_device() to the variable .init.data:sst25l_flash_info: N/A => 
  - warning: drivers/mtd/devices/sst25l.o(.devinit.text+0xbc): Section mismatch in reference from the function sst25l_match_device() to the (unknown reference) .init.data:(unknown): N/A => 
  - warning: drivers/mtd/devices/sst25l.o(.devinit.text+0xbc): Section mismatch in reference from the function sst25l_match_device() to the variable .init.data:sst25l_flash_info: N/A => 
  - warning: drivers/mtd/devices/sst25l.o(.devinit.text+0xc4): Section mismatch in reference from the function sst25l_match_device() to the variable .init.data:sst25l_flash_info: N/A => 
  - warning: drivers/mtd/devices/sst25l.o(.devinit.text+0xc6): Section mismatch in reference from the function sst25l_match_device() to the variable .init.data:sst25l_flash_info: N/A => 
  - warning: drivers/mtd/devices/sst25l.o(.devinit.text+0xe9): Section mismatch in reference from the function sst25l_match_device() to the (unknown reference) .init.data:(unknown): N/A => 
  - warning: drivers/net/depca.o(.devinit.text+0x18): Section mismatch in reference from the function depca_isa_probe() to the function .init.text:depca_common_init(): N/A => 
  - warning: drivers/net/depca.o(.devinit.text+0x40): Section mismatch in reference from the function depca_isa_probe() to the function .init.text:DepcaSignature(): N/A => 
  - warning: drivers/net/depca.o(.devinit.text+0xa0): Section mismatch in reference from the function depca_isa_probe() to the function .init.text:depca_hw_init(): N/A => 
  - warning: drivers/net/irda/smsc-ircc2.o(.devinit.text+0x1ac): Section mismatch in reference from the function smsc_ircc_pnp_probe() to the function .init.text:smsc_ircc_open(): N/A => 
  - warning: drivers/parisc/built-in.o(.data+0x154): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe(): N/A => 
  - warning: drivers/parisc/built-in.o(.data+0x1f0): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe(): N/A => 
  - warning: drivers/parisc/built-in.o(.data+0x334): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe(): N/A => 
  - warning: drivers/parisc/built-in.o(.data+0x428): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip(): N/A => 
  - warning: drivers/parisc/built-in.o(.data+0x484): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip(): N/A => 
  - warning: drivers/parisc/built-in.o(.data+0x4e0): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip(): N/A => 
  - warning: drivers/parisc/built-in.o(.data+0x54c): Section mismatch in reference from the variable eisa_driver to the function .init.text:eisa_probe(): N/A => 
  - warning: drivers/parisc/built-in.o(.data+0x694): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe(): N/A => 
  - warning: drivers/platform/x86/asus-wmi.o(.text+0x235e): Section mismatch in reference from the function asus_wmi_add() to the function .init.text:asus_wmi_platform_init(): N/A => 
  - warning: drivers/platform/x86/msi-laptop.o(.text+0xf11): Section mismatch in reference from the function load_scm_model_init() to the function .init.text:msi_laptop_input_setup(): N/A => 
  - warning: drivers/sbus/char/bbc.o(.devinit.text+0xc): Section mismatch in reference from the function bbc_i2c_probe() to the function .init.text:T.326(): N/A => 
  - warning: drivers/scsi/zalon7xx.o(.data+0xc): Section mismatch in reference from the variable zalon_driver to the function .init.text:zalon_probe(): N/A => 
  - warning: drivers/tty/serial/apbuart.o(.data+0x90): Section mismatch in reference from the variable grlib_apbuart_of_driver to the variable .init.data:apbuart_match: N/A => 
  - warning: drivers/tty/serial/apbuart.o(.text+0x7a0): Section mismatch in reference from the function grlib_apbuart_configure() to the variable .init.data:apbuart_match: N/A => 
  - warning: drivers/tty/serial/apbuart.o(.text+0x7a8): Section mismatch in reference from the function grlib_apbuart_configure() to the variable .init.data:apbuart_match: N/A => 
  - warning: drivers/tty/serial/apbuart.o(.text+0x7e8): Section mismatch in reference from the function grlib_apbuart_configure() to the variable .init.data:apbuart_match: N/A => 
  - warning: drivers/usb/gadget/built-in.o(.text+0x10a10): Section mismatch in reference from the function .composite_bind() to the function .devinit.text:.usb_ep_autoconfig_reset(): N/A => 
  - warning: drivers/usb/gadget/built-in.o(.text+0x7d5c): Section mismatch in reference from the function .usb_add_config() to the function .devinit.text:.usb_ep_autoconfig_reset(): N/A => 
  - warning: drivers/usb/gadget/built-in.o(.text+0xe300): Section mismatch in reference from the function .rndis_bind() to the function .devinit.text:.usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/built-in.o(.text+0xe34c): Section mismatch in reference from the function .rndis_bind() to the function .devinit.text:.usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/built-in.o(.text+0xe380): Section mismatch in reference from the function .rndis_bind() to the function .devinit.text:.usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/built-in.o(.text+0xeaf4): Section mismatch in reference from the function .ecm_bind() to the function .devinit.text:.usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/built-in.o(.text+0xeb40): Section mismatch in reference from the function .ecm_bind() to the function .devinit.text:.usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/built-in.o(.text+0xeb74): Section mismatch in reference from the function .ecm_bind() to the function .devinit.text:.usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_audio.o(.text+0x2b8c): Section mismatch in reference from the function .usb_add_config() to the function .devinit.text:.usb_ep_autoconfig_reset(): N/A => 
  - warning: drivers/usb/gadget/g_audio.o(.text+0x5c98): Section mismatch in reference from the function .composite_bind() to the function .devinit.text:.usb_ep_autoconfig_reset(): N/A => 
  - warning: drivers/usb/gadget/g_cdc.o(.text+0x311c): Section mismatch in reference from the function ecm_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_cdc.o(.text+0x3442): Section mismatch in reference from the function acm_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_cdc.o(.text+0x3b28): Section mismatch in reference from the function ecm_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_cdc.o(.text+0x3b48): Section mismatch in reference from the function ecm_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_cdc.o(.text+0x3b68): Section mismatch in reference from the function ecm_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_cdc.o(.text+0x3d10): Section mismatch in reference from the function .usb_add_config() to the function .devinit.text:.usb_ep_autoconfig_reset(): N/A => 
  - warning: drivers/usb/gadget/g_cdc.o(.text+0x3f84): Section mismatch in reference from the function acm_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_cdc.o(.text+0x3fa4): Section mismatch in reference from the function acm_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_cdc.o(.text+0x3fc4): Section mismatch in reference from the function acm_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_cdc.o(.text+0x4a17): Section mismatch in reference from the function ecm_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_cdc.o(.text+0x4a56): Section mismatch in reference from the function ecm_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_cdc.o(.text+0x4a87): Section mismatch in reference from the function ecm_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_cdc.o(.text+0x4f7f): Section mismatch in reference from the function acm_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_cdc.o(.text+0x4fbe): Section mismatch in reference from the function acm_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_cdc.o(.text+0x4fef): Section mismatch in reference from the function acm_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_cdc.o(.text+0x82b4): Section mismatch in reference from the function .ecm_bind() to the function .devinit.text:.usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_cdc.o(.text+0x8300): Section mismatch in reference from the function .ecm_bind() to the function .devinit.text:.usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_cdc.o(.text+0x8334): Section mismatch in reference from the function .ecm_bind() to the function .devinit.text:.usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_cdc.o(.text+0x89f4): Section mismatch in reference from the function .acm_bind() to the function .devinit.text:.usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_cdc.o(.text+0x8a3c): Section mismatch in reference from the function .acm_bind() to the function .devinit.text:.usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_cdc.o(.text+0x8a70): Section mismatch in reference from the function .acm_bind() to the function .devinit.text:.usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_cdc.o(.text+0xb2e8): Section mismatch in reference from the function .composite_bind() to the function .devinit.text:.usb_ep_autoconfig_reset(): N/A => 
  - warning: drivers/usb/gadget/g_ether.o(.text+0x3d6c): Section mismatch in reference from the function .usb_add_config() to the function .devinit.text:.usb_ep_autoconfig_reset(): N/A => 
  - warning: drivers/usb/gadget/g_ether.o(.text+0x3e28): Section mismatch in reference from the function rndis_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_ether.o(.text+0x41a6): Section mismatch in reference from the function ecm_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_ether.o(.text+0x515c): Section mismatch in reference from the function rndis_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_ether.o(.text+0x517c): Section mismatch in reference from the function rndis_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_ether.o(.text+0x519c): Section mismatch in reference from the function rndis_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_ether.o(.text+0x562c): Section mismatch in reference from the function ecm_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_ether.o(.text+0x564c): Section mismatch in reference from the function ecm_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_ether.o(.text+0x566c): Section mismatch in reference from the function ecm_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_ether.o(.text+0x58fc): Section mismatch in reference from the function rndis_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_ether.o(.text+0x593b): Section mismatch in reference from the function rndis_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_ether.o(.text+0x596c): Section mismatch in reference from the function rndis_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_ether.o(.text+0x5ebf): Section mismatch in reference from the function ecm_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_ether.o(.text+0x5efe): Section mismatch in reference from the function ecm_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_ether.o(.text+0x5f2f): Section mismatch in reference from the function ecm_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_ether.o(.text+0xa310): Section mismatch in reference from the function .rndis_bind() to the function .devinit.text:.usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_ether.o(.text+0xa35c): Section mismatch in reference from the function .rndis_bind() to the function .devinit.text:.usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_ether.o(.text+0xa390): Section mismatch in reference from the function .rndis_bind() to the function .devinit.text:.usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_ether.o(.text+0xab04): Section mismatch in reference from the function .ecm_bind() to the function .devinit.text:.usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_ether.o(.text+0xab50): Section mismatch in reference from the function .ecm_bind() to the function .devinit.text:.usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_ether.o(.text+0xab84): Section mismatch in reference from the function .ecm_bind() to the function .devinit.text:.usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_ether.o(.text+0xca1c): Section mismatch in reference from the function .composite_bind() to the function .devinit.text:.usb_ep_autoconfig_reset(): N/A => 
  - warning: drivers/usb/gadget/g_ether.o(.text+0xca20): Section mismatch in reference from the function .composite_bind() to the function .devinit.text:.usb_ep_autoconfig_reset(): N/A => 
  - warning: drivers/usb/gadget/g_ffs.o(.text+0x1263c): Section mismatch in reference from the function .composite_bind() to the function .devinit.text:.usb_ep_autoconfig_reset(): N/A => 
  - warning: drivers/usb/gadget/g_ffs.o(.text+0x53a0): Section mismatch in reference from the function __ffs_func_bind_do_descs() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_ffs.o(.text+0x546c): Section mismatch in reference from the function rndis_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_ffs.o(.text+0x57ea): Section mismatch in reference from the function ecm_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_ffs.o(.text+0x6ba0): Section mismatch in reference from the function __ffs_func_bind_do_descs() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_ffs.o(.text+0x6c9c): Section mismatch in reference from the function rndis_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_ffs.o(.text+0x6cbc): Section mismatch in reference from the function rndis_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_ffs.o(.text+0x6cdc): Section mismatch in reference from the function rndis_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_ffs.o(.text+0x716c): Section mismatch in reference from the function ecm_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_ffs.o(.text+0x718c): Section mismatch in reference from the function ecm_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_ffs.o(.text+0x71ac): Section mismatch in reference from the function ecm_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_ffs.o(.text+0x74d6): Section mismatch in reference from the function __ffs_func_bind_do_descs() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_ffs.o(.text+0x75f9): Section mismatch in reference from the function rndis_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_ffs.o(.text+0x7638): Section mismatch in reference from the function rndis_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_ffs.o(.text+0x7669): Section mismatch in reference from the function rndis_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_ffs.o(.text+0x7bba): Section mismatch in reference from the function ecm_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_ffs.o(.text+0x7bf9): Section mismatch in reference from the function ecm_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_ffs.o(.text+0x7c2a): Section mismatch in reference from the function ecm_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_ffs.o(.text+0x9978): Section mismatch in reference from the function .usb_add_config() to the function .devinit.text:.usb_ep_autoconfig_reset(): N/A => 
  - warning: drivers/usb/gadget/g_ffs.o(.text+0xe0ec): Section mismatch in reference from the function .__ffs_func_bind_do_descs() to the function .devinit.text:.usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_ffs.o(.text+0xe2cc): Section mismatch in reference from the function .rndis_bind() to the function .devinit.text:.usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_ffs.o(.text+0xe318): Section mismatch in reference from the function .rndis_bind() to the function .devinit.text:.usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_ffs.o(.text+0xe34c): Section mismatch in reference from the function .rndis_bind() to the function .devinit.text:.usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_ffs.o(.text+0xeac0): Section mismatch in reference from the function .ecm_bind() to the function .devinit.text:.usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_ffs.o(.text+0xeb0c): Section mismatch in reference from the function .ecm_bind() to the function .devinit.text:.usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_ffs.o(.text+0xeb40): Section mismatch in reference from the function .ecm_bind() to the function .devinit.text:.usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_hid.o(.text+0x3e64): Section mismatch in reference from the function .usb_add_config() to the function .devinit.text:.usb_ep_autoconfig_reset(): N/A => 
  - warning: drivers/usb/gadget/g_hid.o(.text+0x5aa4): Section mismatch in reference from the function .composite_bind() to the function .devinit.text:.usb_ep_autoconfig_reset(): N/A => 
  - warning: drivers/usb/gadget/g_mass_storage.o(.text+0x42de): Section mismatch in reference from the function fsg_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_mass_storage.o(.text+0x5874): Section mismatch in reference from the function fsg_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_mass_storage.o(.text+0x5898): Section mismatch in reference from the function fsg_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_mass_storage.o(.text+0x6855): Section mismatch in reference from the function fsg_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_mass_storage.o(.text+0x68a6): Section mismatch in reference from the function fsg_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_mass_storage.o(.text+0xab18): Section mismatch in reference from the function .fsg_bind() to the function .devinit.text:.usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_mass_storage.o(.text+0xab74): Section mismatch in reference from the function .fsg_bind() to the function .devinit.text:.usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_mass_storage.o(.text+0xb48c): Section mismatch in reference from the function .composite_bind() to the function .devinit.text:.usb_ep_autoconfig_reset(): N/A => 
  - warning: drivers/usb/gadget/g_mass_storage.o(.text+0xbc7c): Section mismatch in reference from the function .usb_add_config() to the function .devinit.text:.usb_ep_autoconfig_reset(): N/A => 
  - warning: drivers/usb/gadget/g_multi.o(.text+0x15bb8): Section mismatch in reference from the function .fsg_bind() to the function .devinit.text:.usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_multi.o(.text+0x15c14): Section mismatch in reference from the function .fsg_bind() to the function .devinit.text:.usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_multi.o(.text+0x15e28): Section mismatch in reference from the function .rndis_bind() to the function .devinit.text:.usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_multi.o(.text+0x15e74): Section mismatch in reference from the function .rndis_bind() to the function .devinit.text:.usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_multi.o(.text+0x15ea8): Section mismatch in reference from the function .rndis_bind() to the function .devinit.text:.usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_multi.o(.text+0x1661c): Section mismatch in reference from the function .ecm_bind() to the function .devinit.text:.usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_multi.o(.text+0x16668): Section mismatch in reference from the function .ecm_bind() to the function .devinit.text:.usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_multi.o(.text+0x1669c): Section mismatch in reference from the function .ecm_bind() to the function .devinit.text:.usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_multi.o(.text+0x16d5c): Section mismatch in reference from the function .acm_bind() to the function .devinit.text:.usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_multi.o(.text+0x16da4): Section mismatch in reference from the function .acm_bind() to the function .devinit.text:.usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_multi.o(.text+0x16dd8): Section mismatch in reference from the function .acm_bind() to the function .devinit.text:.usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_multi.o(.text+0x87b8): Section mismatch in reference from the function fsg_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_multi.o(.text+0x88d2): Section mismatch in reference from the function rndis_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_multi.o(.text+0x8c52): Section mismatch in reference from the function ecm_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_multi.o(.text+0x8f78): Section mismatch in reference from the function acm_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_multi.o(.text+0xae5c): Section mismatch in reference from the function fsg_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_multi.o(.text+0xae80): Section mismatch in reference from the function fsg_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_multi.o(.text+0xafac): Section mismatch in reference from the function rndis_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_multi.o(.text+0xafcc): Section mismatch in reference from the function rndis_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_multi.o(.text+0xafec): Section mismatch in reference from the function rndis_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_multi.o(.text+0xb47c): Section mismatch in reference from the function ecm_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_multi.o(.text+0xb49c): Section mismatch in reference from the function ecm_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_multi.o(.text+0xb4bc): Section mismatch in reference from the function ecm_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_multi.o(.text+0xb8d8): Section mismatch in reference from the function acm_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_multi.o(.text+0xb8f8): Section mismatch in reference from the function acm_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_multi.o(.text+0xb918): Section mismatch in reference from the function acm_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_multi.o(.text+0xc896): Section mismatch in reference from the function fsg_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_multi.o(.text+0xc8e7): Section mismatch in reference from the function fsg_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_multi.o(.text+0xca5f): Section mismatch in reference from the function rndis_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_multi.o(.text+0xca9e): Section mismatch in reference from the function rndis_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_multi.o(.text+0xcacf): Section mismatch in reference from the function rndis_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_multi.o(.text+0xd020): Section mismatch in reference from the function ecm_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_multi.o(.text+0xd05f): Section mismatch in reference from the function ecm_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_multi.o(.text+0xd090): Section mismatch in reference from the function ecm_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_multi.o(.text+0xd586): Section mismatch in reference from the function acm_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_multi.o(.text+0xd5c5): Section mismatch in reference from the function acm_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_multi.o(.text+0xd5f6): Section mismatch in reference from the function acm_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_multi.o(.text+0xe1c0): Section mismatch in reference from the function .composite_bind() to the function .devinit.text:.usb_ep_autoconfig_reset(): N/A => 
  - warning: drivers/usb/gadget/g_multi.o(.text+0xf37c): Section mismatch in reference from the function .usb_add_config() to the function .devinit.text:.usb_ep_autoconfig_reset(): N/A => 
  - warning: drivers/usb/gadget/g_ncm.o(.text+0x30ec): Section mismatch in reference from the function .usb_add_config() to the function .devinit.text:.usb_ep_autoconfig_reset(): N/A => 
  - warning: drivers/usb/gadget/g_ncm.o(.text+0x82a8): Section mismatch in reference from the function .composite_bind() to the function .devinit.text:.usb_ep_autoconfig_reset(): N/A => 
  - warning: drivers/usb/gadget/g_nokia.o(.text+0x38b2): Section mismatch in reference from the function ecm_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_nokia.o(.text+0x3bd8): Section mismatch in reference from the function acm_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_nokia.o(.text+0x4020): Section mismatch in reference from the function .usb_add_config() to the function .devinit.text:.usb_ep_autoconfig_reset(): N/A => 
  - warning: drivers/usb/gadget/g_nokia.o(.text+0x439c): Section mismatch in reference from the function ecm_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_nokia.o(.text+0x43bc): Section mismatch in reference from the function ecm_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_nokia.o(.text+0x43dc): Section mismatch in reference from the function ecm_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_nokia.o(.text+0x47f8): Section mismatch in reference from the function acm_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_nokia.o(.text+0x4818): Section mismatch in reference from the function acm_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_nokia.o(.text+0x4838): Section mismatch in reference from the function acm_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_nokia.o(.text+0x546b): Section mismatch in reference from the function ecm_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_nokia.o(.text+0x54aa): Section mismatch in reference from the function ecm_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_nokia.o(.text+0x54db): Section mismatch in reference from the function ecm_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_nokia.o(.text+0x59d1): Section mismatch in reference from the function acm_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_nokia.o(.text+0x5a10): Section mismatch in reference from the function acm_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_nokia.o(.text+0x5a41): Section mismatch in reference from the function acm_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_nokia.o(.text+0x97a0): Section mismatch in reference from the function .ecm_bind() to the function .devinit.text:.usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_nokia.o(.text+0x97ec): Section mismatch in reference from the function .ecm_bind() to the function .devinit.text:.usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_nokia.o(.text+0x9820): Section mismatch in reference from the function .ecm_bind() to the function .devinit.text:.usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_nokia.o(.text+0x9ee0): Section mismatch in reference from the function .acm_bind() to the function .devinit.text:.usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_nokia.o(.text+0x9f28): Section mismatch in reference from the function .acm_bind() to the function .devinit.text:.usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_nokia.o(.text+0x9f5c): Section mismatch in reference from the function .acm_bind() to the function .devinit.text:.usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_nokia.o(.text+0xc7d4): Section mismatch in reference from the function .composite_bind() to the function .devinit.text:.usb_ep_autoconfig_reset(): N/A => 
  - warning: drivers/usb/gadget/g_serial.o(.text+0x2436): Section mismatch in reference from the function acm_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_serial.o(.text+0x24e0): Section mismatch in reference from the function acm_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_serial.o(.text+0x251f): Section mismatch in reference from the function acm_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_serial.o(.text+0x2550): Section mismatch in reference from the function acm_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_serial.o(.text+0x2970): Section mismatch in reference from the function acm_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_serial.o(.text+0x2990): Section mismatch in reference from the function acm_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_serial.o(.text+0x29b0): Section mismatch in reference from the function acm_bind() to the function .devinit.text:usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_serial.o(.text+0x4d10): Section mismatch in reference from the function .usb_add_config() to the function .devinit.text:.usb_ep_autoconfig_reset(): N/A => 
  - warning: drivers/usb/gadget/g_serial.o(.text+0x6278): Section mismatch in reference from the function .acm_bind() to the function .devinit.text:.usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_serial.o(.text+0x62c0): Section mismatch in reference from the function .acm_bind() to the function .devinit.text:.usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_serial.o(.text+0x62f4): Section mismatch in reference from the function .acm_bind() to the function .devinit.text:.usb_ep_autoconfig(): N/A => 
  - warning: drivers/usb/gadget/g_serial.o(.text+0x8b6c): Section mismatch in reference from the function .composite_bind() to the function .devinit.text:.usb_ep_autoconfig_reset(): N/A => 
  - warning: drivers/usb/gadget/g_webcam.o(.text+0x68f4): Section mismatch in reference from the function .usb_add_config() to the function .devinit.text:.usb_ep_autoconfig_reset(): N/A => 
  - warning: drivers/usb/gadget/g_webcam.o(.text+0x83e4): Section mismatch in reference from the function .composite_bind() to the function .devinit.text:.usb_ep_autoconfig_reset(): N/A => 
  - warning: drivers/usb/gadget/g_zero.o(.text+0x5c08): Section mismatch in reference from the function .composite_bind() to the function .devinit.text:.usb_ep_autoconfig_reset(): N/A => 
  - warning: drivers/usb/gadget/g_zero.o(.text+0x62a8): Section mismatch in reference from the function .usb_add_config() to the function .devinit.text:.usb_ep_autoconfig_reset(): N/A => 
  - warning: drivers/video/sm501fb.o(.text+0x1714): Section mismatch in reference from the function sm501fb_init_fb() to the variable .devinit.data:sm501_default_mode: N/A => 
  - warning: drivers/video/sm501fb.o(.text+0x1720): Section mismatch in reference from the function sm501fb_init_fb() to the variable .devinit.data:sm501_default_mode: N/A => 
  - warning: drivers/video/sm501fb.o(.text+0x180c): Section mismatch in reference from the function sm501fb_init_fb() to the variable .devinit.data:sm501_default_mode: N/A => 
  - warning: drivers/video/sm501fb.o(.text+0x21bc): Section mismatch in reference from the function sm501fb_init_fb() to the variable .devinit.data:sm501_default_mode: N/A => 
  - warning: vmlinux.o (.xt.lit): unexpected non-allocatable section.: N/A => 
  - warning: vmlinux.o (.xt.prop): unexpected non-allocatable section.: N/A => 
  - warning: vmlinux.o(.devinit.text+0x9358): Section mismatch in reference from the function cnb20le_res() to the function .init.text:acpi_os_get_root_pointer(): N/A => 
  - warning: vmlinux.o(.text+0x33d94): Section mismatch in reference from the function .early_setup_secondary() to the function .cpuinit.text:.early_init_mmu_secondary(): N/A => 
  - warning: vmlinux.o(.text+0x5b8e8): Section mismatch in reference from the function .wake_offline_cpus() to the function .cpuinit.text:.cpu_up(): N/A => 
  - warning: vmlinux.o(.text+0x61c4c): Section mismatch in reference from the function .register_power_pmu() to the function .cpuinit.text:.power_pmu_notifier(): N/A => 
  - warning: vmlinux.o(.text+0x61c68): Section mismatch in reference from the function .register_power_pmu() to the function .cpuinit.text:.power_pmu_notifier(): N/A => 
  - warning: vmlinux.o(.text+0x61c84): Section mismatch in reference from the function .register_power_pmu() to the function .cpuinit.text:.power_pmu_notifier(): N/A => 
  - warning: vmlinux.o(.text+0x742c0): Section mismatch in reference from the function .mark_reserved_regions_for_nid() to the function .init.text:.get_node_active_region(): N/A => 
  - warning: vmlinux.o(.text+0x74370): Section mismatch in reference from the function .mark_reserved_regions_for_nid() to the function .init.text:.reserve_bootmem_node(): N/A => 
  - warning: vmlinux.o(.text+0x743a4): Section mismatch in reference from the function .mark_reserved_regions_for_nid() to the function .init.text:.get_node_active_region(): N/A => 
  - warning: vmlinux.o(.text+0x7d42): Section mismatch in reference from the function atari_stram_alloc() to the function .init.text:__alloc_bootmem_low(): N/A => 
  - warning: vmlinux.o(.text+0xa2af8): Section mismatch in reference from the function .pci_dn_reconfig_notifier() to the function .devinit.text:.update_dn_pci_info(): N/A => 
  - warning: vmlinux.o(.text+0xa88b8): Section mismatch in reference from the function .dlpar_online_cpu() to the function .cpuinit.text:.cpu_up(): N/A => 
  - warning: vmlinux.o(.text+0xb3340): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.of_rescan_bus(): N/A => 
  - warning: vmlinux.o(.text+0xb33d0): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.pcibios_setup_bus_devices(): N/A => 
  - warning: vmlinux.o(.text+0xb3428): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.pci_scan_bridge(): N/A => 
  - warning: vmlinux.o(.text+0xb8aee): Section mismatch in reference from the variable system_reset_iSeries to the variable .init.data:boot_paca: N/A => 

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
