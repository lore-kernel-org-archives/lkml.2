Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579Ab1CAWYd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 17:24:33 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34523 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756534Ab1CAWYb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 17:24:31 -0500
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 1 Mar 2011 14:23:43 -0800
Message-ID: <AANLkTimJQJsN_yvXjZgACQ5dDLm0Ys_7aFQsDZJRvfuP@mail.gmail.com>
Subject: Linux 2.6.38-rc7
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There really isn't a lot to report here. Driver updates (random
one-liners and some sound soc codec and smaller dri updates) and a few
filesystem updates (in particular btrfs fiemap and ENOSPC handling),
but most of it really is pretty tiny. Regressions fixed, hopefully
none introduced..

                   Linus

---

Alan Cox (1):
      cm4000_cs: Fix undefined ops warning

Alan Stern (1):
      USB: add quirks entry for Keytouch QWERTY Panel

Alex Deucher (1):
      Revert "drm/radeon/kms: switch back to min->max pll post divider
iteration"

Alexander Gordeev (1):
      pps: initialize ts_real properly

Alexandre Bounine (1):
      rapidio: fix sysfs config attribute to access 16MB of maint space

Andi Kleen (1):
      thp: fix interleaving for transparent hugepages

Andreas Herrmann (1):
      x86 quirk: Fix polarity for IRQ0 pin2 override on SB800 systems

Anton Blanchard (2):
      afs: Fix oops in afs_unlink_writeback
      RxRPC: Allocate tokens with kzalloc to avoid oops in rxrpc_destroy

Arnaldo Carvalho de Melo (1):
      perf hists: Print number of samples, not the period sum

Axel Lin (2):
      hwmon: (ad7414) add MODULE_DEVICE_TABLE
      hwmon: (adt7411) add MODULE_DEVICE_TABLE

Balaji T K (1):
      i2c-omap: fix build for !CONFIG_SUSPEND

Ben Dooks (1):
      i2c-omap: fixup commit cb527ede1bf6ff2008a025606f25344b8ed7b4ac whitespace

Ben Hutchings (1):
      mm: <asm-generic/pgtable.h> must include <linux/mm_types.h>

Ben Skeggs (1):
      drm/nv50-nvc0: make sure vma is definitely unmapped when destroying bo

Cho, Yu-Chen (1):
      Bluetooth: Add Atheros BT AR5BBU12 fw supported

Chris Mason (3):
      Btrfs: put ENOSPC debugging under a mount option
      Btrfs: allow balance to explicitly allocate chunks as it relocates
      Btrfs: fix fiemap bugs with delalloc

Chris Wilson (3):
      drm/i915: Ignore a hung GPU when flushing the framebuffer prior
to a switch
      agp/intel: Experiment with a 855GM GWB bit
      drm/i915: Fix unintended recursion in ironlake_disable_rc6

Christian Lamparter (1):
      p54pci: update receive dma buffers before and after processing

Cyrill Gorcunov (1):
      perf, x86: P4 PMU: Fix spurious NMI messages

Dan Rosenberg (1):
      xfs: prevent leaking uninitialized stack memory in FSGEOMETRY_V1

Daniel J Blueman (1):
      fix cfg80211_wext_siwfreq lock ordering...

Daniel Vetter (1):
      drm/i915: fix corruptions on i8xx due to relaxed fencing

Dave Airlie (3):
      drm/radeon/kms: align height of fb allocation.
      drm/radeon: fix regression with AA resolve checking
      drm: fix unsigned vs signed comparison issue in modeset ctl ioctl.

David Henningsson (3):
      ALSA: HDA: Fix mic initialization in VIA auto parser
      ALSA: HDA: Add a new Conexant codec 506e (20590)
      ALSA: HDA: Add ideapad quirk for two Dell machines

Davide Libenzi (1):
      epoll: prevent creating circular epoll structures

Dimitris Papastamos (2):
      ASoC: WM8994: Improve robustness in some use cases
      ASoC: WM8994: Improve playback robustness

Dmitry Eremin-Solenikov (1):
      ASoC: correct pxa AC97 DAI names

Dmitry Torokhov (5):
      USB: xhci: rework xhci_print_ir_set() to get ir set from xhci itself
      USB: xhci: fix couple sparse annotations
      USB: xhci: mark local functions as static
      Input: synaptics - document 0x0c query
      Input: serio/gameport - use 'long' system workqueue

Dominik Brodowski (1):
      pcmcia: re-enable Zoomed Video support

Don Zickus (1):
      x86: Use u32 instead of long to set reset vector back to 0

Eric Bénard (1):
      eukrea-tlv320: fix platform_name

Eric Dumazet (3):
      tcp: fix inet_twsk_deschedule()
      sfc: lower stack usage in efx_ethtool_self_test
      net_sched: long word align struct qdisc_skb_cb data

Eric W. Biederman (1):
      net: Fix more stale on-stack list_head objects.

FUJITA Tomonori (1):
      swiotlb: fix wrong panic

Felipe Balbi (2):
      usb: musb: fix build breakage
      usb: musb: core: set has_tt flag

Florian Mickler (1):
      amd64-agp: fix crash at second module load

Florian Westphal (1):
      netfilter: tproxy: do not assign timewait sockets to skb->sk

Gertjan van Wingerde (1):
      rt2x00: Fix WPA TKIP Michael MIC failures.

Greg Kroah-Hartman (1):
      Revert "USB: Reset USB 3.0 devices on (re)discovery"

Greg Thelen (1):
      mm: grab rcu read lock in move_pages()

Harry Wei (1):
      MAINTAINERS: add Chinese documentation maintainer

Hayes Wang (3):
      r8169: fix incorrect args to oob notify.
      r8169: correct settings of rtl8102e.
      r8169: fix RTL8168DP power off issue.

Henry Nestler (2):
      DM9000B: Fix reg_save after spin_lock in dm9000_timeout
      DM9000B: Fix PHY power for network down/up

Herton Ronaldo Krzesinski (1):
      MAINTAINERS: Update email address

Hugh Dickins (2):
      mm: fix possible cause of a page_mapped BUG
      memcg: more mem_cgroup_uncharge() batching

Ilya Dryomov (2):
      Btrfs: make btrfs_rm_device() fail gracefully
      Btrfs: set FMODE_EXCL in btrfs_device->mode

J. R. Okajima (1):
      Unlock vfsmount_lock in do_umount

Jacob Pan (1):
      x86/mrst: Fix apb timer rating when lapic timer is used

Jan Kara (2):
      ocfs2: Fix estimate of necessary credits for mkdir
      aio: fix race between io_destroy() and io_submit()

Janusz Krzysztofik (1):
      ASoC: CX20442: fix wrong reg_cache_default content

Jelle Martijn Kok (1):
      RTC: fix typo in drivers/rtc/rtc-at91sam9.c

Jesper Juhl (1):
      regulator, mc13xxx: Remove pointless test for unsigned less than zero

Jesper Nilsson (1):
      Drop redundant __param section for CRISv32.

Jesse Barnes (2):
      drm/i915: don't enable FDI & transcoder interrupts after all
      drm/i915: skip FDI & PCH enabling for DP_A

Jiri Bohac (1):
      sctp: fix reporting of unknown parameters

Jiri Slaby (1):
      USB: serial/usb_wwan, fix tty NULL dereference

Joerg Marx (1):
      netfilter: ip6t_LOG: fix a flaw in printing the MAC

Joerg Roedel (1):
      KVM: SVM: Advance instruction pointer in dr_intercept

Johan Hovold (2):
      usb: musb: omap2430: fix kernel panic on reboot
      USB: musb: omap2430: fix kernel panic on reboot

John Fastabend (1):
      net: dcb: match dcb_app protocol field with 802.1Qaz spec

John Ogness (1):
      OMAP2/3: clock: fix fint calculation for DPLL_FREQSEL

Jon Thomas (1):
      sierra: add new ID for Airprime/Sierra USB IP modem

Julia Lawall (1):
      drivers/char/pcmcia/ipwireless/main.c: Convert release_resource
to release_region/release_mem_region

Kevin Hilman (3):
      OMAP2420: mailbox: fix IVA vs DSP IRQ numbering
      OMAP2+: mailbox: fix lookups for multiple mailboxes
      i2c-omap: fix static suspend vs. runtime suspend

Krzysztof Wojcik (1):
      md: Fix raid1->raid0 takeover

Kushal Koolwal (1):
      x86: Fix reboot problem on VersaLogic Menlow boards

Lei Xu (1):
      drivers/rtc/rtc-ds3232.c: fix time range difference between
linux and RTC chip

Li Zefan (2):
      Btrfs: Fix BTRFS_IOC_SUBVOL_SETFLAGS ioctl
      Btrfs: Avoid accessing unmapped kernel address

Linus Lüssing (7):
      bridge: Fix IPv6 multicast snooping by storing correct protocol type
      bridge: Fix IPv6 multicast snooping by correcting offset in MLDv2 report
      bridge: Add missing ntohs()s for MLDv2 report parsing
      ipv6: Add IPv6 multicast address flag defines
      bridge: Allow mcast snooping for transient link local addresses too
      bridge: Fix MLD queries' ethernet source address
      bridge: Use IPv6 link-local address for multicast listener queries

Linus Torvalds (3):
      Revert "Bluetooth: Enable USB autosuspend by default on btusb"
      Revert "TPM: Long default timeout fix"
      Linux 2.6.38-rc7

Lu Guanqun (1):
      ALSA: fix one memory leak in sound jack

Luben Tuikov (2):
      USB: Reset USB 3.0 devices on (re)discovery
      USB: Reset USB 3.0 devices on (re)discovery

Lukas Czerner (1):
      xfs: check if device support discard in xfs_ioc_trim()

Maciej Szmigiero (2):
      USB: Add Samsung SGH-I500/Android modem ID switch to visor driver
      USB: Add quirk for Samsung Android phone modem

Mario Kleiner (3):
      drm/vblank: Use abs64(diff_ns) for s64 diff_ns instead of abs(diff_ns)
      drm/vblank: Use memory barriers optimized for atomic_t instead
of generics.
      drm/vblank: Enable precise vblank timestamps for interlaced and
doublescan modes.

Mark Brown (6):
      ASoC: Sync initial widget state with hardware
      ASoC: Ensure supplies are maintained for force enabled widgets
      ASoC: Fix WM8958 default microphone detection argument ordering
      ASoC: Correct definition of WM8903_VMID_RES_5K
      ASoC: Hook wm_hubs micbiases up to CLK_SYS
      regulator: Fix warning with CONFIG_BUG disabled

Mark Fasheh (1):
      ocfs2: Check heartbeat mode for kernel stacks only

Matti J. Aaltonen (2):
      drivers/nfc/Kconfig: use full form of the NFC acronym
      drivers/nfc/pn544.c: add missing regulator

Mel Gorman (1):
      mm: vmscan: stop reclaim/compaction earlier due to insufficient
progress if !__GFP_REPEAT

Miklos Szeredi (5):
      mm: prevent concurrent unmap_mapping_range() on the same inode
      block: fix refcounting in BLKBSZSET
      mm: fix refcounting in swapon
      fuse: fix hang of single threaded fuseblk filesystem
      fuse: fix truncate after open

Mohammed Shafi Shajakhan (1):
      ath9k: Fix ath9k prevents CPU to enter C3 states

Namhyung Kim (1):
      mm: fix dubious code in __count_immobile_pages()

NeilBrown (5):
      md: don't set_capacity before array is active.
      md: correctly handle probe of an 'mdp' device.
      md: avoid spinlock problem in blk_throtl_exit
      Fix over-zealous flush_disk when changing device size.
      md: Fix - again - partition detection when array becomes active

Nick Kossifidis (1):
      ath5k: Fix fast channel switching

Nick Piggin (1):
      aio: fix rcu ioctx lookup

Nikolay Ledovskikh (1):
      ath5k: Correct channel setting for AR2317 chip

Oliver Neukum (1):
      Bluetooth: fix crash with quirky dongles doing sound

Paul Bolle (1):
      drm: drop commented out code and preceding comment

Paul Walmsley (1):
      OMAP2+: clocksource: fix crash on boot when !CONFIG_OMAP_32K_TIMER

Paul Zimmerman (4):
      xhci: Avoid BUG() in interrupt context
      xhci: Clarify some expressions in the TRB math
      xhci: Fix errors in the running total calculations in the TRB math
      xhci: Fix an error in count_sg_trbs_needed()

Pavel Machek (1):
      pcmcia vs. MECR on pxa25x/sa1111

Peter Zijlstra (1):
      perf: Fix throttle logic

Rafael J. Wysocki (2):
      PM: Make ACPI wakeup from S5 work again when CONFIG_PM_SLEEP is unset
      ACPI: Fix build for CONFIG_NET unset

Rakesh Iyer (1):
      Input: tegra-kbc - add function keymap

Randy Dunlap (1):
      fs/block_dev.c: fix new kernel-doc warning

Richard woodruff (1):
      i2c-omap: Double clear of ARDY status in IRQ handler

Romain Francoise (1):
      .gitignore: ignore *.xz files

Santosh Shilimkar (1):
      omap4: prcm: Fix the CPUx clockdomain offsets

Shahar Havivi (1):
      Added support for usb ethernet (0x0fe6, 0x9700)

Stanislaw Gruszka (1):
      mac80211: fix conn_mon_timer running after disassociate

Stephen Warren (2):
      ASoC: WM8903: Fix mic detection register definitions
      ASoC: WM8903: Fix mic detection enable logic

Takashi Iwai (1):
      ALSA: usb-audio: fix oops due to cleanup race when disconnecting

Tejun Heo (1):
      block: bd_link_disk_holder() should hold on to holder_dir

Thomas Gleixner (3):
      genirq: Prevent access beyond allocated_irqs bitmap
      genirq: Disable the SHIRQ_DEBUG call in request_threaded_irq for now
      clockevents: Prevent oneshot mode when broadcast device is periodic

Thomas Renninger (2):
      perf timechart: Fix black idle boxes in the title
      perf timechart: Fix max number of cpus

Timo Warns (1):
      ldm: corrupted partition table can cause kernel oops

Tristan Ye (1):
      Ocfs2/refcounttree: Fix a bug for refcounttree to writeback
clusters in a right number.

Vasiliy Kulikov (3):
      mach-omap2: mux: world-writable debugfs files
      mach-omap2: pm: world-writable debugfs timer files
      mach-omap2: smartreflex: world-writable debugfs voltage files

Vitaliy Kulikov (1):
      ALSA: hda - Add support for new IDT 92HD98 and 92HD99 codecs

Vladislav P (1):
      Bluetooth: Release BTM while sleeping to avoid deadlock

Wolfram Sang (1):
      i2c-stu300: make sure adapter-name is terminated

Xose Vazquez Perez (1):
      wireless: rt2x00: rt2800pci.c: add two ids

Yuchung Cheng (1):
      tcp: undo_retrans counter fixes
