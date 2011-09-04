Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053Ab1IDX17 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 19:27:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58362 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752406Ab1IDX1w convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 19:27:52 -0400
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 4 Sep 2011 16:27:25 -0700
Message-ID: <CA+55aFxDjVJwbpP5YT4o=qud=OcxtT3Ry4HfCtW-FvNdj+RFeQ@mail.gmail.com>
Subject: Linux 3.1-rc5
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So it's been another week, and it's time for another -rc.

However, master.kernel.org is still down, and there really hasn't been
a ton of development going on, so I considered just skipping a week.
But hey, the whole point (well, *one* of the points) of distributed
development is that no single place is really any different from any
other, so since I did a github account for my divelog thing, why not
see how well it holds up to me just putting my whole kernel repo there
too?

So while kernel.org is down for the count, let's just see how github does:

   https://github.com/torvalds/linux.git

NOTE! One thing to look out for when you see a new random public
hosting place usage like that is to verify that yes, it's really the
person you think it is. So is it?

You can take a few different approaches:

 (a) Heck, it's open source, I don't care who I pull from, I just want
a new kernel, and not having a new update from kernel.org in the last
few days, I *really* need my new kernel fix. I'll take it, because I
need to exercise my CPU's by building randconfig kernels. Besides, I
like living dangerously.

 (b) Yeah, the email looks like it comes from Linus, and we all know
that SMTP cannot possibly be spoofed, so it must be him.

 (c) Ok, I can fetch that tree, and I know that Linus always does
signed tags, and I can verify the 3.1-rc5 tag with Linus known public
GPG key that I have somewhere. If it matches, I don't care who the
person doing the release announcement is, I'll trust that Linus signed
the tree

 (d) I'll just wait for kernel.org to feel better.

Whatever works for you.

One thing to note: If you just do

  git pull https://github.com/torvalds/linux.git

you probably won't get the tags, since it's not your origin branch. So do

  git fetch --tags <...>

too, so that you get not only the actual changes, but the tag that you
can verify too.

And I *would* suggest you just pull into an existing tree, rather than
clone a new copy. I bet the github people will appreciate that.

Anything worth saying about the changes themselves? The appended
shortlog pretty much speaks for itself: there really hasn't been much
excitement on the kernel development front.

Now, if you want to talk to me about dive logging software, that's a
whole different kettle of fish..

                   Linus

---
Abhilash K V (2):
      can: ti_hecc: Fix unintialized variable
      can: ti_hecc: Fix uninitialized spinlock in probe

Abhilash Kesavan (2):
      ARM: S5PV210: Fix build warning
      ARM: S3C64XX: Fix build break in PM debug

Alex Deucher (2):
      drm/radeon/kms: add s/r quirk for Compaq Presario V5245EU
      drm/radeon/kms: make sure pci max read request size is valid on
evergreen+ (v2)

Alexey Khoroshilov (1):
      carl9170: Fix mismatch in carl9170_op_set_key mutex lock-unlock

Anton Blanchard (1):
      ibmveth: Fix leak when recycling skb and hypervisor returns error

Axel Lin (1):
      ARM: 7019/1: Footbridge: select CLKEVT_I8253 for ARCH_NETWINDER

Bryan Wu (2):
      ARM: mach-orion5x: add missing header file <linux/vga.h>
      ARM: mach-footbridge: add missing header file <video/vga.h>

Catalin Marinas (1):
      ARM: 7015/1: ARM errata: Possible cache data corruption with
hit-under-miss enabled

Chen Ganir (1):
      Bluetooth: Fixed wrong L2CAP Sock timer value

Christoph Hellwig (3):
      xfs: deprecate the nodelaylog mount option
      xfs: fix xfs_mark_inode_dirty during umount
      xfs: fix ->write_inode return values

Chunhe Lan (1):
      powerpc/p1023rds: Fix the error of bank-width of nor flash

Dan Carpenter (1):
      Bluetooth: unlock if allocation fails in hci_blacklist_add()

Dave Airlie (1):
      drm/radeon/kms: set a default max_pixel_clock

David Engraf (1):
      shwdt: fix usage of mod_timer

David S. Miller (1):
      sparc64: Only Panther cheetah+ chips have POPC.

David Woodhouse (1):
      bcma: add uevent to the bus, to autoload drivers

Eric Bénard (1):
      ARM: 7051/1: cpuimx* boards: fix mach-types errors

Eric Dumazet (3):
      bridge: fix a possible use after free
      arp: fix rcu lockdep splat in arp_process()
      netpoll: fix incorrect access to skb data in __netpoll_rx

Florian Fainelli (1):
      ARM: fix perf build with uclibc toolchains

Florian Tobias Schandinat (1):
      MAINTAINERS: change framebuffer maintainer

Geert Uytterhoeven (1):
      bitops: Move find_next_bit.o from lib-y to obj-y

Giuseppe CAVALLARO (1):
      net/phy: fix DP83865 phy interrupt handler

Huang Weiyi (1):
      ARM: EXYNOS4: remove duplicated inclusion

Ido Yariv (2):
      wl12xx: Remove obsolete testmode NVS push command
      wl12xx: Fix validation of pm_runtime_get_sync return value

Jean-Christophe PLAGNIOL-VILLARD (1):
      at91: at91sam9261.c: fix typo in t2_clk alias for atmel_tcb.0

Jerome Glisse (1):
      drm/radeon/kms: evergreen & ni reset SPI block on CP resume

Jesper Juhl (1):
      ARM: static should be at beginning of declaration

Jiaying Zhang (1):
      ext4: remove i_mutex lock in ext4_evict_inode to fix lockdep complaining

Jonghwan Choi (1):
      ARM: EXYNOS4: Fix wrong devname to support clkdev

Joonyoung Shim (1):
      drm: Fix the number of connector and encoder to cleanup functions

Kim Phillips (1):
      powerpc/85xx: enable caam crypto driver by default

Kjetil Oftedal (1):
      sparc32,sun4d: Change IPI IRQ level to prevent collision between
IPI and timer interrupt

Kukjin Kim (2):
      ARM: S5P64X0: Replace irq_gc_ack() with irq_gc_ack_set_bit()
      ARM: SAMSUNG: Fix Section mismatch in samsung_bl_set()

Kuninori Morimoto (4):
      ARM: mach-shmobile: sh7372: Add USB-DMAC support
      ARM: mach-shmobile: mackerel: Add USB-DMA ID
      ARM: mach-shmobile: clock-sh73a0: tidyup CKSCR main clock selecter
      ARM: mach-shmobile: clock-sh7372: fixup USB-DMAC1 settings

Kyungmin Park (2):
      ARM: EXYNOS4: Use the correct regulator names on universal_c210
      ARM: EXYNOS4: Add restart hook for proper reboot

Linus Torvalds (1):
      Linux 3.1-rc5

Luciano Coelho (1):
      wl12xx: add max_sched_scan_ssids value to the hw description

Magnus Damm (8):
      ARM: mach-shmobile: Use CMT2 for timer on sh7372
      clocksource: sh_cmt: wait for CMCNT on init V2
      sh: intc: enable both edges GPIO interrupts on sh7372
      serial: sh-sci: fix DMA build by including dma-mapping.h
      serial: sh-sci: console Runtime PM support
      ARM: mach-shmobile: Remove 3DG/SGX from sh7372 INTCS
      ARM: mach-shmobile: sh7372 MSIOF clock support
      ARM: mach-shmobile: sh7372 CMT3 and CMT4 clock support

Marek Szyprowski (3):
      ARM: SAMSUNG: Add chained enrty/exit call to timer interrupt handler
      ARM: EXYNOS4: add required chained_irq_enter/exit to eint code
      ARM: S5P: add required chained_irq_enter/exit to gpio-int code

Mark Rutland (2):
      ARM: perf: fix prototype of release_pmu
      ARM: perf: make name of arm_pmu_type consistent

Mathieu Desnoyers (1):
      sendmmsg/sendmsg: fix unsafe user pointer access

Mohammed Shafi Shajakhan (1):
      ath9k: Fix PS wrappers in ath9k_set_coverage_class

Namhyung Kim (1):
      md: use REQ_NOIDLE flag in md_super_write()

Naveen Krishna Chatradhi (1):
      ARM: S5P: fix bug in spdif_clk_get_rate

NeilBrown (5):
      md: report failure if a 'set faulty' request doesn't.
      md: ensure changes to 'write-mostly' are reflected in metadata.
      md/linear: avoid corrupting structure while waiting for rcu_free
to complete.
      md: fix clearing of 'blocked' flag in the presence of bad blocks.
      md/raid5: fix a hang on device failure.

Nick Bowler (1):
      ARM: 7003/1: vexpress: Add clock definition for the SP805.

Nicolas de Pesloüan (1):
      MAINTAINERS: Update GIT trees for network development

Paul Bolle (1):
      Bluetooth: btusb: be quiet on device disconnect

Paul Gortmaker (2):
      sh: Fix conflicting definitions of ptrace_triggered
      arm: fix compile failure in orion5x/dns323-setup.c

Paul Mundt (2):
      serial: sh-sci: Fix up default regtype probing.
      sh: Fix up fallout from cpuidle changes.

Peter Hurley (15):
      Bluetooth: rfcomm: Remove unnecessary krfcommd event
      Bluetooth: rfcomm: Fix lost wakeups waiting to accept socket
      Bluetooth: Fix lost wakeups waiting for sock state change
      Bluetooth: l2cap: Fix lost wakeups waiting to accept socket
      Bluetooth: sco: Fix lost wakeups waiting to accept socket
      Bluetooth: bnep: Fix lost wakeup of session thread
      Bluetooth: cmtp: Fix lost wakeup of session thread
      Bluetooth: l2cap: Fix lost wakeup waiting for ERTM acks
      Bluetooth: bnep: Fix deadlock in session deletion
      Bluetooth: cmtp: Fix deadlock in session deletion
      Bluetooth: hidp: Fix session cleanup on failed conn add
      Bluetooth: hidp: Fix memory leak of cached report descriptor
      Bluetooth: hidp: Only free input device if failed register
      Bluetooth: hidp: Don't release device ref if never held
      Bluetooth: cmtp: Fix session cleanup on failed conn add

Petr Štetiar (2):
      ARM: 6965/1: ep93xx: add model detection for ts-7300 and ts-7400 boards
      ARM: 6967/1: ep93xx: ts72xx: fix board model detection

Phil Edworthy (2):
      sh: Fix unaligned memory access for branches without delay slots
      sh: Add unaligned memory access for PC relative intructions

Ricardo Mendoza (1):
      Bluetooth: Add Toshiba laptops AR30XX device ID

Russell King (4):
      ARM: pm: CPU specific code should not overwrite r1 (v:p offset)
      ARM: pm: arm920/926: fix number of registers saved
      ARM: pm: some ARMv7 requires a dsb in resume to ensure correctness
      ARM: pm: avoid writing the auxillary control register for ARMv7

Senthil Balasubramanian (1):
      ath9k_hw: Fix STA (AR9485) bringup issue due to incorrect MAC address

Simon Horman (2):
      ARM: mach-shmobile: ag5evm: SDHI requires waiting for idle
      mmc: sdhi, mmcif: zboot: Correct clock disable logic

Srinivas Kandagatla (1):
      ARM: 7014/1: cache-l2x0: Fix L2 Cache size calculation.

Stanislaw Gruszka (2):
      mac80211: fix suspend/resume races with unregister hw
      rt2x00: do not drop usb dev reference counter on suspend

Stephen Rothwell (2):
      sparc: Remove another reference to nfsservctl
      remove remaining references to nfsservctl

Sylwester Nawrocki (1):
      ARM: EXYNOS4: Fix the IRQ definitions for MIPI CSIS device

Szymon Janc (1):
      Bluetooth: Don't use cmd_timer to timeout HCI reset command

Takashi YOSHII (1):
      serial: sh-sci: report CTS as active for get_mctrl

Timur Tabi (1):
      powerpc/85xx: enable the audio drivers in the defconfigs

Will Deacon (5):
      ARM: realview: ensure visibility of writes during reset
      ARM: twd: register clockevents device before enabling PPI
      ARM: cache: detect VIPT aliasing I-cache on ARMv6
      ARM: 7065/1: kexec: ensure new kernel is entered in ARM state
      ARM: 7066/1: proc-v7: disable SCTLR.TE when disabling MMU

Yan, Zheng (2):
      mcast: Fix source address selection for multicast listener report
      bridge: Pseudo-header required for the checksum of ICMPv6

Yoshihiro Shimoda (2):
      net: sh_eth: fix the compile error
      sh: fix the compile error in setup-sh7757.c

Yulgon Kim (1):
      ARM: EXYNOS4: Increase reset delay for USB HOST PHY

françois romieu (1):
      cassini: init before use in cas_interruptN.
