Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751259Ab1AEBQI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 20:16:08 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37892 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750919Ab1AEBQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 20:16:07 -0500
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 4 Jan 2011 17:15:45 -0800
Message-ID: <AANLkTikKA-nStyNjkdsVa8hd=PFQR3tYTJh3MnfpNkD8@mail.gmail.com>
Subject: Linux 2.6.37
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's early January, and bleary-eyed people everywhere are getting over
their hangovers and wondering where they should send their merge
requests to.

And now they can. Because 2.6.37 is out, and the merge window for the
next release is thus open. Of course, as usual, I'll probably let
2.6.37 cool for a few days to try to encourage people to look at the
release rather than go all crazy with newly merged features in the
next tree.

All in all, not a lot happened the last week. The diffstat is
dominated by some VFS locking documentation and a few updates to fix
up some ASoC codex register cache changes. The rest is really pretty
small and boring. Full shortlog (from -rc8, naturally - the shortlog
for the whole 2.6.37 release is much too big) appended.

We did have another revert to fix hopefullythe last "blank screen"
regression on intel graphics.

As to the big picture, on the whole I think 2.6.37 has been fairly
calm. That will likely change with the merge window, as I'm looking
forward to getting the new RCU-based pathname lookup and similar
exciting features. So enjoy the calm sanity while it lasts.

                    Linus

---
Andrew Morton (1):
      arch/mn10300/kernel/irq.c: fix build

Andy Walls (1):
      [media] cx25840: Prevent device probe failure due to volume
control ERANGE error

Aric D. Blumer (1):
      ARM: pxa: fix page table corruption on resume

Avi Kivity (2):
      KVM: MMU: Fix incorrect direct gfn for unpaged mode shadow
      KVM: i8259: initialize isr_ack

Axel Lin (1):
      ARM: 6605/1: Add missing include "asm/memory.h"

Ben Hutchings (2):
      starfire: Fix dma_addr_t size test for MIPS
      watchdog: Improve initialisation error message and documentation

Breno Leitao (1):
      ehea: Avoid changing vlan flags

Chris Wilson (4):
      drm/i915/sdvo: Add hdmi connector properties after initing the connector
      drm/i915: Verify Ironlake eDP presence on DP_A using the capability fuse
      Revert "drm/i915/bios: Reverse order of 100/120 Mhz SSC clocks"
      drm/i915/dvo: Report LVDS attached to ch701x as connected

Christoph Hellwig (2):
      update Documentation/filesystems/Locking
      remove trim_fs method from Documentation/filesystems/Locking

Dan Carpenter (1):
      skfp: testing the wrong variable in skfp_driver_init()

Dan Rosenberg (2):
      sound: Prevent buffer overflow in OSS load_mixer_volumes
      CAN: Use inode instead of kernel address for /proc file

Dan Williams (1):
      ueagle-atm: fix PHY signal initialization race

Daniel T Chen (1):
      ALSA: hda: Use LPIB quirk for Dell Inspiron m101z/1120

David Sterba (1):
      tg3: fix return value check in tg3_read_vpd()

Eric Anholt (2):
      drm/i915: Set the required VFMUNIT clock gating disable on Ironlake.
      drm/i915, intel_ips: When i915 loads after IPS, make IPS relink to i915.

Florian Westphal (1):
      bridge: stp: ensure mac header is set

Frederic Weisbecker (1):
      perf: Fix callchain hit bad cast on ascii display

Gregory CLEMENT (1):
      spi/omap2_mcspi.c: Force CS to be in inactive state after
off-mode transition

Guennadi Liakhovetski (1):
      dmaengine: provide dummy functions for DMA_ENGINE=n

Hans Verkuil (1):
      [media] em28xx: radio_fops should also use unlocked_ioctl

Hillf Danton (1):
      fix freeing user_struct in user cache

J. K. Cliburn (1):
      atl1: fix oops when changing tx/rx ring params

Jan Beulich (2):
      kconfig: fix undesirable side effect of adding "visible" menu attribute
      name_to_dev_t() must not call __init code

Jate Sujjavanich (1):
      spi/m68knommu: Coldfire QSPI platform support

Jesper Juhl (2):
      ISDN, Gigaset: Fix memory leak in do_disconnect_req()
      Broadcom CNIC core network driver: fix mem leak on allocation
failures in cnic_alloc_uio_rings()

Joel Sing (1):
      ipv4/route.c: respect prefsrc for local routes

Julia Lawall (1):
      drivers/atm/atmtcp.c: add missing atm_dev_put

KAMEZAWA Hiroyuki (1):
      memcg: fix wrong VM_BUG_ON() in try_charge()'s mm->owner check

Lars-Peter Clausen (9):
      ASoC: codecs: Add missing control_type initialization
      ASoC: codecs: max98088: Fix register cache incoherency
      ASoC: codecs: wm8523: Fix register cache incoherency
      ASoC: codecs: wm8741: Fix register cache incoherency
      ASoC: codecs: wm8904: Fix register cache incoherency
      ASoC: codecs: wm8955: Fix register cache incoherency
      ASoC: codecs: wm8962: Fix register cache incoherency
      ASoC: codecs: wm9090: Fix register cache incoherency
      ASoC: codecs: wm8753: Fix register cache incoherency

Lennert Buytenhek (2):
      ARM: pxa: PXA_ESERIES depends on FB_W100.
      ARM: pxa: PXA_ESERIES depends on FB_W100.

Linus Torvalds (1):
      Linux 2.6.37

Linus Walleij (1):
      ARM: 6537/1: update Nomadik, U300 and Ux500 maintainers

Mauro Carvalho Chehab (1):
      [media] wm8775: Revert changeset fcb9757333 to avoid a regression

Maurus Cuelenaere (1):
      hwmon: (s3c-hwmon) Fix compilation

Mike Rapoport (1):
      ARM: it8152: add IT8152_LAST_IRQ definition to fix build error

Mimi Zohar (1):
      ima: fix add LSM rule bug

Nicolas Pitre (3):
      ARM: get rid of kmap_high_l1_vipt()
      ARM: fix cache-xsc3l2 after stack based kmap_atomic()
      ARM: fix cache-feroceon-l2 after stack based kmap_atomic()

Nitin Gupta (1):
      Revert "Staging: zram: work around oops due to startup ordering snafu"

Robert Richter (1):
      arch/x86/oprofile/op_model_amd.c: Perform initialisation on a single CPU

Russell King (1):
      ARM: smp: avoid incrementing mm_users on CPU startup

Saeed Bishara (1):
      mv_xor: fix race in tasklet function

Stephen Warren (1):
      ARM: 6536/1: Add missing SZ_{32,64,128}

Todd Android Poynor (1):
      ARM: 6540/1: Stop irqsoff trace on return to user

Tomas Winkler (1):
      bridge: fix br_multicast_ipv6_rcv for paged skbs

stephen hemminger (1):
      ppp: allow disabling multilink protocol ID compression
