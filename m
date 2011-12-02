Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190Ab1LBBBD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 20:01:03 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:63566 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755210Ab1LBBBB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 20:01:01 -0500
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 1 Dec 2011 17:00:39 -0800
X-Google-Sender-Auth: UiG-0lirIP4o2RupzBdZFQ7SdW0
Message-ID: <CA+55aFzUjyXEqtqP4NtZJko8zhKwZAP-Q1f1t8qnPR17_ebLwA@mail.gmail.com>
Subject: Linux 3.2-rc4
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This doesn't look tons smaller than -rc2 or -rc3, but it really is.
Yes, there are some ARM updates and fixups to the new Exonys DRI code,
and a questionably late ocfs2 update, but if you ignore those three
areas (and most people can happily ignore them), things really are
calming down pretty nicely.

There are some small sound updates, and btrfs is still getting fixups
(but nowhere near -rc2 levels), but other than that it was almost
eerily quiet.

I'm waiting for the other shoe to drop. Maybe Davem and GregKH are
holding back - they've been suspiciously quiet, and I think I can hear
some evil chuckling going on there. But maybe it's just time for my
meds.

                    Linus

---
Adrian Knoth (1):
      ALSA: hdspm - Fix PCI ID for PCIe RME MADI cards

Akinobu Mita (2):
      ocfs2: use proper little-endian bitops
      ocfs2: avoid unaligned access to dqc_bitmap

Alexandre Oliva (5):
      Btrfs: initialize new bitmaps' list
      Btrfs: reset cluster's max_size when creating bitmap
      Btrfs: start search for new cluster at the beginning
      Btrfs: skip block groups without enough space for a cluster
      Btrfs: skip allocation attempt from empty cluster

Alexandre Rusev (1):
      powerpc/fsl-lbc: Fix for fsl_upm

Andy Whitcroft (1):
      iio: iio_event_getfd -- fix ev_int build failure

Archit Taneja (1):
      ARM: OMAP2PLUS: DSS: Ensure DSS works correctly if display is
enabled in bootloader

Arnd Bergmann (1):
      ARM: imx: export imx_ioremap

Arnd Hannemann (1):
      Fix URL of btrfs-progs git repository in docs

Axel Lin (7):
      ASoC: wm9081: Fix reading wrong register for setting VMID 2*240k
      ASoC: wm9081: Don't write WM9081_BIAS_ENA bit to
WM9081_VMID_CONTROL register
      ARM: SAMSUNG: include linux/types.h at gpio-cfg.h
      ASoC: cs4271: Fix wrong mask parameter in some snd_soc_update_bits calls
      hwmon: convert drivers/hwmon/* to use module_platform_driver()
      ARM: 7175/1: add subname parameter to mfp_set_groupg callers
      regulator: aat2870: Fix the logic of checking if no id is
matched in aat2870_get_regulator

Bob Liu (1):
      percpu: rename pcpu_mem_alloc to pcpu_mem_zalloc

Catalin Marinas (1):
      ARM: 7166/1: Use PMD_SHIFT instead of PGDIR_SHIFT in dma-consistent.c

Christoph Fritz (1):
      efivars: add missing parameter to efi_pstore_read()

Christoph Lameter (1):
      slub: use irqsafe_cpu_cmpxchg for put_cpu_partial

Clemens Ladisch (7):
      ASoC: adau1373: fix DB_RANGE size
      ASoC: rt5631: fix DB_RANGE size
      ASoC: sgtl5000: fix DB_RANGE size
      ASoC: wm8962: fix DB_RANGE size
      ASoC: wm8993: fix DB_RANGE size
      ASoC: wm9090: fix DB_RANGE size
      ASoC: wm_hubs: fix DB_RANGE size

Dan Carpenter (5):
      ocfs2: checking the wrong variable in ocfs2_move_extent()
      ocfs2: null deref on allocation error
      ALSA: cs5535 - Fix an endianness conversion
      ALSA: hda - cut and paste typo in cs420x_models[]
      btrfs scrub: handle -ENOMEM from init_ipath()

Dan Magenheimer (1):
      ocfs2: send correct UUID to cleancache initialization

Daniel Drake (1):
      viafb: correct sync polarity for OLPC DCON

Dave Young (1):
      percpu: explain why per_cpu_ptr_to_phys() is more complicated
than necessary

Edward Donovan (1):
      genirq: fix regression in irqfixup, irqpoll

Eric Dumazet (2):
      slub: avoid potential NULL dereference or corruption
      IB: Fix RCU lockdep splats

Eric Miao (1):
      ARM: pxa168/gplugd: add the correct SSP device

Fabio Estevam (2):
      ARM: imx: Remove unused chip revision strings
      ARM: mx5: Fix checkpatch warnings in cpu-imx5.c

Felipe Balbi (1):
      ARM: OMAP: smartreflex: fix IRQ handling bug

Govindraj.R (1):
      ARM: OMAP2+: Fix Compilation error when omap_l3_noc built as module

Guennadi Liakhovetski (1):
      ARM: 7170/2: fix compilation breakage in entry-armv.S

Haojian Zhuang (2):
      ARM: pxa: fix inconsistent CONFIG_USB_PXA27X
      ARM: mmp: fix build error on gpio

Hector Palacios (1):
      timekeeping: add arch_offset hook to ktime_get functions

Inki Dae (7):
      drm/exynos: added manager object to connector
      drm/exynos: changed exynos_drm_display to exynos_drm_display_ops
      drm/exynos: use gem create function generically
      drm/exynos: removed unnecessary variable.
      drm/exynos: changed buffer structure.
      drm/exynos: fix vblank bug.
      drm/exynos: include linux/module.h

Jan Kara (2):
      ocfs2: Avoid livelock in ocfs2_readpage()
      ocfs2: Use filemap_write_and_wait() instead of write_inode_now()

Jan Schmidt (1):
      Btrfs: fix meta data raid-repair merge problem

Jassi Brar (1):
      MAINTAINERS: Drop inactive Samsung ASoC maintainer

Javi Merino (2):
      ARM: 7163/2: PL330: Only register usable channels
      ARM: 7165/2: PL330: Fix typo in _prepare_ccr()

Jean-Christophe PLAGNIOL-VILLARD (3):
      ARM: at91: rename defconfig files appropriately
      ARM: at91: refresh soc defconfig files for 3.2
      ARM: at91: enable additional boards in existing soc defconfig files

Jeff Ohlstein (1):
      hrtimer: Fix extra wakeups from __remove_hrtimer()

Joakim Tjernlund (1):
      powerpc/qe: Fixup QE_General4 errata

Johannes Stezenbach (1):
      ASoC: sta32x: preserve coefficient RAM

John Stultz (2):
      time: Improve documentation of timekeeeping_adjust()
      clocksource: Avoid selecting mult values that might overflow when adjusted

Jon Medhurst (1):
      ARM: 7174/1: Fix build error in kprobes test code on Thumb2 kernels

Jon Medhurst (Tixy) (2):
      ARM: 7180/1: Change kprobes testcase with unpredictable STRD instruction
      ARM: 7181/1: Restrict kprobes probing SWP instructions to ARMv5 and below

Jonathan Lallinger (1):
      RDMA/cxgb4: Fix iw_cxgb4 count_rcqes() logic

Joonyoung Shim (3):
      drm/exynos: restored kernel_fb_list when reiniting fb_helper
      drm/exynos: added crtc dpms for disable crtc
      drm/exynos: Add disable of manager

Julia Lawall (2):
      fs/ocfs2/dlm/dlmlock.c: free kmem_cache_zalloc'd data using
kmem_cache_free
      arch/powerpc/sysdev/ehv_pic.c: add missing kfree

Kees Cook (1):
      pstore: pass allocated memory region back to caller

Kevin Hilman (2):
      ARM: OMAP3: CPUidle: include <linux/export.h>
      ARM: OMAP: PM: only register TWL with voltage layer when device is present

Kukjin Kim (2):
      ARM: S5P: Fix export.h inclusion
      ARM: SAMSUNG: inclusion export.h instead of module.h

Kumar Gala (2):
      powerpc/85xx: Fix compile error on p3060_qds.c
      powerpc: Fix compiliation with hugetlbfs enabled

Kumar Sanghvi (1):
      RDMA/cxgb4: Fix retry with MPAv1 logic for MPAv2

Kyungmin Park (1):
      ARM: EXYNOS: Fix compiler error with THIS_MODULE

Lars-Peter Clausen (1):
      hwmon: Remove redundant spi driver bus initialization

Li Zefan (1):
      Btrfs: fix oops when calling statfs on readonly device

Linus Torvalds (1):
      Linux 3.2-rc4

Linus Walleij (2):
      ARM: u300: update defconfig
      ARM: ux500: update defconfig

Lothar Waßmann (1):
      regulator: fix use after free bug

Manjunathappa, Prakash (1):
      video:da8xx-fb: Disable and reset sequence on version2 of LCDC

Marc Zyngier (2):
      genirq: Don't allow per cpu interrupts to be suspended
      ARM: 7176/1: cpu_pm: register GIC PM notifier only once

Mark Brown (2):
      ASoC: Ensure WM8731 register cache is synced when resuming from disabled
      gpio: pca953x: Staticise pca953x_get_altdata()

Mark Fasheh (2):
      ocfs2: serialize unaligned aio
      ocfs2: honor O_(D)SYNC flag in fallocate

Miao Xie (1):
      Btrfs: fix deadlock on metadata reservation when evicting a inode

Michal Hocko (1):
      cgroup_freezer: fix freezing groups with stopped tasks

Mike Fleetwood (1):
      Btrfs: Don't error on resizing FS to same size

Mike Marciniszyn (3):
      IB/qib: Don't use schedule_work()
      IB/qib: Fix over-scheduling of QSFP work
      IB/ipoib: Prevent hung task or softlockup processing multicast response

Ming Lei (1):
      ARM: OMAP2: select ARM_AMBA if OMAP3_EMU is defined

Paul Bolle (2):
      ARM: imx: drop 'ARCH_MX31' and 'ARCH_MX35'
      powerpc/p3060qds: Fix select of 'MPC8xxx_GPIO'

Pawel Moll (1):
      of: Add Silicon Image vendor prefix

Phil Sutter (1):
      crypto: mv_cesa - fix hashing of chunks > 1920 bytes

Rafael J. Wysocki (7):
      PM / Hibernate: Do not leak memory in error/test code paths
      ath9k: Revert change that broke AR928X on Acer Ferrari One
      PM / Domains: Document how PM domains are used by the PM core
      PM / Sleep: Correct inaccurate information in devices.txt
      PM / Runtime: Make documentation follow the new behavior of irq_safe
      PM / Sleep: Update documentation related to system wakeup
      PM: Update comments describing device power management callbacks

Richard Zhao (1):
      ARM: imx6q: move clock register map to machine_desc.map_io

Rob Herring (2):
      ARM: 7168/1: use cache type functions for arch_get_unmapped_area
      of/irq: of_irq_init: add check for parent equal to child node

Roy Zang (1):
      powerpc/p1023: set IRQ[4:6,11] to active-high level sensitive for PCIe

Sascha Hauer (1):
      MAINTAINERS: Add missing directory

Seung-Woo Kim (6):
      drm/exynos: added kms poll for handling hpd event
      drm/exynos: fixed connector flag with hpd and interlace scan for hdmi
      drm/exynos: fixed converting between display mode and timing
      drm/exynos: removed meaningless parameter from fbdev update
      drm/exynos: checked for null pointer
      drm/exynos: fixed wrong err ptr usage and destroy call in exeception

Shaohua Li (2):
      slub: use correct parameter to add a page to partial list tail
      slub: move discard_slab out of node lock

Shaohui Xie (1):
      drivers/edac/mpc85xx_edac.c: fix memory controller compatible for edac

Shawn Guo (3):
      MAINTAINERS: add ARM/FREESCALE MXS entry
      arm/imx: remove imx_idle hook and use pm_idle instead
      ARM: Update mach-types to fix mxs build breakage

Sumit Bhattacharya (1):
      ARM: 7172/1: dma: Drop GFP_COMP for DMA memory allocations

Sunil Mushran (16):
      ocfs2/cluster: Abort heartbeat start on hard-ro devices
      ocfs2/cluster: Clean up messages in o2net
      ocfs2/dlm: Clean up messages in o2dlm
      ocfs2: Clean up messages in stack_o2cb.c
      ocfs2/dlm: Cleanup up dlm_finish_local_lockres_recovery()
      ocfs2/dlm: Clean up refmap helpers
      ocfs2/dlm: Trace insert/remove of resource to/from hash
      ocfs2/dlm: Cleanup dlm_wait_for_node_death() and
dlm_wait_for_node_recovery()
      ocfs2/dlm: Take inflight reference count for remotely mastered
resources too
      ocfs2/dlm: dlmlock_remote() needs to account for remastery
      ocfs2/cluster: Fix output in file elapsed_time_in_ms
      ocfs2/cluster: Add new function o2net_fill_node_map()
      ocfs2/cluster: Cluster up now includes network connections too
      ocfs2: Clean up messages in the fs
      ocfs2: Add comment about orphan scanning
      ocfs2: Implement llseek()

Takashi Iwai (6):
      ALSA: hda - Add pin fix for Alienware M17x R3
      ALSA: hda - Check subdevice mask in snd_hda_check_board_codec_sid_config()
      ALSA: hda - Fix invalid pin and GPIO for Apple laptops with CS codecs
      ALSA: hda/realtek - Fix missing inits of item indices for auto-mic
      ALSA: hda/realtek - Minor cleanup
      ALSA: hda - Fix jack-detection control of VT1708

Tejun Heo (2):
      percpu: fix chunk range calculation
      ext4: fix racy use-after-free in ext4_end_io_dio()

Tero Kristo (1):
      regulator: twl: fix twl4030 support for smps regulators

Thomas Weber (1):
      ARM: OMAP2+: Remove empty io.h

Tiger Yang (1):
      ocfs2: Bugfix for hard readonly mount

Tim Blechmann (2):
      ALSA: lx6464es - command buffer API cleanup
      ALSA: lx6464es - fix device communication via command bus

Timo Juhani Lindfors (1):
      ASoC: wm8753: Skip noop reconfiguration of DAI mode

Timur Tabi (1):
      ASoC: fsl_ssi: properly initialize the sysfs attribute object

Tomi Valkeinen (12):
      ARM: OMAP2xxx: HWMOD: Fix DSS reset
      ARM: OMAP2xxx: HWMOD: fix DSS clock data
      ARM: OMAP3: HWMOD: Fix DSS reset
      ARM: OMAP3: HWMOD: fix DSS clock data
      ARM: OMAP4: HWMOD: remove extra clocks
      ARM: OMAP4: HWMOD: Add HWMOD_CONTROL_OPT_CLKS_IN_RESET for dss_core
      ARM: OMAP4: HWMOD: fix DSS clock data
      ARM: OMAP2/3: HWMOD: Add SYSS_HAS_RESET_STATUS for dss
      ARM: OMAP: HWMOD: Unify DSS resets for OMAPs
      OMAPDSS: HDMI: fix returned HDMI pixel clock
      OMAPFB: fix compilation warnings due to missing include
      OMAPDSS: DISPC: skip scaling calculations when not scaling

Tony Breeds (1):
      powerpc/44x: Add mtd ndfc to the ppx44x defconfig

Tony Lindgren (3):
      ARM: OMAP: Fix map_io for Amstrad E3
      ARM: OMAP: Fix dpll_data compile error when omap2 only is selected
      ARM: OMAP: Fix reprogramming of dpll1 rate

Trond Myklebust (1):
      SUNRPC: Ensure we return EAGAIN in xs_nospace if congestion is cleared

Uwe Kleine-König (1):
      ARM: imx/mm-imx3: conditionally compile i.MX31 and i.MX35 code

Vincent Guittot (1):
      ARM: 7182/1: ARM cpu topology: fix warning

Wengang Wang (3):
      ocfs2: Fix ocfs2_page_mkwrite()
      ocfs2: make direntry invalid when deleting it
      ocfs2: Commit transactions in error cases -v2

Will Deacon (10):
      ARM: PMU: re-export release_pmu symbol to modules
      ARM: PMU: remove pmu_init declaration
      ARM: highbank: convert logical CPU numbers to physical numbers
      ARM: mach-imx: convert logical CPU numbers to physical numbers
      ARM: perf: initialise used_mask for fake PMU during validation
      ARM: 7161/1: errata: no automatic store buffer drain
      ARM: 7162/1: errata: tidy up Kconfig options for PL310 errata workarounds
      ARM: perf: check that we have a platform device when reserving PMU
      ARM: 7171/1: unwind: add unwind directives to bitops assembly macros
      ARM: 7177/1: GIC: avoid skipping non-existent PPIs in irq_start
calculation

Wolfram Sang (1):
      arm: mx28: fix bit operation in clock setting

Wu Fengguang (2):
      ALSA: hda - repoll ELD content for multiple times
      ALSA: hda - fail ELD reading early

Xiaowei.Hu (1):
      ocfs2: Add a missing journal credit in ocfs2_link_credits() -v2

sricharan (1):
      ARM: OMAP: hwmod: Fix the addr space, irq, dma count APIs
