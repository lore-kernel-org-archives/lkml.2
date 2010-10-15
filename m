Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531Ab0JOWfT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 18:35:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48978 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751498Ab0JOWfQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 18:35:16 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTikjo16KzXyTLxn_OTp-B4woDHf-mHYAw_zjxNcr@mail.gmail.com>
References: <AANLkTikjo16KzXyTLxn_OTp-B4woDHf-mHYAw_zjxNcr@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 15 Oct 2010 15:34:18 -0700
Message-ID: <AANLkTikvuo86wS5meFyizWBKBU6RPHGMTod8CvL90D8C@mail.gmail.com>
Subject: Re: 2.6.36-rc8
To: Michel Lespinasse <walken@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 15, 2010 at 3:12 PM, Michel Lespinasse <walken@google.com> wrote:
> Hi Linus,
>
> It's somewhat unusual that you post an RC without an announcement.
> Could you let us know your thoughts about 2.6.36 status/timeframe at
> this point ?
>
> LWN has been wondering too: http://lwn.net/Articles/410129/

Oh, I announced it, but apparently gmail had decided to enable "rich
formatting" because I had replied to a html email earlier in the day,
and then lkml ate my announcement.

Damn, I've been very happy with gmail, but that idiotic "use html by
default even for text" is just crazy. And when I do email on the fly
on my android phone, I can't even turn it off.

Anyway, here's my announcement, now double-checked that it's just text.

                            Linus

---

I really hate doing this, and I'd much rather just release 2.6.36, but
I'm doing one last final -rc instead. There's too much noise here (and
pending in emails) for me to be happy, and while I first thought to
just delay a day or two, I'm now looking at next week instead, and
thus the additional -rc.

That's going to mean that the merge window for 37 is going to overlap
the kernel summit, but that should be ok. If people think of it as a
"I'm giving you another week before the merge window opens" instead,
and give them time to have everything ready, you can send all your
pull requests early in the window..

                  Linus

---
Alex Deucher (3):
      drm/radeon/kms: leave certain CP int bits enabled
      drm/radeon/kms: make TV/DFP table info less verbose
      drm/radeon/kms: fix bad cast/shift in evergreen.c

Anders Larsen (1):
      ARM: 6436/1: AT91: Fix power-saving in idle-mode on 926T processors

Andi Kleen (4):
      HWPOISON: Copy si_addr_lsb to user
      HWPOISON: Report correct address granuality for AO huge page errors
      HWPOISON: Stop shrinking at right page count
      Define _addr_lsb in siginfo_t for mips

Andrei Emeltchenko (1):
      Bluetooth: fix MTU L2CAP configuration parameter

Andrew Morton (1):
      MAINTAINERS: Haavard has moved

Andy Walls (1):
      V4L/DVB: cx25840: Fix typo in volume control initialization:
65335 vs. 65535

Andy Whitcroft (1):
      intel_ips -- ensure we do not enable gpu turbo mode without driver linkage

Aneesh Kumar K.V (2):
      ceph: Fix return value of encode_fh function
      ceph: Update max_len with minimum required size

Aristeu Rozanski (1):
      Input: wacom - fix pressure in Cintiq 21UX2

Arnaud Lacombe (1):
      kconfig: delay symbol direct dependency initialization

Baruch Siach (1):
      V4L/DVB: mx2_camera: fix a race causing NULL dereference

Ben Hutchings (2):
      Revert "ipv4: Make INET_LRO a bool instead of tristate."
      netdev: Depend on INET before selecting INET_LRO

Boaz Harrosh (1):
      exofs: Fix double page_unlock BUG in write_begin/end

Borislav Petkov (1):
      x86, AMD, MCE thresholding: Fix the MCi_MISCj iteration order

Breno Leitao (1):
      ehea: Fix a checksum issue on the receive path

Brian Rogers (1):
      V4L/DVB: ir-core: Fix null dereferences in the protocols sysfs interface

Chris Wilson (1):
      drm/i915: Prevent module unload to avoid random memory corruption

Dan Carpenter (8):
      V4L/DVB: unlock on error path
      V4L/DVB: IR: ir-raw-event: null pointer dereference
      V4L/DVB: opera1: remove unneeded NULL check
      V4L/DVB: pvrusb2: remove unneeded NULL checks
      V4L/DVB: saa7164: move dereference under NULL check
      cls_u32: signedness bug
      isdn: strcpy() => strlcpy()
      OSS: soundcard: locking bug in sound_ioctl()

Dan Rosenberg (3):
      V4L/DVB: ivtvfb: prevent reading uninitialized stack memory
      sctp: prevent reading out-of-bounds memory
      sctp: Fix out-of-bounds reading in sctp_asoc_get_hmac()

Dan Williams (1):
      ioat2: fix performance regression

Dave Airlie (1):
      drm: don't drop handle reference on unload

David Stevens (1):
      ipv4: correct IGMP behavior on v3 query during v2-compatibility mode

Deng-Cheng Zhu (1):
      perf, MIPS: Support cross compiling of tools/perf for MIPS

Dmitri Belimov (1):
      V4L/DVB: Fix regression for BeholdTV Columbus

Dmitry Torokhov (1):
      Input: wacom - fix runtime PM related deadlock

Eric Bénard (2):
      cpuimx27: fix compile when ULPI is selected
      cpuimx27: fix i2c bus selection

Eric Dumazet (3):
      caif: fix two caif_connect() bugs
      sysctl: fix min/max handling in __do_proc_doulongvec_minmax()
      tg3: restore rx_dropped accounting

Eric Paris (1):
      fanotify: disable fanotify syscalls

Felix Fietkau (1):
      ath9k_hw: fix regression in ANI listen time calculation

Grant Likely (1):
      of/i2c: Fix module load order issue caused by of_i2c.c

Greg Farnum (1):
      ceph: send cap release message early on failed revoke.

Greg Ungerer (1):
      net: allow FEC driver to use fixed PHY support

Gustavo F. Padovan (5):
      Bluetooth: Simplify L2CAP Streaming mode sending
      Bluetooth: Fix inconsistent lock state with RFCOMM
      Revert "Bluetooth: Don't accept ConfigReq if we aren't in the
BT_CONFIG state"
      Bluetooth: Fix deadlock in the ERTM logic
      Bluetooth: Disallow to change L2CAP_OPTIONS values when connected

Hans Verkuil (1):
      V4L/DVB: videobuf-dma-sg: set correct size in last sg element

Hari Kanigeri (1):
      omap: iommu-load cam register before flushing the entry

Henrik Rydberg (1):
      Input: uinput - setup MT usage during device creation

Henry C Chang (1):
      ceph: fix list_add usage on unsafe_writes list

Ionut Gabriel Popescu (1):
      V4L/DVB: mt9v022.c: Fixed compilation warning

J. Bruce Fields (1):
      nfsd: fix BUG at fs/nfsd/nfsfh.h:199 on unlink

Jarod Wilson (1):
      V4L/DVB: mceusb: add two new ASUS device IDs

Jason Wang (1):
      V4L/DVB: gspca - main: Fix a crash of some webcams on ARM arch

Jean Delvare (1):
      drm/radeon/kms: Silent spurious error message

Jean-François Moine (1):
      V4L/DVB: gspca - sn9c20x: Bad transfer size of Bayer images

Jeff Kirsher (4):
      ixgbevf.txt: Update ixgbevf documentation
      e1000.txt: Update e1000 documentation
      e1000e.txt: Add e1000e documentation
      MAINTAINERS: update Intel LAN Ethernet info

Jens Axboe (1):
      elevator: fix oops on early call to elevator_change()

Jerome Glisse (1):
      drm/radeon/kms: avoid corner case issue with unmappable vram V2

Jesse Barnes (4):
      IPS driver: don't toggle CPU turbo on unsupported CPUs
      IPS driver: verify BIOS provided limits
      IPS driver: apply BIOS provided CPU limit if different from default
      IPS driver: disable CPU turbo

Jin Dongming (1):
      x86, mce, therm_throt.c: Fix missing curly braces in error handling logic

Jiri Slaby (4):
      ATM: solos-pci, remove use after free
      ATM: mpc, fix use after free
      ATM: iphase, remove sleep-inside-atomic
      NET: wimax, fix use after free

Johannes Berg (1):
      mac80211: delete AddBA response timer

Johannes Weiner (1):
      xfs: properly account for reclaimed inodes

John Blackwood (1):
      perf: Fix incorrect copy_from_user() usage

John W. Linville (1):
      Revert "mac80211: use netif_receive_skb in ieee80211_tx_status callpath"

Kees Cook (2):
      net: clear heap allocation for ETHTOOL_GRXCLSRLALL
      net: clear heap allocations for privileged ethtool actions

Kenneth Waters (1):
      Input: joydev - fix JSIOCSAXMAP ioctl

Kirill A. Shutemov (1):
      memcg: fix thresholds with use_hierarchy == 1

Kukjin Kim (1):
      ARM: SAMSUNG: Fix build warnings because of unused codes

Kyle McMartin (1):
      kbuild: fix oldnoconfig to do the right thing

Kyungmin Park (1):
      MAINTAINERS: add Samsung S5P series FIMC maintainers

Laurent Pinchart (2):
      V4L/DVB: uvcvideo: Fix support for Medion Akoya All-in-one PC
integrated webcam
      V4L/DVB: uvcvideo: Restrict frame rates for Chicony CNF7129 webcam

Lee, Chun-Yi (1):
      ACPI: add DMI to disable AML Vista compatibility on MSI GX723 Notebook

Len Brown (1):
      intel_idle: enable Atom C6

Linus Torvalds (3):
      Don't dump task struct in a.out core-dumps
      Un-inline the core-dump helper functions
      Linux 2.6.36-rc8

Luke Yelavich (1):
      ALSA: hda - Add another HP DV6 quirk

Maciej Żenczykowski (1):
      net: Fix IPv6 PMTU disc. w/ asymmetric routes

Marek Szyprowski (2):
      V4L/DVB: v4l: radio: si470x: fix unneeded free_irq() call
      ARM: SAMSUNG: Add a workaround for get_clock() for serial driver

Mark Brown (3):
      ASoC: Add Jassi Brar as Samsung maintainer
      ASoC: Add Dimitris Papastamos to Wolfson maintainers
      ASoC: Update links for Wolfson MAINTAINERS entry

Mat Martineau (1):
      Bluetooth: Only enable L2CAP FCS for ERTM or streaming

Matthew Garrett (1):
      IPS driver: Fix limit clamping when reducing CPU power

Mauro Carvalho Chehab (3):
      V4L/DVB: Don't identify PV SBTVD Hybrid as a DibCom device
      V4L/DVB: rc-core: increase repeat time
      V4L/DVB: cx231xx: Avoid an OOPS when card is unknown (card=0)

Maxim Levitsky (3):
      V4L/DVB: IR: fix duty cycle capability
      V4L/DVB: IR: fix keys beeing stuck down forever
      V4L/DVB: IR: extend MCE keymap

Michael Grzeschik (2):
      V4L/DVB: mt9m111: cropcap and s_crop check if type is VIDEO_CAPTURE
      V4L/DVB: mt9m111: added current colorspace at g_fmt

Michal Marek (1):
      kconfig: Temporarily disable dependency warnings

Mika Westerberg (1):
      ARM: 6440/1: ep93xx: DMA: fix channel_disable

Mike Snitzer (1):
      virtio-blk: fix request leak.

Nagendra Tomar (1):
      net: Fix the condition passed to sk_wait_event()

Naoya Horiguchi (1):
      page-types.c: fix name of unpoison interface

Neil Horman (1):
      bonding: fix WARN_ON when writing to bond_master sysfs file

NeilBrown (2):
      md/raid1:  avoid overflow in raid1 resync when bitmap is in use.
      md/raid1: minor bio initialisation improvements.

Olivier Grenie (2):
      V4L/DVB: dib7770: enable the current mirror
      V4L/DVB: dib7000p: add disable sample and hold, and diversity
delay parameter

Oskar Schirmer (1):
      net/fec: carrier off initially to avoid root mount failure

Paul Fertser (1):
      b44: fix carrier detection on bind

Pawel Osciak (4):
      V4L/DVB: v4l: mem2mem_testdev: fix errorenous comparison
      V4L/DVB: v4l: mem2mem_testdev: add missing release for video_device
      V4L/DVB: v4l: s5p-fimc: Fix return value on probe() failure
      V4L/DVB: v4l: videobuf: prevent passing a NULL to dma_free_coherent()

Rajendra Nayak (1):
      i2c: Fix checks which cause legacy suspend to never get called

Randy Dunlap (1):
      V4L/DVB: tm6000: depends on IR_CORE

Richard Zidlicky (1):
      V4L/DVB: dvb: fix smscore_getbuffer() logic

Robin Holt (1):
      mm: alloc_large_system_hash() printk overflow on 16TB boot

Russell King (2):
      ARM: fix section mismatch warnings in Versatile Express
      ARM: relax ioremap prohibition (309caa9) for -final and -stable

Sage Weil (2):
      ceph: avoid null deref in osd request error path
      ceph: update issue_seq on cap grant

Santosh Shilimkar (1):
      ARM: 6419/1: mmu: Fix MT_MEMORY and MT_MEMORY_NONCACHED pte flags

SeungChull Suh (1):
      ARM: S5P: Bug fix on errors of build with CONFIG_PREEMPT_NONE

Stanislaw Gruszka (3):
      skge: add quirk to limit DMA
      r8169: allocate with GFP_KERNEL flag when able to sleep
      r8169: use device model DMA API

Stefan Ringel (1):
      V4L/DVB: tm6000: bugfix data handling

Steven Rostedt (1):
      ring-buffer: Fix typo of time extends per page

Sylwester Nawrocki (1):
      V4L/DVB: v4l: s5p-fimc: Fix 3-planar formats handling and pixel
offset error on S5PV210 SoCs

Thomas Hellstrom (1):
      drm/ttm: Fix two race conditions + fix busy codepaths

Tim Gardner (1):
      intel_ips: Print MCP limit exceeded values.

Tony Lindgren (1):
      ARM: 6435/1: Fix HWCAP_TLS flag for ARM11MPCore/Cortex-A9

Vasiliy Kulikov (1):
      md: check return code of read_sb_page

Vishwanath BS (1):
      i2c: Fix for suspend/resume issue

Will Deacon (2):
      ARM: 6416/1: errata: faulty hazard checking in the Store Buffer
may lead to data corruption
      ARM: 6412/1: kprobes-decode: add support for MOVW instruction

Wolfram Sang (1):
      i2c: Remove obsolete cleanup for clientdata

Yegor Yefremov (1):
      i2c-pca: Fix waitforcompletion() return value

Yinghai Lu (2):
      ACPI: Handle ACPI0007 Device in acpi_early_set_pdc
      x86, numa: For each node, register the memory blocks actually used

Zachary Amsden (2):
      KVM: x86: Fix SVM VMCB reset
      KVM: x86: Move TSC reset out of vmcb_init

lawrence rust (1):
      V4L/DVB: cx88: Kconfig: Remove EXPERIMENTAL dependency from
VIDEO_CX88_ALSA

minskey guo (4):
      seqno mask of THM_ITV register is 16bit
      old_cpu_power is wrongly divided by 65535 in ips_monitor()
      Release symbol on error-handling path of ips_get_i915_syms()
      NULL pointer might be used in ips_monitor()
