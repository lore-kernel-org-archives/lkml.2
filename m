Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548Ab1KQSi3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 13:38:29 -0500
Received: from brigitte.telenet-ops.be ([195.130.137.66]:50765 "EHLO
	brigitte.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754270Ab1KQSi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 13:38:26 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Subject: Build regressions/improvements in v3.2-rc2
Date: Thu, 17 Nov 2011 19:38:20 +0100
Message-Id: <1321555100-1053-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is the list of build error/warning regressions/improvements in
v3.2-rc2[1] compared to v3.1[2].

Summarized:
  - build errors: +128/-129
  - build warnings: +269/-173

JFYI, when comparing v3.2-rc2 to v3.2-rc1[3], the summaries are:
  - build errors: +6/-12
  - build warnings: +71/-235

As master.kernel.org is down, there's no verbose summary yet at
http://www.kernel.org/pub/linux/kernel/people/geert/linux-log/v3.2-rc2.summary.gz

Happy fixing! ;-)

Thanks to the linux-next team for providing the build service.

[1] http://kisskb.ellerman.id.au/kisskb/head/4423/ (all 108 configs)
[2] http://kisskb.ellerman.id.au/kisskb/head/4378/ (all 108 configs)
[3] http://kisskb.ellerman.id.au/kisskb/head/4402/ (all 108 configs)


*** ERRORS ***

128 regressions:
  + error: vsprintf.c: relocation truncated to fit: R_AVR32_11H_PCREL against `.text'+57c:  => (.text+0x982)
  + src/arch/powerpc/kernel/jump_label.c: error: 'struct jump_entry' declared inside parameter list:  => 15
  + src/arch/powerpc/kernel/jump_label.c: error: its scope is only this definition or declaration, which is probably not what you want:  => 15
  + src/arch/sh/boards/board-magicpanelr2.c: error: implicit declaration of function 'parse_mtd_partitions':  => 354
  + src/arch/sh/boards/mach-rsk/setup.c: error: implicit declaration of function 'parse_mtd_partitions':  => 82
  + src/arch/um/os-Linux/skas/process.c: error: 'PTRACE_O_TRACESYSGOOD' undeclared (first use in this function):  => 321, 552
  + src/arch/um/os-Linux/skas/process.c: error: (Each undeclared identifier is reported only once:  => 321
  + src/arch/um/os-Linux/skas/process.c: error: for each function it appears in.):  => 321
  + src/arch/um/os-Linux/start_up.c: error: 'PTRACE_O_TRACESYSGOOD' undeclared (first use in this function):  => 302, 244
  + src/arch/um/os-Linux/start_up.c: error: 'PTRACE_SETOPTIONS' undeclared (first use in this function):  => 243, 301
  + src/arch/um/os-Linux/start_up.c: error: (Each undeclared identifier is reported only once:  => 243
  + src/arch/um/os-Linux/start_up.c: error: for each function it appears in.):  => 243
  + src/drivers/ata/libata-sff.c: error: 'ata_bmdma_interrupt' undeclared (first use in this function):  => 2549
  + src/drivers/ata/libata-sff.c: error: (Each undeclared identifier is reported only once:  => 2549
  + src/drivers/ata/libata-sff.c: error: for each function it appears in.):  => 2549
  + src/drivers/ata/libata-sff.c: error: implicit declaration of function 'ata_pci_bmdma_prepare_host':  => 2538
  + src/drivers/ata/pata_of_platform.c: error: implicit declaration of function 'of_irq_to_resource':  => 54
  + src/drivers/misc/altera-stapl/altera-lpt.c: error: implicit declaration of function 'inb':  => 40
  + src/drivers/misc/altera-stapl/altera-lpt.c: error: implicit declaration of function 'outb':  => 34
  + src/drivers/net/arcnet/com20020.c: error: implicit declaration of function 'inb':  => 122
  + src/drivers/net/arcnet/com20020.c: error: implicit declaration of function 'insb':  => 70
  + src/drivers/net/arcnet/com20020.c: error: implicit declaration of function 'outb':  => 66
  + src/drivers/net/arcnet/com20020.c: error: implicit declaration of function 'outsb':  => 84
  + src/drivers/net/arcnet/com20020_cs.c: error: implicit declaration of function 'outb':  => 313
  + src/drivers/net/arcnet/com90io.c: error: implicit declaration of function 'inb':  => 98
  + src/drivers/net/arcnet/com90io.c: error: implicit declaration of function 'outb':  => 95
  + src/drivers/net/arcnet/com90xx.c: error: implicit declaration of function 'inb':  => 178
  + src/drivers/net/arcnet/com90xx.c: error: implicit declaration of function 'outb':  => 331
  + src/drivers/net/ethernet/3com/3c574_cs.c: error: implicit declaration of function 'inb':  => 374
  + src/drivers/net/ethernet/3com/3c574_cs.c: error: implicit declaration of function 'inl':  => 378
  + src/drivers/net/ethernet/3com/3c574_cs.c: error: implicit declaration of function 'insl':  => 1021
  + src/drivers/net/ethernet/3com/3c574_cs.c: error: implicit declaration of function 'inw':  => 480
  + src/drivers/net/ethernet/3com/3c574_cs.c: error: implicit declaration of function 'outb':  => 610
  + src/drivers/net/ethernet/3com/3c574_cs.c: error: implicit declaration of function 'outl':  => 617
  + src/drivers/net/ethernet/3com/3c574_cs.c: error: implicit declaration of function 'outsl':  => 754
  + src/drivers/net/ethernet/3com/3c574_cs.c: error: implicit declaration of function 'outw':  => 357
  + src/drivers/net/ethernet/3com/3c589_cs.c: error: implicit declaration of function 'inb':  => 419
  + src/drivers/net/ethernet/3com/3c589_cs.c: error: implicit declaration of function 'inl':  => 301
  + src/drivers/net/ethernet/3com/3c589_cs.c: error: implicit declaration of function 'insl':  => 827
  + src/drivers/net/ethernet/3com/3c589_cs.c: error: implicit declaration of function 'inw':  => 366
  + src/drivers/net/ethernet/3com/3c589_cs.c: error: implicit declaration of function 'outb':  => 440
  + src/drivers/net/ethernet/3com/3c589_cs.c: error: implicit declaration of function 'outsl':  => 570
  + src/drivers/net/ethernet/3com/3c589_cs.c: error: implicit declaration of function 'outw':  => 278
  + src/drivers/net/ethernet/8390/axnet_cs.c: error: implicit declaration of function 'inb':  => 318
  + src/drivers/net/ethernet/8390/axnet_cs.c: error: implicit declaration of function 'inb_p':  => 442
  + src/drivers/net/ethernet/8390/axnet_cs.c: error: implicit declaration of function 'insw':  => 641
  + src/drivers/net/ethernet/8390/axnet_cs.c: error: implicit declaration of function 'inw':  => 225
  + src/drivers/net/ethernet/8390/axnet_cs.c: error: implicit declaration of function 'outb':  => 324
  + src/drivers/net/ethernet/8390/axnet_cs.c: error: implicit declaration of function 'outb_p':  => 222
  + src/drivers/net/ethernet/8390/axnet_cs.c: error: implicit declaration of function 'outsw':  => 687
  + src/drivers/net/ethernet/8390/lib8390.c: error: implicit declaration of function 'inb':  => 265
  + src/drivers/net/ethernet/8390/lib8390.c: error: implicit declaration of function 'outb':  => 324
  + src/drivers/net/ethernet/8390/pcnet_cs.c: error: implicit declaration of function 'inb':  => 355
  + src/drivers/net/ethernet/8390/pcnet_cs.c: error: implicit declaration of function 'inb_p':  => 383
  + src/drivers/net/ethernet/8390/pcnet_cs.c: error: implicit declaration of function 'insw':  => 1146
  + src/drivers/net/ethernet/8390/pcnet_cs.c: error: implicit declaration of function 'inw':  => 414
  + src/drivers/net/ethernet/8390/pcnet_cs.c: error: implicit declaration of function 'outb':  => 700
  + src/drivers/net/ethernet/8390/pcnet_cs.c: error: implicit declaration of function 'outb_p':  => 352
  + src/drivers/net/ethernet/8390/pcnet_cs.c: error: implicit declaration of function 'outsw':  => 1253
  + src/drivers/net/ethernet/amd/nmclan_cs.c: error: implicit declaration of function 'inb':  => 497
  + src/drivers/net/ethernet/amd/nmclan_cs.c: error: implicit declaration of function 'insw':  => 1112
  + src/drivers/net/ethernet/amd/nmclan_cs.c: error: implicit declaration of function 'inw':  => 1076
  + src/drivers/net/ethernet/amd/nmclan_cs.c: error: implicit declaration of function 'outb':  => 501
  + src/drivers/net/ethernet/amd/nmclan_cs.c: error: implicit declaration of function 'outsw':  => 893
  + src/drivers/net/ethernet/amd/nmclan_cs.c: error: implicit declaration of function 'outw':  => 891
  + src/drivers/net/ethernet/dlink/de600.c: error: implicit declaration of function 'inb':  => 90
  + src/drivers/net/ethernet/dlink/de600.c: error: implicit declaration of function 'outb_p':  => 89
  + src/drivers/net/ethernet/dlink/de620.c: error: implicit declaration of function 'inb':  => 249
  + src/drivers/net/ethernet/dlink/de620.c: error: implicit declaration of function 'outb':  => 263
  + src/drivers/net/ethernet/dlink/de620.c: error: invalid operands to binary ^ (have 'void *' and 'int'):  => 372, 267, 396
  + src/drivers/net/ethernet/ethoc.c: error: implicit declaration of function 'ioread32':  => 234
  + src/drivers/net/ethernet/ethoc.c: error: implicit declaration of function 'iowrite32':  => 239
  + src/drivers/net/ethernet/fujitsu/fmvj18x_cs.c: error: implicit declaration of function 'inb':  => 496
  + src/drivers/net/ethernet/fujitsu/fmvj18x_cs.c: error: implicit declaration of function 'insw':  => 1015
  + src/drivers/net/ethernet/fujitsu/fmvj18x_cs.c: error: implicit declaration of function 'inw':  => 793
  + src/drivers/net/ethernet/fujitsu/fmvj18x_cs.c: error: implicit declaration of function 'outb':  => 447
  + src/drivers/net/ethernet/fujitsu/fmvj18x_cs.c: error: implicit declaration of function 'outsw':  => 852
  + src/drivers/net/ethernet/fujitsu/fmvj18x_cs.c: error: implicit declaration of function 'outw':  => 735
  + src/drivers/net/ethernet/micrel/ks8851_mll.c: error: implicit declaration of function 'ioread16':  => 492
  + src/drivers/net/ethernet/micrel/ks8851_mll.c: error: implicit declaration of function 'ioread8':  => 761
  + src/drivers/net/ethernet/micrel/ks8851_mll.c: error: implicit declaration of function 'iowrite16':  => 491
  + src/drivers/net/ethernet/seeq/seeq8005.c: error: implicit declaration of function 'inb':  => 667
  + src/drivers/net/ethernet/seeq/seeq8005.c: error: implicit declaration of function 'insw':  => 560
  + src/drivers/net/ethernet/seeq/seeq8005.c: error: implicit declaration of function 'inw':  => 179
  + src/drivers/net/ethernet/seeq/seeq8005.c: error: implicit declaration of function 'outb':  => 647
  + src/drivers/net/ethernet/seeq/seeq8005.c: error: implicit declaration of function 'outsw':  => 709
  + src/drivers/net/ethernet/seeq/seeq8005.c: error: implicit declaration of function 'outw':  => 195
  + src/drivers/net/ethernet/seeq/seeq8005.c: error: invalid operands to binary >> (have 'void *' and 'int'):  => 545
  + src/drivers/net/ethernet/seeq/seeq8005.c: error: invalid operands to binary | (have 'void *' and 'int'):  => 221, 673, 662, 503, 323, 706, 469, 723, 701, 439, 672, 544, 641, 462, 674
  + src/drivers/net/ethernet/smsc/smc91c92_cs.c: error: implicit declaration of function 'inb':  => 780
  + src/drivers/net/ethernet/smsc/smc91c92_cs.c: error: implicit declaration of function 'insw':  => 1514
  + src/drivers/net/ethernet/smsc/smc91c92_cs.c: error: implicit declaration of function 'inw':  => 556
  + src/drivers/net/ethernet/smsc/smc91c92_cs.c: error: implicit declaration of function 'outb':  => 659
  + src/drivers/net/ethernet/smsc/smc91c92_cs.c: error: implicit declaration of function 'outsw':  => 1164
  + src/drivers/net/ethernet/smsc/smc91c92_cs.c: error: implicit declaration of function 'outw':  => 549
  + src/drivers/net/ethernet/xircom/xirc2ps_cs.c: error: implicit declaration of function 'inb':  => 407
  + src/drivers/net/ethernet/xircom/xirc2ps_cs.c: error: implicit declaration of function 'insw':  => 1068
  + src/drivers/net/ethernet/xircom/xirc2ps_cs.c: error: implicit declaration of function 'inw':  => 1037
  + src/drivers/net/ethernet/xircom/xirc2ps_cs.c: error: implicit declaration of function 'outb':  => 358
  + src/drivers/net/ethernet/xircom/xirc2ps_cs.c: error: implicit declaration of function 'outsw':  => 1259
  + src/drivers/net/ethernet/xircom/xirc2ps_cs.c: error: implicit declaration of function 'outw':  => 1123
  + src/drivers/net/tokenring/ibmtr.c: error: implicit declaration of function 'inb':  => 399
  + src/drivers/net/tokenring/ibmtr.c: error: implicit declaration of function 'outb':  => 292
  + src/drivers/pci/ats.c: error: implicit declaration of function 'kfree':  => 45
  + src/drivers/pci/ats.c: error: implicit declaration of function 'kzalloc':  => 29
  + src/drivers/staging/et131x/et131x.c: error: 'et131x_pci_setup' undeclared here (not in a function):  => 5489
  + src/drivers/staging/media/lirc/lirc_serial.c: error: implicit declaration of function 'inb':  => 296
  + src/drivers/staging/media/lirc/lirc_serial.c: error: implicit declaration of function 'outb':  => 306
  + src/drivers/staging/media/lirc/lirc_sir.c: error: implicit declaration of function 'inb':  => 219
  + src/drivers/staging/media/lirc/lirc_sir.c: error: implicit declaration of function 'outb':  => 224
  + src/drivers/usb/gadget/r8a66597-udc.h: error: implicit declaration of function 'iowrite32':  => 273
  + src/drivers/usb/host/isp1760-if.c: error: implicit declaration of function 'irq_create_of_mapping':  => 73
  + src/drivers/usb/host/isp1760-if.c: error: implicit declaration of function 'of_irq_map_one':  => 68
  + src/drivers/usb/host/isp1760-if.c: error: storage size of 'oirq' isn't known:  => 46
  + src/drivers/usb/renesas_usbhs/common.c: error: implicit declaration of function 'ioread16':  => 72
  + src/drivers/usb/renesas_usbhs/common.c: error: implicit declaration of function 'iowrite16':  => 77
  + src/drivers/usb/renesas_usbhs/fifo.c: error: implicit declaration of function 'ioread32':  => 662
  + src/drivers/usb/renesas_usbhs/fifo.c: error: implicit declaration of function 'ioread32_rep':  => 654
  + src/drivers/usb/renesas_usbhs/fifo.c: error: implicit declaration of function 'iowrite32_rep':  => 511
  + src/drivers/usb/renesas_usbhs/fifo.c: error: implicit declaration of function 'iowrite8':  => 518
  + src/drivers/virtio/virtio_mmio.c: error: implicit declaration of function 'readb':  => 135
  + src/drivers/virtio/virtio_mmio.c: error: implicit declaration of function 'readl':  => 109
  + src/drivers/virtio/virtio_mmio.c: error: implicit declaration of function 'writeb':  => 146
  + src/drivers/virtio/virtio_mmio.c: error: implicit declaration of function 'writel':  => 107
  + src/include/asm-generic/gpio.h: error: implicit declaration of function '__gpio_get_value':  => 212
  + src/include/asm-generic/gpio.h: error: implicit declaration of function '__gpio_set_value':  => 218
  + src/kernel/trace/trace_clock.c: error: implicit declaration of function 'atomic64_add_return':  => 126
  + src/kernel/trace/trace_clock.c: error: syntax error before 'trace_counter':  => 117

129 improvements:
  - build/linus_sparc-allmodconfig_sparc64/usr/include/linux/hidraw.h: error: expected specifier-qualifier-list before '__u32': 27, 22 => 
  - build/linus_sparc-allmodconfig_sparc64/usr/include/linux/input.h: error: expected specifier-qualifier-list before '__s16': 958, 969 => 
  - build/linus_sparc-allmodconfig_sparc64/usr/include/linux/input.h: error: expected specifier-qualifier-list before '__s32': 65 => 
  - build/linus_sparc-allmodconfig_sparc64/usr/include/linux/input.h: error: expected specifier-qualifier-list before '__u16': 1035, 39, 919, 1063, 985, 929, 23, 1014, 946 => 
  - build/linus_sparc-allmodconfig_sparc64/usr/include/linux/input.h: error: expected specifier-qualifier-list before '__u8': 90 => 
  - build/linus_sparc-allmodconfig_sparc64/usr/include/linux/types.h: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__be16': 28 => 
  - build/linus_sparc-allmodconfig_sparc64/usr/include/linux/types.h: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__be32': 30 => 
  - build/linus_sparc-allmodconfig_sparc64/usr/include/linux/types.h: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__be64': 32 => 
  - build/linus_sparc-allmodconfig_sparc64/usr/include/linux/types.h: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__le16': 27 => 
  - build/linus_sparc-allmodconfig_sparc64/usr/include/linux/types.h: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__le32': 29 => 
  - build/linus_sparc-allmodconfig_sparc64/usr/include/linux/types.h: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__le64': 31 => 
  - build/linus_sparc-allmodconfig_sparc64/usr/include/linux/types.h: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__sum16': 34 => 
  - build/linus_sparc-allmodconfig_sparc64/usr/include/linux/types.h: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__wsum': 35 => 
  - build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/hidraw.h: error: expected specifier-qualifier-list before '__u32': 27, 22 => 
  - build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/input.h: error: expected specifier-qualifier-list before '__s16': 958, 969 => 
  - build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/input.h: error: expected specifier-qualifier-list before '__s32': 65 => 
  - build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/input.h: error: expected specifier-qualifier-list before '__u16': 1035, 39, 919, 1063, 985, 929, 23, 1014, 946 => 
  - build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/input.h: error: expected specifier-qualifier-list before '__u8': 90 => 
  - build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/types.h: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__be16': 28 => 
  - build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/types.h: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__be32': 30 => 
  - build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/types.h: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__be64': 32 => 
  - build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/types.h: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__le16': 27 => 
  - build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/types.h: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__le32': 29 => 
  - build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/types.h: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__le64': 31 => 
  - build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/types.h: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__sum16': 34 => 
  - build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/types.h: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__wsum': 35 => 
  - error: vsprintf.c: relocation truncated to fit: R_AVR32_11H_PCREL against `.text'+500: (.text+0x906) => 
  - src/arch/mips/include/asm/io.h: error: 'asm' operand has impossible constraints: 430 => 
  - src/arch/powerpc/kernel/exceptions-64s.S: Error: attempt to move .org backwards: 1160, 1151 => 
  - src/drivers/i2c/busses/i2c-elektor.c: error: implicit declaration of function 'ioport_map': 153 => 
  - src/drivers/i2c/busses/i2c-elektor.c: error: implicit declaration of function 'ioport_unmap': 287 => 
  - src/drivers/net/de600.c: error: implicit declaration of function 'inb': 90 => 
  - src/drivers/net/de600.c: error: implicit declaration of function 'outb_p': 89 => 
  - src/drivers/net/de620.c: error: implicit declaration of function 'inb': 249 => 
  - src/drivers/net/de620.c: error: implicit declaration of function 'outb': 263 => 
  - src/drivers/net/de620.c: error: invalid operands to binary ^ (have 'void *' and 'int'): 372, 267, 396 => 
  - src/drivers/net/ethoc.c: error: implicit declaration of function 'ioread32': 233 => 
  - src/drivers/net/ethoc.c: error: implicit declaration of function 'iowrite32': 238 => 
  - src/drivers/net/ks8851_mll.c: error: implicit declaration of function 'ioread16': 492 => 
  - src/drivers/net/ks8851_mll.c: error: implicit declaration of function 'ioread8': 761 => 
  - src/drivers/net/ks8851_mll.c: error: implicit declaration of function 'iowrite16': 491 => 
  - src/drivers/net/lib8390.c: error: implicit declaration of function 'inb': 265 => 
  - src/drivers/net/lib8390.c: error: implicit declaration of function 'outb': 324 => 
  - src/drivers/net/pcmcia/3c574_cs.c: error: implicit declaration of function 'inb': 374 => 
  - src/drivers/net/pcmcia/3c574_cs.c: error: implicit declaration of function 'inl': 378 => 
  - src/drivers/net/pcmcia/3c574_cs.c: error: implicit declaration of function 'insl': 1021 => 
  - src/drivers/net/pcmcia/3c574_cs.c: error: implicit declaration of function 'inw': 480 => 
  - src/drivers/net/pcmcia/3c574_cs.c: error: implicit declaration of function 'outb': 610 => 
  - src/drivers/net/pcmcia/3c574_cs.c: error: implicit declaration of function 'outl': 617 => 
  - src/drivers/net/pcmcia/3c574_cs.c: error: implicit declaration of function 'outsl': 754 => 
  - src/drivers/net/pcmcia/3c574_cs.c: error: implicit declaration of function 'outw': 357 => 
  - src/drivers/net/pcmcia/3c589_cs.c: error: implicit declaration of function 'inb': 419 => 
  - src/drivers/net/pcmcia/3c589_cs.c: error: implicit declaration of function 'inl': 301 => 
  - src/drivers/net/pcmcia/3c589_cs.c: error: implicit declaration of function 'insl': 827 => 
  - src/drivers/net/pcmcia/3c589_cs.c: error: implicit declaration of function 'inw': 366 => 
  - src/drivers/net/pcmcia/3c589_cs.c: error: implicit declaration of function 'outb': 440 => 
  - src/drivers/net/pcmcia/3c589_cs.c: error: implicit declaration of function 'outsl': 570 => 
  - src/drivers/net/pcmcia/3c589_cs.c: error: implicit declaration of function 'outw': 278 => 
  - src/drivers/net/pcmcia/axnet_cs.c: error: implicit declaration of function 'inb': 318 => 
  - src/drivers/net/pcmcia/axnet_cs.c: error: implicit declaration of function 'inb_p': 442 => 
  - src/drivers/net/pcmcia/axnet_cs.c: error: implicit declaration of function 'insw': 641 => 
  - src/drivers/net/pcmcia/axnet_cs.c: error: implicit declaration of function 'inw': 225 => 
  - src/drivers/net/pcmcia/axnet_cs.c: error: implicit declaration of function 'outb': 324 => 
  - src/drivers/net/pcmcia/axnet_cs.c: error: implicit declaration of function 'outb_p': 222 => 
  - src/drivers/net/pcmcia/axnet_cs.c: error: implicit declaration of function 'outsw': 687 => 
  - src/drivers/net/pcmcia/fmvj18x_cs.c: error: implicit declaration of function 'inb': 496 => 
  - src/drivers/net/pcmcia/fmvj18x_cs.c: error: implicit declaration of function 'insw': 1015 => 
  - src/drivers/net/pcmcia/fmvj18x_cs.c: error: implicit declaration of function 'inw': 793 => 
  - src/drivers/net/pcmcia/fmvj18x_cs.c: error: implicit declaration of function 'outb': 447 => 
  - src/drivers/net/pcmcia/fmvj18x_cs.c: error: implicit declaration of function 'outsw': 852 => 
  - src/drivers/net/pcmcia/fmvj18x_cs.c: error: implicit declaration of function 'outw': 735 => 
  - src/drivers/net/pcmcia/nmclan_cs.c: error: implicit declaration of function 'inb': 497 => 
  - src/drivers/net/pcmcia/nmclan_cs.c: error: implicit declaration of function 'insw': 1112 => 
  - src/drivers/net/pcmcia/nmclan_cs.c: error: implicit declaration of function 'inw': 1076 => 
  - src/drivers/net/pcmcia/nmclan_cs.c: error: implicit declaration of function 'outb': 501 => 
  - src/drivers/net/pcmcia/nmclan_cs.c: error: implicit declaration of function 'outsw': 893 => 
  - src/drivers/net/pcmcia/nmclan_cs.c: error: implicit declaration of function 'outw': 891 => 
  - src/drivers/net/pcmcia/pcnet_cs.c: error: implicit declaration of function 'inb': 355 => 
  - src/drivers/net/pcmcia/pcnet_cs.c: error: implicit declaration of function 'inb_p': 383 => 
  - src/drivers/net/pcmcia/pcnet_cs.c: error: implicit declaration of function 'insw': 1146 => 
  - src/drivers/net/pcmcia/pcnet_cs.c: error: implicit declaration of function 'inw': 414 => 
  - src/drivers/net/pcmcia/pcnet_cs.c: error: implicit declaration of function 'outb': 700 => 
  - src/drivers/net/pcmcia/pcnet_cs.c: error: implicit declaration of function 'outb_p': 352 => 
  - src/drivers/net/pcmcia/pcnet_cs.c: error: implicit declaration of function 'outsw': 1253 => 
  - src/drivers/net/pcmcia/smc91c92_cs.c: error: implicit declaration of function 'inb': 780 => 
  - src/drivers/net/pcmcia/smc91c92_cs.c: error: implicit declaration of function 'insw': 1514 => 
  - src/drivers/net/pcmcia/smc91c92_cs.c: error: implicit declaration of function 'inw': 556 => 
  - src/drivers/net/pcmcia/smc91c92_cs.c: error: implicit declaration of function 'outb': 659 => 
  - src/drivers/net/pcmcia/smc91c92_cs.c: error: implicit declaration of function 'outsw': 1164 => 
  - src/drivers/net/pcmcia/smc91c92_cs.c: error: implicit declaration of function 'outw': 549 => 
  - src/drivers/net/pcmcia/xirc2ps_cs.c: error: implicit declaration of function 'inb': 407 => 
  - src/drivers/net/pcmcia/xirc2ps_cs.c: error: implicit declaration of function 'insw': 1068 => 
  - src/drivers/net/pcmcia/xirc2ps_cs.c: error: implicit declaration of function 'inw': 1037 => 
  - src/drivers/net/pcmcia/xirc2ps_cs.c: error: implicit declaration of function 'outb': 358 => 
  - src/drivers/net/pcmcia/xirc2ps_cs.c: error: implicit declaration of function 'outsw': 1259 => 
  - src/drivers/net/pcmcia/xirc2ps_cs.c: error: implicit declaration of function 'outw': 1123 => 
  - src/drivers/net/wireless/rtlwifi/rtl8192c/../pci.h: error: implicit declaration of function 'inb': 288 => 
  - src/drivers/net/wireless/rtlwifi/rtl8192c/../pci.h: error: implicit declaration of function 'inl': 298 => 
  - src/drivers/net/wireless/rtlwifi/rtl8192c/../pci.h: error: implicit declaration of function 'inw': 293 => 
  - src/drivers/net/wireless/rtlwifi/rtl8192c/../pci.h: error: implicit declaration of function 'outb': 283 => 
  - src/drivers/net/wireless/rtlwifi/rtl8192c/../pci.h: error: implicit declaration of function 'outl': 278 => 
  - src/drivers/net/wireless/rtlwifi/rtl8192cu/../pci.h: error: implicit declaration of function 'inb': 288 => 
  - src/drivers/net/wireless/rtlwifi/rtl8192cu/../pci.h: error: implicit declaration of function 'inl': 298 => 
  - src/drivers/net/wireless/rtlwifi/rtl8192cu/../pci.h: error: implicit declaration of function 'inw': 293 => 
  - src/drivers/net/wireless/rtlwifi/rtl8192cu/../pci.h: error: implicit declaration of function 'outb': 283 => 
  - src/drivers/net/wireless/rtlwifi/rtl8192cu/../pci.h: error: implicit declaration of function 'outl': 278 => 
  - src/drivers/net/wireless/rtlwifi/rtl8192de/../pci.h: error: implicit declaration of function 'inb': 288 => 
  - src/drivers/net/wireless/rtlwifi/rtl8192de/../pci.h: error: implicit declaration of function 'inl': 298 => 
  - src/drivers/net/wireless/rtlwifi/rtl8192de/../pci.h: error: implicit declaration of function 'inw': 293 => 
  - src/drivers/net/wireless/rtlwifi/rtl8192de/../pci.h: error: implicit declaration of function 'outb': 283 => 
  - src/drivers/net/wireless/rtlwifi/rtl8192de/../pci.h: error: implicit declaration of function 'outl': 278 => 
  - src/drivers/net/wireless/rtlwifi/rtl8192se/../pci.h: error: implicit declaration of function 'inb': 288 => 
  - src/drivers/net/wireless/rtlwifi/rtl8192se/../pci.h: error: implicit declaration of function 'inl': 298 => 
  - src/drivers/net/wireless/rtlwifi/rtl8192se/../pci.h: error: implicit declaration of function 'inw': 293 => 
  - src/drivers/net/wireless/rtlwifi/rtl8192se/../pci.h: error: implicit declaration of function 'outb': 283 => 
  - src/drivers/net/wireless/rtlwifi/rtl8192se/../pci.h: error: implicit declaration of function 'outl': 278 => 
  - src/drivers/staging/altera-stapl/altera-lpt.c: error: implicit declaration of function 'inb': 40 => 
  - src/drivers/staging/altera-stapl/altera-lpt.c: error: implicit declaration of function 'outb': 34 => 
  - src/drivers/staging/lirc/lirc_serial.c: error: implicit declaration of function 'inb': 296 => 
  - src/drivers/staging/lirc/lirc_serial.c: error: implicit declaration of function 'outb': 306 => 
  - src/drivers/staging/lirc/lirc_sir.c: error: implicit declaration of function 'inb': 219 => 
  - src/drivers/staging/lirc/lirc_sir.c: error: implicit declaration of function 'outb': 224 => 
  - src/include/asm-generic/gpio.h: error: implicit declaration of function 'gpio_get_value': 223 => 
  - src/include/asm-generic/gpio.h: error: implicit declaration of function 'gpio_set_value': 229 => 
  - src/samples/hidraw/hid-example.c: error: 'struct hidraw_devinfo' has no member named 'bustype': 104 => 
  - src/samples/hidraw/hid-example.c: error: 'struct hidraw_devinfo' has no member named 'product': 106 => 
  - src/samples/hidraw/hid-example.c: error: 'struct hidraw_devinfo' has no member named 'vendor': 105 => 
  - src/samples/hidraw/hid-example.c: error: 'struct hidraw_report_descriptor' has no member named 'size': 72, 78 => 
  - src/samples/hidraw/hid-example.c: error: 'struct hidraw_report_descriptor' has no member named 'value': 79 => 


*** WARNINGS ***

269 regressions:
  + .config: warning: override: PCI_GOANY changes choice state:  => 400
  + /tmp/ccnvOulU.s: Warning: source register same as write-back base:  => 104
  + <stdin>: warning: #warning syscall process_vm_readv not implemented:  => 1562:2
  + <stdin>: warning: #warning syscall process_vm_writev not implemented:  => 1566:2
  + arch/mips/configs/ip22_defconfig: warning: symbol value 'm' invalid for PHYLIB:  => 240
  + arch/powerpc/configs/ppc6xx_defconfig: warning: symbol value 'm' invalid for MCU_MPC8349EMITX:  => 74
  + arch/sh/configs/titan_defconfig: warning: symbol value 'm' invalid for PHYLIB:  => 176
  + modpost: WARNING: modpost: Found 21 section mismatch(es).:  => N/A
  + modpost: WARNING: modpost: Found 22 section mismatch(es).:  => N/A
  + modpost: WARNING: modpost: Found 3 section mismatch(es).:  => N/A
  + src/arch/ia64/sn/kernel/io_common.c: warning: data definition has no type or storage class:  => 564, 562, 563, 565, 48
  + src/arch/ia64/sn/kernel/io_common.c: warning: parameter names (without types) in function declaration:  => 564, 562, 563, 565, 48
  + src/arch/ia64/sn/kernel/io_common.c: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL':  => 564, 562, 563, 565
  + src/arch/ia64/sn/kernel/io_common.c: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL':  => 48
  + src/arch/ia64/sn/kernel/sn2/sn_hwperf.c: warning: data definition has no type or storage class:  => 1002
  + src/arch/ia64/sn/kernel/sn2/sn_hwperf.c: warning: parameter names (without types) in function declaration:  => 1002
  + src/arch/ia64/sn/kernel/sn2/sn_hwperf.c: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL':  => 1002
  + src/arch/s390/kernel/setup.c: warning: 'msg' may be used uninitialized in this function:  => 710
  + src/arch/x86/kernel/apic/io_apic.c: warning: 'eu' is used uninitialized in this function:  => 387
  + src/arch/x86/kernel/quirks.c: warning: 'd' may be used uninitialized in this function:  => 364
  + src/arch/x86/kernel/quirks.c: warning: 'val' may be used uninitialized in this function:  => 407
  + src/drivers/ata/pata_pdc2027x.c: warning: 'pdc2027x_reinit_one' declared 'static' but never defined:  => 66
  + src/drivers/gpu/drm/nouveau/nouveau_dp.c: warning: 'eq_done' may be used uninitialized in this function:  => 533
  + src/drivers/i2c/busses/i2c-designware-pcidrv.c: warning: 'i2c_dw_pci_runtime_idle' defined but not used:  => 190, 189
  + src/drivers/idle/intel_idle.c: warning: cast to pointer from integer of different size:  => 518
  + src/drivers/input/mouse/synaptics.c: warning: 'synaptics_invert_y' defined but not used:  => 53
  + src/drivers/leds/leds-lp5521.c: warning: 'buf' may be used uninitialized in this function:  => 649
  + src/drivers/leds/leds-lp5521.c: warning: 'ret' may be used uninitialized in this function:  => 648
  + src/drivers/md/dm-table.c: warning: statement with no effect:  => 1285
  + src/drivers/md/dm.c: warning: statement with no effect:  => 1097, 1070
  + src/drivers/media/video/ov6650.c: warning: cast to pointer from integer of different size:  => 543
  + src/drivers/mfd/twl6030-irq.c: warning: cast to pointer from integer of different size: 334 => 378, 396
  + src/drivers/mfd/wm8994-core.c: warning: 'wm8994_read' defined but not used:  => 31
  + src/drivers/mfd/wm8994-core.c: warning: 'wm8994_write' defined but not used:  => 71
  + src/drivers/misc/hpilo.c: warning: 'ilo_remove' defined but not used:  => 722
  + src/drivers/mmc/card/block.c: warning: 'arg' may be used uninitialized in this function:  => 748, 794
  + src/drivers/mmc/card/block.c: warning: 'from' may be used uninitialized in this function:  => 748, 794
  + src/drivers/mmc/card/block.c: warning: 'nr' may be used uninitialized in this function:  => 748, 794
  + src/drivers/mmc/core/mmc_ops.c: warning: 'flags' may be used uninitialized in this function:  => 556
  + src/drivers/mtd/devices/docg3.c: warning: 'doc_get_erase_count' defined but not used:  => 752, 753
  + src/drivers/mtd/devices/sst25l.c: warning: unused variable 'i':  => 381
  + src/drivers/mtd/mtdchar.c: warning: passing argument 2 of 'access_ok' makes pointer from integer without a cast:  => 578, 579
  + src/drivers/net/arcnet/arc-rimi.c: warning: unused variable 'lp':  => 364
  + src/drivers/net/ethernet/8390/ax88796.c: warning: unused variable 'ei_local':  => 796
  + src/drivers/net/ethernet/alteon/acenic.c: warning: passing argument 3 of 'pci_free_consistent' discards qualifiers from pointer target type:  => 765, 759, 754
  + src/drivers/net/ethernet/amd/nmclan_cs.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:201):  => 628
  + src/drivers/net/ethernet/amd/nmclan_cs.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:203):  => 628
  + src/drivers/net/ethernet/broadcom/cnic.c: warning: large integer implicitly truncated to unsigned type:  => 1399, 1387, 1414, 1429
  + src/drivers/net/ethernet/brocade/bna/bnad.c: warning: comparison is always true due to limited range of data type:  => 2778
  + src/drivers/net/ethernet/hp/hp100.c: warning: label 'out3' defined but not used:  => 3046
  + src/drivers/net/ethernet/i825xx/lib82596.c: warning: passing argument 2 of 'dma_cache_sync' discards qualifiers from pointer target type:  => 391, 1262, 600, 961, 896, 581, 1287, 629, 375, 1318, 580, 855, 837, 372, 388
  + src/drivers/net/ethernet/i825xx/znet.c: warning: cast from pointer to integer of different size:  => 864, 871
  + src/drivers/net/ethernet/marvell/sky2.c: warning: control reaches end of non-void function:  => 3065
  + src/drivers/net/ethernet/neterion/vxge/vxge-main.c: warning: 'adaptive_coalesce_rx_interrupts' defined but not used:  => 2145
  + src/drivers/net/ethernet/neterion/vxge/vxge-main.c: warning: 'adaptive_coalesce_tx_interrupts' defined but not used:  => 2117
  + src/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe.h: warning: "pr_fmt" redefined:  => 24:1
  + src/drivers/net/ethernet/renesas/sh_eth.c: warning: unused variable 'mdp':  => 1920
  + src/drivers/net/ethernet/seeq/seeq8005.c: warning: integer overflow in expression:  => 701, 544
  + src/drivers/net/ethernet/seeq/seeq8005.c: warning: statement with no effect:  => 560
  + src/drivers/net/ethernet/smsc/smc911x.c: warning: unused variable 'lp':  => 2122
  + src/drivers/net/ethernet/smsc/smc911x.h: warning: control reaches end of non-void function:  => 135
  + src/drivers/net/ethernet/smsc/smc91c92_cs.c: warning: unused variable 'smc':  => 960
  + src/drivers/net/ethernet/smsc/smc91x.c: warning: cast from pointer to integer of different size:  => 1910
  + src/drivers/net/ethernet/smsc/smc91x.c: warning: passing argument 1 of 'insw' makes integer from pointer without a cast:  => 490
  + src/drivers/net/ethernet/smsc/smc91x.c: warning: passing argument 1 of 'inw' makes integer from pointer without a cast:  => 833, 1341, 621, 571, 1921, 860, 1908, 1661, 470, 679, 1346, 729, 796, 1895, 677, 1345, 1687, 440, 1682, 1656, 800, 752, 1289, 1280, 421, 1250, 1878, 717, 1343, 1266, 1226, 1689, 756, 330, 492, 314, 1286, 1225, 1342, 1233, 1198, 396, 1174, 1946, 724, 774, 1823, 691, 411
  + src/drivers/net/ethernet/smsc/smc91x.c: warning: passing argument 1 of 'outsw' makes integer from pointer without a cast:  => 597
  + src/drivers/net/ethernet/smsc/smc91x.c: warning: passing argument 2 of 'outw' makes integer from pointer without a cast:  => 391, 1677, 621, 1920, 679, 600, 1457, 1460, 821, 785, 329, 1200, 805, 1681, 582, 1808, 1289, 1280, 313, 1836, 1250, 395, 1267, 938, 1653, 1680, 753, 1454, 347, 1296, 441, 1894, 728, 1132, 349, 1458, 865, 725, 325, 1809, 803, 350, 1907, 1657, 1650, 1945, 396, 797, 1201, 691, 1199, 1175, 311, 833, 1173, 1074, 860, 1663, 309, 1683, 346, 389, 762, 1295, 1652, 1197, 939, 1815, 1347, 380, 761, 838, 310, 418, 760, 1075, 381, 471, 783, 614, 581, 1664, 345, 254, 1265, 278, 490, 271, 1455, 328, 1024, 594, 669, 1286, 851, 1344, 1692, 757, 1678, 390, 253, 597, 1025, 356, 1655, 1227, 296, 357, 1691, 940, 1649, 493, 270
  + src/drivers/net/ethernet/smsc/smc91x.h: warning: "SMC_inb" redefined:  => 505:1
  + src/drivers/net/ethernet/smsc/smc91x.h: warning: "SMC_inl" redefined:  => 463:1
  + src/drivers/net/ethernet/smsc/smc91x.h: warning: "SMC_insl" redefined:  => 465:1
  + src/drivers/net/ethernet/smsc/smc91x.h: warning: "SMC_outb" redefined:  => 506:1
  + src/drivers/net/ethernet/smsc/smc91x.h: warning: "SMC_outl" redefined:  => 464:1
  + src/drivers/net/ethernet/smsc/smc91x.h: warning: "SMC_outsl" redefined:  => 466:1
  + src/drivers/net/ethernet/smsc/smc91x.h: warning: this is the location of the previous definition:  => 181:1, 180:1, 183:1, 185:1, 178:1, 184:1
  + src/drivers/net/ethernet/tehuti/tehuti.c: warning: passing argument 2 of 'bdx_tx_push_desc_safe' discards qualifiers from pointer target type:  => 330
  + src/drivers/net/ethernet/ti/tlan.c: warning: label 'err_out' defined but not used:  => 618
  + src/drivers/net/ethernet/xilinx/ll_temac_main.c: warning: cast to pointer from integer of different size:  => 629
  + src/drivers/net/tokenring/ibmtr_cs.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:201):  => 195
  + src/drivers/net/tokenring/ibmtr_cs.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:203):  => 195
  + src/drivers/net/tokenring/ibmtr_cs.c: warning: unused variable 'ti':  => 271
  + src/drivers/net/vmxnet3/vmxnet3_drv.c: warning: large integer implicitly truncated to unsigned type:  => 1439, 1434
  + src/drivers/net/wireless/ath/ath6kl/cfg80211.c: warning: comparison is always false due to limited range of data type:  => 759, 871, 904, 940, 341
  + src/drivers/net/wireless/ath/ath6kl/main.c: warning: comparison is always true due to limited range of data type:  => 64
  + src/drivers/net/wireless/ath/ath6kl/sdio.c: warning: 'sg_sz' may be used uninitialized in this function:  => 319
  + src/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c: warning: 'wsec' may be used uninitialized in this function:  => 346
  + src/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c: warning: passing argument 2 of 'dma_map_single' discards qualifiers from pointer target type:  => 820
  + src/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c: warning: passing argument 2 of 'dma_map_single_attrs' discards qualifiers from pointer target type:  => 820
  + src/drivers/net/wireless/mwifiex/pcie.c: warning: 'mwifiex_pcie_resume' defined but not used:  => 194, 193
  + src/drivers/net/wireless/mwifiex/pcie.c: warning: 'mwifiex_pcie_suspend' defined but not used:  => 155, 156
  + src/drivers/nfc/nfcwilink.c: warning: overflow in implicit constant conversion:  => 140
  + src/drivers/pci/ats.c: warning: assignment makes pointer from integer without a cast:  => 29
  + src/drivers/platform/x86/asus-laptop.c: warning: 'lo' may be used uninitialized in this function:  => 1174
  + src/drivers/platform/x86/dell-laptop.c: warning: function declaration isn't a prototype:  => 593, 600
  + src/drivers/scsi/lpfc/lpfc_debugfs.c: warning: integer constant is too large for 'long' type:  => 3892
  + src/drivers/scsi/lpfc/lpfc_scsi.c: warning: integer constant is too large for 'long' type:  => 1344, 1378, 1307, 1367, 1434, 1412, 1333
  + src/drivers/scsi/mpt2sas/mpt2sas_scsih.c: warning: 'fw_event' is used uninitialized in this function:  => 2805
  + src/drivers/scsi/mpt2sas/mpt2sas_scsih.c: warning: 'fw_event' may be used uninitialized in this function:  => 2805
  + src/drivers/scsi/mvumi.c: warning: 'mvumi_resume' defined but not used:  => 1923, 1924
  + src/drivers/scsi/mvumi.c: warning: 'mvumi_suspend' defined but not used:  => 1904, 1905
  + src/drivers/staging/gma500/power.c: warning: passing argument 1 of 'gma_resume_display' from incompatible pointer type:  => 269
  + src/drivers/staging/iio/dac/ad5064.c: warning: type qualifiers ignored on function return type:  => 352
  + src/drivers/staging/iio/gyro/adis16080_core.c: warning: 'ut' may be used uninitialized in this function:  => 85
  + src/drivers/staging/media/dt3155v4l/dt3155v4l.c: warning: initialization from incompatible pointer type:  => 307, 311
  + src/drivers/staging/media/lirc/lirc_serial.c: warning: format '%lx' expects type 'long unsigned int', but argument 6 has type '__kernel_suseconds_t':  => 720, 731, 705
  + src/drivers/staging/media/lirc/lirc_serial.c: warning: format '%lx' expects type 'long unsigned int', but argument 7 has type '__kernel_suseconds_t':  => 720, 731, 705
  + src/drivers/staging/rtl8192e/rtl819x_TSProc.c: warning: comparison is always true due to limited range of data type:  => 321
  + src/drivers/staging/rtl8192e/rtllib_softmac.c: warning: 'aid' may be used uninitialized in this function:  => 2210
  + src/drivers/staging/rtl8192e/rtllib_softmac.c: warning: 'challenge' may be used uninitialized in this function:  => 2294
  + src/drivers/staging/rtl8192e/rtllib_softmac.c: warning: value computed is not used:  => 917
  + src/drivers/staging/wlags49_h2/wl_wext.c: warning: comparison is always false due to limited range of data type:  => 225
  + src/drivers/staging/wlags49_h2/wl_wext.c: warning: comparison is always true due to limited range of data type:  => 250
  + src/drivers/staging/wlags49_h25/../wlags49_h2/wl_wext.c: warning: comparison is always false due to limited range of data type:  => 225
  + src/drivers/staging/wlags49_h25/../wlags49_h2/wl_wext.c: warning: comparison is always true due to limited range of data type:  => 250
  + src/drivers/target/iscsi/iscsi_target_auth.c: warning: ignoring return value of 'hex2bin', declared with attribute warn_unused_result:  => 35
  + src/drivers/tty/ehv_bytechan.c: warning: 'ehv_bc_console_init' defined but not used:  => 334
  + src/drivers/tty/ehv_bytechan.c: warning: data definition has no type or storage class:  => 362
  + src/drivers/tty/ehv_bytechan.c: warning: parameter names (without types) in function declaration:  => 362
  + src/drivers/tty/ehv_bytechan.c: warning: type defaults to 'int' in declaration of 'console_initcall':  => 362
  + src/drivers/tty/serial/mfd.c: warning: 'serial_hsu_remove' defined but not used:  => 1447
  + src/drivers/usb/dwc3/gadget.c: warning: 'trb' is used uninitialized in this function:  => 1330
  + src/drivers/usb/host/isp1760-if.c: warning: unused variable 'oirq':  => 46
  + src/drivers/usb/host/xhci-mem.c: warning: 'tt_info' may be used uninitialized in this function:  => 699
  + src/drivers/usb/host/xhci.c: warning: 'xhci_msix_sync_irqs' defined but not used:  => 319, 318
  + src/drivers/usb/renesas_usbhs/fifo.c: warning: passing argument 1 of 'virt_to_phys' makes pointer from integer without a cast:  => 774
  + src/drivers/video/riva/fbdev.c: warning: 'modedb$hsync_len' may be used uninitialized in this function:  => 1810
  + src/drivers/video/riva/fbdev.c: warning: 'modedb$left_margin' may be used uninitialized in this function:  => 1810
  + src/drivers/video/riva/fbdev.c: warning: 'modedb$lower_margin' may be used uninitialized in this function:  => 1810
  + src/drivers/video/riva/fbdev.c: warning: 'modedb$pixclock' may be used uninitialized in this function:  => 1810
  + src/drivers/video/riva/fbdev.c: warning: 'modedb$right_margin' may be used uninitialized in this function:  => 1810
  + src/drivers/video/riva/fbdev.c: warning: 'modedb$sync' may be used uninitialized in this function:  => 1810
  + src/drivers/video/riva/fbdev.c: warning: 'modedb$upper_margin' may be used uninitialized in this function:  => 1810
  + src/drivers/video/riva/fbdev.c: warning: 'modedb$vmode' may be used uninitialized in this function:  => 1810
  + src/drivers/video/riva/fbdev.c: warning: 'modedb$vsync_len' may be used uninitialized in this function:  => 1810
  + src/drivers/video/riva/fbdev.c: warning: 'modedb$xres' may be used uninitialized in this function:  => 1810
  + src/drivers/video/riva/fbdev.c: warning: 'modedb$yres' may be used uninitialized in this function:  => 1810
  + src/drivers/video/sis/sis_main.c: warning: #warning Neither CONFIG_FB_SIS_300 nor CONFIG_FB_SIS_315 is set:  => 64:2
  + src/drivers/video/sis/sis_main.c: warning: #warning sisfb will not work!:  => 65:2
  + src/drivers/video/sis/sis_main.c: warning: 'sisfb_post_map_vram' defined but not used:  => 4153
  + src/fs/btrfs/backref.c: warning: 'ret' may be used uninitialized in this function:  => 419, 485
  + src/fs/btrfs/backref.c: warning: cast from pointer to integer of different size:  => 686
  + src/fs/btrfs/extent_io.c: warning: cast from pointer to integer of different size:  => 2289
  + src/fs/btrfs/ioctl.c: warning: cast from pointer to integer of different size:  => 2933
  + src/fs/btrfs/ioctl.c: warning: cast to pointer from integer of different size:  => 3020, 2937
  + src/fs/btrfs/scrub.c: warning: cast to pointer from integer of different size:  => 275
  + src/fs/compat_binfmt_elf.c: warning: 'cputime_to_compat_timeval' defined but not used:  => 51
  + src/fs/ext4/page-io.c: warning: format '%zd' expects type 'signed size_t', but argument 6 has type 'ssize_t':  => 108
  + src/fs/fat/namei_vfat.c: warning: 'lcase' may be used uninitialized in this function:  => 603
  + src/fs/fat/namei_vfat.c: warning: 'ulen' may be used uninitialized in this function:  => 608
  + src/fs/locks.c: warning: control reaches end of non-void function:  => 1474
  + src/fs/ncpfs/dir.c: warning: unused variable 'sb':  => 128
  + src/include/linux/printk.h: warning: this is the location of the previous definition:  => 152:1
  + src/include/media/soc_camera.h: warning: cast to pointer from integer of different size:  => 257
  + src/kernel/power/qos.c: warning: control reaches end of non-void function:  => 143
  + src/kernel/sched_fair.c: warning: 'account_cfs_rq_runtime' declared inline after being called:  => 310, 309
  + src/kernel/sched_fair.c: warning: 'return_cfs_rq_runtime' declared inline after being called:  => 1055
  + src/kernel/sched_fair.c: warning: previous declaration of 'account_cfs_rq_runtime' was here:  => 310, 309
  + src/kernel/sched_fair.c: warning: previous declaration of 'return_cfs_rq_runtime' was here:  => 1055
  + src/kernel/trace/ring_buffer.c: warning: unused variable 'local_clock_stable':  => 2202
  + src/kernel/trace/trace.c: warning: 'page2' may be used uninitialized in this function:  => 3644
  + src/kernel/trace/trace_clock.c: warning: data definition has no type or storage class:  => 117
  + src/kernel/trace/trace_clock.c: warning: type defaults to 'int' in declaration of 'trace_counter':  => 117
  + src/kernel/watchdog.c: warning: 'watchdog_disable' defined but not used:  => 464, 463
  + src/net/ieee802154/6lowpan.c: warning: passing argument 3 of 'lowpan_raw_dump_inline' discards qualifiers from pointer target type:  => 282, 295
  + src/net/mac80211/debugfs_netdev.c: warning: passing argument 2 of 'drv_get_tsf' discards qualifiers from pointer target type:  => 342
  + src/net/sctp/protocol.c: warning: label 'free_next' defined but not used:  => 676
  + src/sound/soc/codecs/adau1373.c: warning: large integer implicitly truncated to unsigned type:  => 940
  + src/sound/soc/codecs/wm8900.c: warning: 'fll_div.fll_ratio' may be used uninitialized in this function:  => 744
  + src/sound/soc/codecs/wm8900.c: warning: 'fll_div.fll_slow_lock_ref' may be used uninitialized in this function:  => 744
  + src/sound/soc/codecs/wm8900.c: warning: 'fll_div.fllclk_div' may be used uninitialized in this function:  => 744
  + src/sound/soc/codecs/wm8900.c: warning: 'fll_div.k' may be used uninitialized in this function:  => 744
  + src/sound/soc/codecs/wm8900.c: warning: 'fll_div.n' may be used uninitialized in this function:  => 744
  + src/sound/soc/codecs/wm8983.c: warning: 'pll_div.div2' may be used uninitialized in this function:  => 855
  + src/sound/soc/codecs/wm8983.c: warning: 'pll_div.k' may be used uninitialized in this function:  => 855
  + src/sound/soc/codecs/wm8983.c: warning: 'pll_div.n' may be used uninitialized in this function:  => 855
  + src/sound/soc/codecs/wm8985.c: warning: 'pll_div.div2' may be used uninitialized in this function:  => 785
  + src/sound/soc/codecs/wm8985.c: warning: 'pll_div.k' may be used uninitialized in this function:  => 785
  + src/sound/soc/codecs/wm8985.c: warning: 'pll_div.n' may be used uninitialized in this function:  => 785
  + src/sound/soc/codecs/wm8994.c: warning: unused variable 'wm8994':  => 58
  + src/sound/soc/sh/fsi.c: warning: passing argument 1 of '__fsi_reg_mask_set' makes pointer from integer without a cast:  => 664, 920, 742, 898, 739
  + src/sound/soc/sh/fsi.c: warning: passing argument 1 of '__fsi_reg_read' makes pointer from integer without a cast:  => 453, 506, 443, 529, 444, 454
  + src/sound/soc/sh/fsi.c: warning: passing argument 1 of '__fsi_reg_write' makes pointer from integer without a cast:  => 741, 738, 468, 518, 911, 469, 915, 494, 914
  + warning: (ETRAX_USB_HOST && MOUSE_APPLETOUCH && MOUSE_BCM5974 && JOYSTICK_XPAD && TABLET_USB_ACECAD && TABLET_USB_AIPTEK && TABLET_USB_HANWANG && TABLET_USB_KBTAB && TABLET_USB_WACOM && TOUCHSCREEN_USB_COMPOSITE && INPUT_ATI_REMOTE2 && INPUT_KEYSPAN_REMOTE && INPUT_POWERMATE && INPUT_YEALINK && INPUT_CM109) selects USB which has unmet direct dependencies (USB_SUPPORT && USB_ARCH_HAS_HCD):  => N/A
  + warning: (IA32_EMULATION) selects COMPAT_BINFMT_ELF which has unmet direct dependencies (COMPAT && BINFMT_ELF):  => N/A
  + warning: (IWLWIFI && IWLWIFI_LEGACY && ATH5K && ATH9K && ATH9K_HTC && CARL9170_LEDS) selects MAC80211_LEDS which has unmet direct dependencies (NET && WIRELESS && MAC80211 && LEDS_CLASS):  => N/A
  + warning: (MIPS_ALCHEMY && CAVIUM_OCTEON_REFERENCE_BOARD && SOC_AR71XX && SOC_AR724X && BCM63XX_CPU_6338) selects USB_ARCH_HAS_OHCI which has unmet direct dependencies (USB_SUPPORT):  => N/A
  + warning: (MIPS_ALCHEMY && CAVIUM_OCTEON_REFERENCE_BOARD && SOC_AR71XX && SOC_AR724X && SOC_AR913X) selects USB_ARCH_HAS_EHCI which has unmet direct dependencies (USB_SUPPORT):  => N/A
  + warning: (PLATFORM_AT32AP) selects HAVE_NET_MACB which has unmet direct dependencies (NETDEVICES && ETHERNET):  => N/A
  + warning: (PPC_CELL_NATIVE && 440EPX && 440GRX && 440GX && 440SPe && 460EX && 460SX && APM821xx && 405EX) selects IBM_EMAC_EMAC4 which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM):  => N/A
  + warning: (PPC_CELL_NATIVE && 440GX && 460EX && 460SX && APM821xx) selects IBM_EMAC_TAH which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM):  => N/A
  + warning: (PPC_CELL_NATIVE && BLUESTONE && CANYONLANDS && GLACIER && EIGER && 440EPX && 440GRX && 440GX && 460SX && 405EX) selects IBM_EMAC_RGMII which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM):  => N/A
  + warning: (PPC_CELL_NATIVE && CANYONLANDS && GLACIER && 440EP && 440EPX && 440GRX && 440GP && 440GX && 460SX && 405GP) selects IBM_EMAC_ZMII which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM):  => N/A
  + warning: (PREEMPT && DEBUG_ATOMIC_SLEEP) selects PREEMPT_COUNT which has unmet direct dependencies (COLDFIRE):  => N/A
  + warning: (SCHED_AUTOGROUP) selects CGROUP_SCHED which has unmet direct dependencies (CGROUPS && EXPERIMENTAL):  => N/A
  + warning: arch/powerpc/mm/built-in.o(.text+0xb614): Section mismatch in reference from the function .mark_reserved_regions_for_nid() to the function .init.text:.get_node_active_region():  => N/A
  + warning: arch/powerpc/mm/built-in.o(.text+0xb6f8): Section mismatch in reference from the function .mark_reserved_regions_for_nid() to the function .init.text:.get_node_active_region():  => N/A
  + warning: arch/powerpc/mm/built-in.o(.text+0xb7ec): Section mismatch in reference from the function .mark_reserved_regions_for_nid() to the function .init.text:.get_node_active_region():  => N/A
  + warning: arch/powerpc/mm/built-in.o(.text+0xb8d0): Section mismatch in reference from the function .mark_reserved_regions_for_nid() to the function .init.text:.get_node_active_region():  => N/A
  + warning: arch/powerpc/sysdev/built-in.o(.text+0x109d8): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics():  => N/A
  + warning: arch/powerpc/sysdev/built-in.o(.text+0xe834): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics():  => N/A
  + warning: arch/powerpc/sysdev/built-in.o(.text+0xef54): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics():  => N/A
  + warning: arch/powerpc/sysdev/xics/built-in.o(.text+0x1850): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics():  => N/A
  + warning: arch/powerpc/sysdev/xics/built-in.o(.text+0x2014): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics():  => N/A
  + warning: drivers/built-in.o(.data+0x1660c): Section mismatch in reference from the variable cs5535_mfd_drv to the function .devinit.text:cs5535_mfd_probe():  => N/A
  + warning: drivers/built-in.o(.devinit.text+0xd784): Section mismatch in reference from the function spi_gpio_probe() to the function .init.text:spi_gpio_request():  => N/A
  + warning: drivers/built-in.o(.devinit.text+0xe7b8c): Section mismatch in reference from the function .spi_gpio_probe() to the function .init.text:.spi_gpio_alloc():  => N/A
  + warning: drivers/built-in.o(.devinit.text+0xe7bc0): Section mismatch in reference from the function .spi_gpio_probe() to the function .init.text:.spi_gpio_alloc():  => N/A
  + warning: drivers/built-in.o(.devinit.text+0xe7bf0): Section mismatch in reference from the function .spi_gpio_probe() to the function .init.text:.spi_gpio_alloc():  => N/A
  + warning: drivers/built-in.o(.text+0x127cd4): Section mismatch in reference from the function dmar_parse_rmrr_atsr_dev() to the function .init.text:dmar_parse_dev_scope():  => N/A
  + warning: drivers/built-in.o(.text+0x127d7c): Section mismatch in reference from the function dmar_parse_rmrr_atsr_dev() to the function .init.text:dmar_parse_dev_scope():  => N/A
  + warning: drivers/built-in.o(.text+0x129ac6): Section mismatch in reference from the function ir_dev_scope_init() to the function .init.text:dmar_dev_scope_init():  => N/A
  + warning: drivers/built-in.o(.text+0x2869244): Section mismatch in reference from the function .usbhs_mod_remove() to the function .devexit.text:.usbhs_mod_host_remove():  => N/A
  + warning: drivers/built-in.o(.text+0x28692e4): Section mismatch in reference from the function .usbhs_mod_probe() to the function .devinit.text:.usbhs_mod_host_probe():  => N/A
  + warning: drivers/built-in.o(.text+0x2869394): Section mismatch in reference from the function .usbhs_mod_probe() to the function .devexit.text:.usbhs_mod_host_remove():  => N/A
  + warning: drivers/iommu/built-in.o(.text+0xbba4): Section mismatch in reference from the function dmar_parse_rmrr_atsr_dev() to the function .init.text:dmar_parse_dev_scope():  => N/A
  + warning: drivers/iommu/built-in.o(.text+0xbc4c): Section mismatch in reference from the function dmar_parse_rmrr_atsr_dev() to the function .init.text:dmar_parse_dev_scope():  => N/A
  + warning: drivers/iommu/built-in.o(.text+0xd996): Section mismatch in reference from the function ir_dev_scope_init() to the function .init.text:dmar_dev_scope_init():  => N/A
  + warning: drivers/mfd/built-in.o(.data+0x4428): Section mismatch in reference from the variable cs5535_mfd_drv to the function .devinit.text:cs5535_mfd_probe():  => N/A
  + warning: drivers/net/ethernet/amd/depca.o(.devinit.text+0x18): Section mismatch in reference from the function depca_isa_probe() to the function .init.text:depca_common_init():  => N/A
  + warning: drivers/net/ethernet/amd/depca.o(.devinit.text+0x40): Section mismatch in reference from the function depca_isa_probe() to the function .init.text:DepcaSignature():  => N/A
  + warning: drivers/net/ethernet/amd/depca.o(.devinit.text+0xa0): Section mismatch in reference from the function depca_isa_probe() to the function .init.text:depca_hw_init():  => N/A
  + warning: drivers/sbus/char/bbc.o(.devinit.text+0x8): Section mismatch in reference from the function bbc_i2c_probe() to the function .init.text:T.409():  => N/A
  + warning: drivers/spi/built-in.o(.devinit.text+0x1458): Section mismatch in reference from the function .spi_gpio_probe() to the function .init.text:.spi_gpio_alloc():  => N/A
  + warning: drivers/spi/built-in.o(.devinit.text+0x148c): Section mismatch in reference from the function .spi_gpio_probe() to the function .init.text:.spi_gpio_alloc():  => N/A
  + warning: drivers/spi/built-in.o(.devinit.text+0x14bc): Section mismatch in reference from the function .spi_gpio_probe() to the function .init.text:.spi_gpio_alloc():  => N/A
  + warning: drivers/spi/built-in.o(.devinit.text+0x2e9): Section mismatch in reference from the function spi_gpio_probe() to the function .init.text:spi_gpio_request():  => N/A
  + warning: drivers/spi/spi-gpio.o(.devinit.text+0x66): Section mismatch in reference from the function spi_gpio_probe() to the function .init.text:spi_gpio_alloc():  => N/A
  + warning: drivers/spi/spi-gpio.o(.devinit.text+0x8b): Section mismatch in reference from the function spi_gpio_probe() to the function .init.text:spi_gpio_alloc():  => N/A
  + warning: drivers/spi/spi-gpio.o(.devinit.text+0xac): Section mismatch in reference from the function spi_gpio_probe() to the function .init.text:spi_gpio_alloc():  => N/A
  + warning: drivers/usb/built-in.o(.text+0x235618): Section mismatch in reference from the function .usbhs_mod_remove() to the function .devexit.text:.usbhs_mod_host_remove():  => N/A
  + warning: drivers/usb/built-in.o(.text+0x2356b8): Section mismatch in reference from the function .usbhs_mod_probe() to the function .devinit.text:.usbhs_mod_host_probe():  => N/A
  + warning: drivers/usb/built-in.o(.text+0x235768): Section mismatch in reference from the function .usbhs_mod_probe() to the function .devexit.text:.usbhs_mod_host_remove():  => N/A
  + warning: drivers/usb/gadget/g_ffs.o(.text+0x5468): Section mismatch in reference from the function eth_bind_config() to the function .init.text:geth_bind_config():  => N/A
  + warning: drivers/usb/gadget/g_ffs.o(.text+0xba76): Section mismatch in reference from the function eth_bind_config() to the function .init.text:geth_bind_config():  => N/A
  + warning: drivers/usb/gadget/g_multi.o(.text+0x8580): Section mismatch in reference from the function cdc_config_register() to the function .init.text:cdc_do_config():  => N/A
  + warning: drivers/usb/gadget/g_multi.o(.text+0x85e8): Section mismatch in reference from the function rndis_config_register() to the function .init.text:rndis_do_config():  => N/A
  + warning: drivers/usb/renesas_usbhs/built-in.o(.text+0x1a5c): Section mismatch in reference from the function usbhs_mod_remove() to the function .devexit.text:usbhs_mod_host_remove():  => N/A
  + warning: drivers/usb/renesas_usbhs/built-in.o(.text+0x1b78): Section mismatch in reference from the function usbhs_mod_probe() to the function .devinit.text:usbhs_mod_host_probe():  => N/A
  + warning: drivers/usb/renesas_usbhs/built-in.o(.text+0x1b94): Section mismatch in reference from the function usbhs_mod_probe() to the function .devexit.text:usbhs_mod_host_remove():  => N/A
  + warning: drivers/usb/renesas_usbhs/built-in.o(.text+0x1ea8): Section mismatch in reference from the function .usbhs_mod_remove() to the function .devexit.text:.usbhs_mod_host_remove():  => N/A
  + warning: drivers/usb/renesas_usbhs/built-in.o(.text+0x1f48): Section mismatch in reference from the function .usbhs_mod_probe() to the function .devinit.text:.usbhs_mod_host_probe():  => N/A
  + warning: drivers/usb/renesas_usbhs/built-in.o(.text+0x1ff8): Section mismatch in reference from the function .usbhs_mod_probe() to the function .devexit.text:.usbhs_mod_host_remove():  => N/A
  + warning: drivers/usb/renesas_usbhs/renesas_usbhs.o(.text+0x1100): Section mismatch in reference from the function usbhs_mod_remove() to the function .devexit.text:usbhs_mod_host_remove():  => N/A
  + warning: drivers/usb/renesas_usbhs/renesas_usbhs.o(.text+0x12cc): Section mismatch in reference from the function usbhs_mod_probe() to the function .devinit.text:usbhs_mod_host_probe():  => N/A
  + warning: drivers/usb/renesas_usbhs/renesas_usbhs.o(.text+0x133c): Section mismatch in reference from the function usbhs_mod_probe() to the function .devexit.text:usbhs_mod_host_remove():  => N/A
  + warning: drivers/usb/renesas_usbhs/renesas_usbhs.o(.text+0x1a5c): Section mismatch in reference from the function usbhs_mod_remove() to the function .devexit.text:usbhs_mod_host_remove():  => N/A
  + warning: drivers/usb/renesas_usbhs/renesas_usbhs.o(.text+0x1a70): Section mismatch in reference from the function usbhs_mod_remove() to the function .devexit.text:usbhs_mod_host_remove():  => N/A
  + warning: drivers/usb/renesas_usbhs/renesas_usbhs.o(.text+0x1a74): Section mismatch in reference from the function usbhs_mod_remove() to the function .devexit.text:usbhs_mod_gadget_remove():  => N/A
  + warning: drivers/usb/renesas_usbhs/renesas_usbhs.o(.text+0x1b78): Section mismatch in reference from the function usbhs_mod_probe() to the function .devinit.text:usbhs_mod_host_probe():  => N/A
  + warning: drivers/usb/renesas_usbhs/renesas_usbhs.o(.text+0x1b94): Section mismatch in reference from the function usbhs_mod_probe() to the function .devexit.text:usbhs_mod_host_remove():  => N/A
  + warning: drivers/usb/renesas_usbhs/renesas_usbhs.o(.text+0x1bdc): Section mismatch in reference from the function usbhs_mod_probe() to the function .devinit.text:usbhs_mod_host_probe():  => N/A
  + warning: drivers/usb/renesas_usbhs/renesas_usbhs.o(.text+0x1be0): Section mismatch in reference from the function usbhs_mod_probe() to the function .devinit.text:usbhs_mod_gadget_probe():  => N/A
  + warning: drivers/usb/renesas_usbhs/renesas_usbhs.o(.text+0x1bf8): Section mismatch in reference from the function usbhs_mod_probe() to the function .devexit.text:usbhs_mod_gadget_remove():  => N/A
  + warning: drivers/usb/renesas_usbhs/renesas_usbhs.o(.text+0x1bfc): Section mismatch in reference from the function usbhs_mod_probe() to the function .devexit.text:usbhs_mod_host_remove():  => N/A
  + warning: drivers/usb/renesas_usbhs/renesas_usbhs.o(.text+0x1ea8): Section mismatch in reference from the function .usbhs_mod_remove() to the function .devexit.text:.usbhs_mod_host_remove():  => N/A
  + warning: drivers/usb/renesas_usbhs/renesas_usbhs.o(.text+0x1f48): Section mismatch in reference from the function .usbhs_mod_probe() to the function .devinit.text:.usbhs_mod_host_probe():  => N/A
  + warning: drivers/usb/renesas_usbhs/renesas_usbhs.o(.text+0x1ff8): Section mismatch in reference from the function .usbhs_mod_probe() to the function .devexit.text:.usbhs_mod_host_remove():  => N/A
  + warning: drivers/usb/renesas_usbhs/renesas_usbhs.o(.text+0xb28): Section mismatch in reference from the function usbhs_mod_remove() to the function .devexit.text:usbhs_mod_host_remove():  => N/A
  + warning: drivers/usb/renesas_usbhs/renesas_usbhs.o(.text+0xb54): Section mismatch in reference from the function usbhs_mod_probe() to the function .devinit.text:usbhs_mod_host_probe():  => N/A
  + warning: drivers/usb/renesas_usbhs/renesas_usbhs.o(.text+0xbb0): Section mismatch in reference from the function usbhs_mod_probe() to the function .devexit.text:usbhs_mod_host_remove():  => N/A
  + warning: drivers/usb/renesas_usbhs/renesas_usbhs.o(.text+0xe19): Section mismatch in reference from the function usbhs_mod_remove() to the function .devexit.text:usbhs_mod_host_remove():  => N/A
  + warning: drivers/usb/renesas_usbhs/renesas_usbhs.o(.text+0xe5e): Section mismatch in reference from the function usbhs_mod_probe() to the function .devinit.text:usbhs_mod_host_probe():  => N/A
  + warning: drivers/usb/renesas_usbhs/renesas_usbhs.o(.text+0xeda): Section mismatch in reference from the function usbhs_mod_probe() to the function .devexit.text:usbhs_mod_host_remove():  => N/A
  + warning: vmlinux.o(.data+0x4110c): Section mismatch in reference from the variable cs5535_mfd_drv to the function .devinit.text:cs5535_mfd_probe():  => N/A
  + warning: vmlinux.o(.devinit.text+0xa59e): Section mismatch in reference from the function cnb20le_res() to the function .init.text:acpi_os_get_root_pointer():  => N/A
  + warning: vmlinux.o(.devinit.text+0xd879): Section mismatch in reference from the function spi_gpio_probe() to the function .init.text:spi_gpio_request():  => N/A
  + warning: vmlinux.o(.text+0x263309): Section mismatch in reference from the function kernel_tree_alloc() to the function .init.text:prom_early_alloc():  => N/A
  + warning: vmlinux.o(.text+0x494b1c): Section mismatch in reference from the function dmar_parse_rmrr_atsr_dev() to the function .init.text:dmar_parse_dev_scope():  => N/A
  + warning: vmlinux.o(.text+0x494bc4): Section mismatch in reference from the function dmar_parse_rmrr_atsr_dev() to the function .init.text:dmar_parse_dev_scope():  => N/A
  + warning: vmlinux.o(.text+0x49690e): Section mismatch in reference from the function ir_dev_scope_init() to the function .init.text:dmar_dev_scope_init():  => N/A

173 improvements:
  - .config: warning: override: SLOB changes choice state: 152 => 
  - /tmp/ccTGV2yr.s: Warning: source register same as write-back base: 104 => 
  - include/generated/autoconf.h: warning: this is the location of the previous definition: 5707:1, 4837:1, 6559:1, 3531:1, 4669:1, 4551:1, 6081:1, 6234:1, 5629:1 => 
  - modpost: WARNING: modpost: Found 4 section mismatch(es).: N/A => 
  - modpost: WARNING: modpost: Found 5 section mismatch(es).: N/A => 
  - modpost: WARNING: modpost: Found 6 section mismatch(es).: N/A => 
  - src/arch/powerpc/mm/hugetlbpage.c: warning: control reaches end of non-void function: 48 => 
  - src/arch/x86/xen/enlighten.c: warning: 'cx' may be used uninitialized in this function: 226 => 
  - src/block/blk-merge.c: warning: 'bbio' may be used uninitialized in this function: 18 => 
  - src/drivers/edac/i82975x_edac.c: warning: integer constant is too large for 'unsigned long' type: 298 => 
  - src/drivers/gpu/drm/radeon/radeon_gart.c: warning: passing argument 3 of 'pci_free_consistent' discards qualifiers from pointer target type: 69 => 
  - src/drivers/i2c/busses/i2c-elektor.c: warning: assignment makes pointer from integer without a cast: 153 => 
  - src/drivers/input/keyboard/lm8323.c: warning: 'lm8323_resume' defined but not used: 817 => 
  - src/drivers/input/keyboard/lm8323.c: warning: 'lm8323_suspend' defined but not used: 797 => 
  - src/drivers/input/misc/twl6040-vibra.c: warning: "CONFIG_PM_SLEEP" is not defined: 231:5 => 
  - src/drivers/input/mouse/synaptics_i2c.c: warning: 'synaptics_i2c_resume' defined but not used: 637 => 
  - src/drivers/input/mouse/synaptics_i2c.c: warning: 'synaptics_i2c_suspend' defined but not used: 624 => 
  - src/drivers/input/touchscreen/ad7879-i2c.c: warning: 'ad7879_i2c_resume' defined but not used: 31 => 
  - src/drivers/input/touchscreen/ad7879-i2c.c: warning: 'ad7879_i2c_suspend' defined but not used: 21 => 
  - src/drivers/leds/leds-lp5521.c: warning: 'engine_state' may be used uninitialized in this function: 168 => 
  - src/drivers/media/video/m5mols/m5mols_capture.c: warning: 'timeout' may be used uninitialized in this function: 124 => 
  - src/drivers/message/fusion/mptbase.c: warning: 'seq_mpt_print_ioc_summary' defined but not used: 6810 => 
  - src/drivers/mtd/maps/physmap.c: warning: assignment from incompatible pointer type: 255 => 
  - src/drivers/net/acenic.c: warning: passing argument 3 of 'pci_free_consistent' discards qualifiers from pointer target type: 765, 759, 754 => 
  - src/drivers/net/ax88796.c: warning: unused variable 'ei_local': 796 => 
  - src/drivers/net/cnic.c: warning: large integer implicitly truncated to unsigned type: 1399, 1387, 1414, 1429 => 
  - src/drivers/net/hp100.c: warning: label 'out3' defined but not used: 3046 => 
  - src/drivers/net/lib82596.c: warning: passing argument 2 of 'dma_cache_sync' discards qualifiers from pointer target type: 391, 1262, 600, 961, 896, 581, 1287, 629, 375, 1318, 580, 855, 837, 372, 388 => 
  - src/drivers/net/ll_temac_main.c: warning: cast to pointer from integer of different size: 629 => 
  - src/drivers/net/pch_gbe/pch_gbe_main.c: warning: unused variable 'netdev': 701 => 
  - src/drivers/net/pcmcia/ibmtr_cs.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:201): 195 => 
  - src/drivers/net/pcmcia/ibmtr_cs.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:203): 195 => 
  - src/drivers/net/pcmcia/nmclan_cs.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:201): 628 => 
  - src/drivers/net/pcmcia/nmclan_cs.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:203): 628 => 
  - src/drivers/net/pcmcia/smc91c92_cs.c: warning: unused variable 'smc': 960 => 
  - src/drivers/net/seeq8005.c: warning: integer overflow in expression: 701, 544 => 
  - src/drivers/net/sh_eth.c: warning: unused variable 'mdp': 1907 => 
  - src/drivers/net/sky2.c: warning: control reaches end of non-void function: 3046 => 
  - src/drivers/net/smc911x.c: warning: unused variable 'lp': 2122 => 
  - src/drivers/net/smc911x.h: warning: control reaches end of non-void function: 135 => 
  - src/drivers/net/smc91x.c: warning: cast from pointer to integer of different size: 1910 => 
  - src/drivers/net/smc91x.c: warning: passing argument 1 of 'insw' makes integer from pointer without a cast: 490 => 
  - src/drivers/net/smc91x.c: warning: passing argument 1 of 'inw' makes integer from pointer without a cast: 833, 1341, 621, 571, 1921, 860, 1908, 1661, 470, 679, 1346, 729, 796, 1895, 677, 1345, 1687, 440, 1682, 1656, 800, 752, 1289, 1280, 421, 1250, 1878, 717, 1343, 1266, 1226, 1689, 756, 330, 492, 314, 1286, 1225, 1342, 1233, 1198, 396, 1174, 1946, 724, 774, 1823, 691, 411 => 
  - src/drivers/net/smc91x.c: warning: passing argument 1 of 'outsw' makes integer from pointer without a cast: 597 => 
  - src/drivers/net/smc91x.c: warning: passing argument 2 of 'outw' makes integer from pointer without a cast: 391, 1677, 621, 1920, 679, 600, 1457, 1460, 821, 785, 329, 1200, 805, 1681, 582, 1808, 1289, 1280, 313, 1836, 1250, 395, 1267, 938, 1653, 1680, 753, 1454, 347, 1296, 441, 1894, 728, 1132, 349, 1458, 865, 725, 325, 1809, 803, 350, 1907, 1657, 1650, 1945, 396, 797, 1201, 691, 1199, 1175, 311, 833, 1173, 1074, 860, 1663, 309, 1683, 346, 389, 762, 1295, 1652, 1197, 939, 1815, 1347, 380, 761, 838, 310, 418, 760, 1075, 381, 471, 783, 614, 581, 1664, 345, 254, 1265, 278, 490, 271, 1455, 328, 1024, 594, 669, 1286, 851, 1344, 1692, 757, 1678, 390, 253, 597, 1025, 356, 1655, 1227, 296, 357, 1691, 940, 1649, 493, 270 => 
  - src/drivers/net/smc91x.h: warning: "SMC_inb" redefined: 505:1 => 
  - src/drivers/net/smc91x.h: warning: "SMC_inl" redefined: 463:1 => 
  - src/drivers/net/smc91x.h: warning: "SMC_insl" redefined: 465:1 => 
  - src/drivers/net/smc91x.h: warning: "SMC_outb" redefined: 506:1 => 
  - src/drivers/net/smc91x.h: warning: "SMC_outl" redefined: 464:1 => 
  - src/drivers/net/smc91x.h: warning: "SMC_outsl" redefined: 466:1 => 
  - src/drivers/net/smc91x.h: warning: this is the location of the previous definition: 181:1, 180:1, 183:1, 185:1, 178:1, 184:1 => 
  - src/drivers/net/tehuti.c: warning: passing argument 2 of 'bdx_tx_push_desc_safe' discards qualifiers from pointer target type: 330 => 
  - src/drivers/net/tlan.c: warning: label 'err_out' defined but not used: 618 => 
  - src/drivers/net/vxge/vxge-main.c: warning: 'adaptive_coalesce_rx_interrupts' defined but not used: 2144 => 
  - src/drivers/net/vxge/vxge-main.c: warning: 'adaptive_coalesce_tx_interrupts' defined but not used: 2116 => 
  - src/drivers/net/wireless/b43/phy_lcn.h: warning: no newline at end of file: 14:28 => 
  - src/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c: warning: passing argument 2 of 'dma_map_single' discards qualifiers from pointer target type: 665 => 
  - src/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c: warning: passing argument 2 of 'dma_map_single_attrs' discards qualifiers from pointer target type: 665 => 
  - src/drivers/net/wireless/libertas/if_spi.c: warning: 'hiStatus' may be used uninitialized in this function: 870 => 
  - src/drivers/net/wireless/libertas/if_spi.c: warning: 'len' may be used uninitialized in this function: 690, 552, 753 => 
  - src/drivers/net/wireless/libertas/if_spi.c: warning: 'rval' may be used uninitialized in this function: 401 => 
  - src/drivers/net/wireless/libertas/if_spi.c: warning: 'val' may be used uninitialized in this function: 299 => 
  - src/drivers/net/wireless/rtlwifi/rtl8192de/hw.c: warning: unused variable 'rtlpci': 1234 => 
  - src/drivers/net/wireless/rtlwifi/rtl8192se/hw.c: warning: unused variable 'rtlpci': 1223 => 
  - src/drivers/pci/hotplug/acpiphp_glue.c: warning: passing argument 2 of 'register_hotplug_dock_device' discards qualifiers from pointer target type: 227 => 
  - src/drivers/platform/x86/tc1100-wmi.c: warning: 'suspend_data' defined but not used: 57 => 
  - src/drivers/scsi/lpfc/lpfc_attr.c: warning: 'portstat_reg.word0' may be used uninitialized in this function: 771 => 
  - src/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c: warning: 'cmd52_resp' may be used uninitialized in this function: 615 => 
  - src/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c: warning: 'err' may be used uninitialized in this function: 611 => 
  - src/drivers/staging/ath6kl/htc2/htc_services.c: warning: 'pLastEntry' may be used uninitialized in this function: 312 => 
  - src/drivers/staging/ath6kl/os/linux/ar6000_drv.c: warning: "CONFIG_AR600x_BT_RESET_PIN" redefined: 1345:1 => 
  - src/drivers/staging/ath6kl/os/linux/cfg80211.c: warning: comparison is always false due to limited range of data type: 1048, 1009, 366, 1089, 921 => 
  - src/drivers/staging/easycap/easycap_main.c: warning: comparison of distinct pointer types lacks a cast: 1610, 1617 => 
  - src/drivers/staging/iio/accel/sca3000_ring.c: warning: 'sca3000_show_ring_bpse' defined but not used: 239, 236 => 
  - src/drivers/staging/iio/accel/sca3000_ring.c: warning: 'sca3000_store_ring_bpse' defined but not used: 266, 270 => 
  - src/drivers/staging/iio/adc/ad7150.c: warning: 'iio_dev_attr_available_conversion_modes' defined but not used: 179 => 
  - src/drivers/staging/iio/adc/ad7150.c: warning: 'iio_dev_attr_conversion_mode' defined but not used: 218, 220 => 
  - src/drivers/staging/iio/adc/ad7291.c: warning: 'size' may be used uninitialized in this function: 365 => 
  - src/drivers/staging/iio/dac/ad5504.c: warning: 'st' may be used uninitialized in this function: 281 => 
  - src/drivers/staging/iio/dac/ad5791.c: warning: label 'error_ret' defined but not used: 384 => 
  - src/drivers/staging/iio/industrialio-core.c: warning: 'mask' may be used uninitialized in this function: 914 => 
  - src/drivers/staging/iio/light/tsl2563.c: warning: 'id' may be used uninitialized in this function: 736 => 
  - src/drivers/staging/iio/light/tsl2563.c: warning: initialization from incompatible pointer type: 687 => 
  - src/drivers/staging/iio/meter/ade7854.c: warning: label 'error_ret' defined but not used: 585 => 
  - src/drivers/staging/iio/resolver/ad2s120x.c: warning: 'pos' may be used uninitialized in this function: 46 => 
  - src/drivers/staging/iio/resolver/ad2s120x.c: warning: 'vel' may be used uninitialized in this function: 47 => 
  - src/drivers/staging/lirc/lirc_serial.c: warning: format '%lx' expects type 'long unsigned int', but argument 6 has type '__kernel_suseconds_t': 720, 731, 705 => 
  - src/drivers/staging/lirc/lirc_serial.c: warning: format '%lx' expects type 'long unsigned int', but argument 7 has type '__kernel_suseconds_t': 720, 731, 705 => 
  - src/drivers/staging/rtl8192e/ieee80211/ieee80211_module.c: warning: comparison of distinct pointer types lacks a cast: 253 => 
  - src/drivers/usb/otg/twl6030-usb.c: warning: 'twl6030_set_phy_clk' defined but not used: 142, 141 => 
  - src/drivers/video/fsl-diu-fb.c: warning: format '%08x' expects type 'unsigned int', but argument 5 has type 'resource_size_t': 1521 => 
  - src/drivers/video/via/via-core.c: warning: assignment discards qualifiers from pointer target type: 691 => 
  - src/drivers/video/via/viafbdev.c: warning: ignoring return value of 'kstrtoul', declared with attribute warn_unused_result: 1328, 1161, 1397, 1289, 1231, 1434 => 
  - src/include/linux/posix_acl.h: warning: control reaches end of non-void function  CC [M]  drivers/video/backlight/ili9320.o: 101 => 
  - src/include/linux/video_output.h: warning: 'video_output_register' defined but not used: 45 => 
  - src/include/linux/video_output.h: warning: 'video_output_unregister' defined but not used: 52 => 
  - src/kernel/futex.c: warning: 'curval' may be used uninitialized in this function: 1579 => 
  - src/kernel/futex.c: warning: 'nval' may be used uninitialized in this function: 2484 => 
  - src/kernel/pm_qos_params.c: warning: control may reach end of non-void function 'pm_qos_get_value' being inlined: 411 => 
  - src/kernel/pm_qos_params.c: warning: control reaches end of non-void function: 146 => 
  - src/kernel/profile.c: warning: 'profile_cpu_callback' defined but not used: 355 => 
  - src/kernel/profile.c: warning: 'profile_discard_flip_buffers' defined but not used: 291 => 
  - src/kernel/profile.c: warning: 'profile_flip_buffers' defined but not used: 268 => 
  - src/kernel/trace/trace_printk.c: warning: 'fmt' may be used uninitialized in this function: 52 => 
  - src/kernel/watchdog.c: warning: 'watchdog_disable_all_cpus' defined but not used: 501 => 
  - src/kernel/watchdog.c: warning: 'watchdog_enable_all_cpus' defined but not used: 484 => 
  - src/net/core/secure_seq.c: warning: 'seq_scale' defined but not used: 23 => 
  - src/net/ipv4/route.c: warning: 'ip_rt_gc_interval' defined but not used: 123 => 
  - src/sound/soc/codecs/wm8996.c: warning: 'i' may be used uninitialized in this function: 701 => 
  - src/sound/soc/fsl/fsl_dma.c: warning: unused variable 'dai': 300 => 
  - src/sound/soc/soc-io.c: warning: 'ret' may be used uninitialized in this function: 276 => 
  - warning: (BATTERY_DS2780) selects W1 which has unmet direct dependencies (HAS_IOMEM): N/A => 
  - warning: (CAVIUM_OCTEON_REFERENCE_BOARD && SOC_AR71XX && SOC_AR724X && BCM63XX_CPU_6338) selects USB_ARCH_HAS_OHCI which has unmet direct dependencies (USB_SUPPORT): N/A => 
  - warning: (CAVIUM_OCTEON_REFERENCE_BOARD && SOC_AR71XX && SOC_AR724X && SOC_AR913X) selects USB_ARCH_HAS_EHCI which has unmet direct dependencies (USB_SUPPORT): N/A => 
  - warning: (ETRAX_USB_HOST && MOUSE_APPLETOUCH && MOUSE_BCM5974 && JOYSTICK_XPAD && TABLET_USB_ACECAD && TABLET_USB_AIPTEK && TABLET_USB_HANWANG && TABLET_USB_KBTAB && TABLET_USB_WACOM && TOUCHSCREEN_USB_COMPOSITE && INPUT_ATI_REMOTE && INPUT_ATI_REMOTE2 && INPUT_KEYSPAN_REMOTE && INPUT_POWERMATE && INPUT_YEALINK && INPUT_CM109) selects USB which has unmet direct dependencies (USB_SUPPORT && USB_ARCH_HAS_HCD): N/A => 
  - warning: (HAVE_TEXT_POKE_SMP) selects STOP_MACHINE which has unmet direct dependencies (SMP && MODULE_UNLOAD || HOTPLUG_CPU): N/A => 
  - warning: (IWLAGN && IWLWIFI_LEGACY && ATH5K && ATH9K && ATH9K_HTC && CARL9170_LEDS) selects MAC80211_LEDS which has unmet direct dependencies (NET && WIRELESS && MAC80211 && LEDS_CLASS): N/A => 
  - warning: (PM_SLEEP_SMP) selects HOTPLUG_CPU which has unmet direct dependencies (SMP && HOTPLUG && EXPERIMENTAL && (PPC_PSERIES || PPC_PMAC)): N/A => 
  - warning: (PPC_CELL_NATIVE && 440EPX && 440GRX && 440GX && 440SPe && 460EX && 460SX && APM821xx && 405EX) selects IBM_NEW_EMAC_EMAC4 which has unmet direct dependencies (NETDEVICES && NET_ETHERNET): N/A => 
  - warning: (PPC_CELL_NATIVE && 440GX && 460EX && 460SX && APM821xx) selects IBM_NEW_EMAC_TAH which has unmet direct dependencies (NETDEVICES && NET_ETHERNET): N/A => 
  - warning: (PPC_CELL_NATIVE && BLUESTONE && CANYONLANDS && GLACIER && EIGER && 440EPX && 440GRX && 440GX && 460SX && 405EX) selects IBM_NEW_EMAC_RGMII which has unmet direct dependencies (NETDEVICES && NET_ETHERNET): N/A => 
  - warning: (PPC_CELL_NATIVE && CANYONLANDS && GLACIER && 440EP && 440EPX && 440GRX && 440GP && 440GX && 460SX && 405GP) selects IBM_NEW_EMAC_ZMII which has unmet direct dependencies (NETDEVICES && NET_ETHERNET): N/A => 
  - warning: (PPC_PS3 && 440EP) selects USB_ARCH_HAS_OHCI which has unmet direct dependencies (USB_SUPPORT): N/A => 
  - warning: (PPC_PS3) selects USB_ARCH_HAS_EHCI which has unmet direct dependencies (USB_SUPPORT): N/A => 
  - warning: (PREEMPT && DEBUG_ATOMIC_SLEEP) selects PREEMPT_COUNT which has unmet direct dependencies (!MMU && COLDFIRE): N/A => 
  - warning: arch/powerpc/mm/built-in.o(.text+0x6a60): Section mismatch in reference from the function .mark_reserved_regions_for_nid() to the function .init.text:.get_node_active_region(): N/A => 
  - warning: arch/powerpc/mm/built-in.o(.text+0x6ab4): Section mismatch in reference from the function .mark_reserved_regions_for_nid() to the function .init.text:.get_node_active_region(): N/A => 
  - warning: arch/powerpc/mm/built-in.o(.text+0xb468): Section mismatch in reference from the function .mark_reserved_regions_for_nid() to the function .init.text:.get_node_active_region(): N/A => 
  - warning: arch/powerpc/mm/built-in.o(.text+0xb54c): Section mismatch in reference from the function .mark_reserved_regions_for_nid() to the function .init.text:.get_node_active_region(): N/A => 
  - warning: arch/powerpc/sysdev/built-in.o(.text+0x10014): Section mismatch in reference from the function .icp_native_init() to the function .init.text:.icp_native_init_one_node(): N/A => 
  - warning: arch/powerpc/sysdev/built-in.o(.text+0x100c4): Section mismatch in reference from the function .icp_native_init() to the function .init.text:.icp_native_init_one_node(): N/A => 
  - warning: arch/powerpc/sysdev/built-in.o(.text+0x10ac4): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics(): N/A => 
  - warning: arch/powerpc/sysdev/built-in.o(.text+0x9370): Section mismatch in reference from the function .icp_native_init() to the function .init.text:.icp_native_init_one_node(): N/A => 
  - warning: arch/powerpc/sysdev/built-in.o(.text+0x93e8): Section mismatch in reference from the function .icp_native_init() to the function .init.text:.icp_native_init_one_node(): N/A => 
  - warning: arch/powerpc/sysdev/built-in.o(.text+0x99c4): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics(): N/A => 
  - warning: arch/powerpc/sysdev/built-in.o(.text+0xe57c): Section mismatch in reference from the function .icp_native_init() to the function .init.text:.icp_native_init_one_node(): N/A => 
  - warning: arch/powerpc/sysdev/built-in.o(.text+0xe62c): Section mismatch in reference from the function .icp_native_init() to the function .init.text:.icp_native_init_one_node(): N/A => 
  - warning: arch/powerpc/sysdev/built-in.o(.text+0xf02c): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics(): N/A => 
  - warning: arch/powerpc/sysdev/xics/built-in.o(.text+0x14bc): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics(): N/A => 
  - warning: arch/powerpc/sysdev/xics/built-in.o(.text+0x1758): Section mismatch in reference from the function .icp_native_init() to the function .init.text:.icp_native_init_one_node(): N/A => 
  - warning: arch/powerpc/sysdev/xics/built-in.o(.text+0x1808): Section mismatch in reference from the function .icp_native_init() to the function .init.text:.icp_native_init_one_node(): N/A => 
  - warning: arch/powerpc/sysdev/xics/built-in.o(.text+0x2208): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics(): N/A => 
  - warning: arch/powerpc/sysdev/xics/built-in.o(.text+0xe68): Section mismatch in reference from the function .icp_native_init() to the function .init.text:.icp_native_init_one_node(): N/A => 
  - warning: arch/powerpc/sysdev/xics/built-in.o(.text+0xee0): Section mismatch in reference from the function .icp_native_init() to the function .init.text:.icp_native_init_one_node(): N/A => 
  - warning: drivers/built-in.o(.data+0xd66a0): Section mismatch in reference from the variable uio_pdrv_genirq to the variable .devinit.rodata:uio_of_genirq_match: N/A => 
  - warning: drivers/built-in.o(.text+0x2942bf0): Section mismatch in reference from the function .tc3589x_keypad_open() to the function .devinit.text:.tc3589x_keypad_init_key_hardware(): N/A => 
  - warning: drivers/input/built-in.o(.text+0x28304): Section mismatch in reference from the function .tc3589x_keypad_open() to the function .devinit.text:.tc3589x_keypad_init_key_hardware(): N/A => 
  - warning: drivers/input/keyboard/built-in.o(.text+0x10c10): Section mismatch in reference from the function .tc3589x_keypad_open() to the function .devinit.text:.tc3589x_keypad_init_key_hardware(): N/A => 
  - warning: drivers/input/keyboard/built-in.o(.text+0xc380): Section mismatch in reference from the function tc3589x_keypad_open() to the function .devinit.text:adp5520_keys_probe(): N/A => 
  - warning: drivers/mfd/built-in.o(.data+0x6400): Section mismatch in reference from the variable ab3550_driver to the function .init.text:pm860x_i2c_init(): N/A => 
  - warning: drivers/sbus/char/bbc.o(.devinit.text+0x8): Section mismatch in reference from the function bbc_i2c_probe() to the function .init.text:T.407(): N/A => 
  - warning: drivers/uio/built-in.o(.data+0x680): Section mismatch in reference from the variable uio_pdrv_genirq to the variable .devinit.rodata:uio_of_genirq_match: N/A => 
  - warning: drivers/usb/gadget/g_ffs.o(.text+0xbac2): Section mismatch in reference from the function eth_bind_config() to the function .init.text:geth_bind_config(): N/A => 
  - warning: drivers/usb/gadget/g_multi.o(.text+0x873c): Section mismatch in reference from the function cdc_config_register() to the function .init.text:cdc_do_config(): N/A => 
  - warning: drivers/usb/gadget/g_multi.o(.text+0x87a4): Section mismatch in reference from the function rndis_config_register() to the function .init.text:rndis_do_config(): N/A => 
  - warning: vmlinux.o(.devinit.text+0x9792): Section mismatch in reference from the function cnb20le_res() to the function .init.text:acpi_os_get_root_pointer(): N/A => 
  - warning: vmlinux.o(.text+0x1e724): Section mismatch in reference from the function .early_setup_secondary() to the function .cpuinit.text:.early_init_mmu_secondary(): N/A => 
  - warning: vmlinux.o(.text+0x3a6e0): Section mismatch in reference from the function .mark_reserved_regions_for_nid() to the function .init.text:.get_node_active_region(): N/A => 
  - warning: vmlinux.o(.text+0x3a734): Section mismatch in reference from the function .mark_reserved_regions_for_nid() to the function .init.text:.get_node_active_region(): N/A => 
  - warning: vmlinux.o(.text+0x3a784): Section mismatch in reference from the function .mark_reserved_regions_for_nid() to the function .init.text:.reserve_bootmem_node(): N/A => 
  - warning: vmlinux.o(.text+0x490d8): Section mismatch in reference from the function .icp_native_init() to the function .init.text:.icp_native_init_one_node(): N/A => 
  - warning: vmlinux.o(.text+0x49150): Section mismatch in reference from the function .icp_native_init() to the function .init.text:.icp_native_init_one_node(): N/A => 
  - warning: vmlinux.o(.text+0x4972c): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics(): N/A => 
  - warning: vmlinux.o(.text+0x571ac): Section mismatch in reference from the function .pci_dn_reconfig_notifier() to the function .devinit.text:.update_dn_pci_info(): N/A => 
  - warning: vmlinux.o(.text+0x5aafc): Section mismatch in reference from the function .dlpar_online_cpu() to the function .cpuinit.text:.cpu_up(): N/A => 
  - warning: vmlinux.o(.text+0x5faf8): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.pcibios_setup_bus_devices(): N/A => 
  - warning: vmlinux.o(.text+0x5fb44): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.pci_scan_bridge(): N/A => 
  - warning: vmlinux.o(.text+0x5fb80): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.of_rescan_bus(): N/A => 
  - warning: vmlinux.o(.text+0x62022): Section mismatch in reference from the variable system_reset_iSeries to the variable .init.data:boot_paca: N/A => 
  - warning: vmlinux.o(.text+0x9082): Section mismatch in reference from the variable generic_secondary_common_init to the variable .init.data:spinning_secondaries: N/A => 
  - warning: vmlinux.o(.text+0x92f0): Section mismatch in reference from the function .start_secondary_prolog() to the function .devinit.text:.start_secondary(): N/A => 
  - warning: vmlinux.o(.text+0x9304): Section mismatch in reference from the function .start_secondary_resume() to the function .devinit.text:.start_secondary(): N/A => 

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
