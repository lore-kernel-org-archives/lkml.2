Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790Ab2IAWLY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 18:11:24 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:43848 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755746Ab2IAWLU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 18:11:20 -0400
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 1 Sep 2012 15:10:58 -0700
X-Google-Sender-Auth: uYvhX5hhsisoxUJToL-DxWoQ0Ro
Message-ID: <CA+55aFzJWwBPgqp_QquhncpRqLXHRh0m9hHPh94Ujzd1d7kMDQ@mail.gmail.com>
Subject: Linux 3.6-rc4
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel summit is over, and most people have either returned or are
returning from San Diego.

Probably as a result of lots of maintainers having been away, it's
been pretty quiet - despite it being ten days (rather than the usual
week) since -rc3.

The statistics look a bit unusual, too, likely for the same reason.
It's 40% architecture work (powerpc, x86, mips, arm), and 20% btrfs
(late pull request of fixes, because I rejected an earlier bigger pull
request). Just 20% drivers, mainly some drm updates (the bulk being
radeon) and some block driver things (libata and drbd).

Shortlog appended, as you can see it's just fairly random. I'm hoping
we're entering the boring/stable part of the -rc windows, and that
things won't really pick up speed just because people are getting
home.

               Linus

---

Aaro Koskinen (1):
      powerpc/dma-iommu: Fix IOMMU window check

Aaron Lu (1):
      [libata] acpi: call ata_acpi_gtm during ata port init time

Afzal Mohammed (1):
      arm/dts: Fix am33xx wdt node

Alan Cox (2):
      ppc: e500_tlb memset clears nothing
      kvm: Fix nonsense handling of compat ioctl

Alex Deucher (5):
      drm/radeon: don't disable plls that are in use by other crtcs
      drm/radeon/atom: rework DIG modesetting on DCE3+
      drm/radeon/atom: powergating fixes for DCE6
      drm/radeon: rework panel mode setup
      drm/radeon: fix dig encoder selection on DCE61

Alexander Graf (1):
      KVM: PPC: Add cache flush on page map

Alexey Khoroshilov (1):
      bio: Fix potential memory leak in bio_find_or_create_slab()

Andreas Herrmann (1):
      x86, microcode, AMD: Fix broken ucode patch size check

Andreas Schwab (1):
      time: Fix casting issue in timekeeping_forward_now

Anton Blanchard (2):
      powerpc: POWER7 copy_to_user/copy_from_user patch applied twice
      powerpc: Fix VMX in interrupt check in POWER7 copy loops

Arnaldo Carvalho de Melo (1):
      perf tools: Add missing files to build the python binding

Arnaud Patard (3):
      ARM: Orion: Set eth packet size csum offload limit
      ARM: Kirkwood: Fix iconnect leds
      ARM: Kirkwood: fix Makefile.boot

Arnd Bergmann (7):
      ARM: mv78xx0: fix win_cfg_base prototype
      ARM: omap: allow building omap44xx without SMP
      ARM: imx: build pm-imx5 code only when PM is enabled
      ARM: imx: fix ksz9021rn_phy_fixup
      ARM: imx: select CPU_FREQ_TABLE when needed
      ARM: imx: build i.MX6 functions only when needed
      ARM: ux500: don't select LEDS_GPIO for snowball

Arnd Hannemann (1):
      pata_atiixp: override cable detection on MSI E350DM-E33

Arne Jansen (2):
      Btrfs: fix deadlock in wait_for_more_refs
      Btrfs: fix race in run_clustered_refs

Artem Bityutskiy (5):
      UBIFS: remove stale commentary
      UBIFS: fix crash on error path
      UBIFS: fix replay regression
      UBIFS: fix complaints about too small debug buffer size
      UBIFS: fix error messages spelling

Ashish Sangwan (1):
      UDF: During mount free lvid_bh before rescanning with different blocksize

Asias He (2):
      block: Introduce __blk_segment_map_sg() helper
      block: Add blk_bio_map_sg() helper

Avi Kivity (2):
      x86/alternatives: Fix p6 nops on non-modular kernels
      KVM: x86 emulator: use stack size attribute to mask rsp in stack ops

Ben Skeggs (1):
      drm/nvc0/copy: check PUNITS to determine which copy engines are disabled

Benjamin Herrenschmidt (1):
      Revert "powerpc: Update g5_defconfig"

Bruno Randolf (1):
      MIPS: MTX-1: Add udelay to mtx1_pci_idsel

Calvin Walton (1):
      i915: Quirk no_lvds on Gigabyte GA-D525TUD ITX motherboard

Chris Mason (1):
      Btrfs: don't run __tree_mod_log_free_eb on leaves

Chris Wilson (1):
      drm/i915: Use the correct size of the GTT for placing the
per-process entries

Christian König (1):
      drm/radeon: fix double free in radeon_gpu_reset

Christoph Hellwig (1):
      xfs: unlock the AGI buffer when looping in xfs_dialloc

Dan Carpenter (4):
      Btrfs: fix some error codes in btrfs_qgroup_inherit()
      Btrfs: checking for NULL instead of IS_ERR
      Btrfs: unlock on error in btrfs_delalloc_reserve_metadata()
      Btrfs: fix some endian bugs handling the root times

Dave Chinner (1):
      xfs: fix uninitialised variable in xfs_rtbuf_get()

David Daney (1):
      MIPS: Octeon: Fix broken interrupt controller code.

David Rientjes (1):
      mm, slab: lock the correct nodelist after reenabling irqs

Domenico Andreoli (1):
      OMAP: remove unused parameter arch_id from uncompress.h

Fengguang Wu (3):
      block: remove plugging at buffered write time
      block: move down direct IO plugging
      btrfs: fix second lock in btrfs_delete_delayed_items()

Florian Fainelli (1):
      MIPS: BCM63xx: Fix SPI message control register handling for BCM6338/6348.

Forest Bond (1):
      gma500: Consider CRTC initially active.

Gabor Juhos (5):
      MIPS: ath79: Fix number of GPIO lines for AR724[12]
      MIPS: ath79: Use correct IRQ number for the OHCI controller on AR7240
      MIPS: ath79: select HAVE_CLK
      MIPS: ath79: don't hardcode the unavailability of the DSP ASE
      MIPS: pci-ar724x: avoid data bus error due to a missing PCIe module

Geert Uytterhoeven (1):
      s390: Always use "long" for ssize_t to match size_t

Gleb Natapov (1):
      KVM: x86: update KVM_SAVE_MSRS_BEGIN to correct value

Heiko Carstens (3):
      s390/dasd: fix ioctl return value
      s390/smp: add missing smp_store_status() for !SMP
      s390/32: Don't clobber personality flags on exec

Heiko Stuebner (2):
      ARM: S3C24XX: Add missing DMACH_DT_PROP
      ARM: S3C24XX: Fix s3c2410_dma_enqueue parameters

Hugh Dickins (1):
      block: replace __getblk_slow misfix by grow_dev_page fix

Ian Abbott (1):
      udf: fix udf_setsize() for file data in ICB

Igor Grinberg (1):
      Revert "ARM: OMAP3530evm: set pendown_state and debounce time for ads7846"

J. Bruce Fields (4):
      nfsd4: fix security flavor of NFSv4.0 callback
      svcrpc: fix BUG() in svc_tcp_clear_pages
      svcrpc: sends on closed socket should stop immediately
      svcrpc: fix svc_xprt_enqueue/svc_recv busy-looping

Jakob Bornecrantz (1):
      drm: Check for invalid cursor flags

James Ralston (2):
      ahci: Add Device IDs for Intel Lynx Point-LP PCH
      ata_piix: Add Device IDs for Intel Lynx Point-LP PCH

Jan Kara (1):
      jbd: don't write superblock when unmounting an ro filesystem

Jan Luebbe (1):
      omap: Fix multi.h when only ARCH_OMAP3 and SOC_AM33XX are selected

Javier Martinez Canillas (1):
      ARM: OMAP3: igep0020: set GPIO mode for mux mcspi1_cs2 pin

Jayachandran C (1):
      MIPS: Synchronize MIPS count one CPU at a time

Jeff Garzik (1):
      [libata] new quirk, lift bridge limits for Buffalo DriveStation Quattro

Jeff Liu (1):
      quota: Move down dqptr_sem read after initializing default
warn[] type at __dquot_alloc_space().

Jeff Mahoney (1):
      reiserfs: fix deadlocks with quotas

Jerome Glisse (1):
      drm/radeon: force dma32 to fix regression rs4xx,rs6xx,rs740

Jia Hongtao (1):
      powerpc/fsl-pci: Only scan PCI bus if configured as a host

Jianpeng Ma (2):
      fs/block-dev.c:fix performance regression in O_DIRECT writes to
md block devices
      block: Don't use static to define "void *p" in show_partition_start()

Jiri Kosina (2):
      [PARISC] fix personality flag check in copy_thread()
      powerpc: Fix personality handling in ppc64_personality()

John Stultz (5):
      time: Improve sanity checking of timekeeping inputs
      time: Ensure we normalize the timekeeper in tk_xtime_add
      time: Avoid potential shift overflow with large shift values
      time: Avoid making adjustments if we haven't accumulated anything
      time: Move ktime_t overflow checking into timespec_valid_strict

Jon Hunter (1):
      ARM: OMAP2+: Fix dmtimer set source clock failure

Josef Bacik (9):
      Btrfs: lock extents as we map them in DIO
      Btrfs: do not use missing devices when showing devname
      Btrfs: do not strdup non existent strings
      Btrfs: don't allocate a seperate csums array for direct reads
      Btrfs: barrier before waitqueue_active
      Btrfs: increase the size of the free space cache
      Btrfs: fix enospc problems when deleting a subvol
      Btrfs: allow delayed refs to be merged
      Btrfs: fix deadlock with freeze and sync V2

Jussi Kivilinna (1):
      crypto: hifn_795x - fix 64bit division and undefined __divdi3 on
32bit archs

Kevin Hilman (2):
      ARM: OMAP3: TWL4030: ensure sys_nirq1 is mux'd and wakeup enabled
      Revert "ARM: OMAP3: PM: call pre/post transition per powerdomain"

Kim Phillips (3):
      crypto: caam - fix possible deadlock condition
      powerpc/fsl: update defconfigs
      powerpc/fsl: fix "Failed to mount /dev: No such device" errors

Konrad Rzeszutek Wilk (3):
      Revert "xen PVonHVM: move shared_info to MMIO before kexec"
      xen/p2m: Reuse existing P2M leafs if they are filled with 1:1
PFNs or INVALID.
      xen/setup: Fix one-off error when adding for-balloon PFNs to the P2M.

Lars Ellenberg (1):
      drbd: fix drbd wire compatibility for empty flushes

Lee Jones (2):
      ARM: ux500: Fix merge error, no matching driver name for 'snd_soc_u8500'
      ARM: ux500: Ensure probing of Audio devices when Device Tree is enabled

Linus Torvalds (1):
      Linux 3.6-rc4

Liu Bo (2):
      Btrfs: fix a dio write regression
      Btrfs: fix ordered extent leak when failing to start a transaction

Liu, Chuansheng (1):
      x86/fixup_irq: Use cpu_online_mask instead of cpu_all_mask

Luca Tettamanti (1):
      hwmon: (asus_atk0110) Add quirk for Asus M5A78L

Marek Olšák (3):
      drm/radeon: fix reading CB_COLORn_MASK from the CS
      drm/radeon: initialize tracked CS state
      drm/radeon: add proper checking of RESOLVE_BOX command for r600-r700

Mel Gorman (1):
      [PARISC] Redefine ATOMIC_INIT and ATOMIC64_INIT to drop the casts

Miao Xie (1):
      Btrfs: fix wrong mtime and ctime when creating snapshots

Michael Ellerman (2):
      powerpc: Fix xmon dl command for new printk implementation
      powerpc: Fixup whitespace in xmon

Michael Jones (1):
      omap2: mux: remove comment for nonexistent member

Michael Neuling (2):
      powerpc: Fix null pointer deref in perf hardware breakpoints
      powerpc: Remove unnecessary ifdefs

Michael S. Tsirkin (1):
      KVM: x86: fix KVM_GET_MSR for PV EOI

Miklos Szeredi (1):
      ide: fix generic_ide_suspend/resume Oops

Namjae Jeon (3):
      Documentation: update missing index files in block/00-INDEX
      Documentation: update tunable options in block/cfq-iosched.txt
      Documentation: update tunable options in block/cfq-iosched.txt

Nikola Pajkovsky (1):
      udf: fix retun value on error path in udf_load_logicalvol

Oleg Nesterov (1):
      uprobes: Fix mmap_region()'s mm->mm_rb corruption if uprobe_mmap() fails

Paolo Bonzini (2):
      block: reorganize rounding of max_discard_sectors
      block: split discard into aligned requests

Paul Mackerras (1):
      KVM: PPC: Book3S HV: Fix incorrect branch in H_CEDE code

Paul Menzel (2):
      [libata] Kconfig: Elaborate that SFF is meant for legacy and PATA stuff
      drm: Add EDID_QUIRK_FORCE_REDUCED_BLANKING for ASUS VW222S

Philipp Reisner (2):
      drbd: Finish requests that completed while IO was frozen
      drbd: Write all pages of the bitmap after an online resize

Philipp Zabel (1):
      ARM i.MX6q: Add virtual 1/3.5 dividers in the LDB clock path

Prarit Bhargava (1):
      libata: Add a space to " 2GB ATA Flash Disk" DMA blacklist entry

Prasad Joshi (5):
      logfs: destroy the reserved inodes while unmounting
      logfs: initialize the number of iovecs in bio
      logfs: create a pagecache page if it is not present
      logfs: maintain the ordering of meta-inode destruction
      logfs: query block device for number of pages to send with bio

Rajendra Nayak (3):
      arm/dts: Mark vcxio, v2v1 and v1v8 regulators as always on
      cpufreq: OMAP: Handle missing frequency table on SMP systems
      ARM: OMAP4: Register the OPP table only for 4430 device

Ralf Baechle (4):
      MIPS: Fix memory leak in error path of HI16/LO16 relocation handling.
      MIPS: Fix race condition in module relocation code.
      MIPS: Module: Deal with malformed HI16/LO16 relocation sequences.
      MIPS: Malta: Delete duplicate PCI fixup.

Randy Dunlap (1):
      watchdog: fix watchdog-test.c build warning

Richard Weinberger (1):
      x86/spinlocks: Fix comment in spinlock.h

Rob Herring (1):
      ahci: un-staticize ahci_dev_classify

Sachin Kamat (4):
      ARM: Samsung: Make uart_save static in pm.c file
      ARM: SAMSUNG: Set HDMI platform data for Exynos4x12 SoCs
      ARM: EXYNOS: Set HDMI platform data in SMDKV310
      watchdog: da9052: Remove duplicate inclusion of delay.h

Santosh Shilimkar (2):
      OMAP2+: Fix random config build break with !ARM_CPU_SUSPEND
      ARM: OMAP4: sleep: Save the complete used register stack frame

Scott Wood (1):
      powerpc/mpic_msgr: Add missing includes

Shaohua Li (1):
      block: disable discard request merge temporarily

Shawn Guo (2):
      ARM: imx6: spin the cpu until hardware takes it down
      ARM: dts: imx51-babbage: fix esdhc cd/wp properties

Shengzhou Liu (1):
      powerpc/p4080ds: dts - add usb controller version info and port0

Simon Farnsworth (1):
      HID: Remove QUANTA from special drivers list

Stefan Behrens (5):
      Btrfs: fix a misplaced address operator in a condition
      Btrfs: fix that error value is changed by mistake
      Btrfs: remove superblock writing after fatal error
      Btrfs: revert checksum error statistic which can cause a BUG()
      Btrfs: fix that repair code is spuriously executed for transid failures

Sukadev Bhattiprolu (1):
      powerpc/perf: Use pmc_overflow() to detect rolled back events

Takuya Yoshikawa (1):
      KVM: MMU: Fix mmu_shrink() so that it can free mmu pages as intended

Tiejun Chen (4):
      booke/wdt: some ioctls do not return values properly
      powerpc/kgdb: Do not set kgdb_single_step on ppc
      powerpc/kgdb: Bail out of KGDB when we've been triggered
      powerpc/kgdb: Restore current_thread_info properly

Timo Kokkonen (1):
      ARM: OMAP: dmtimers: Fix locking issue in omap_dm_timer_request*()

Tomas Racek (1):
      xfs: check for possible overflow in xfs_ioc_trim

Tushar Behera (2):
      ARM: SAMSUNG: Add API to set platform data for s5p-tv driver
      ARM: EXYNOS: Set HDMI platform data in Origen board

Vaibhav Hiremath (1):
      ARM: OMAP2+: cpu: Add am33xx device under cpu_class_is_omap2

Vijay Purushothaman (1):
      drm/i915: fix color order for BGR formats on IVB

Ville Syrjälä (1):
      drm: Initialize object type when using DRM_MODE() macro

Will Deacon (1):
      tracing/syscalls: Fix perf syscall tracing when syscall_nr == -1

Xu, Anhua (1):
      drm/i915: fix wrong order of parameters in port checking functions

Yuanhan Liu (1):
      ARM: mmp: fix potential NULL dereference

Zhao Chenhui (1):
      powerpc/85xx: mpc85xx_defconfig - add VIA PATA support for MPC85xxCDS
