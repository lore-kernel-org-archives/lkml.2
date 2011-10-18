Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964Ab1JRET6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 00:19:58 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53521 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab1JRET4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 00:19:56 -0400
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 17 Oct 2011 21:19:35 -0700
X-Google-Sender-Auth: ct-7MqC0Z2WushOWfUlO8ET1EHo
Message-ID: <CA+55aFy0BH=XUCP7gHgZEc3nrTNEGeZLn1Q_ekofyEHvJZYNVQ@mail.gmail.com>
Subject: Linux 3.1-rc10
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, we're a week away from the kernel summit, and here's the last -rc
I'm planning to make.

There really hasn't been all that much going on - the smallish MIPS
updates are still the bulk of this -rc, and the rest is pretty much
small driver fixes. Oh, and some last-minute fs (btrfs and xfs) fixes
in there too.

The shortlog is about as informative as it gets. There's still some
discussion about a couple of minor things we would like to get
resolved, but on the whole 3.1 is long over-due and by the KS I think
everybody will be relieved to have it out, and ready to open the merge
window.

                          Linus

---
Adrian Bunk (1):
      x86: Default to vsyscall=native for now

Alex Deucher (3):
      drm/radeon/kms: retry aux transactions if there are status flags
      drm/radeon/kms: fix dp_detect handling for DP bridge chips
      drm/radeon/kms: use hardcoded dig encoder to transmitter mapping
for DCE4.1

Arnaud Lacombe (1):
      MIPS: Do not use EXTRA_CFLAGS

Axel Lin (1):
      ARM: OMAP: musb: Remove a redundant omap4430_phy_init call in
usb_musb_init

Benjamin Poirier (1):
      net: fix typos in Documentation/networking/scaling.txt

Bryan Buckley (1):
      ARM: OMAP4: MMC: fix power and audio issue, decouple USBC1 from MMC1

Chris Mason (1):
      Btrfs: make sure not to defrag extents past i_size

Chris Metcalf (1):
      tile: revert change from <asm/atomic.h> to <linux/atomic.h> in asm files

Christoph Hellwig (3):
      xfs: do not update xa_last_pushed_lsn for locked items
      xfs: force the log if we encounter pinned buffers in .iop_pushbuf
      xfs: revert to using a kthread for AIL pushing

David Daney (4):
      MIPS: Octeon: Select CONFIG_HOLES_IN_ZONE
      MIPS: Don't clobber CP0_STATUS value for CONFIG_MIPS_MT_SMTC
      MIPS: No branches in delay slots for huge pages in handle_tlbl
      MIPS: Octeon: Enable C0_UserLocal probing.

David Ward (1):
      macvlan/macvtap: Fix unicast between macvtap interfaces in bridge mode

Dmitry Kravkov (1):
      bnx2x: fix cl_id allocation for non-eth clients for NPAR mode

Hartmut Knaack (1):
      gpio-pca953x: fix gpio_base

Hillf Danton (2):
      MIPS: VPE: Select correct tc
      MIPS: i8259: Correct comment for i8259

Janusz Krzysztofik (1):
      gpio/omap: fix build error with certain OMAP1 configs

Jason Gerecke (1):
      Input: wacom - revert "Cintiq 21UX2 does not have menu strips"

Jean Delvare (1):
      hwmon: (w83627ehf) Properly report thermal diode sensors

Jesper Juhl (1):
      MIPS: Remove unneeded version.h includes from arch/mips/

Johann Felix Soden (1):
      ide: Fix file references in drivers/ide/

John Crispin (3):
      MIPS: Lantiq: Fix external interrupt sources
      MIPS: Lantiq: Fix setting the PCI bus speed on AR9
      SERIAL: Lantiq: Set timeout in uart_port

Jonthan Brassow (1):
      dm: raid fix write_mostly arg validation

Kevin Cernekee (1):
      MIPS: Trivial style cleanups in mmap.c

Li Zefan (1):
      Btrfs: fix recursive auto-defrag

Liming Wang (1):
      MIPS: i8259: Mark cascade interrupt non-threaded

Linus Torvalds (2):
      Avoid using variable-length arrays in kernel/sys.c
      Linux 3.1-rc10

Linus Walleij (1):
      ARM: 7113/1: mm: Align bank start to MAX_ORDER_NR_PAGES

Manuel Lauss (3):
      MIPS: Alchemy: Fix typo in MAC0 registration
      MIPS: Alchemy: Include Au1100 in PM code.
      MIPS: Alchemy: DB1200: Disable cascade IRQ in handler

Marc Dietrich (1):
      ARM: tegra: fix compilation error due to mach/hardware.h removal

Mark Salyzyn (1):
      [SCSI] libsas: fix panic when single phy is disabled on a wide port

Mika Westerberg (1):
      x86, mrst: use a temporary variable for SFI irq

Mike Snitzer (2):
      dm: flakey fix corrupt_bio_byte error path
      dm table: avoid crash if integrity profile changes

Milan Broz (1):
      dm crypt: always disable discard_zeroes_data

Nathan Lynch (1):
      MIPS: Call oops_enter, oops_exit in die

NeilBrown (1):
      md: Avoid waking up a thread after it has been freed.

Olof Johansson (1):
      MAINTAINERS: Update tegra maintainer information

Paul Menzel (1):
      x86/PCI: use host bridge _CRS info on ASUS M2V-MX SE

      MIPS: PM: Use struct syscore_ops instead of sysdevs for PM (v2)

Ralf Baechle (3):
      MIPS: Handle __put_user() sleeping.
      MIPS: MSP71xx: Fix build error.
      MIPS: tlbex: Fix build error in R3000 code.

Roland Dreier (1):
      [SCSI] qla2xxx: Fix crash in qla2x00_abort_all_cmds() on unload

Roy.Li (1):
      staging/octeon: Software should check the checksum of no tcp/udp packets

Shawn Guo (1):
      ARM: 7122/1: localtimer: add header linux/errno.h explicitly

Steve French (1):
      [CIFS] Fix first time message on mount, ntlmv2 upgrade delayed to 3.2

Thadeu Lima de Souza Cascardo (1):
      mlx4_en: fix endianness with blue frame support

Thomas Gleixner (3):
      MIPS: Ftrace: Fix the CONFIG_DYNAMIC_FTRACE=n compile
      MIPS: Allow forced irq threading
      netfilter: Use proper rwlock init function

Tony Lindgren (1):
      ARM: OMAP: Fix i2c init for twl4030

Will Deacon (1):
      ARM: 7117/1: perf: fix HW_CACHE_* events on Cortex-A9

Wolfgang Grandegger (1):
      mscan: too much data copied to CAN frame due to 16 bit accesses

Wu Zhangjin (3):
      MIPS: Make the die_lock be raw
      MIPS: Mark cascade and low level interrupts IRQF_NO_THREAD
      MIPS: Loongson: Mark cascade interrupts IRQF_NO_THREAD

Yan, Zheng (3):
      tcp: properly handle md5sig_pool references
      tcp: properly update lost_cnt_hint during shifting
      gro: refetch inet6_protos[] after pulling ext headers

Yoichi Yuasa (1):
      MIPS: RC32434: Fix PCI build error

Yong Zhang (1):
      MIPS: Compat: Use 32-bit wrapper for compat_sys_futex.

Zoltan Devai (1):
      ARM: 7128/1: vic: Don't write to the read-only register VIC_IRQ_STATUS

srinidhi kasagar (1):
      ARM: mach-ux500: enable fix for ARM errata 754322

stephen hemminger (1):
      bridge: leave carrier on for empty bridge
