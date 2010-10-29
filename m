Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934248Ab0J2RZm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 13:25:42 -0400
Received: from kroah.org ([198.145.64.141]:59319 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934221Ab0J2RZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 13:25:30 -0400
Date: Fri, 29 Oct 2010 10:24:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.35.8
Message-ID: <20101029172450.GE17043@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.35.8 kernel.

All users of the 2.6.35 kernel series must upgrade.

There will only be one more .35 kernel released after this one, so you
should be using .36 instead.

The updated 2.6.35.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.35.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.35.y.git;a=summary

thanks,

greg k-h

------------

 Documentation/sound/alsa/HD-Audio-Models.txt |    1 
 Makefile                                     |    2 
 arch/arm/Kconfig                             |    1 
 arch/arm/mach-vexpress/ct-ca9x4.c            |    2 
 arch/arm/oprofile/common.c                   |    7 ++
 arch/powerpc/kernel/head_64.S                |   18 ++++---
 arch/um/drivers/ubd_kern.c                   |    9 ++-
 arch/x86/include/asm/amd_iommu_proto.h       |    6 ++
 arch/x86/include/asm/amd_iommu_types.h       |   12 ++++
 arch/x86/include/asm/pgtable_32.h            |    1 
 arch/x86/include/asm/trampoline.h            |    5 +-
 arch/x86/kernel/Makefile                     |    2 
 arch/x86/kernel/amd_iommu.c                  |    4 +
 arch/x86/kernel/amd_iommu_init.c             |   67 ++++++++++++++++++---------
 arch/x86/kernel/apic/io_apic.c               |   11 +++-
 arch/x86/kernel/cpu/common.c                 |    4 -
 arch/x86/kernel/cpu/cpu.h                    |    1 
 arch/x86/kernel/cpu/intel.c                  |    1 
 arch/x86/kernel/cpu/mcheck/mce_amd.c         |    9 +--
 arch/x86/kernel/head_32.S                    |    8 ++-
 arch/x86/kernel/hpet.c                       |    2 
 arch/x86/kernel/setup.c                      |    2 
 arch/x86/kernel/smpboot.c                    |   32 +++++-------
 arch/x86/kernel/trampoline.c                 |   17 ++++++
 arch/x86/kvm/irq.h                           |    2 
 arch/x86/kvm/svm.c                           |    2 
 arch/x86/mm/srat_64.c                        |    8 ++-
 arch/x86/oprofile/nmi_int.c                  |    1 
 block/bsg.c                                  |    2 
 drivers/acpi/acpica/aclocal.h                |    1 
 drivers/acpi/blacklist.c                     |   16 ++++++
 drivers/acpi/bus.c                           |   14 +----
 drivers/acpi/processor_core.c                |    7 --
 drivers/acpi/sleep.c                         |   22 ++++++++
 drivers/ata/ahci.c                           |    4 +
 drivers/ata/ahci.h                           |   12 ++++
 drivers/ata/ahci_platform.c                  |    6 ++
 drivers/ata/libahci.c                        |   16 +-----
 drivers/block/virtio_blk.c                   |    6 ++
 drivers/char/agp/intel-agp.c                 |    1 
 drivers/char/agp/intel-agp.h                 |    6 ++
 drivers/char/agp/intel-gtt.c                 |   50 ++++++++++++++++----
 drivers/char/virtio_console.c                |   17 +++++-
 drivers/dma/ioat/dma_v2.c                    |    2 
 drivers/dma/mv_xor.c                         |    2 
 drivers/edac/i7core_edac.c                   |    1 
 drivers/firewire/ohci.c                      |   19 -------
 drivers/firewire/ohci.h                      |    8 ---
 drivers/gpu/drm/drm_gem.c                    |   31 +++---------
 drivers/gpu/drm/drm_vm.c                     |   28 +++++++----
 drivers/gpu/drm/i915/i915_dma.c              |    9 ++-
 drivers/gpu/drm/i915/i915_gem.c              |   31 +++++++++---
 drivers/gpu/drm/radeon/evergreen.c           |    4 +
 drivers/gpu/drm/radeon/r600.c                |    3 -
 drivers/gpu/drm/radeon/radeon_atombios.c     |    9 +++
 drivers/gpu/drm/radeon/radeon_cursor.c       |   28 ++++-------
 drivers/gpu/drm/radeon/radeon_display.c      |    2 
 drivers/hid/hidraw.c                         |   11 ++++
 drivers/hwmon/lis3lv02d.c                    |    4 -
 drivers/i2c/busses/i2c-pca-isa.c             |   12 +++-
 drivers/i2c/busses/i2c-pca-platform.c        |   11 ++--
 drivers/infiniband/hw/cxgb3/iwch_cm.c        |    6 +-
 drivers/input/joydev.c                       |    3 +
 drivers/input/tablet/wacom_wac.c             |    4 +
 drivers/media/IR/ir-keytable.c               |    2 
 drivers/media/dvb/dvb-usb/dib0700_devices.c  |   55 +++++++++++++++++++++-
 drivers/media/dvb/frontends/dib7000p.c       |    2 
 drivers/media/dvb/frontends/dib7000p.h       |    3 +
 drivers/media/video/cx231xx/Makefile         |    1 
 drivers/media/video/cx231xx/cx231xx-cards.c  |   17 ++++--
 drivers/media/video/gspca/gspca.c            |    1 
 drivers/media/video/gspca/sn9c20x.c          |    3 -
 drivers/media/video/v4l2-compat-ioctl32.c    |   32 ++++++++----
 drivers/mfd/wm831x-irq.c                     |    9 ++-
 drivers/mmc/core/core.c                      |   13 +++++
 drivers/mmc/host/sdhci-s3c.c                 |    6 +-
 drivers/net/atlx/atl1.c                      |    5 +-
 drivers/net/b44.c                            |    4 -
 drivers/net/r8169.c                          |   12 ++--
 drivers/net/skge.c                           |   18 ++++++-
 drivers/pci/quirks.c                         |   20 ++++++++
 drivers/scsi/scsi.c                          |    4 -
 drivers/usb/core/file.c                      |   35 ++++++--------
 drivers/usb/core/message.c                   |    1 
 drivers/usb/musb/musb_gadget.c               |   22 +++++++-
 drivers/usb/musb/musb_gadget.h               |    2 
 drivers/usb/musb/musb_gadget_ep0.c           |    9 +++
 fs/exec.c                                    |   14 +++++
 fs/ocfs2/symlink.c                           |    2 
 fs/proc/task_mmu.c                           |    3 -
 fs/reiserfs/ioctl.c                          |    7 +-
 fs/xfs/linux-2.6/xfs_sync.c                  |   16 ++++--
 fs/xfs/linux-2.6/xfs_sync.h                  |    1 
 fs/xfs/xfs_iget.c                            |    1 
 include/drm/drmP.h                           |   11 ++--
 include/drm/drm_pciids.h                     |    2 
 include/linux/intel-gtt.h                    |   20 ++++++++
 include/linux/mm.h                           |    6 ++
 include/linux/pci_ids.h                      |    3 +
 kernel/hrtimer.c                             |   13 ++++-
 kernel/trace/ring_buffer.c                   |    2 
 lib/list_sort.c                              |    2 
 mm/ksm.c                                     |    6 +-
 mm/mlock.c                                   |    6 --
 net/mac80211/rx.c                            |    4 -
 net/rds/page.c                               |   27 ++--------
 net/wireless/wext-priv.c                     |    2 
 sound/core/control.c                         |    5 ++
 sound/core/rawmidi.c                         |    4 +
 sound/oss/soundcard.c                        |    4 -
 sound/pci/hda/patch_analog.c                 |    1 
 sound/pci/hda/patch_conexant.c               |   20 ++++++++
 sound/pci/oxygen/oxygen.c                    |    4 +
 sound/pci/rme9652/hdsp.c                     |    1 
 sound/pci/rme9652/hdspm.c                    |    1 
 virt/kvm/eventfd.c                           |    3 -
 virt/kvm/kvm_main.c                          |    4 +
 117 files changed, 773 insertions(+), 343 deletions(-)


Alan Stern (1):
      USB: fix bug in initialization of interface minor numbers

Alex Deucher (6):
      drm/radeon/kms: fix bad cast/shift in evergreen.c
      drm/radeon/kms: avivo cursor workaround applies to evergreen as well
      drm/radeon/kms: fix possible sigbus in evergreen accel code
      drm/radeon/kms: fix up encoder info messages for DFP6
      drm/radeon/kms: fix potential segfault in r600_ioctl_wait_idle
      drm/radeon/kms: add quirk for MSI K9A2GM motherboard

Amit Shah (1):
      virtio: console: Don't block entire guest if host doesn't read data

Antonio Ospite (2):
      HID: hidraw, fix a NULL pointer dereference in hidraw_ioctl
      HID: hidraw, fix a NULL pointer dereference in hidraw_write

Aristeu Rozanski (1):
      Input: wacom - fix pressure in Cintiq 21UX2

Borislav Petkov (1):
      x86, AMD, MCE thresholding: Fix the MCi_MISCj iteration order

Catalin Marinas (1):
      ARM: 6395/1: VExpress: Set bit 22 in the PL310 (cache controller) AuxCtlr register

Chris Wilson (4):
      drm/i915: Prevent module unload to avoid random memory corruption
      drm/i915: Sanity check pread/pwrite
      drm: Prune GEM vma entries
      drm: Hold the mutex when dropping the last GEM reference (v2)

Clemens Ladisch (1):
      ALSA: rawmidi: fix oops (use after free) when unloading a driver module

Colin Ian King (1):
      ACPI: enable repeated PCIEXP wakeup by clearing PCIEXP_WAKE_STS on resume

Dan Carpenter (1):
      OSS: soundcard: locking bug in sound_ioctl()

Dan Rosenberg (2):
      ALSA: sound/pci/rme9652: prevent reading uninitialized stack memory
      ALSA: prevent heap corruption in snd_ctl_new()

Dan Williams (1):
      ioat2: fix performance regression

Dave Airlie (1):
      drm/radeon: fix PCI ID 5657 to be an RV410

Don Mullis (1):
      lib/list_sort: do not pass bad pointers to cmp callback

Erik J. Staab (1):
      ALSA: oxygen: fix analog capture on Claro halo cards

FUJITA Tomonori (1):
      bsg: fix incorrect device_status value

Frederic Weisbecker (2):
      reiserfs: fix dependency inversion between inode and reiserfs mutexes
      reiserfs: fix unwanted reiserfs lock recursion

Greg Kroah-Hartman (1):
      Linux 2.6.35.8

H. Peter Anvin (2):
      x86, cpu: After uncapping CPUID, re-run CPU feature detection
      x86-32: Fix dummy trampoline-related inline stubs

Herton Ronaldo Krzesinski (1):
      ALSA: hda - add ideapad model for Conexant 5051 codec

Hugh Dickins (2):
      ksm: fix bad user data when swapping
      x86, mm: Fix CONFIG_VMSPLIT_1G and 2G_OPT trampoline

Jacob Pan (1):
      x86: detect scattered cpuid features earlier

Jason Wang (1):
      V4L/DVB: gspca - main: Fix a crash of some webcams on ARM arch

Jean-François Moine (1):
      V4L/DVB: gspca - sn9c20x: Bad transfer size of Bayer images

Jeremy Fitzhardinge (1):
      tracing/x86: Don't use mcount in pvclock.c

Jesse Barnes (1):
      drm/i915: fix GMCH power reporting

Jiri Olsa (1):
      oprofile: Add Support for Intel CPU Family 6 / Model 29

Joel Becker (1):
      ocfs2: Don't walk off the end of fast symlinks.

Joerg Roedel (4):
      x86/amd-iommu: Set iommu configuration flags in enable-loop
      x86/amd-iommu: Fix rounding-bug in __unmap_single
      x86/amd-iommu: Work around S3 BIOS bug
      x86-32: Separate 1:1 pagetables from swapper_pg_dir

Johannes Berg (2):
      mac80211: fix use-after-free
      wext: fix potential private ioctl memory content leak

Johannes Weiner (1):
      xfs: properly account for reclaimed inodes

Julia Lawall (1):
      drivers/gpu/drm/i915/i915_gem.c: Add missing error handling code

Kenneth Waters (1):
      Input: joydev - fix JSIOCSAXMAP ioctl

Len Brown (4):
      ACPI: invoke DSDT corruption workaround on all Toshiba Satellite
      intel_idle: PCI quirk to prevent Lenovo Ideapad s10-3 boot hang
      ACPI: EC: add Vista incompatibility DMI entry for Toshiba Satellite L355
      ACPI: delete ZEPTO idle=nomwait DMI quirk

Linus Torvalds (2):
      v4l1: fix 32-bit compat microcode loading translation
      De-pessimize rds_page_copy_user

Luca Tettamanti (1):
      atl1: fix resume

Luke Yelavich (1):
      ALSA: hda - Add Dell Latitude E6400 model quirk

Marcelo Tosatti (5):
      KVM: i8259: fix migration
      KVM: x86: Fix SVM VMCB reset
      KVM: x86: Move TSC reset out of vmcb_init
      KVM: fix irqfd assign/deassign race
      KVM: Fix reboot on Intel hosts

Marcin Slusarz (1):
      i7core_edac: fix panic in udimm sysfs attributes registration

Marek Szyprowski (1):
      mmc: sdhci-s3c: fix NULL ptr access in sdhci_s3c_remove

Mark Brown (1):
      mfd: Ignore non-GPIO IRQs when setting wm831x IRQ types

Martin K. Petersen (1):
      Fix VPD inquiry page wrapper

Matt Evans (1):
      powerpc: Initialise paca->kstack before early_setup_secondary

Mauro Carvalho Chehab (2):
      V4L/DVB: cx231xx: Avoid an OOPS when card is unknown (card=0)
      V4L/DVB: Don't identify PV SBTVD Hybrid as a DibCom device

Maxim Levitsky (1):
      V4L/DVB: IR: fix keys beeing stuck down forever

Michael Neuling (1):
      powerpc: Don't use kernel stack with translation off

Mike Snitzer (1):
      virtio-blk: fix request leak.

Ming Lei (1):
      usb: musb: gadget: fix kernel panic if using out ep with FIFO_TXRX style

Ohad Ben-Cohen (1):
      mmc: sdio: fix SDIO suspend/resume regression

Olivier Grenie (1):
      V4L/DVB: dib7770: enable the current mirror

Paul Fertser (1):
      b44: fix carrier detection on bind

Peter Korsgaard (1):
      ARM: 6400/1: at91: fix arch_gettimeoffset fallout

Rafael J. Wysocki (1):
      PM / ACPI: Blacklist systems known to require acpi_sleep=nonvs

Robert Richter (1):
      oprofile, ARM: Release resources on failure

Roland McGrath (3):
      setup_arg_pages: diagnose excessive argument size
      execve: improve interactivity with large arguments
      execve: make responsive to SIGKILL with large arguments

Salman Qazi (1):
      hrtimer: Preserve timer state in remove_hrtimer()

Sergei Shtylyov (1):
      usb: musb: gadget: restart request on clearing endpoint halt

Simon Guinot (1):
      dmaengine: fix interrupt clearing for mv_xor

Stanislaw Gruszka (2):
      skge: add quirk to limit DMA
      r8169: allocate with GFP_KERNEL flag when able to sleep

Stefan Bader (1):
      mm: Move vma_stack_continue into mm.h

Stefan Richter (1):
      firewire: ohci: fix TI TSB82AA2 regression since 2.6.35

Steve Wise (1):
      RDMA/cxgb3: Turn off RX coalescing for iWARP connections

Steven Rostedt (2):
      tracing/x86: Don't use mcount in kvmclock.c
      ring-buffer: Fix typo of time extends per page

Takashi Iwai (1):
      hwmon: (lis3) Fix Oops with NULL platform data

Tejun Heo (2):
      ahci: fix module refcount breakage introduced by libahci split
      ubd: fix incorrect sector handling during request restart

Thomas Gleixner (2):
      x86, hpet: Fix bogus error check in hpet_assign_irq()
      x86, irq: Plug memory leak in sparse irq

Yegor Yefremov (1):
      i2c-pca: Fix waitforcompletion() return value

Yinghai Lu (2):
      x86, numa: For each node, register the memory blocks actually used
      ACPI: Handle ACPI0007 Device in acpi_early_set_pdc

Zhang Rui (1):
      ACPI: Disable Windows Vista compatibility for Toshiba P305D

Zhenyu Wang (1):
      agp/intel: Fix cache control for Sandybridge

