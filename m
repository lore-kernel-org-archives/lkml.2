Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252Ab2JLVQr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 17:16:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55834 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab2JLVQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 17:16:44 -0400
Date: Sat, 13 Oct 2012 06:16:37 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.6.2
Message-ID: <20121012211637.GA28879@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tKW2IUtsqtDRztdT"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.6.2 kernel.

All users of the 3.6 kernel series must upgrade.

The updated 3.6.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.6.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------

 Makefile                                         |    2=20
 arch/alpha/kernel/process.c                      |    3=20
 arch/arm/include/asm/syscall.h                   |    1=20
 arch/cris/kernel/process.c                       |    3=20
 arch/frv/kernel/process.c                        |    3=20
 arch/h8300/kernel/process.c                      |    3=20
 arch/ia64/kernel/process.c                       |    3=20
 arch/m32r/kernel/process.c                       |    3=20
 arch/m68k/kernel/process.c                       |    3=20
 arch/mips/Makefile                               |    2=20
 arch/mips/ath79/clock.c                          |    4=20
 arch/mips/kernel/Makefile                        |    2=20
 arch/mn10300/Makefile                            |    2=20
 arch/mn10300/kernel/process.c                    |    3=20
 arch/parisc/kernel/process.c                     |    3=20
 arch/powerpc/include/asm/pci-bridge.h            |    8 +
 arch/powerpc/kernel/iommu.c                      |    5=20
 arch/powerpc/lib/memcpy_power7.S                 |    4=20
 arch/powerpc/platforms/pseries/eeh.c             |    2=20
 arch/powerpc/sysdev/dart_iommu.c                 |   12 +
 arch/score/kernel/process.c                      |    4=20
 arch/x86/Makefile                                |    4=20
 arch/x86/boot/compressed/Makefile                |    3=20
 arch/x86/include/asm/pgtable.h                   |   11 +
 arch/x86/platform/efi/efi.c                      |    1=20
 arch/xtensa/kernel/process.c                     |    3=20
 drivers/acpi/bus.c                               |    8 -
 drivers/base/power/main.c                        |    2=20
 drivers/dma/dmaengine.c                          |    2=20
 drivers/gpu/drm/drm_crtc.c                       |    8 -
 drivers/gpu/drm/i915/i915_irq.c                  |   16 +-
 drivers/gpu/drm/i915/i915_reg.h                  |    7=20
 drivers/gpu/drm/i915/intel_display.c             |   26 +++
 drivers/gpu/drm/i915/intel_hdmi.c                |   15 +
 drivers/gpu/drm/i915/intel_pm.c                  |    5=20
 drivers/gpu/drm/nouveau/nvc0_fence.c             |   25 +++
 drivers/gpu/drm/radeon/evergreen_cs.c            |   59 ++++++-
 drivers/gpu/drm/radeon/r600_cs.c                 |    3=20
 drivers/gpu/drm/radeon/radeon_drv.c              |    4=20
 drivers/gpu/drm/radeon/radeon_irq_kms.c          |   10 +
 drivers/gpu/drm/radeon/radeon_pm.c               |    8 -
 drivers/gpu/drm/savage/savage_bci.c              |    2=20
 drivers/hid/hidraw.c                             |   69 +++------
 drivers/i2c/busses/i2c-piix4.c                   |    1=20
 drivers/iommu/intel-iommu.c                      |    4=20
 drivers/media/dvb/frontends/drxk.h               |    2=20
 drivers/media/dvb/frontends/drxk_hard.c          |   20 +-
 drivers/media/rc/ite-cir.c                       |    2=20
 drivers/media/video/em28xx/em28xx-cards.c        |   22 +-
 drivers/media/video/em28xx/em28xx-dvb.c          |    5=20
 drivers/media/video/gspca/pac7302.c              |    3=20
 drivers/mfd/88pm860x-core.c                      |   92 ++++++++----
 drivers/mfd/max8925-core.c                       |   10 +
 drivers/mmc/core/slot-gpio.c                     |    8 -
 drivers/mmc/host/omap_hsmmc.c                    |    3=20
 drivers/mmc/host/sh_mmcif.c                      |    4=20
 drivers/mtd/maps/autcpu12-nvram.c                |   19 +-
 drivers/mtd/mtdpart.c                            |    5=20
 drivers/mtd/nand/nand_bbt.c                      |    2=20
 drivers/mtd/nand/nandsim.c                       |    1=20
 drivers/mtd/nand/omap2.c                         |    3=20
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c |    5=20
 drivers/net/ethernet/ti/davinci_cpdma.c          |    1=20
 drivers/net/rionet.c                             |   20 ++
 drivers/net/usb/asix_devices.c                   |    4=20
 drivers/pci/probe.c                              |    6=20
 drivers/s390/scsi/zfcp_aux.c                     |    1=20
 drivers/s390/scsi/zfcp_ccw.c                     |   73 ++++++++-
 drivers/s390/scsi/zfcp_cfdc.c                    |    2=20
 drivers/s390/scsi/zfcp_dbf.c                     |   22 ++
 drivers/s390/scsi/zfcp_dbf.h                     |    1=20
 drivers/s390/scsi/zfcp_def.h                     |    2=20
 drivers/s390/scsi/zfcp_ext.h                     |    2=20
 drivers/s390/scsi/zfcp_fsf.c                     |   57 ++++++-
 drivers/s390/scsi/zfcp_qdio.c                    |   16 +-
 drivers/s390/scsi/zfcp_sysfs.c                   |   18 ++
 drivers/s390/scsi/zfcp_unit.c                    |   36 +++-
 drivers/scsi/atp870u.c                           |   11 +
 fs/buffer.c                                      |   13 -
 fs/cifs/cifs_unicode.c                           |   22 ++
 fs/cifs/connect.c                                |    9 +
 fs/ext4/inode.c                                  |   26 ++-
 fs/ext4/move_extent.c                            |  174 +++++++-----------=
-----
 fs/ext4/namei.c                                  |    2=20
 fs/ext4/resize.c                                 |   26 ++-
 fs/ext4/super.c                                  |    2=20
 fs/fs-writeback.c                                |    1=20
 fs/jbd2/journal.c                                |    5=20
 fs/jffs2/super.c                                 |    4=20
 fs/jffs2/wbuf.c                                  |    8 -
 fs/nilfs2/file.c                                 |    1=20
 fs/proc/page.c                                   |    8 -
 include/linux/mempolicy.h                        |    2=20
 include/net/ip_fib.h                             |    1=20
 kernel/rcutree.c                                 |    4=20
 kernel/sched/core.c                              |    2=20
 kernel/sys.c                                     |    1=20
 kernel/workqueue.c                               |   27 +++
 lib/gcd.c                                        |    3=20
 mm/hugetlb.c                                     |    3=20
 mm/mempolicy.c                                   |  137 +++++++++++-------
 mm/slab.c                                        |    6=20
 mm/truncate.c                                    |    3=20
 net/8021q/vlan_core.c                            |    3=20
 net/ipv4/fib_semantics.c                         |    2=20
 net/ipv6/addrconf.c                              |   10 +
 net/ipv6/route.c                                 |   11 -
 scripts/Kbuild.include                           |   14 -
 scripts/Makefile.fwinst                          |    4=20
 scripts/gcc-version.sh                           |    6=20
 scripts/gcc-x86_32-has-stack-protector.sh        |    2=20
 scripts/gcc-x86_64-has-stack-protector.sh        |    2=20
 scripts/kconfig/check.sh                         |    2=20
 scripts/kconfig/lxdialog/check-lxdialog.sh       |    2=20
 scripts/kconfig/streamline_config.pl             |    2=20
 scripts/package/buildtar                         |    2=20
 sound/drivers/aloop.c                            |    6=20
 sound/pci/hda/hda_codec.c                        |   10 -
 sound/pci/hda/hda_intel.c                        |   37 ++++
 sound/pci/hda/patch_conexant.c                   |    1=20
 sound/pci/hda/patch_realtek.c                    |   12 -
 sound/pci/hda/patch_via.c                        |   32 ++++
 sound/soc/codecs/wm5110.c                        |    4=20
 sound/soc/codecs/wm9712.c                        |    2=20
 sound/soc/codecs/wm_hubs.c                       |    5=20
 sound/usb/card.h                                 |    2=20
 sound/usb/endpoint.c                             |    8 +
 sound/usb/helper.c                               |    5=20
 sound/usb/mixer.c                                |    7=20
 sound/usb/quirks-table.h                         |   53 +++++++
 sound/usb/quirks.c                               |   24 +++
 sound/usb/quirks.h                               |   10 +
 tools/lguest/lguest.c                            |    1=20
 tools/perf/Makefile                              |    2=20
 tools/power/cpupower/Makefile                    |    2=20
 135 files changed, 1168 insertions(+), 456 deletions(-)

Alex Deucher (3):
      drm/radeon: only adjust default clocks on NI GPUs
      drm/radeon: Add MSI quirk for gateway RS690
      drm/radeon: force MSIs on RS690 asics

Alex Williamson (1):
      intel-iommu: Default to non-coherent for domains unattached to iommus

Alexander Shiyan (1):
      mtd: autcpu12-nvram: Fix compile breakage

Alexandre Bounine (1):
      rapidio/rionet: fix multicast packet transmit logic

Andrea Arcangeli (1):
      mm: thp: fix pmd_present for split_huge_page and PROT_NONE with THP

Andreas Bie=C3=9Fmann (2):
      mtd: omap2: fix omap_nand_remove segfault
      mtd: omap2: fix module loading

Anton Blanchard (1):
      powerpc/iommu: Fix multiple issues with IOMMU pools code

Antonio Quartulli (1):
      8021q: fix mac_len recomputation in vlan_untag()

Artem Bityutskiy (1):
      JFFS2: fix unmount regression

Ben Hutchings (1):
      media: rc: ite-cir: Initialise ite_dev::rdev earlier

Ben Skeggs (1):
      drm/nvc0/fence: restore pre-suspend fence buffer context on resume

Ben Widawsky (1):
      drm/i915: Fix GT_MODE default value

Bernd Schubert (1):
      ext4: always set i_op in ext4_mknod()

Brian Norris (1):
      JFFS2: don't fail on bitflips in OOB

Charles Keepax (1):
      ASoC: wm5110: Adding missing volume update bits

Chris Ball (1):
      mmc: slot-gpio: Fix missing assignment to ctx->ro_gpio

Chris Wilson (2):
      drm: Destroy the planes prior to destroying the associated CRTC
      drm/i915: Flush the pending flips on the CRTC before modification

Daniel J Blueman (1):
      i2c-piix4: Fix build failure

Daniel Mack (1):
      ALSA: snd-usb: Add quirks for Playback Designs devices

Daniel Vetter (1):
      drm/i915: call drm_handle_vblank before finish_page_flip

David Henningsson (2):
      ALSA: hda - limit internal mic boost for Asus X202E
      ALSA: usb - disable broken hw volume for Tenx TP6911

Davidlohr Bueso (1):
      lib/gcd.c: prevent possible div by 0

Dmitry Monakhov (2):
      ext4: move_extent code cleanup
      ext4: online defrag is not supported for journaled files

Dylan Reid (1):
      ALSA: hda - Fix hang caused by race during suspend.

Eric Dumazet (1):
      ipv4: add a fib_type to fib_info

Eric Sandeen (1):
      jbd2: don't write superblock when if its empty

Eugeni Dodonov (1):
      drm/i915: prevent possible pin leak on error path

Fabio Estevam (1):
      drivers/dma/dmaengine.c: lower the priority of 'failed to get' dma ch=
annel message

Felix Kaechele (1):
      ALSA: hda - Add inverted internal mic quirk for Lenovo IdeaPad U310

Feng Hong (1):
      PM / Sleep: use resume event when call dpm_resume_early

Florian Zumbiehl (1):
      drm/savage: re-add busmaster enable, regression fix

Frank Sch=C3=A4fer (2):
      media: gspca_pac7302: add support for device 1ae7:2001 Speedlink Snap=
py Microphone SL-6825-SBK
      media: gspca_pac7302: make red balance and blue balance controls work=
 again

Frederic Weisbecker (10):
      h8300: Add missing RCU idle APIs on idle loop
      parisc: Add missing RCU idle APIs on idle loop
      xtensa: Add missing RCU idle APIs on idle loop
      frv: Add missing RCU idle APIs on idle loop
      mn10300: Add missing RCU idle APIs on idle loop
      m68k: Add missing RCU idle APIs on idle loop
      alpha: Add missing RCU idle APIs on idle loop
      cris: Add missing RCU idle APIs on idle loop
      m32r: Add missing RCU idle APIs on idle loop
      score: Add missing RCU idle APIs on idle loop

Frediano Ziglio (1):
      Convert properly UTF-8 to UTF-16

Gabor Juhos (1):
      MIPS: ath79: use correct fractional dividers for {CPU,DDR}_PLL on AR9=
34x

Gao feng (1):
      ipv6: release reference of ip6_null_entry's dst entry in __ip6_del_rt

Gavin Shan (1):
      powerpc/eeh: Fix crash on converting OF node to edev

Geert Uytterhoeven (1):
      mn10300: only add -mmem-funcs to KBUILD_CFLAGS if gcc supports it

Greg Kroah-Hartman (1):
      Linux 3.6.2

Guennadi Liakhovetski (1):
      mmc: sh-mmcif: avoid oops on spurious interrupts

Herton Ronaldo Krzesinski (3):
      ext4: fix crash when accessing /proc/mounts concurrently
      ALSA: hda/via - don't report presence on HPs with no presence support
      ALSA: hda/realtek - Fix detection of ALC271X codec

Huang Shijie (1):
      mtd: mtdpart: break it as soon as we parse out the partitions

Hugh Dickins (1):
      mm: fix invalidate_complete_page2() lock ordering

Jacob Keller (1):
      ixgbe: fix PTP ethtool timestamping function

Jan Kara (1):
      ext4: fix fdatasync() for files with only i_size changes

Jean Delvare (1):
      kbuild: Fix gcc -x syntax

Jeff Layton (1):
      cifs: reinstate the forcegid option

Julia Lawall (1):
      SCSI: zfcp: remove invalid reference to list iterator variable

KOSAKI Motohiro (3):
      revert "mm: mempolicy: Let vma_merge and vma_split handle vma->vm_pol=
icy linkages"
      mempolicy: remove mempolicy sharing
      mempolicy: fix refcount leak in mpol_set_shared_policy()

Lai Jiangshan (1):
      workqueue: fix possible stall on try_to_grab_pending() of a delayed w=
ork item

Lin Ming (1):
      ACPI: run _OSC after ACPI_FULL_INITIALIZATION

Marek Ol=C5=A1=C3=A1k (2):
      drm/radeon/kms: allow STRMOUT_BASE_UPDATE on RS780 and RS880
      drm/radeon: allow MIP_ADDRESS=3D0 for MSAA textures on Evergreen

Mark Brown (4):
      mfd: max8925: Move _IO resources out of ioport_ioresource
      mfd: 88pm860x: Move _IO resources out of ioport_ioresource
      ASoC: wm_hubs: Ensure volume updates are handled during class W start=
up
      ASoC: wm9712: Fix name of Capture Switch

Marko Friedemann (1):
      ALSA: USB: Support for (original) Xbox Communicator

Martin Michlmayr (1):
      drivers/scsi/atp870u.c: fix bad use of udelay

Martin Peschke (1):
      SCSI: zfcp: only access zfcp_scsi_dev for valid scsi_device

Matthew Garrett (1):
      efi: Build EFI stub with EFI-appropriate options

Mauro Carvalho Chehab (3):
      em28xx: Make all em28xx extensions to be initialized asynchronously
      drxk: allow loading firmware synchrousnously
      em28xx: regression fix: use DRX-K sync firmware requests on em28xx

Mel Gorman (2):
      mempolicy: fix a race in shared_policy_replace()
      mempolicy: fix a memory corruption by refcount imbalance in alloc_pag=
es_vma()

Michael Wang (1):
      slab: fix the DEADLOCK issue on l3 alien lock

Michal Hocko (1):
      hugetlb: do not use vma_hugecache_offset() for vma_prio_tree_foreach

Michal Marek (1):
      kbuild: Do not package /boot and /lib in make tar-pkg

Naoya Horiguchi (1):
      kpageflags: fix wrong KPF_THP on non-huge compound pages

Nicolas Dichtel (1):
      ipv6: del unreachable route when an addr is deleted on lo

Nishanth Aravamudan (1):
      powerpc: Fix VMX fix for memcpy case

Omair Mohammed Abdullah (1):
      ALSA: aloop - add locking to timer access

Paul E. McKenney (2):
      ia64: Add missing RCU idle APIs on idle loop
      rcu: Fix day-one dyntick-idle stall-warning bug

Paulo Zanoni (1):
      drm/i915: make sure we write all the DIP data bytes

Peter Zijlstra (1):
      sched: Fix load avg vs. cpu-hotplug

Pierre-Louis Bossart (1):
      ALSA: hda - use LPIB for delay estimation

Quinlan Pfiffer (1):
      asix: Adds support for Lenovo 10/100 USB dongle.

Ratan Nalumasu (1):
      HID: hidraw: don't deallocate memory when it is in use

Richard Genoud (1):
      mtd: nandsim: bugfix: fail if overridesize is too big

Rusty Russell (1):
      lguest: fix occasional crash in example launcher.

Sascha Hauer (1):
      kbuild: make: fix if_changed when command contains backslashes

Seiji Aguchi (1):
      efi: initialize efi.runtime_version to make query_variable_info/updat=
e_capsule workable

Shawn Guo (1):
      kernel/sys.c: call disable_nonboot_cpus() in kernel_restart()

Shmulik Ladkani (1):
      mtd: nand: Use the mirror BBT descriptor when reading its version

Steffen Maier (5):
      SCSI: zfcp: Adapt to new FC_PORTSPEED semantics
      SCSI: zfcp: Make trace record tags unique
      SCSI: zfcp: Bounds checking for deferred error trace
      SCSI: zfcp: Do not wakeup while suspended
      SCSI: zfcp: restore refcount check on port_remove

Tao Hou (1):
      net: ethernet: davinci_cpdma: decrease the desc count when cleaning u=
p the remaining packets

Tejun Heo (1):
      workqueue: add missing smp_wmb() in process_one_work()

Theodore Ts'o (2):
      ext4: fix potential deadlock in ext4_nonda_switch()
      ext4: fix mtime update in nodelalloc mode

Vaibhav Bedia (1):
      mmc: omap_hsmmc: Pass on the suspend failure to the PM core

Wade Farnsworth (1):
      ARM: 7548/1: include linux/sched.h in syscall.h

Wang Xingchao (1):
      ALSA: hda - Add another pci id for Haswell board

Yinghai Lu (1):
      PCI: Check P2P bridge for invalid secondary/subordinate range

Yongqiang Yang (3):
      ext4: ignore last group w/o enough space when resizing instead of BUG=
'ing
      ext4: don't copy non-existent gdt blocks when resizing
      ext4: avoid duplicate writes of the backup bg descriptor blocks

Yuta Ando (1):
      localmodconfig: Fix localyesconfig to set to 'y' not 'm'


--tKW2IUtsqtDRztdT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQeIi1AAoJEDjbvchgkmk+0y0P/0R81xD/PuLNH+7DIrEn6hmo
AuMX1tQmhZq8dqyJOqJ//Yvp/F3LewD5TaegxC+01rp1WTarKogwCu0ljc3Ubj5e
pvbI58GNTMiYXf8BTJzXrTCOMyo2Z3sCiv+Zqq6en5tcrXbRruoAxLvjVefGY+DT
3ZE64hnoaC4m/dr+fXjVJdKfdP24WNpG0B6htpt8vTwM6BzV2/ygcbGSyKAgM+Gu
nWoM2Bi8rTzMnyBCF3KhvIhZu1jv3+du3tNGHArgEdyCMkdQnaO3sUbhtlaMG8o3
eGWQPXEnBIiEeG60k+gsjJezIROd5uEdUACf6E5dbuiYZdh31mPzseyMoU2P4NMx
A6jZtD1W4bpdr9r9qpUTS4gXGOnpPJzpB6ulWcP61y0O09jFxgo09nTYMcpIWvVP
FUoq7l9+w85LjA8CI6GsWhFCgq1nvuXu3Xu9B+gn0vi9hYXnErCNeUbCIT3+u9uT
m+hRINyA4WojQjb+KlR20hYyE5dyoJoiVueJC/deUWCIYZwi9fWfxiw1V5jpNTBs
vDhhBE8iOHbztEop74FK/ckfqoRRImp5j+DeZrnBBccaWuqMGXs0WuJu3Tw2zrdi
3PYutZXZH5fVMbl8ZKrH58LBvJFfOegPr3IALTn/BY6qe3zwPlTPrkOVALCZpELt
EuA4XDhPJRlhAv34xnzu
=qb9n
-----END PGP SIGNATURE-----

--tKW2IUtsqtDRztdT--
