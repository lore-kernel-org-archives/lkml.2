Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933163Ab2JKASO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 20:18:14 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:48966 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933118Ab2JKARc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 20:17:32 -0400
X-Sasl-enc: jnaGO3DDr8WHEijQEKuFSm1W2E4EPyX+qyK++3gVarI2 1349914650
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk
Subject: =?UTF-8?q?=5B=20000/122=5D=203=2E6=2E2-stable=20review?=
Date: Thu, 11 Oct 2012 07:52:46 +0900
Message-Id: <20121010225337.989799482@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.6.2 release.
There are 122 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri Oct 12 22:53:00 UTC 2012.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.6.2-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Frediano Ziglio <frediano.ziglio@citrix.com>
    Convert properly UTF-8 to UTF-16

Jeff Layton <jlayton@redhat.com>
    cifs: reinstate the forcegid option

Brian Norris <computersforpeace@gmail.com>
    JFFS2: don't fail on bitflips in OOB

Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
    JFFS2: fix unmount regression

Guennadi Liakhovetski <g.liakhovetski@gmx.de>
    mmc: sh-mmcif: avoid oops on spurious interrupts

Chris Ball <cjb@laptop.org>
    mmc: slot-gpio: Fix missing assignment to ctx->ro_gpio

Vaibhav Bedia <vaibhav.bedia@ti.com>
    mmc: omap_hsmmc: Pass on the suspend failure to the PM core

Andreas Bießmann <andreas@biessmann.de>
    mtd: omap2: fix module loading

Andreas Bießmann <andreas@biessmann.de>
    mtd: omap2: fix omap_nand_remove segfault

Shmulik Ladkani <shmulik.ladkani@gmail.com>
    mtd: nand: Use the mirror BBT descriptor when reading its version

Richard Genoud <richard.genoud@gmail.com>
    mtd: nandsim: bugfix: fail if overridesize is too big

Alexander Shiyan <shc_work@mail.ru>
    mtd: autcpu12-nvram: Fix compile breakage

Huang Shijie <shijie8@gmail.com>
    mtd: mtdpart: break it as soon as we parse out the partitions

Dylan Reid <dgreid@chromium.org>
    ALSA: hda - Fix hang caused by race during suspend.

Quinlan Pfiffer <qpfiffer@gmail.com>
    asix: Adds support for Lenovo 10/100 USB dongle.

Peter Zijlstra <peterz@infradead.org>
    sched: Fix load avg vs. cpu-hotplug

Mauro Carvalho Chehab <mchehab@redhat.com>
    em28xx: regression fix: use DRX-K sync firmware requests on em28xx

Seiji Aguchi <seiji.aguchi@hds.com>
    efi: initialize efi.runtime_version to make query_variable_info/update_capsule workable

Matthew Garrett <mjg@redhat.com>
    efi: Build EFI stub with EFI-appropriate options

Mel Gorman <mgorman@suse.de>
    mempolicy: fix a memory corruption by refcount imbalance in alloc_pages_vma()

KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
    mempolicy: fix refcount leak in mpol_set_shared_policy()

Mel Gorman <mgorman@suse.de>
    mempolicy: fix a race in shared_policy_replace()

KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
    mempolicy: remove mempolicy sharing

KOSAKI Motohiro <kosaki.motohiro@gmail.com>
    revert "mm: mempolicy: Let vma_merge and vma_split handle vma->vm_policy linkages"

Paul E. McKenney <paul.mckenney@linaro.org>
    rcu: Fix day-one dyntick-idle stall-warning bug

Frederic Weisbecker <fweisbec@gmail.com>
    score: Add missing RCU idle APIs on idle loop

Frederic Weisbecker <fweisbec@gmail.com>
    m32r: Add missing RCU idle APIs on idle loop

Frederic Weisbecker <fweisbec@gmail.com>
    cris: Add missing RCU idle APIs on idle loop

Frederic Weisbecker <fweisbec@gmail.com>
    alpha: Add missing RCU idle APIs on idle loop

Frederic Weisbecker <fweisbec@gmail.com>
    m68k: Add missing RCU idle APIs on idle loop

Frederic Weisbecker <fweisbec@gmail.com>
    mn10300: Add missing RCU idle APIs on idle loop

Frederic Weisbecker <fweisbec@gmail.com>
    frv: Add missing RCU idle APIs on idle loop

Frederic Weisbecker <fweisbec@gmail.com>
    xtensa: Add missing RCU idle APIs on idle loop

Frederic Weisbecker <fweisbec@gmail.com>
    parisc: Add missing RCU idle APIs on idle loop

Frederic Weisbecker <fweisbec@gmail.com>
    h8300: Add missing RCU idle APIs on idle loop

Paul E. McKenney <paul.mckenney@linaro.org>
    ia64: Add missing RCU idle APIs on idle loop

Ben Widawsky <ben@bwidawsk.net>
    drm/i915: Fix GT_MODE default value

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/i915: call drm_handle_vblank before finish_page_flip

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Flush the pending flips on the CRTC before modification

Ratan Nalumasu <ratan@google.com>
    HID: hidraw: don't deallocate memory when it is in use

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: force MSIs on RS690 asics

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: Add MSI quirk for gateway RS690

Marek Olšák <maraeo@gmail.com>
    drm/radeon: allow MIP_ADDRESS=0 for MSAA textures on Evergreen

Marek Olšák <maraeo@gmail.com>
    drm/radeon/kms: allow STRMOUT_BASE_UPDATE on RS780 and RS880

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: only adjust default clocks on NI GPUs

Chris Wilson <chris@chris-wilson.co.uk>
    drm: Destroy the planes prior to destroying the associated CRTC

Ben Skeggs <bskeggs@redhat.com>
    drm/nvc0/fence: restore pre-suspend fence buffer context on resume

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ALSA: hda - use LPIB for delay estimation

Wang Xingchao <xingchao.wang@intel.com>
    ALSA: hda - Add another pci id for Haswell board

Marko Friedemann <mfr@bmx-chemnitz.de>
    ALSA: USB: Support for (original) Xbox Communicator

Daniel Mack <zonque@gmail.com>
    ALSA: snd-usb: Add quirks for Playback Designs devices

David Henningsson <david.henningsson@canonical.com>
    ALSA: usb - disable broken hw volume for Tenx TP6911

David Henningsson <david.henningsson@canonical.com>
    ALSA: hda - limit internal mic boost for Asus X202E

Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
    ALSA: hda/realtek - Fix detection of ALC271X codec

Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
    ALSA: hda/via - don't report presence on HPs with no presence support

Omair Mohammed Abdullah <omair.m.abdullah@linux.intel.com>
    ALSA: aloop - add locking to timer access

Felix Kaechele <felix@fetzig.org>
    ALSA: hda - Add inverted internal mic quirk for Lenovo IdeaPad U310

Paulo Zanoni <paulo.r.zanoni@intel.com>
    drm/i915: make sure we write all the DIP data bytes

Eugeni Dodonov <eugeni.dodonov@intel.com>
    drm/i915: prevent possible pin leak on error path

Gabor Juhos <juhosg@openwrt.org>
    MIPS: ath79: use correct fractional dividers for {CPU,DDR}_PLL on AR934x

Andrea Arcangeli <aarcange@redhat.com>
    mm: thp: fix pmd_present for split_huge_page and PROT_NONE with THP

Hugh Dickins <hughd@google.com>
    mm: fix invalidate_complete_page2() lock ordering

Michal Hocko <mhocko@suse.cz>
    hugetlb: do not use vma_hugecache_offset() for vma_prio_tree_foreach

Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
    kpageflags: fix wrong KPF_THP on non-huge compound pages

Mark Brown <broonie@opensource.wolfsonmicro.com>
    ASoC: wm9712: Fix name of Capture Switch

Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
    ASoC: wm5110: Adding missing volume update bits

Mark Brown <broonie@opensource.wolfsonmicro.com>
    ASoC: wm_hubs: Ensure volume updates are handled during class W startup

Theodore Ts'o <tytso@mit.edu>
    ext4: fix mtime update in nodelalloc mode

Jan Kara <jack@suse.cz>
    ext4: fix fdatasync() for files with only i_size changes

Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
    ext4: always set i_op in ext4_mknod()

Dmitry Monakhov <dmonakhov@openvz.org>
    ext4: online defrag is not supported for journaled files

Dmitry Monakhov <dmonakhov@openvz.org>
    ext4: move_extent code cleanup

Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
    ext4: fix crash when accessing /proc/mounts concurrently

Theodore Ts'o <tytso@mit.edu>
    ext4: fix potential deadlock in ext4_nonda_switch()

Yongqiang Yang <xiaoqiangnk@gmail.com>
    ext4: avoid duplicate writes of the backup bg descriptor blocks

Yongqiang Yang <xiaoqiangnk@gmail.com>
    ext4: don't copy non-existent gdt blocks when resizing

Yongqiang Yang <xiaoqiangnk@gmail.com>
    ext4: ignore last group w/o enough space when resizing instead of BUG'ing

Yinghai Lu <yinghai@kernel.org>
    PCI: Check P2P bridge for invalid secondary/subordinate range

Martin Peschke <mpeschke@linux.vnet.ibm.com>
    SCSI: zfcp: only access zfcp_scsi_dev for valid scsi_device

Steffen Maier <maier@linux.vnet.ibm.com>
    SCSI: zfcp: restore refcount check on port_remove

Julia Lawall <Julia.Lawall@lip6.fr>
    SCSI: zfcp: remove invalid reference to list iterator variable

Steffen Maier <maier@linux.vnet.ibm.com>
    SCSI: zfcp: Do not wakeup while suspended

Steffen Maier <maier@linux.vnet.ibm.com>
    SCSI: zfcp: Bounds checking for deferred error trace

Steffen Maier <maier@linux.vnet.ibm.com>
    SCSI: zfcp: Make trace record tags unique

Steffen Maier <maier@linux.vnet.ibm.com>
    SCSI: zfcp: Adapt to new FC_PORTSPEED semantics

Florian Zumbiehl <florz@florz.de>
    drm/savage: re-add busmaster enable, regression fix

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    ipv6: del unreachable route when an addr is deleted on lo

Tao Hou <hotforest@gmail.com>
    net: ethernet: davinci_cpdma: decrease the desc count when cleaning up the remaining packets

Gao feng <gaofeng@cn.fujitsu.com>
    ipv6: release reference of ip6_null_entry's dst entry in __ip6_del_rt

Antonio Quartulli <ordex@autistici.org>
    8021q: fix mac_len recomputation in vlan_untag()

Eric Dumazet <edumazet@google.com>
    ipv4: add a fib_type to fib_info

Yuta Ando <yuta.and@gmail.com>
    localmodconfig: Fix localyesconfig to set to 'y' not 'm'

Eric Sandeen <sandeen@redhat.com>
    jbd2: don't write superblock when if its empty

Lai Jiangshan <laijs@cn.fujitsu.com>
    workqueue: fix possible stall on try_to_grab_pending() of a delayed work item

Tejun Heo <tj@kernel.org>
    workqueue: add missing smp_wmb() in process_one_work()

Feng Hong <hongfeng@marvell.com>
    PM / Sleep: use resume event when call dpm_resume_early

Alexandre Bounine <alexandre.bounine@idt.com>
    rapidio/rionet: fix multicast packet transmit logic

Mauro Carvalho Chehab <mchehab@redhat.com>
    drxk: allow loading firmware synchrousnously

Jacob Keller <jacob.e.keller@intel.com>
    ixgbe: fix PTP ethtool timestamping function

Gavin Shan <shangw@linux.vnet.ibm.com>
    powerpc/eeh: Fix crash on converting OF node to edev

Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
    powerpc: Fix VMX fix for memcpy case

Rusty Russell <rusty@rustcorp.com.au>
    lguest: fix occasional crash in example launcher.

Fabio Estevam <fabio.estevam@freescale.com>
    drivers/dma/dmaengine.c: lower the priority of 'failed to get' dma channel message

Martin Michlmayr <tbm@cyrius.com>
    drivers/scsi/atp870u.c: fix bad use of udelay

Shawn Guo <shawn.guo@linaro.org>
    kernel/sys.c: call disable_nonboot_cpus() in kernel_restart()

Davidlohr Bueso <dave@gnu.org>
    lib/gcd.c: prevent possible div by 0

Mark Brown <broonie@opensource.wolfsonmicro.com>
    mfd: 88pm860x: Move _IO resources out of ioport_ioresource

Mark Brown <broonie@opensource.wolfsonmicro.com>
    mfd: max8925: Move _IO resources out of ioport_ioresource

Lin Ming <ming.m.lin@intel.com>
    ACPI: run _OSC after ACPI_FULL_INITIALIZATION

Frank Schäfer <fschaefer.oss@googlemail.com>
    media: gspca_pac7302: make red balance and blue balance controls work again

Frank Schäfer <fschaefer.oss@googlemail.com>
    media: gspca_pac7302: add support for device 1ae7:2001 Speedlink Snappy Microphone SL-6825-SBK

Ben Hutchings <ben@decadent.org.uk>
    media: rc: ite-cir: Initialise ite_dev::rdev earlier

Mauro Carvalho Chehab <mchehab@redhat.com>
    em28xx: Make all em28xx extensions to be initialized asynchronously

Wade Farnsworth <wade_farnsworth@mentor.com>
    ARM: 7548/1: include linux/sched.h in syscall.h

Alex Williamson <alex.williamson@redhat.com>
    intel-iommu: Default to non-coherent for domains unattached to iommus

Anton Blanchard <anton@samba.org>
    powerpc/iommu: Fix multiple issues with IOMMU pools code

Michael Wang <wangyun@linux.vnet.ibm.com>
    slab: fix the DEADLOCK issue on l3 alien lock

Daniel J Blueman <daniel@quora.org>
    i2c-piix4: Fix build failure

Jean Delvare <jdelvare@suse.de>
    kbuild: Fix gcc -x syntax

Michal Marek <mmarek@suse.cz>
    kbuild: Do not package /boot and /lib in make tar-pkg

Sascha Hauer <s.hauer@pengutronix.de>
    kbuild: make: fix if_changed when command contains backslashes

Geert Uytterhoeven <geert@linux-m68k.org>
    mn10300: only add -mmem-funcs to KBUILD_CFLAGS if gcc supports it


-------------

Diffstat:

 Makefile                                         |   4 +-
 arch/alpha/kernel/process.c                      |   3 ++
 arch/arm/include/asm/syscall.h                   |   1 +
 arch/cris/kernel/process.c                       |   3 ++
 arch/frv/kernel/process.c                        |   3 ++
 arch/h8300/kernel/process.c                      |   3 ++
 arch/ia64/kernel/process.c                       |   3 ++
 arch/m32r/kernel/process.c                       |   3 ++
 arch/m68k/kernel/process.c                       |   3 ++
 arch/mips/Makefile                               |   2 +-
 arch/mips/ath79/clock.c                          |   4 +-
 arch/mips/kernel/Makefile                        |   2 +-
 arch/mn10300/Makefile                            |   2 +-
 arch/mn10300/kernel/process.c                    |   3 ++
 arch/parisc/kernel/process.c                     |   3 ++
 arch/powerpc/include/asm/pci-bridge.h            |   8 ++++
 arch/powerpc/kernel/iommu.c                      |   5 ++-
 arch/powerpc/lib/memcpy_power7.S                 |   4 +-
 arch/powerpc/platforms/pseries/eeh.c             |   2 +-
 arch/powerpc/sysdev/dart_iommu.c                 |  12 ++++++
 arch/score/kernel/process.c                      |   4 +-
 arch/x86/Makefile                                |   4 +-
 arch/x86/boot/compressed/Makefile                |   3 ++
 arch/x86/include/asm/pgtable.h                   |  11 +++--
 arch/x86/platform/efi/efi.c                      |   1 +
 arch/xtensa/kernel/process.c                     |   3 ++
 drivers/acpi/bus.c                               |   8 +++-
 drivers/base/power/main.c                        |   2 +-
 drivers/dma/dmaengine.c                          |   2 +-
 drivers/gpu/drm/drm_crtc.c                       |   8 ++--
 drivers/gpu/drm/i915/i915_irq.c                  |  16 ++++----
 drivers/gpu/drm/i915/i915_reg.h                  |   7 ++++
 drivers/gpu/drm/i915/intel_display.c             |  26 ++++++++++--
 drivers/gpu/drm/i915/intel_hdmi.c                |  15 +++++++
 drivers/gpu/drm/i915/intel_pm.c                  |   5 +++
 drivers/gpu/drm/nouveau/nvc0_fence.c             |  25 ++++++++++++
 drivers/gpu/drm/radeon/evergreen_cs.c            |  59 +++++++++++++++++++++++----
 drivers/gpu/drm/radeon/r600_cs.c                 |   3 +-
 drivers/gpu/drm/radeon/radeon_drv.c              |   4 +-
 drivers/gpu/drm/radeon/radeon_irq_kms.c          |  10 +++++
 drivers/gpu/drm/radeon/radeon_pm.c               |   8 +++-
 drivers/gpu/drm/savage/savage_bci.c              |   2 +
 drivers/hid/hidraw.c                             |  69 ++++++++++++-------------------
 drivers/i2c/busses/i2c-piix4.c                   |   1 +
 drivers/iommu/intel-iommu.c                      |   4 +-
 drivers/media/dvb/frontends/drxk.h               |   2 +
 drivers/media/dvb/frontends/drxk_hard.c          |  20 ++++++---
 drivers/media/rc/ite-cir.c                       |   2 +-
 drivers/media/video/em28xx/em28xx-cards.c        |  22 +++++-----
 drivers/media/video/em28xx/em28xx-dvb.c          |   5 +++
 drivers/media/video/gspca/pac7302.c              |   3 +-
 drivers/mfd/88pm860x-core.c                      |  92 ++++++++++++++++++++++++++++-------------
 drivers/mfd/max8925-core.c                       |  10 +++++
 drivers/mmc/core/slot-gpio.c                     |   8 +++-
 drivers/mmc/host/omap_hsmmc.c                    |   3 +-
 drivers/mmc/host/sh_mmcif.c                      |   4 ++
 drivers/mtd/maps/autcpu12-nvram.c                |  19 +++++----
 drivers/mtd/mtdpart.c                            |   5 ++-
 drivers/mtd/nand/nand_bbt.c                      |   2 +-
 drivers/mtd/nand/nandsim.c                       |   1 +
 drivers/mtd/nand/omap2.c                         |   3 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c |   5 +--
 drivers/net/ethernet/ti/davinci_cpdma.c          |   1 +
 drivers/net/rionet.c                             |  20 +++++++--
 drivers/net/usb/asix_devices.c                   |   4 ++
 drivers/pci/probe.c                              |   6 ++-
 drivers/s390/scsi/zfcp_aux.c                     |   1 +
 drivers/s390/scsi/zfcp_ccw.c                     |  73 ++++++++++++++++++++++++++++-----
 drivers/s390/scsi/zfcp_cfdc.c                    |   2 +-
 drivers/s390/scsi/zfcp_dbf.c                     |  22 +++++++++-
 drivers/s390/scsi/zfcp_dbf.h                     |   1 +
 drivers/s390/scsi/zfcp_def.h                     |   2 +
 drivers/s390/scsi/zfcp_ext.h                     |   2 +
 drivers/s390/scsi/zfcp_fsf.c                     |  57 ++++++++++++++++++++++----
 drivers/s390/scsi/zfcp_qdio.c                    |  16 +++++---
 drivers/s390/scsi/zfcp_sysfs.c                   |  18 +++++++-
 drivers/s390/scsi/zfcp_unit.c                    |  36 +++++++++++-----
 drivers/scsi/atp870u.c                           |  11 ++++-
 fs/buffer.c                                      |  13 +++---
 fs/cifs/cifs_unicode.c                           |  22 ++++++++++
 fs/cifs/connect.c                                |   9 ++++
 fs/ext4/inode.c                                  |  26 ++++++++----
 fs/ext4/move_extent.c                            | 174 ++++++++++++++++++++++++------------------------------------------------------
 fs/ext4/namei.c                                  |   2 -
 fs/ext4/resize.c                                 |  26 ++++++++----
 fs/ext4/super.c                                  |   2 +-
 fs/fs-writeback.c                                |   1 +
 fs/jbd2/journal.c                                |   5 +++
 fs/jffs2/super.c                                 |   4 ++
 fs/jffs2/wbuf.c                                  |   8 ++--
 fs/nilfs2/file.c                                 |   1 +
 fs/proc/page.c                                   |   8 +++-
 include/linux/mempolicy.h                        |   2 +-
 include/net/ip_fib.h                             |   1 +
 kernel/rcutree.c                                 |   4 +-
 kernel/sched/core.c                              |   2 +
 kernel/sys.c                                     |   1 +
 kernel/workqueue.c                               |  27 ++++++++++--
 lib/gcd.c                                        |   3 ++
 mm/hugetlb.c                                     |   3 +-
 mm/mempolicy.c                                   | 137 +++++++++++++++++++++++++++++++++++++++----------------------
 mm/slab.c                                        |   6 +--
 mm/truncate.c                                    |   3 +-
 net/8021q/vlan_core.c                            |   3 +-
 net/ipv4/fib_semantics.c                         |   2 +
 net/ipv6/addrconf.c                              |  10 ++++-
 net/ipv6/route.c                                 |  11 ++---
 scripts/Kbuild.include                           |  14 +++----
 scripts/Makefile.fwinst                          |   4 +-
 scripts/gcc-version.sh                           |   6 +--
 scripts/gcc-x86_32-has-stack-protector.sh        |   2 +-
 scripts/gcc-x86_64-has-stack-protector.sh        |   2 +-
 scripts/kconfig/check.sh                         |   2 +-
 scripts/kconfig/lxdialog/check-lxdialog.sh       |   2 +-
 scripts/kconfig/streamline_config.pl             |   2 +
 scripts/package/buildtar                         |   2 +-
 sound/drivers/aloop.c                            |   6 +++
 sound/pci/hda/hda_codec.c                        |  10 +++--
 sound/pci/hda/hda_intel.c                        |  37 ++++++++++++++---
 sound/pci/hda/patch_conexant.c                   |   1 +
 sound/pci/hda/patch_realtek.c                    |  12 +++---
 sound/pci/hda/patch_via.c                        |  32 ++++++++++++++-
 sound/soc/codecs/wm5110.c                        |   4 ++
 sound/soc/codecs/wm9712.c                        |   2 +-
 sound/soc/codecs/wm_hubs.c                       |   5 +++
 sound/usb/card.h                                 |   2 +
 sound/usb/endpoint.c                             |   8 ++++
 sound/usb/helper.c                               |   5 +++
 sound/usb/mixer.c                                |   7 ++++
 sound/usb/quirks-table.h                         |  53 ++++++++++++++++++++++++
 sound/usb/quirks.c                               |  24 +++++++++++
 sound/usb/quirks.h                               |  10 +++++
 tools/lguest/lguest.c                            |   1 +
 tools/perf/Makefile                              |   2 +-
 tools/power/cpupower/Makefile                    |   2 +-
 135 files changed, 1169 insertions(+), 457 deletions(-)


