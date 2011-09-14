Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933015Ab1INTik (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 15:38:40 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:57685 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932890Ab1INTih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 15:38:37 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Subject: Build regressions/improvements in v3.1-rc6
Date: Wed, 14 Sep 2011 21:38:23 +0200
Message-Id: <1316029103-10390-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is the list of build error/warning regressions/improvements in
v3.1-rc6[1] compared to v3.0[2].

Summarized:
  - build errors: +79/-40
  - build warnings: +175/-261

JFYI, when comparing v3.1-rc6 to v3.1-rc5[3], the summaries are:
  - build errors: +0/-0
  - build warnings: +64/-81

Note that there may be false regressions, as some logs are incomplete.
Still, they're build errors/warnings.

As master.kernel.org is down, there's no verbose summary yet at
http://www.kernel.org/pub/linux/kernel/people/geert/linux-log/v3.1-rc6.summary.gz

Happy fixing! ;-)

Thanks to the linux-next team for providing the build service.

[1] http://kisskb.ellerman.id.au/kisskb/head/4322/ (all 108 configs)
[2] http://kisskb.ellerman.id.au/kisskb/head/4202/ (107 out of 108 configs)
[3] http://kisskb.ellerman.id.au/kisskb/head/4316/ (all 108 configs)


*** ERRORS ***

79 regressions:
  + build/linus_sparc-allmodconfig_sparc64/usr/include/linux/hidraw.h: error: expected specifier-qualifier-list before '__u32':  => 27, 22
  + build/linus_sparc-allmodconfig_sparc64/usr/include/linux/input.h: error: expected specifier-qualifier-list before '__s16':  => 958, 969
  + build/linus_sparc-allmodconfig_sparc64/usr/include/linux/input.h: error: expected specifier-qualifier-list before '__s32':  => 65
  + build/linus_sparc-allmodconfig_sparc64/usr/include/linux/input.h: error: expected specifier-qualifier-list before '__u16':  => 1035, 39, 919, 1063, 985, 929, 23, 1014, 946
  + build/linus_sparc-allmodconfig_sparc64/usr/include/linux/input.h: error: expected specifier-qualifier-list before '__u8':  => 90
  + build/linus_sparc-allmodconfig_sparc64/usr/include/linux/types.h: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__be16':  => 28
  + build/linus_sparc-allmodconfig_sparc64/usr/include/linux/types.h: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__be32':  => 30
  + build/linus_sparc-allmodconfig_sparc64/usr/include/linux/types.h: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__be64':  => 32
  + build/linus_sparc-allmodconfig_sparc64/usr/include/linux/types.h: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__le16':  => 27
  + build/linus_sparc-allmodconfig_sparc64/usr/include/linux/types.h: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__le32':  => 29
  + build/linus_sparc-allmodconfig_sparc64/usr/include/linux/types.h: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__le64':  => 31
  + build/linus_sparc-allmodconfig_sparc64/usr/include/linux/types.h: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__sum16':  => 34
  + build/linus_sparc-allmodconfig_sparc64/usr/include/linux/types.h: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__wsum':  => 35
  + error: vsprintf.c: relocation truncated to fit: R_AVR32_11H_PCREL against `.text'+500:  => (.text+0x906)
  + src/arch/parisc/lib/iomap.c: error: redefinition of 'pci_iomap':  => 440
  + src/arch/parisc/lib/iomap.c: error: redefinition of 'pci_iounmap':  => 461
  + src/arch/powerpc/kernel/exceptions-64s.S: Error: attempt to move .org backwards:  => 1160, 1151
  + src/arch/powerpc/kernel/jump_label.c: error: dereferencing pointer to incomplete type:  => 17, 20
  + src/arch/xtensa/include/asm/irqflags.h: Error: invalid symbolic operand:  => 26
  + src/drivers/hwmon/sch56xx-common.c: error: implicit declaration of function 'inb':  => 54
  + src/drivers/hwmon/sch56xx-common.c: error: implicit declaration of function 'outb':  => 53
  + src/drivers/i2c/busses/i2c-elektor.c: error: implicit declaration of function 'ioport_map':  => 153
  + src/drivers/i2c/busses/i2c-elektor.c: error: implicit declaration of function 'ioport_unmap':  => 287
  + src/drivers/net/wireless/libertas/if_cs.c: error: implicit declaration of function 'ioport_map':  => 841
  + src/drivers/net/wireless/libertas/if_cs.c: error: implicit declaration of function 'ioport_unmap':  => 786
  + src/drivers/net/wireless/orinoco/orinoco_cs.c: error: implicit declaration of function 'ioport_map':  => 154
  + src/drivers/net/wireless/orinoco/orinoco_cs.c: error: implicit declaration of function 'ioport_unmap':  => 206
  + src/drivers/net/wireless/orinoco/spectrum_cs.c: error: implicit declaration of function 'ioport_map':  => 217
  + src/drivers/net/wireless/orinoco/spectrum_cs.c: error: implicit declaration of function 'ioport_unmap':  => 274
  + src/drivers/net/wireless/rtlwifi/rtl8192de/../pci.h: error: implicit declaration of function 'inb':  => 288
  + src/drivers/net/wireless/rtlwifi/rtl8192de/../pci.h: error: implicit declaration of function 'inl':  => 298
  + src/drivers/net/wireless/rtlwifi/rtl8192de/../pci.h: error: implicit declaration of function 'inw':  => 293
  + src/drivers/net/wireless/rtlwifi/rtl8192de/../pci.h: error: implicit declaration of function 'outb':  => 283
  + src/drivers/net/wireless/rtlwifi/rtl8192de/../pci.h: error: implicit declaration of function 'outl':  => 278
  + src/drivers/staging/ft1000/ft1000-pcmcia/ft1000.h: error: implicit declaration of function 'inw':  => 80
  + src/drivers/staging/ft1000/ft1000-pcmcia/ft1000.h: error: implicit declaration of function 'outw':  => 86
  + src/drivers/usb/gadget/m66592-udc.h: error: implicit declaration of function 'ioread16':  => 540
  + src/drivers/usb/gadget/m66592-udc.h: error: implicit declaration of function 'ioread16_rep':  => 554
  + src/drivers/usb/gadget/m66592-udc.h: error: implicit declaration of function 'ioread32_rep':  => 551
  + src/drivers/usb/gadget/m66592-udc.h: error: implicit declaration of function 'iowrite16':  => 561
  + src/drivers/usb/gadget/m66592-udc.h: error: implicit declaration of function 'iowrite16_rep':  => 606
  + src/drivers/usb/gadget/m66592-udc.h: error: implicit declaration of function 'iowrite32_rep':  => 591
  + src/drivers/usb/gadget/m66592-udc.h: error: implicit declaration of function 'iowrite8':  => 597
  + src/drivers/usb/gadget/r8a66597-udc.h: error: implicit declaration of function 'ioread16':  => 130
  + src/drivers/usb/gadget/r8a66597-udc.h: error: implicit declaration of function 'ioread16_rep':  => 164
  + src/drivers/usb/gadget/r8a66597-udc.h: error: implicit declaration of function 'ioread32':  => 155
  + src/drivers/usb/gadget/r8a66597-udc.h: error: implicit declaration of function 'ioread32_rep':  => 147
  + src/drivers/usb/gadget/r8a66597-udc.h: error: implicit declaration of function 'iowrite16':  => 182
  + src/drivers/usb/gadget/r8a66597-udc.h: error: implicit declaration of function 'iowrite16_rep':  => 204
  + src/drivers/usb/gadget/r8a66597-udc.h: error: implicit declaration of function 'iowrite32_rep':  => 197
  + src/drivers/usb/gadget/r8a66597-udc.h: error: implicit declaration of function 'iowrite8':  => 219
  + src/include/asm-generic/gpio.h: error: implicit declaration of function 'gpio_get_value':  => 223
  + src/include/asm-generic/gpio.h: error: implicit declaration of function 'gpio_set_value':  => 229
  + src/include/asm-generic/iomap.h: error: previous definition of 'pci_iomap' was here:  => 77
  + src/include/asm-generic/iomap.h: error: previous definition of 'pci_iounmap' was here:  => 81
  + src/include/linux/prefetch.h: Error: couldn't find a valid instruction format:  => 62
  + src/include/linux/prefetch.h: Error: unknown opcode or format name 'static':  => 53
  + src/include/linux/sh_pfc.h: error: field 'chip' has incomplete type:  => 91
  + src/mm/memcontrol.c: error: this is the insn::  => 4096
  + src/mm/memcontrol.c: error: unable to find a register to spill in class 'R0_REGS':  => 4096
  + src/net/mac80211/cfg.c: error: 'struct <anonymous>' has no member named 'tx_pn':  => 271, 260
  + src/net/mac80211/cfg.c: error: implicit declaration of function 'atomic64_read':  => 260
  + src/net/mac80211/debugfs_key.c: error: 'struct <anonymous>' has no member named 'icverrors':  => 193
  + src/net/mac80211/debugfs_key.c: error: 'struct <anonymous>' has no member named 'replays':  => 170, 174
  + src/net/mac80211/debugfs_key.c: error: 'struct <anonymous>' has no member named 'rx_pn':  => 147, 138
  + src/net/mac80211/debugfs_key.c: error: 'struct <anonymous>' has no member named 'tx_pn':  => 103, 97
  + src/net/mac80211/debugfs_key.c: error: implicit declaration of function 'atomic64_read':  => 97
  + src/net/mac80211/key.c: error: 'struct <anonymous>' has no member named 'rx_pn':  => 697, 689, 691, 399, 380
  + src/net/mac80211/key.c: error: 'struct <anonymous>' has no member named 'tfm':  => 436, 387, 389, 406, 407, 434, 388, 404
  + src/net/mac80211/key.c: error: 'struct <anonymous>' has no member named 'tx_pn':  => 656, 647
  + src/net/mac80211/key.c: error: implicit declaration of function 'atomic64_read':  => 647
  + src/net/mac80211/key.h: error: expected specifier-qualifier-list before 'atomic64_t':  => 88, 100
  + src/net/mac80211/rx.c: error: 'struct <anonymous>' has no member named 'rx_pn':  => 1427, 1396
  + src/net/mac80211/wpa.c: error: 'struct <anonymous>' has no member named 'icverrors':  => 619
  + src/net/mac80211/wpa.c: error: 'struct <anonymous>' has no member named 'replays':  => 484, 609
  + src/net/mac80211/wpa.c: error: 'struct <anonymous>' has no member named 'rx_pn':  => 501, 483, 608, 624
  + src/net/mac80211/wpa.c: error: 'struct <anonymous>' has no member named 'tfm':  => 434, 577, 494, 616
  + src/net/mac80211/wpa.c: error: 'struct <anonymous>' has no member named 'tx_pn':  => 568, 417
  + src/net/mac80211/wpa.c: error: implicit declaration of function 'atomic64_inc_return':  => 417

40 improvements:
  - error: vsprintf.c: relocation truncated to fit: R_AVR32_11H_PCREL against `.text'+61c: (.text+0xa22) => 
  - src/arch/cris/arch-v10/drivers/sync_serial.c: error: 'ret' undeclared (first use in this function): 628 => 
  - src/arch/cris/arch-v10/drivers/sync_serial.c: error: (Each undeclared identifier is reported only once: 628 => 
  - src/arch/cris/arch-v10/drivers/sync_serial.c: error: conflicting types for 'sync_serial_ioctl': 961 => 
  - src/arch/cris/arch-v10/drivers/sync_serial.c: error: for each function it appears in.): 628 => 
  - src/arch/cris/arch-v10/drivers/sync_serial.c: error: previous declaration of 'sync_serial_ioctl' was here: 161 => 
  - src/arch/cris/arch-v10/kernel/irq.c: error: implicit declaration of function 'breakpoint': 240 => 
  - src/arch/cris/arch-v10/kernel/irq.c: error: implicit declaration of function 'kgdb_init': 239 => 
  - src/arch/powerpc/platforms/embedded6xx/wii.c: error: format '%08llx' expects type 'long long unsigned int', but argument 2 has type 'phys_addr_t': 90, 88 => 
  - src/arch/powerpc/platforms/embedded6xx/wii.c: error: format '%08llx' expects type 'long long unsigned int', but argument 3 has type 'phys_addr_t': 90, 88 => 
  - src/arch/powerpc/sysdev/mv64x60_dev.c: error: assignment makes pointer from integer without a cast: 253 => 
  - src/arch/powerpc/sysdev/mv64x60_dev.c: error: implicit declaration of function 'of_get_mac_address': 253 => 
  - src/arch/powerpc/sysdev/tsi108_dev.c: error: assignment makes pointer from integer without a cast: 108 => 
  - src/arch/powerpc/sysdev/tsi108_dev.c: error: implicit declaration of function 'of_get_mac_address': 108 => 
  - src/arch/xtensa/include/asm/uaccess.h: error: implicit declaration of function 'prefetch': 403 => 
  - src/arch/xtensa/include/asm/uaccess.h: error: implicit declaration of function 'prefetchw': 412 => 
  - src/drivers/hwmon/lm78.c: error: implicit declaration of function 'inb_p': 750 => 
  - src/drivers/hwmon/lm78.c: error: implicit declaration of function 'outb_p': 749 => 
  - src/drivers/hwmon/sch5627.c: error: implicit declaration of function 'inb': 120 => 
  - src/drivers/hwmon/sch5627.c: error: implicit declaration of function 'outb': 119 => 
  - src/drivers/parport/parport_pc.c: error: implicit declaration of function 'outsb': 592, 388 => 388
  - src/drivers/staging/dt3155v4l/dt3155v4l.c: error: implicit declaration of function 'kzalloc': 434 => 
  - src/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dev.h: error: implicit declaration of function 'inw': 44 => 
  - src/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dev.h: error: implicit declaration of function 'outw': 62 => 
  - src/drivers/staging/solo6x10/core.c: error: implicit declaration of function 'kzalloc': 140 => 
  - src/drivers/staging/solo6x10/enc.c: error: implicit declaration of function 'kzalloc': 101 => 
  - src/drivers/staging/solo6x10/g723.c: error: implicit declaration of function 'kzalloc': 139 => 
  - src/drivers/staging/solo6x10/p2m.c: error: implicit declaration of function 'kzalloc': 52 => 
  - src/drivers/staging/speakup/serialio.h: error: asm/serial.h: No such file or directory: 9:24 => 
  - src/drivers/staging/tty/riscom8.c: error: implicit declaration of function 'inb': 165 => 
  - src/drivers/staging/tty/riscom8.c: error: implicit declaration of function 'outb': 172 => 
  - src/drivers/staging/tty/specialix.c: error: implicit declaration of function 'inb': 228 => 
  - src/drivers/staging/tty/specialix.c: error: implicit declaration of function 'outb': 227 => 
  - src/drivers/staging/tty/specialix.c: error: invalid operands to binary | (have 'void *' and 'int'): 237, 227 => 
  - src/drivers/tty/serial/8250.c: error: asm/serial.h: No such file or directory: 109:24 => 
  - src/drivers/tty/serial/8250_early.c: error: 'BASE_BAUD' undeclared (first use in this function): 160 => 
  - src/drivers/tty/serial/8250_early.c: error: (Each undeclared identifier is reported only once: 160 => 
  - src/drivers/tty/serial/8250_early.c: error: asm/serial.h: No such file or directory: 37:24 => 
  - src/drivers/tty/serial/8250_early.c: error: for each function it appears in.): 160 => 
  - src/kernel/fork.c: error: implicit declaration of function 'alloc_thread_info_node': 266 => 


*** WARNINGS ***

175 regressions:
  + .config: warning: override: HIGHMEM4G changes choice state:  => 335
  + /tmp/ccq656OK.s: Warning: source register same as write-back base:  => 104
  + <stdin>: warning: #warning syscall sync_file_range not implemented:  => 1430:2
  + <stdin>: warning: #warning syscall umount2 not implemented:  => 394:2
  + include/generated/autoconf.h: warning: this is the location of the previous definition:  => 5707:1, 4837:1, 6559:1, 3531:1, 4669:1, 4551:1, 6081:1, 6234:1, 5629:1
  + modpost: WARNING: modpost: Found 12 section mismatch(es).:  => N/A
  + modpost: WARNING: modpost: Found 13 section mismatch(es).:  => N/A
  + modpost: WARNING: modpost: Found 14 section mismatch(es).:  => N/A
  + src/arch/alpha/kernel/pci.c: warning: passing argument 2 of 'pci_fixup_irqs' from incompatible pointer type:  => 438
  + src/arch/alpha/kernel/sys_alcor.c: warning: initialization from incompatible pointer type:  => 273, 300
  + src/arch/alpha/kernel/sys_cabriolet.c: warning: initialization from incompatible pointer type:  => 365, 440, 338, 389, 415
  + src/arch/alpha/kernel/sys_dp264.c: warning: initialization from incompatible pointer type:  => 595, 571, 641, 669, 618
  + src/arch/alpha/kernel/sys_dp264.c: warning: passing argument 1 of 'isa_irq_fixup' discards qualifiers from pointer target type:  => 403, 510, 487, 432
  + src/arch/alpha/kernel/sys_eb64p.c: warning: initialization from incompatible pointer type:  => 234, 210
  + src/arch/alpha/kernel/sys_eiger.c: warning: initialization from incompatible pointer type:  => 224
  + src/arch/alpha/kernel/sys_eiger.c: warning: passing argument 1 of 'pci_read_config_byte' discards qualifiers from pointer target type:  => 158
  + src/arch/alpha/kernel/sys_miata.c: warning: initialization from incompatible pointer type:  => 290
  + src/arch/alpha/kernel/sys_mikasa.c: warning: initialization from incompatible pointer type:  => 243, 218
  + src/arch/alpha/kernel/sys_nautilus.c: warning: initialization from incompatible pointer type:  => 277
  + src/arch/alpha/kernel/sys_nautilus.c: warning: passing argument 1 of 'pci_read_config_byte' discards qualifiers from pointer target type:  => 79
  + src/arch/alpha/kernel/sys_nautilus.c: warning: passing argument 2 of 'pci_fixup_irqs' from incompatible pointer type:  => 252
  + src/arch/alpha/kernel/sys_noritake.c: warning: initialization from incompatible pointer type:  => 332, 307
  + src/arch/alpha/kernel/sys_rawhide.c: warning: initialization from incompatible pointer type:  => 269
  + src/arch/alpha/kernel/sys_ruffian.c: warning: initialization from incompatible pointer type:  => 237
  + src/arch/alpha/kernel/sys_rx164.c: warning: initialization from incompatible pointer type:  => 200
  + src/arch/alpha/kernel/sys_sable.c: warning: initialization from incompatible pointer type:  => 628, 597, 565
  + src/arch/alpha/kernel/sys_sio.c: warning: initialization from incompatible pointer type:  => 387, 328, 425, 454, 358
  + src/arch/alpha/kernel/sys_sx164.c: warning: initialization from incompatible pointer type:  => 175
  + src/arch/alpha/kernel/sys_takara.c: warning: assignment from incompatible pointer type:  => 250
  + src/arch/alpha/kernel/sys_takara.c: warning: initialization from incompatible pointer type:  => 286
  + src/arch/mips/mm/tlbex.c: warning: 'wr.r1' is used uninitialized in this function:  => 1769
  + src/arch/mips/mm/tlbex.c: warning: 'wr.r2' is used uninitialized in this function:  => 1769
  + src/arch/mips/mm/tlbex.c: warning: 'wr.r3' is used uninitialized in this function:  => 1769
  + src/arch/powerpc/kernel/jump_label.c: warning: 'struct jump_entry' declared inside parameter list:  => 15
  + src/arch/powerpc/kernel/jump_label.c: warning: its scope is only this definition or declaration, which is probably not what you want:  => 15
  + src/arch/sh/include/cpu-sh2/cpu/dma.h: warning: "CHCR" redefined:  => 18:1
  + src/arch/sh/include/cpu-sh2/cpu/dma.h: warning: "DAR" redefined:  => 16:1
  + src/arch/sh/include/cpu-sh2/cpu/dma.h: warning: "DMAOR" redefined:  => 20:1
  + src/arch/sh/include/cpu-sh2/cpu/dma.h: warning: "SAR" redefined:  => 15:1
  + src/arch/sh/kernel/cpu/clock-cpg.c: warning: 'cpg_clk_init' is deprecated (declared at /scratch/kisskb/src/arch/sh/kernel/cpu/clock-cpg.c:47):  => 73
  + src/arch/x86/kvm/vmx.c: warning: 'save' may be used uninitialized in this function:  => 2954
  + src/arch/x86/kvm/x86.c: warning: 'exchanged' may be used uninitialized in this function:  => 4209
  + src/arch/xtensa/include/asm/regs.h: warning: this is the location of the previous definition:  => 59:1
  + src/arch/xtensa/kernel/entry.S: Warning: value 0xffffffff30000000 truncated to 0x30000000:  => 1545
  + src/arch/xtensa/kernel/irq.c: warning: passing argument 1 of 'xtensa_irq_mask' makes pointer from integer without a cast:  => 92
  + src/arch/xtensa/kernel/irq.c: warning: passing argument 1 of 'xtensa_irq_unmask' makes pointer from integer without a cast:  => 87
  + src/arch/xtensa/kernel/process.c: warning: unused variable 'ti':  => 180
  + src/arch/xtensa/kernel/time.c: warning: initialization from incompatible pointer type:  => 42
  + src/arch/xtensa/mm/tlb.c: warning: comparison of distinct pointer types lacks a cast:  => 71, 68
  + src/drivers/ata/pata_atiixp.c: warning: 'wanted_pio' may be used uninitialized in this function:  => 115
  + src/drivers/gpu/drm/radeon/ni.c: warning: 'chip_name' may be used uninitialized in this function:  => 276
  + src/drivers/gpu/drm/radeon/ni.c: warning: 'mc_req_size' may be used uninitialized in this function:  => 278
  + src/drivers/gpu/drm/radeon/ni.c: warning: 'me_req_size' may be used uninitialized in this function:  => 278
  + src/drivers/gpu/drm/radeon/ni.c: warning: 'pfp_req_size' may be used uninitialized in this function:  => 278
  + src/drivers/gpu/drm/radeon/ni.c: warning: 'rlc_chip_name' may be used uninitialized in this function:  => 277
  + src/drivers/gpu/drm/radeon/ni.c: warning: 'rlc_req_size' may be used uninitialized in this function:  => 278
  + src/drivers/gpu/drm/radeon/r600.c: warning: 'chip_name' may be used uninitialized in this function:  => 1956
  + src/drivers/gpu/drm/radeon/r600.c: warning: 'rlc_chip_name' may be used uninitialized in this function:  => 1957
  + src/drivers/i2c/busses/i2c-elektor.c: warning: assignment makes pointer from integer without a cast:  => 153
  + src/drivers/input/keyboard/gpio_keys.c: warning: 'flags' may be used uninitialized in this function:  => 499
  + src/drivers/input/misc/twl6040-vibra.c: warning: "CONFIG_PM_SLEEP" is not defined:  => 231:5
  + src/drivers/md/md.c: warning: large integer implicitly truncated to unsigned type:  => 1425, 1143
  + src/drivers/media/dvb/firewire/firedtv-avc.c: warning: 'pos' may be used uninitialized in this function:  => 591
  + src/drivers/media/dvb/pt1/va1j5jf8007s.c: warning: control reaches end of non-void function:  => 508, 143
  + src/drivers/media/dvb/pt1/va1j5jf8007t.c: warning: control reaches end of non-void function:  => 127, 354
  + src/drivers/media/rc/redrat3.c: warning: assignment from incompatible pointer type:  => 1107
  + src/drivers/media/video/em28xx/em28xx-core.c: warning: 'packet_size' may be used uninitialized in this function:  => 1116
  + src/drivers/mtd/maps/latch-addr-flash.c: warning: 'latch_addr_flash_remove' defined but not used:  => 102
  + src/drivers/net/qlcnic/qlcnic_main.c: warning: 'pci_using_dac' may be used uninitialized in this function:  => 1538
  + src/drivers/net/vxge/vxge-main.c: warning: 'adaptive_coalesce_rx_interrupts' defined but not used: 2149 => 2143, 2144
  + src/drivers/net/vxge/vxge-main.c: warning: 'adaptive_coalesce_tx_interrupts' defined but not used: 2121 => 2115, 2116
  + src/drivers/net/wireless/b43/phy_lcn.h: warning: no newline at end of file:  => 14:28
  + src/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c: warning: passing argument 2 of 'dma_map_single' discards qualifiers from pointer target type:  => 665
  + src/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c: warning: passing argument 2 of 'dma_map_single_attrs' discards qualifiers from pointer target type:  => 665
  + src/drivers/net/wireless/libertas/if_cs.c: warning: assignment makes pointer from integer without a cast:  => 842
  + src/drivers/net/wireless/orinoco/orinoco_cs.c: warning: assignment makes pointer from integer without a cast:  => 155
  + src/drivers/net/wireless/orinoco/spectrum_cs.c: warning: assignment makes pointer from integer without a cast:  => 218
  + src/drivers/net/wireless/rtlwifi/rtl8192de/dm.c: warning: comparison is always false due to limited range of data type:  => 1067
  + src/drivers/net/wireless/rtlwifi/rtl8192de/hw.c: warning: unused variable 'rtlpci':  => 1234
  + src/drivers/net/wireless/rtlwifi/rtl8192de/trx.c: warning: 'rx_pwr_all' may be used uninitialized in this function:  => 217
  + src/drivers/net/wireless/rtlwifi/rtl8192se/hw.c: warning: unused variable 'rtlpci':  => 1223
  + src/drivers/of/of_net.c: warning: type qualifiers ignored on function return type:  => 41
  + src/drivers/scsi/g_NCR5380.c: warning: 'id_table' defined but not used:  => 943
  + src/drivers/scsi/lpfc/lpfc_attr.c: warning: 'portstat_reg.word0' may be used uninitialized in this function:  => 771
  + src/drivers/scsi/megaraid/megaraid_mbox.c: warning: 'megaraid_detach_one' defined but not used:  => 560
  + src/drivers/scsi/mpt2sas/mpt2sas_scsih.c: warning: unused variable 'event_data':  => 5595
  + src/drivers/scsi/scsi_debug.c: warning: comparison of distinct pointer types lacks a cast:  => 1879, 1788, 1998, 2025, 2046, 1718
  + src/drivers/scsi/scsi_debug.c: warning: passing argument 1 of '__div64_32' from incompatible pointer type:  => 1879, 1788, 1998, 2025, 2046, 1718
  + src/drivers/scsi/scsi_debug.c: warning: right shift count >= width of type:  => 1879, 1788, 1998, 2025, 2046, 1718
  + src/drivers/spi/spi-topcliff-pch.c: warning: 'bpw_len' may be used uninitialized in this function:  => 270
  + src/drivers/spi/spi-topcliff-pch.c: warning: 'tx_index' may be used uninitialized in this function:  => 270
  + src/drivers/staging/gma500/mid_bios.c: warning: cast from pointer to integer of different size:  => 200, 191, 201
  + src/drivers/staging/iio/dac/ad5504.c: warning: 'st' may be used uninitialized in this function:  => 281
  + src/drivers/staging/iio/dac/ad5791.c: warning: label 'error_ret' defined but not used:  => 384
  + src/drivers/staging/iio/light/tsl2563.c: warning: 'id' may be used uninitialized in this function:  => 736
  + src/drivers/staging/iio/meter/ade7854.c: warning: label 'error_ret' defined but not used:  => 585
  + src/drivers/staging/iio/resolver/ad2s120x.c: warning: 'pos' may be used uninitialized in this function:  => 46
  + src/drivers/staging/iio/resolver/ad2s120x.c: warning: 'vel' may be used uninitialized in this function:  => 47
  + src/drivers/staging/vt6655/device_main.c: warning: the frame size of 1296 bytes is larger than 1024 bytes:  => 3578
  + src/drivers/staging/vt6655/iwctl.c: warning: the frame size of 1280 bytes is larger than 1024 bytes:  => 817
  + src/drivers/staging/zcache/zcache-main.c: warning: 'enable_zcache' defined but not used:  => 1908, 1909
  + src/drivers/staging/zcache/zcache-main.c: warning: 'no_cleancache' defined but not used:  => 1919, 1920
  + src/drivers/staging/zcache/zcache-main.c: warning: 'no_frontswap' defined but not used:  => 1929, 1930
  + src/drivers/target/iscsi/iscsi_target_util.c: warning: 'iscsit_do_rx_data' uses dynamic stack allocation:  => 1555
  + src/drivers/target/iscsi/iscsi_target_util.c: warning: 'iscsit_do_tx_data' uses dynamic stack allocation:  => 1686
  + src/drivers/tty/serial/pch_uart.c: warning: 'pch_uart_pci_remove' defined but not used:  => 1486
  + src/drivers/usb/gadget/pch_udc.c: warning: 'retval' may be used uninitialized in this function:  => 2875
  + src/drivers/usb/storage/ene_ub6250.c: warning: 'offset' may be used uninitialized in this function:  => 1765
  + src/drivers/usb/storage/ene_ub6250.c: warning: 'result' may be used uninitialized in this function:  => 1728
  + src/drivers/usb/storage/realtek_cr.c: warning: 'fw5895_init' defined but not used:  => 605, 606
  + src/drivers/video/sis/sis_main.c: warning: #warning Neither CONFIG_FB_SIS_300 nor CONFIG_FB_SIS_315 is set:  => 64:2
  + src/drivers/video/sis/sis_main.c: warning: #warning sisfb will not work!:  => 65:2
  + src/drivers/video/sis/sis_main.c: warning: 'sisfb_post_map_vram' defined but not used:  => 4163
  + src/drivers/virtio/virtio_balloon.c: warning: 'events[11]' is used uninitialized in this function:  => 185
  + src/drivers/virtio/virtio_balloon.c: warning: 'events[12]' is used uninitialized in this function:  => 184
  + src/drivers/virtio/virtio_balloon.c: warning: 'events[2]' is used uninitialized in this function:  => 180
  + src/drivers/virtio/virtio_balloon.c: warning: 'events[3]' is used uninitialized in this function:  => 182
  + src/drivers/watchdog/gef_wdt.c: warning: 'gef_wdt_remove' defined but not used:  => 287
  + src/fs/gfs2/dir.c: warning: 'leaf_no' may be used uninitialized in this function:  => 969, 762
  + src/fs/isofs/compress.c: warning: 'zisofs_readpage' uses dynamic stack allocation  CC      drivers/scsi/sd_dif.o:  => 360
  + src/fs/jfs/jfs_dmap.c: warning: 'leafidx' may be used uninitialized in this function:  => 1622
  + src/fs/nfs/callback_proc.c: warning: 'lo' may be used uninitialized in this function:  => 115
  + src/fs/qnx4/namei.c: warning: 'ino' may be used uninitialized in this function:  => 103
  + src/fs/sysfs/dir.c: warning: 'sysfs_pathname' defined but not used: 415 => 414, 415
  + src/fs/xfs/xfs_acl.c: warning: 'ea_name' may be used uninitialized in this function:  => 110
  + src/include/linux/of_net.h: warning: type qualifiers ignored on function return type:  => 12
  + src/include/linux/posix_acl.h: warning: control reaches end of non-void function:  => 101
  + src/include/linux/sh_dma.h: warning: this is the location of the previous definition:  => 77:1, 75:1, 78:1, 74:1
  + src/kernel/irq/debug.h: warning: "PS" redefined:  => 8:1
  + src/kernel/sys.c: warning: 'override_release' uses dynamic stack allocation:  => 1194
  + src/kernel/trace/ring_buffer.c: warning: unused variable 'local_clock_stable':  => 2189
  + src/kernel/watchdog.c: warning: 'watchdog_disable_all_cpus' defined but not used:  => 501
  + src/kernel/watchdog.c: warning: 'watchdog_enable_all_cpus' defined but not used:  => 484
  + src/lib/debugobjects.c: warning: 'obj_states' defined but not used:  => 73
  + src/lib/debugobjects.c: warning: unused variable 'hint':  => 256
  + src/net/core/secure_seq.c: warning: 'seq_scale' defined but not used:  => 22
  + src/net/netfilter/ipset/ip_set_hash_ipportnet.c: warning: 'ip_to' may be used uninitialized in this function:  => 187
  + src/sound/soc/blackfin/bf5xx-ad73311.c: warning: initialization from incompatible pointer type:  => 195
  + src/sound/soc/codecs/wm8996.c: warning: 'bclk_reg' may be used uninitialized in this function:  => 1578
  + src/sound/soc/codecs/wm8996.c: warning: 'i' may be used uninitialized in this function:  => 701
  + src/sound/soc/fsl/fsl_dma.c: warning: unused variable 'dai':  => 300
  + src/sound/soc/soc-io.c: warning: 'ret' may be used uninitialized in this function:  => 276
  + warning: "cause_of_death" [vmlinux] is COMMON symbol:  => N/A
  + warning: (IMA) selects TCG_TPM which has unmet direct dependencies (HAS_IOMEM && EXPERIMENTAL):  => N/A
  + warning: (IWM && WIMAX_IWMC3200_SDIO) selects IWMC3200TOP which has unmet direct dependencies (MISC_DEVICES && MMC && EXPERIMENTAL):  => N/A
  + warning: (MTD_DOC2000 && MTD_DOC2001 && MTD_DOC2001PLUS) selects MTD_NAND_IDS which has unmet direct dependencies (MTD && MTD_NAND):  => N/A
  + warning: (OLPC_XO1_PM && OLPC_XO1_SCI && I2C_ISCH && GPIO_SCH && GPIO_RDC321X && RADIO_WL1273) selects MFD_CORE which has unmet direct dependencies (MFD_SUPPORT):  => N/A
  + warning: (PM_SLEEP_SMP) selects HOTPLUG_CPU which has unmet direct dependencies (SMP && HOTPLUG && EXPERIMENTAL && (PPC_PSERIES || PPC_PMAC)):  => N/A
  + warning: (PREEMPT && DEBUG_ATOMIC_SLEEP) selects PREEMPT_COUNT which has unmet direct dependencies (!MMU && COLDFIRE):  => N/A
  + warning: (SCSI_SRP) selects SCSI_TGT which has unmet direct dependencies (SCSI && EXPERIMENTAL):  => N/A
  + warning: arch/powerpc/mm/built-in.o(.text+0xb468): Section mismatch in reference from the function .mark_reserved_regions_for_nid() to the function .init.text:.get_node_active_region():  => N/A
  + warning: arch/powerpc/mm/built-in.o(.text+0xb54c): Section mismatch in reference from the function .mark_reserved_regions_for_nid() to the function .init.text:.get_node_active_region():  => N/A
  + warning: arch/powerpc/sysdev/built-in.o(.text+0x10014): Section mismatch in reference from the function .icp_native_init() to the function .init.text:.icp_native_init_one_node():  => N/A
  + warning: arch/powerpc/sysdev/built-in.o(.text+0x100c4): Section mismatch in reference from the function .icp_native_init() to the function .init.text:.icp_native_init_one_node():  => N/A
  + warning: arch/powerpc/sysdev/built-in.o(.text+0x10ac4): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics():  => N/A
  + warning: arch/powerpc/sysdev/built-in.o(.text+0xe57c): Section mismatch in reference from the function .icp_native_init() to the function .init.text:.icp_native_init_one_node():  => N/A
  + warning: arch/powerpc/sysdev/built-in.o(.text+0xe62c): Section mismatch in reference from the function .icp_native_init() to the function .init.text:.icp_native_init_one_node():  => N/A
  + warning: arch/powerpc/sysdev/built-in.o(.text+0xf02c): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics():  => N/A
  + warning: arch/powerpc/sysdev/xics/built-in.o(.text+0x1758): Section mismatch in reference from the function .icp_native_init() to the function .init.text:.icp_native_init_one_node():  => N/A
  + warning: arch/powerpc/sysdev/xics/built-in.o(.text+0x1808): Section mismatch in reference from the function .icp_native_init() to the function .init.text:.icp_native_init_one_node():  => N/A
  + warning: arch/powerpc/sysdev/xics/built-in.o(.text+0x2208): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics():  => N/A
  + warning: drivers/built-in.o(.data+0xd6688): Section mismatch in reference from the variable uio_pdrv_genirq to the variable .devinit.rodata:uio_of_genirq_match:  => N/A
  + warning: drivers/built-in.o(.text+0x29410a4): Section mismatch in reference from the function .tc3589x_keypad_open() to the function .devinit.text:.tc3589x_keypad_init_key_hardware():  => N/A
  + warning: drivers/input/built-in.o(.text+0x28304): Section mismatch in reference from the function .tc3589x_keypad_open() to the function .devinit.text:.tc3589x_keypad_init_key_hardware():  => N/A
  + warning: drivers/input/keyboard/built-in.o(.text+0x10c10): Section mismatch in reference from the function .tc3589x_keypad_open() to the function .devinit.text:.tc3589x_keypad_init_key_hardware():  => N/A
  + warning: drivers/input/keyboard/built-in.o(.text+0xc380): Section mismatch in reference from the function tc3589x_keypad_open() to the function .devinit.text:adp5520_keys_probe():  => N/A
  + warning: drivers/mfd/built-in.o(.data+0x6400): Section mismatch in reference from the variable ab3550_driver to the function .init.text:pm860x_i2c_init():  => N/A
  + warning: drivers/sbus/char/bbc.o(.devinit.text+0x8): Section mismatch in reference from the function bbc_i2c_probe() to the function .init.text:T.407():  => N/A
  + warning: drivers/spi/spi-topcliff-pch.o(.data+0x30): Section mismatch in reference from the variable pch_spi_pcidev to the function .devinit.text:pch_spi_probe():  => N/A
  + warning: drivers/spi/spi-topcliff-pch.o(.data+0x38): Section mismatch in reference from the variable pch_spi_pcidev to the function .devexit.text:pch_spi_remove():  => N/A
  + warning: drivers/uio/built-in.o(.data+0x680): Section mismatch in reference from the variable uio_pdrv_genirq to the variable .devinit.rodata:uio_of_genirq_match:  => N/A
  + warning: drivers/usb/gadget/g_ffs.o(.text+0xbac2): Section mismatch in reference from the function eth_bind_config() to the function .init.text:geth_bind_config():  => N/A
  + warning: drivers/usb/gadget/g_multi.o(.text+0x873c): Section mismatch in reference from the function cdc_config_register() to the function .init.text:cdc_do_config():  => N/A
  + warning: drivers/usb/gadget/g_multi.o(.text+0x87a4): Section mismatch in reference from the function rndis_config_register() to the function .init.text:rndis_do_config():  => N/A
  + warning: vmlinux.o(.devinit.text+0x9761): Section mismatch in reference from the function cnb20le_res() to the function .init.text:acpi_os_get_root_pointer():  => N/A

261 improvements:
  - ./include/generated/autoconf.h: warning: this is the location of the previous definition: 1874:1, 2155:1, 1163:1, 1517:1, 1482:1, 1851:1, 2004:1, 1585:1, 2048:1 => 
  - /tmp/cccOYI2m.s: Warning: source register same as write-back base: 104 => 
  - modpost: WARNING: modpost: Found 16 section mismatch(es).: N/A => 
  - modpost: WARNING: modpost: Found 17 section mismatch(es).: N/A => 
  - modpost: WARNING: modpost: Found 8 section mismatch(es).: N/A => 
  - src/arch/cris/arch-v10/drivers/sync_serial.c: warning: initialization from incompatible pointer type: 252 => 
  - src/arch/cris/arch-v32/mach-a3/pinmux.c: warning: ISO C90 forbids mixed declarations and code: 273, 96 => 
  - src/arch/m68k/include/asm/atarihw.h: warning: this is the location of the previous definition: 403:1, 402:1 => 
  - src/arch/m68k/kernel/setup_mm.c: warning: unused variable 'i': 219 => 
  - src/arch/mips/pci/pci.c: warning: passing argument 2 of 'pci_fixup_irqs' from incompatible pointer type: 160 => 
  - src/arch/sh/kernel/cpu/clock-cpg.c: warning: 'cpg_clk_init' is deprecated (declared at /scratch/kisskb/src/arch/sh/kernel/cpu/clock-cpg.c:49): 75 => 
  - src/arch/sh/math-emu/math.c: warning: right shift count is negative  MK_FW   firmware/mts_gsm.fw.gen.S: 116 => 
  - src/arch/x86/ia32/sys_ia32.c: warning: 'handler' may be used uninitialized in this function: 259, 188 => 
  - src/arch/x86/ia32/sys_ia32.c: warning: 'mask' may be used uninitialized in this function: 258 => 
  - src/arch/x86/ia32/sys_ia32.c: warning: 'restorer' may be used uninitialized in this function: 259, 188 => 
  - src/arch/x86/kvm/emulate.c: warning: 'cs_sel' may be used uninitialized in this function: 2020 => 
  - src/arch/x86/kvm/emulate.c: warning: 'ss_sel' may be used uninitialized in this function: 2020 => 
  - src/drivers/ata/sata_sil.c: warning: 'serror' may be used uninitialized in this function: 441 => 
  - src/drivers/char/ipmi/ipmi_msghandler.c: warning: 'lun' may be used uninitialized in this function: 1876, 1844 => 
  - src/drivers/char/ipmi/ipmi_msghandler.c: warning: 'saddr' may be used uninitialized in this function: 1876, 1844 => 
  - src/drivers/char/tpm/tpm_tis.c: warning: 'is_itpm' defined but not used: 96 => 
  - src/drivers/edac/i7300_edac.c: warning: 'nr_pages' may be used uninitialized in this function: 780 => 
  - src/drivers/gpio/bt8xxgpio.c: warning: ignoring return value of 'gpiochip_remove', declared with attribute warn_unused_result: 247 => 
  - src/drivers/gpu/drm/drm_context.c: warning: passing argument 2 of '__constant_test_and_set_bit' discards qualifiers from pointer target type: 233 => 
  - src/drivers/gpu/drm/drm_context.c: warning: passing argument 2 of '__generic_test_and_set_bit' discards qualifiers from pointer target type: 233 => 
  - src/drivers/gpu/drm/via/via_dmablit.c: warning: 'queue' may be used uninitialized in this function: 435 => 
  - src/drivers/hwmon/lm90.c: warning: 'chip_id' may be used uninitialized in this function: 1095 => 
  - src/drivers/hwmon/lm90.c: warning: 'reg_config1' may be used uninitialized in this function: 1095 => 
  - src/drivers/hwmon/lm90.c: warning: 'reg_convrate' may be used uninitialized in this function: 1095 => 
  - src/drivers/hwmon/lm90.c: warning: 'reg_emerg2' may be used uninitialized in this function: 1167 => 
  - src/drivers/hwmon/lm90.c: warning: 'reg_status2' may be used uninitialized in this function: 1167 => 
  - src/drivers/hwmon/smsc47m1.c: warning: 'address' may be used uninitialized in this function: 861 => 
  - src/drivers/ide/ide-io.c: warning: passing argument 2 of '__constant_test_and_set_bit' discards qualifiers from pointer target type: 415 => 
  - src/drivers/ide/ide-io.c: warning: passing argument 2 of '__generic_test_and_set_bit' discards qualifiers from pointer target type: 415 => 
  - src/drivers/infiniband/core/ucma.c: warning: 'qp_type' may be used uninitialized in this function: 391 => 
  - src/drivers/input/keyboard/sh_keysc.c: warning: "CONFIG_PM_SLEEP" is not defined: 294:5 => 
  - src/drivers/isdn/i4l/isdn_common.c: warning: unused variable 's': 1279 => 
  - src/drivers/leds/leds-gpio.c: warning: 'flags' may be used uninitialized in this function: 191 => 
  - src/drivers/mtd/devices/docprobe.c: warning: #warning Unknown architecture for DiskOnChip. No default probe locations defin  CC [M]  drivers/media/rc/keymaps/rc-eztv.o: 79:2 => 
  - src/drivers/net/gianfar_ethtool.c: warning: the frame size of 2048 bytes is larger than 1024 bytes: 765 => 
  - src/drivers/net/pcmcia/smc91c92_cs.c: warning: 'j' may be used uninitialized in this function: 812 => 
  - src/drivers/net/sh_eth.c: warning: 'mdp' may be used uninitialized in this function: 1775 => 
  - src/drivers/net/stmmac/stmmac_main.c: warning: ignoring return value of 'kstrtoul', declared with attribute warn_unused_result: 1948, 1941, 1931, 1945, 1939, 1943, 1929, 1936, 1933 => 
  - src/drivers/net/wireless/iwlwifi/iwl-tx.c: warning: passing argument 2 of 'pci_map_single' discards qualifiers from pointer target type: 696 => 
  - src/drivers/net/wireless/rtlwifi/core.c: warning: passing argument 3 of 'get_sta' discards qualifiers from pointer target type: 688, 653 => 
  - src/drivers/net/wireless/rtlwifi/rtl8192c/../rtl8192ce/reg.h: warning: "GPIO_IN" redefined: 369:1 => 
  - src/drivers/net/wireless/rtlwifi/rtl8192c/../rtl8192ce/reg.h: warning: "GPIO_OUT" redefined: 370:1 => 
  - src/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c: warning: comparison is always true due to limited range of data type: 845, 877 => 
  - src/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c: warning: 'rx_pwr_all' may be used uninitialized in this function: 228 => 
  - src/drivers/net/wireless/rtlwifi/rtl8192se/reg.h: warning: "GPIO_IN" redefined: 252:1 => 
  - src/drivers/net/wireless/rtlwifi/rtl8192se/reg.h: warning: "GPIO_OUT" redefined: 253:1 => 
  - src/drivers/pci/pcie/portdrv_core.c: warning: 'cap_mask' may be used uninitialized in this function: 240 => 
  - src/drivers/power/twl4030_charger.c: warning: overflow in implicit constant conversion: 498, 490 => 
  - src/drivers/scsi/NCR5380.h: warning: 'NCR5380_exit' declared 'static' but never defined: 303 => 
  - src/drivers/scsi/atari_NCR5380.c: warning: unused variable 'oldto': 917 => 
  - src/drivers/scsi/lpfc/lpfc_bsg.c: warning: 'mbxstatus' may be used uninitialized in this function: 1744, 1570 => 
  - src/drivers/scsi/lpfc/lpfc_debugfs.c: warning: 'reg_val' may be used uninitialized in this function: 2259 => 
  - src/drivers/scsi/mac_scsi.c: warning: "NDEBUG_ABORT" is not defined: 220:5, 271:5 => 
  - src/drivers/scsi/mpt2sas/mpt2sas_base.c: warning: right shift count >= width of type: 3248, 3250 => 
  - src/drivers/scsi/sun3_NCR5380.c: warning: "NCR_TIMEOUT" is not defined: 1442:5 => 
  - src/drivers/scsi/sun3_NCR5380.c: warning: "NDEBUG_MERGING" is not defined: 476:15, 487:15, 495:15 => 
  - src/drivers/scsi/sun3_NCR5380.c: warning: 'merge_contiguous_buffers' defined but not used: 473 => 
  - src/drivers/scsi/sun3_NCR5380.c: warning: assignment discards qualifiers from pointer target type: 2333, 2277, 1147, 993 => 
  - src/drivers/scsi/sun3_scsi.h: warning: "NDEBUG" is not defined: 255:5, 243:5, 297:5, 351:5, 237:5, 273:5, 225:5, 327:5, 321:5, 357:5, 231:5, 261:5, 303:5, 309:5, 315:5, 279:5, 333:5, 345:5, 339:5, 267:5, 291:5, 249:5, 285:5 => 
  - src/drivers/scsi/sun3_scsi.h: warning: "NDEBUG_ABORT" is not defined: 345:14 => 
  - src/drivers/scsi/sun3_scsi.h: warning: "NDEBUG_MERGING" is not defined: 357:14 => 
  - src/drivers/scsi/sun3_scsi.h: warning: "NDEBUG_TAGS" is not defined: 351:14 => 
  - src/drivers/ssb/driver_chipcommon_pmu.c: warning: 'updown_tab_size' may be used uninitialized in this function: 420 => 
  - src/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c: warning: cast from pointer to integer of different size: 966, 1061 => 
  - src/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c: warning: cast from pointer to integer of different size: 6014 => 
  - src/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c: warning: cast to pointer from integer of different size: 5282 => 
  - src/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c: warning: initialization from incompatible pointer type: 2306 => 
  - src/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c: warning: ignoring return value of 'kstrtoul', declared with attribute warn_unused_result: 1301, 1290 => 
  - src/drivers/staging/dt3155v4l/dt3155v4l.c: warning: assignment makes pointer from integer without a cast: 1027, 1020, 434, 1077 => 
  - src/drivers/staging/gma500/psb_bl.c: warning: 'device_backlight_init' defined but not used: 127 => 
  - src/drivers/staging/gma500/psb_drv.c: warning: cast from pointer to integer of different size: 324, 323, 314 => 
  - src/drivers/staging/gma500/psb_drv.c: warning: unused variable 'bd': 787, 772 => 
  - src/drivers/staging/gma500/psb_gtt.c: warning: 'ret' may be used uninitialized in this function: 218 => 
  - src/drivers/staging/gma500/psb_gtt.c: warning: format '%s' expects type 'char *', but argument 5 has type 'void *': 493 => 
  - src/drivers/staging/gma500/psb_gtt.c: warning: too few arguments for format: 493 => 
  - src/drivers/staging/gma500/psb_gtt.c: warning: unused variable 'dev_priv': 81 => 
  - src/drivers/staging/iio/adc/max1363_core.c: warning: 'st' may be used uninitialized in this function: 1253 => 
  - src/drivers/staging/iio/gyro/adis16130_core.c: warning: 'val' may be used uninitialized in this function: 109 => 
  - src/drivers/staging/iio/meter/ade7753.c: warning: 'val' may be used uninitialized in this function: 176 => 
  - src/drivers/staging/mei/interrupt.c: warning: 'buffer' may be used uninitialized in this function: 198 => 
  - src/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c: warning: value computed is not used: 824 => 
  - src/drivers/staging/rtl8192e/ieee80211/ieee80211_softmac.c: warning: value computed is not used: 781 => 
  - src/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c: warning: value computed is not used: 780 => 
  - src/drivers/staging/solo6x10/core.c: warning: assignment makes pointer from integer without a cast: 140 => 
  - src/drivers/staging/solo6x10/enc.c: warning: assignment makes pointer from integer without a cast: 132, 101 => 
  - src/drivers/staging/solo6x10/g723.c: warning: assignment makes pointer from integer without a cast: 139 => 
  - src/drivers/staging/solo6x10/p2m.c: warning: initialization makes pointer from integer without a cast: 52 => 
  - src/drivers/staging/tty/ip2/i2lib.c: warning: 'pCh' may be used uninitialized in this function: 1454 => 
  - src/drivers/staging/usbip/stub_tx.c: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'size_t': 237 => 
  - src/drivers/target/tcm_fc/tfc_conf.c: warning: 'ft_init' defined but not used: 641, 642 => 
  - src/drivers/target/tcm_fc/tfc_io.c: warning: comparison of distinct pointer types lacks a cast: 160 => 
  - src/drivers/tty/rocket.c: warning: 'info' may be used uninitialized in this function: 893 => 
  - src/drivers/tty/serial/8250.c: warning: 'i' may be used uninitialized in this function: 1775, 1727 => 1775
  - src/drivers/tty/serial/ucc_uart.c: warning: format '%x' expects type 'unsigned int', but argument 3 has type 'dma_addr_t': 238 => 
  - src/drivers/uio/uio.c: warning: 'ret' may be used uninitialized in this function: 266 => 
  - src/drivers/usb/gadget/fusb300_udc.c: warning: 'fusb300_ep0_complete' defined but not used: 985, 983 => 
  - src/drivers/usb/gadget/fusb300_udc.c: warning: 'fusb300_set_ep_bycnt' defined but not used: 1032, 1033 => 
  - src/drivers/usb/gadget/fusb300_udc.c: warning: 'fusb300_wrfifo' defined but not used: 773, 771 => 
  - src/drivers/usb/gadget/fusb300_udc.c: warning: cast from pointer to integer of different size: 1079 => 
  - src/drivers/usb/gadget/fusb300_udc.c: warning: cast to pointer from integer of different size: 1134 => 
  - src/drivers/video/aty/aty128fb.c: warning: 'fifo_reg.dda_config' may be used uninitialized in this function: 1520 => 
  - src/drivers/video/aty/aty128fb.c: warning: 'fifo_reg.dda_on_off' may be used uninitialized in this function: 1520 => 
  - src/drivers/video/aty/radeon_monitor.c: warning: 'tmp' may be used uninitialized in this function: 442 => 
  - src/drivers/video/riva/fbdev.c: warning: 'modedb$hsync_len' may be used uninitialized in this function: 1810 => 
  - src/drivers/video/riva/fbdev.c: warning: 'modedb$left_margin' may be used uninitialized in this function: 1810 => 
  - src/drivers/video/riva/fbdev.c: warning: 'modedb$lower_margin' may be used uninitialized in this function: 1810 => 
  - src/drivers/video/riva/fbdev.c: warning: 'modedb$pixclock' may be used uninitialized in this function: 1810 => 
  - src/drivers/video/riva/fbdev.c: warning: 'modedb$right_margin' may be used uninitialized in this function: 1810 => 
  - src/drivers/video/riva/fbdev.c: warning: 'modedb$sync' may be used uninitialized in this function: 1810 => 
  - src/drivers/video/riva/fbdev.c: warning: 'modedb$upper_margin' may be used uninitialized in this function: 1810 => 
  - src/drivers/video/riva/fbdev.c: warning: 'modedb$vmode' may be used uninitialized in this function: 1810 => 
  - src/drivers/video/riva/fbdev.c: warning: 'modedb$vsync_len' may be used uninitialized in this function: 1810 => 
  - src/drivers/video/riva/fbdev.c: warning: 'modedb$xres' may be used uninitialized in this function: 1810 => 
  - src/drivers/video/riva/fbdev.c: warning: 'modedb$yres' may be used uninitialized in this function: 1810 => 
  - src/drivers/video/via/viafbdev.c: warning: unused variable 'r': 2019 => 
  - src/fs/compat.c: warning: 'buf' may be used uninitialized in this function: 590 => 
  - src/fs/compat.c: warning: 'h' may be used uninitialized in this function: 1380 => 
  - src/fs/ecryptfs/inode.c: warning: 'dentry_save' may be used uninitialized in this function: 163 => 
  - src/fs/ecryptfs/inode.c: warning: 'flags_save' may be used uninitialized in this function: 165 => 
  - src/fs/ecryptfs/inode.c: warning: 'vfsmount_save' may be used uninitialized in this function: 164 => 
  - src/fs/eventpoll.c: warning: 'pwq' may be used uninitialized in this function: 884 => 
  - src/fs/ext2/balloc.c: warning: passing argument 2 of 'test_and_clear_bit' from incompatible pointer type: 550 => 
  - src/fs/ext2/balloc.c: warning: passing argument 2 of 'test_and_set_bit' from incompatible pointer type: 724, 739 => 
  - src/fs/ext2/ialloc.c: warning: passing argument 2 of 'test_and_set_bit' from incompatible pointer type: 494 => 
  - src/fs/ext3/balloc.c: warning: passing argument 2 of 'test_and_clear_bit' from incompatible pointer type: 849, 635, 2011 => 
  - src/fs/ext3/balloc.c: warning: passing argument 2 of 'test_and_set_bit' from incompatible pointer type: 845, 626 => 
  - src/fs/ext3/ialloc.c: warning: passing argument 2 of 'test_and_clear_bit' from incompatible pointer type: 142 => 
  - src/fs/ext3/ialloc.c: warning: passing argument 2 of 'test_and_set_bit' from incompatible pointer type: 472 => 
  - src/fs/nilfs2/alloc.c: warning: passing argument 2 of 'test_and_clear_bit' from incompatible pointer type: 670, 557, 520 => 
  - src/fs/nilfs2/alloc.c: warning: passing argument 2 of 'test_and_set_bit' from incompatible pointer type: 374, 355 => 
  - src/fs/xfs/linux-2.6/xfs_acl.c: warning: 'ea_name' may be used uninitialized in this function: 110 => 
  - src/include/linux/netfilter.h: warning: 'ret' may be used uninitialized in this function: 229 => 
  - src/kernel/fork.c: warning: assignment makes pointer from integer without a cast: 266 => 
  - src/kernel/ptrace.c: warning: 'len' may be used uninitialized in this function: 863 => 
  - src/kernel/trace/trace_events.c: warning: enumeration value 'TRACE_REG_PERF_REGISTER' not handled in switch: 152 => 
  - src/kernel/trace/trace_events.c: warning: enumeration value 'TRACE_REG_PERF_UNREGISTER' not handled in switch: 152 => 
  - src/kernel/trace/trace_syscalls.c: warning: enumeration value 'TRACE_REG_PERF_REGISTER' not handled in switch: 674, 653 => 
  - src/kernel/trace/trace_syscalls.c: warning: enumeration value 'TRACE_REG_PERF_UNREGISTER' not handled in switch: 674, 653 => 
  - src/kernel/workqueue.c: warning: 'last_gcwq' may be used uninitialized in this function: 999 => 
  - src/mm/memory.c: warning: 'dst_ptl' may be used uninitialized in this function: 933 => 
  - src/mm/memory.c: warning: 'ptl' may be used uninitialized in this function: 2119 => 
  - src/net/batman-adv/vis.c: warning: passing argument 2 of 'compare_eth' discards qualifiers from pointer target type: 146 => 
  - src/net/bridge/br_multicast.c: warning: 'max_delay' may be used uninitialized in this function: 1199 => 
  - src/net/compat.c: warning: 'fmode' may be used uninitialized in this function: 612 => 
  - src/net/compat.c: warning: 'interface' may be used uninitialized in this function: 612 => 
  - src/net/compat.c: warning: 'numsrc' may be used uninitialized in this function: 612, 651 => 
  - src/net/compat.c: warning: 'tmp1' may be used uninitialized in this function: 62 => 
  - src/net/compat.c: warning: 'tmp2' may be used uninitialized in this function: 62 => 
  - src/net/compat.c: warning: 'tmp3' may be used uninitialized in this function: 62 => 
  - src/net/compat.c: warning: 'ulen' may be used uninitialized in this function: 652 => 
  - src/net/core/dev.c: warning: 'err' may be used uninitialized in this function: 1859 => 
  - src/net/core/neighbour.c: warning: 'error' may be used uninitialized in this function: 463 => 
  - src/net/core/neighbour.c: warning: 'neigh' may be used uninitialized in this function: 1303 => 
  - src/net/core/scm.c: warning: 'file' may be used uninitialized in this function: 96 => 
  - src/net/core/skbuff.c: warning: 'err' may be used uninitialized in this function: 1077 => 
  - src/net/ipv4/inet_connection_sock.c: warning: 'head' may be used uninitialized in this function: 94 => 
  - src/net/ipv4/ip_options.c: warning: 'faddr' may be used uninitialized in this function: 160 => 
  - src/net/ipv4/ip_output.c: warning: 'left' may be used uninitialized in this function: 980 => 
  - src/net/ipv4/raw.c: warning: 'node' may be used uninitialized in this function: 113 => 
  - src/net/ipv4/syncookies.c: warning: 'mss' may be used uninitialized in this function: 276 => 
  - src/net/ipv4/tcp.c: warning: 'chunk' may be used uninitialized in this function: 1739 => 
  - src/net/ipv4/tcp.c: warning: 'copy' may be used uninitialized in this function: 786 => 
  - src/net/ipv4/udp.c: warning: 'node' may be used uninitialized in this function: 542 => 
  - src/net/ipv6/ip6_output.c: warning: 'left' may be used uninitialized in this function: 1439 => 
  - src/net/ipv6/raw.c: warning: 'node' may be used uninitialized in this function: 73 => 
  - src/net/ipv6/syncookies.c: warning: 'mss' may be used uninitialized in this function: 165 => 
  - src/net/ipv6/udp.c: warning: 'node' may be used uninitialized in this function: 563 => 
  - src/net/mac80211/util.c: warning: label 'wake_up' defined but not used: 1279 => 
  - src/net/netfilter/ipset/ip_set_hash_ipport.c: warning: 'ip_to' may be used uninitialized in this function: 151 => 
  - src/net/sched/cls_route.c: warning: 'f' may be used uninitialized in this function: 134 => 
  - src/net/sched/sch_cbq.c: warning: 'len' may be used uninitialized in this function: 1188 => 
  - src/net/sched/sch_hfsc.c: warning: 'cl' may be used uninitialized in this function: 1152 => 
  - src/net/sched/sch_hfsc.c: warning: 'len' may be used uninitialized in this function: 1678 => 
  - src/net/sched/sch_prio.c: warning: 'len' may be used uninitialized in this function: 130 => 
  - src/net/sched/sch_sfb.c: warning: 'salt' may be used uninitialized in this function: 287 => 
  - src/net/wireless/nl80211.c: warning: 'dev' may be used uninitialized in this function: 5332 => 
  - src/net/wireless/nl80211.c: warning: 'rdev' may be used uninitialized in this function: 1113, 5331 => 
  - src/net/wireless/radiotap.c: warning: 'size' may be used uninitialized in this function: 204 => 
  - src/net/wireless/scan.c: warning: 'err' may be used uninitialized in this function: 135 => 
  - src/net/xfrm/xfrm_state.c: warning: 'x0' may be used uninitialized in this function: 797 => 
  - src/sound/oss/pss.c: warning: 'check_region' is deprecated (declared at /scratch/kisskb/src/include/linux/ioport.h:170): 676 => 
  - src/sound/oss/pss.c: warning: 'check_region' is deprecated (declared at /scratch/kisskb/src/include/linux/ioport.h:172): 676 => 
  - src/sound/pci/rme9652/hdspm.c: warning: 'freq_const' may be used uninitialized in this function: 1309 => 
  - src/sound/pci/rme9652/hdspm.c: warning: 'n' may be used uninitialized in this function: 1333 => 
  - src/sound/pcmcia/pdaudiocf/pdaudiocf.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:201): 226 => 
  - src/sound/pcmcia/pdaudiocf/pdaudiocf.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:203): 226 => 
  - src/sound/pcmcia/vx/vxpocket.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:201): 232 => 
  - src/sound/pcmcia/vx/vxpocket.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:203): 232 => 
  - src/sound/soc/codecs/wm8915.c: warning: 'i' may be used uninitialized in this function: 703 => 
  - src/sound/soc/soc-cache.c: warning: 'ret' may be used uninitialized in this function: 299 => 
  - warning: (HAVE_TEXT_POKE_SMP) selects STOP_MACHINE which has unmet direct dependencies (SMP && MODULE_UNLOAD || HOTPLUG_CPU): N/A => 
  - warning: (I2C_ISCH && GPIO_SCH && GPIO_RDC321X && RADIO_WL1273) selects MFD_CORE which has unmet direct dependencies (MFD_SUPPORT): N/A => 
  - warning: (IA32_EMULATION) selects COMPAT_BINFMT_ELF which has unmet direct dependencies (COMPAT && BINFMT_ELF): N/A => 
  - warning: (ISDN_PPP) selects SLHC which has unmet direct dependencies (NETDEVICES): N/A => 
  - warning: (LOCKDEP && FAULT_INJECTION_STACKTRACE_FILTER && LATENCYTOP && DWARF_UNWINDER && FUNCTION_TRACER && KMEMCHECK) selects FRAME_POINTER which has unmet direct dependencies (DEBUG_KERNEL && (CRIS || M68K || FRV || UML || AVR32 || SUPERH || BLACKFIN || MN10300) || ARCH_WANT_FRAME_POINTERS): N/A => 
  - warning: (PPC_MPC5200_LPBFIFO) selects PPC_BESTCOMM_GEN_BD which has unmet direct dependencies (PPC_BESTCOMM): N/A => 
  - warning: 3 bad relocations: N/A => 
  - warning: You need at binutils >= 2.19 to build a CONFIG_RELCOATABLE kernel: N/A => 
  - warning: arch/powerpc/kernel/built-in.o(.text+0x5bcd4): Section mismatch in reference from the function .register_power_pmu() to the function .cpuinit.text:.power_pmu_notifier(): N/A => 
  - warning: arch/powerpc/kernel/built-in.o(.text+0x5bcf0): Section mismatch in reference from the function .register_power_pmu() to the function .cpuinit.text:.power_pmu_notifier(): N/A => 
  - warning: arch/powerpc/kernel/built-in.o(.text+0x5bd0c): Section mismatch in reference from the function .register_power_pmu() to the function .cpuinit.text:.power_pmu_notifier(): N/A => 
  - warning: arch/powerpc/kernel/built-in.o(.text+0x5d834): Section mismatch in reference from the function .register_power_pmu() to the function .cpuinit.text:.power_pmu_notifier(): N/A => 
  - warning: arch/powerpc/kernel/built-in.o(.text+0x5d850): Section mismatch in reference from the function .register_power_pmu() to the function .cpuinit.text:.power_pmu_notifier(): N/A => 
  - warning: arch/powerpc/kernel/built-in.o(.text+0x5d86c): Section mismatch in reference from the function .register_power_pmu() to the function .cpuinit.text:.power_pmu_notifier(): N/A => 
  - warning: arch/powerpc/mm/built-in.o(.text+0xb3a4): Section mismatch in reference from the function .mark_reserved_regions_for_nid() to the function .init.text:.get_node_active_region(): N/A => 
  - warning: arch/powerpc/mm/built-in.o(.text+0xb488): Section mismatch in reference from the function .mark_reserved_regions_for_nid() to the function .init.text:.get_node_active_region(): N/A => 
  - warning: arch/powerpc/sysdev/built-in.o(.text+0x101cc): Section mismatch in reference from the function .icp_native_init() to the function .init.text:.icp_native_init_one_node(): N/A => 
  - warning: arch/powerpc/sysdev/built-in.o(.text+0x1027c): Section mismatch in reference from the function .icp_native_init() to the function .init.text:.icp_native_init_one_node(): N/A => 
  - warning: arch/powerpc/sysdev/built-in.o(.text+0x10c7c): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics(): N/A => 
  - warning: arch/powerpc/sysdev/built-in.o(.text+0xe734): Section mismatch in reference from the function .icp_native_init() to the function .init.text:.icp_native_init_one_node(): N/A => 
  - warning: arch/powerpc/sysdev/built-in.o(.text+0xe7e4): Section mismatch in reference from the function .icp_native_init() to the function .init.text:.icp_native_init_one_node(): N/A => 
  - warning: arch/powerpc/sysdev/built-in.o(.text+0xf1e4): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics(): N/A => 
  - warning: arch/powerpc/sysdev/xics/built-in.o(.text+0x16d0): Section mismatch in reference from the function .icp_native_init() to the function .init.text:.icp_native_init_one_node(): N/A => 
  - warning: arch/powerpc/sysdev/xics/built-in.o(.text+0x1780): Section mismatch in reference from the function .icp_native_init() to the function .init.text:.icp_native_init_one_node(): N/A => 
  - warning: arch/powerpc/sysdev/xics/built-in.o(.text+0x2180): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics(): N/A => 
  - warning: drivers/built-in.o(.text+0x278eae4): Section mismatch in reference from the function .tc3589x_keypad_open() to the function .devinit.text:.tc3589x_keypad_init_key_hardware(): N/A => 
  - warning: drivers/built-in.o(.text+0x6539e8): Section mismatch in reference from the function .radeon_get_clock_info() to the function .devinit.text:.radeon_read_clocks_OF(): N/A => 
  - warning: drivers/gpu/built-in.o(.text+0x1388a4): Section mismatch in reference from the function .radeon_get_clock_info() to the function .devinit.text:.radeon_read_clocks_OF(): N/A => 
  - warning: drivers/gpu/drm/built-in.o(.text+0x1388a4): Section mismatch in reference from the function .radeon_get_clock_info() to the function .devinit.text:.radeon_read_clocks_OF(): N/A => 
  - warning: drivers/gpu/drm/radeon/built-in.o(.text+0xd4824): Section mismatch in reference from the function .radeon_get_clock_info() to the function .devinit.text:.radeon_read_clocks_OF(): N/A => 
  - warning: drivers/gpu/drm/radeon/radeon.o(.text+0x49760): Section mismatch in reference from the function radeon_get_clock_info() to the function .devinit.text:radeon_read_clocks_OF(): N/A => 
  - warning: drivers/gpu/drm/radeon/radeon.o(.text+0xd4824): Section mismatch in reference from the function .radeon_get_clock_info() to the function .devinit.text:.radeon_read_clocks_OF(): N/A => 
  - warning: drivers/gpu/drm/radeon/radeon.o(.text+0xd4828): Section mismatch in reference from the function .radeon_get_clock_info() to the function .devinit.text:.radeon_read_clocks_OF(): N/A => 
  - warning: drivers/input/built-in.o(.text+0x27a64): Section mismatch in reference from the function .tc3589x_keypad_open() to the function .devinit.text:.tc3589x_keypad_init_key_hardware(): N/A => 
  - warning: drivers/input/keyboard/built-in.o(.text+0x10860): Section mismatch in reference from the function .tc3589x_keypad_open() to the function .devinit.text:.tc3589x_keypad_init_key_hardware(): N/A => 
  - warning: drivers/input/keyboard/built-in.o(.text+0xc3ec): Section mismatch in reference from the function tc3589x_keypad_open() to the function .devinit.text:adp5520_keys_probe(): N/A => 
  - warning: drivers/mfd/built-in.o(.data+0x61cc): Section mismatch in reference from the variable ab3550_driver to the function .init.text:pm860x_i2c_init(): N/A => 
  - warning: drivers/net/depca.o(.devinit.text+0x18): Section mismatch in reference from the function depca_isa_probe() to the function .init.text:depca_common_init(): N/A => 
  - warning: drivers/net/depca.o(.devinit.text+0x40): Section mismatch in reference from the function depca_isa_probe() to the function .init.text:DepcaSignature(): N/A => 
  - warning: drivers/net/depca.o(.devinit.text+0xa0): Section mismatch in reference from the function depca_isa_probe() to the function .init.text:depca_hw_init(): N/A => 
  - warning: drivers/net/irda/smsc-ircc2.o(.devinit.text+0x1a7): Section mismatch in reference from the function smsc_ircc_pnp_probe() to the function .init.text:smsc_ircc_open(): N/A => 
  - warning: drivers/sbus/char/bbc.o(.devinit.text+0x8): Section mismatch in reference from the function bbc_i2c_probe() to the function .init.text:T.356(): N/A => 
  - warning: drivers/usb/gadget/g_multi.o(.text+0x7d38): Section mismatch in reference from the function cdc_config_register() to the function .init.text:cdc_do_config(): N/A => 
  - warning: drivers/usb/gadget/g_multi.o(.text+0x7da0): Section mismatch in reference from the function rndis_config_register() to the function .init.text:rndis_do_config(): N/A => 
  - warning: vmlinux.o(.devinit.text+0x9269): Section mismatch in reference from the function cnb20le_res() to the function .init.text:acpi_os_get_root_pointer(): N/A => 
  - warning: vmlinux.o(.text+0x35464): Section mismatch in reference from the function .early_setup_secondary() to the function .cpuinit.text:.early_init_mmu_secondary(): N/A => 
  - warning: vmlinux.o(.text+0x5d608): Section mismatch in reference from the function .wake_offline_cpus() to the function .cpuinit.text:.cpu_up(): N/A => 
  - warning: vmlinux.o(.text+0x671f4): Section mismatch in reference from the function .register_power_pmu() to the function .cpuinit.text:.power_pmu_notifier(): N/A => 
  - warning: vmlinux.o(.text+0x67210): Section mismatch in reference from the function .register_power_pmu() to the function .cpuinit.text:.power_pmu_notifier(): N/A => 
  - warning: vmlinux.o(.text+0x6722c): Section mismatch in reference from the function .register_power_pmu() to the function .cpuinit.text:.power_pmu_notifier(): N/A => 
  - warning: vmlinux.o(.text+0x79a3c): Section mismatch in reference from the function .mark_reserved_regions_for_nid() to the function .init.text:.get_node_active_region(): N/A => 
  - warning: vmlinux.o(.text+0x79aec): Section mismatch in reference from the function .mark_reserved_regions_for_nid() to the function .init.text:.reserve_bootmem_node(): N/A => 
  - warning: vmlinux.o(.text+0x79b20): Section mismatch in reference from the function .mark_reserved_regions_for_nid() to the function .init.text:.get_node_active_region(): N/A => 
  - warning: vmlinux.o(.text+0x7d42): Section mismatch in reference from the function atari_stram_alloc() to the function .init.text:__alloc_bootmem_low(): N/A => 
  - warning: vmlinux.o(.text+0x9082): Section mismatch in reference from the variable generic_secondary_common_init to the variable .init.data:boot_cpu_count: N/A => 
  - warning: vmlinux.o(.text+0x90a70): Section mismatch in reference from the function .icp_native_init() to the function .init.text:.icp_native_init_one_node(): N/A => 
  - warning: vmlinux.o(.text+0x90b20): Section mismatch in reference from the function .icp_native_init() to the function .init.text:.icp_native_init_one_node(): N/A => 
  - warning: vmlinux.o(.text+0x91520): Section mismatch in reference from the function .ics_rtas_init() to the function .init.text:.xics_register_ics(): N/A => 
  - warning: vmlinux.o(.text+0x92f0): Section mismatch in reference from the function .start_secondary_prolog() to the function .devinit.text:.start_secondary(): N/A => 
  - warning: vmlinux.o(.text+0x9304): Section mismatch in reference from the function .start_secondary_resume() to the function .devinit.text:.start_secondary(): N/A => 
  - warning: vmlinux.o(.text+0xab698): Section mismatch in reference from the function .pci_dn_reconfig_notifier() to the function .devinit.text:.update_dn_pci_info(): N/A => 
  - warning: vmlinux.o(.text+0xb153c): Section mismatch in reference from the function .dlpar_online_cpu() to the function .cpuinit.text:.cpu_up(): N/A => 
  - warning: vmlinux.o(.text+0xb9f40): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.of_rescan_bus(): N/A => 
  - warning: vmlinux.o(.text+0xb9fd0): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.pcibios_setup_bus_devices(): N/A => 
  - warning: vmlinux.o(.text+0xba028): Section mismatch in reference from the function .pcibios_add_pci_devices() to the function .devinit.text:.pci_scan_bridge(): N/A => 
  - warning: vmlinux.o(.text+0xbf91e): Section mismatch in reference from the variable system_reset_iSeries to the variable .init.data:boot_paca: N/A => 

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
