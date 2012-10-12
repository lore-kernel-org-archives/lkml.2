Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271Ab2JLVSO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 17:18:14 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50553 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094Ab2JLVSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 17:18:10 -0400
Date: Sat, 13 Oct 2012 06:18:04 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.5.7
Message-ID: <20121012211804.GA30409@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VbJkn9YxBvnuCH5J"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.5.7 kernel.

Note, this is the LAST 3.5.y kernel release, it is now end-of-life.
Please move to the 3.6 kernel branch at this time.

All users of the 3.5 kernel series must upgrade.

The updated 3.5.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.5.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------

 Makefile                                             |    2=20
 arch/alpha/kernel/process.c                          |    3=20
 arch/arm/include/asm/syscall.h                       |    1=20
 arch/cris/kernel/process.c                           |    3=20
 arch/frv/kernel/process.c                            |    3=20
 arch/h8300/kernel/process.c                          |    3=20
 arch/ia64/kernel/process.c                           |    3=20
 arch/m32r/kernel/process.c                           |    3=20
 arch/m68k/kernel/process.c                           |    3=20
 arch/mips/Makefile                                   |    2=20
 arch/mips/ath79/clock.c                              |    4=20
 arch/mips/kernel/Makefile                            |    2=20
 arch/mn10300/Makefile                                |    2=20
 arch/mn10300/kernel/process.c                        |    3=20
 arch/parisc/kernel/process.c                         |    3=20
 arch/powerpc/include/asm/pci-bridge.h                |    8=20
 arch/powerpc/platforms/pseries/eeh.c                 |    2=20
 arch/score/kernel/process.c                          |    4=20
 arch/x86/Makefile                                    |    2=20
 arch/x86/boot/compressed/Makefile                    |    3=20
 arch/x86/include/asm/pgtable.h                       |   11 -
 arch/x86/kvm/vmx.c                                   |   70 +------
 arch/x86/platform/efi/efi.c                          |    1=20
 arch/xtensa/kernel/process.c                         |    3=20
 drivers/acpi/bus.c                                   |    8=20
 drivers/base/core.c                                  |    4=20
 drivers/base/power/main.c                            |    2=20
 drivers/block/aoe/aoecmd.c                           |    1=20
 drivers/gpu/drm/drm_crtc.c                           |    8=20
 drivers/gpu/drm/i915/i915_irq.c                      |   16 -
 drivers/gpu/drm/i915/i915_reg.h                      |    3=20
 drivers/gpu/drm/i915/intel_display.c                 |   26 ++
 drivers/gpu/drm/i915/intel_pm.c                      |    5=20
 drivers/gpu/drm/i915/intel_ringbuffer.c              |    7=20
 drivers/gpu/drm/nouveau/nvc0_fence.c                 |   25 ++
 drivers/gpu/drm/radeon/radeon_irq_kms.c              |   10 +
 drivers/gpu/drm/radeon/radeon_pm.c                   |    8=20
 drivers/gpu/drm/savage/savage_bci.c                  |    2=20
 drivers/iommu/intel-iommu.c                          |    4=20
 drivers/media/rc/ite-cir.c                           |    2=20
 drivers/media/video/em28xx/em28xx-cards.c            |   22 +-
 drivers/media/video/gspca/pac7302.c                  |    1=20
 drivers/mfd/max8925-core.c                           |   10 +
 drivers/mmc/host/omap_hsmmc.c                        |    3=20
 drivers/mmc/host/sh_mmcif.c                          |    4=20
 drivers/mtd/maps/autcpu12-nvram.c                    |   19 +-
 drivers/mtd/mtdpart.c                                |    5=20
 drivers/mtd/nand/nand_bbt.c                          |    2=20
 drivers/mtd/nand/nandsim.c                           |    1=20
 drivers/mtd/nand/omap2.c                             |    3=20
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c      |   12 -
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c     |    5=20
 drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c |    4=20
 drivers/net/ethernet/ti/davinci_cpdma.c              |    1=20
 drivers/net/ppp/pppoe.c                              |    2=20
 drivers/net/rionet.c                                 |   20 +-
 drivers/net/usb/sierra_net.c                         |    2=20
 drivers/net/wan/ixp4xx_hss.c                         |    1=20
 drivers/pci/hotplug/acpiphp_glue.c                   |   13 -
 drivers/pci/probe.c                                  |    6=20
 drivers/s390/scsi/zfcp_aux.c                         |    1=20
 drivers/s390/scsi/zfcp_ccw.c                         |   73 ++++++-
 drivers/s390/scsi/zfcp_cfdc.c                        |    2=20
 drivers/s390/scsi/zfcp_dbf.c                         |   22 ++
 drivers/s390/scsi/zfcp_dbf.h                         |    1=20
 drivers/s390/scsi/zfcp_def.h                         |    2=20
 drivers/s390/scsi/zfcp_ext.h                         |    2=20
 drivers/s390/scsi/zfcp_fsf.c                         |   57 +++++-
 drivers/s390/scsi/zfcp_qdio.c                        |   16 +
 drivers/s390/scsi/zfcp_sysfs.c                       |   18 +
 drivers/s390/scsi/zfcp_unit.c                        |   36 ++-
 drivers/scsi/atp870u.c                               |   11 +
 fs/cifs/cifs_unicode.c                               |   22 ++
 fs/cifs/connect.c                                    |    9=20
 fs/ext4/inode.c                                      |   25 +-
 fs/ext4/move_extent.c                                |  174 +++++---------=
-----
 fs/ext4/namei.c                                      |    2=20
 fs/ext4/resize.c                                     |   26 ++
 fs/ext4/super.c                                      |    2=20
 fs/fs-writeback.c                                    |    1=20
 fs/jbd2/journal.c                                    |    5=20
 fs/jffs2/super.c                                     |    4=20
 fs/jffs2/wbuf.c                                      |    8=20
 fs/proc/page.c                                       |    8=20
 include/linux/mempolicy.h                            |    2=20
 include/linux/xfrm.h                                 |    2=20
 include/net/xfrm.h                                   |    3=20
 kernel/cpuset.c                                      |    3=20
 kernel/rcutree.c                                     |    4=20
 kernel/sched/core.c                                  |   40 +++-
 kernel/sys.c                                         |    1=20
 kernel/workqueue.c                                   |    2=20
 lib/gcd.c                                            |    3=20
 mm/hugetlb.c                                         |    3=20
 mm/mempolicy.c                                       |  137 +++++++++-----
 mm/slab.c                                            |    6=20
 mm/truncate.c                                        |    3=20
 net/8021q/vlan_core.c                                |    3=20
 net/batman-adv/bitarray.h                            |    7=20
 net/core/dev.c                                       |   14 -
 net/core/sock.c                                      |    3=20
 net/ipv4/raw.c                                       |   14 -
 net/ipv4/tcp.c                                       |   10 -
 net/ipv4/tcp_input.c                                 |    5=20
 net/ipv6/addrconf.c                                  |   10 -
 net/ipv6/ip6_fib.c                                   |    4=20
 net/ipv6/mip6.c                                      |   20 +-
 net/ipv6/raw.c                                       |   21 +-
 net/ipv6/route.c                                     |   11 -
 net/l2tp/l2tp_eth.c                                  |    2=20
 net/netrom/af_netrom.c                               |    7=20
 net/sched/sch_cbq.c                                  |    5=20
 net/sched/sch_qfq.c                                  |    5=20
 net/sctp/output.c                                    |   21 ++
 net/xfrm/xfrm_input.c                                |    2=20
 net/xfrm/xfrm_policy.c                               |    2=20
 net/xfrm/xfrm_replay.c                               |   15 +
 net/xfrm/xfrm_user.c                                 |   57 ++++--
 scripts/Kbuild.include                               |   14 -
 scripts/gcc-version.sh                               |    6=20
 scripts/gcc-x86_32-has-stack-protector.sh            |    2=20
 scripts/gcc-x86_64-has-stack-protector.sh            |    2=20
 scripts/kconfig/check.sh                             |    2=20
 scripts/kconfig/lxdialog/check-lxdialog.sh           |    2=20
 scripts/kconfig/streamline_config.pl                 |    2=20
 sound/drivers/aloop.c                                |    6=20
 sound/pci/hda/patch_conexant.c                       |    1=20
 sound/pci/hda/patch_realtek.c                        |   12 -
 sound/pci/hda/patch_via.c                            |   29 +++
 sound/soc/codecs/wm9712.c                            |    2=20
 sound/soc/codecs/wm_hubs.c                           |    5=20
 sound/usb/mixer.c                                    |    7=20
 sound/usb/quirks-table.h                             |   53 +++++
 tools/lguest/lguest.c                                |    1=20
 tools/perf/Makefile                                  |    2=20
 tools/power/cpupower/Makefile                        |    2=20
 136 files changed, 1051 insertions(+), 484 deletions(-)

Alan Cox (1):
      netrom: copy_datagram_iovec can fail

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

Antonio Quartulli (1):
      8021q: fix mac_len recomputation in vlan_untag()

Artem Bityutskiy (1):
      JFFS2: fix unmount regression

Avi Kivity (1):
      Revert "KVM: VMX: Fix KVM_SET_SREGS with big real mode segments"

Ben Hutchings (1):
      media: rc: ite-cir: Initialise ite_dev::rdev earlier

Ben Skeggs (1):
      drm/nvc0/fence: restore pre-suspend fence buffer context on resume

Ben Widawsky (1):
      drm/i915: Fix GT_MODE default value

Bernd Schubert (1):
      ext4: always set i_op in ext4_mknod()

Bjorn Helgaas (1):
      PCI: acpiphp: check whether _ADR evaluation succeeded

Brian Norris (1):
      JFFS2: don't fail on bitflips in OOB

Chema Gonzalez (1):
      net: small bug on rxhash calculation

Chris Wilson (2):
      drm: Destroy the planes prior to destroying the associated CRTC
      drm/i915: Flush the pending flips on the CRTC before modification

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

Ed L. Cashin (2):
      net: do not disable sg for packets requiring no checksum
      aoe: assert AoE packets marked as requiring no checksum

Eric Dumazet (7):
      tcp: fix regression in urgent data handling
      net-sched: sch_cbq: avoid infinite loop
      net: guard tcp_set_keepalive() to tcp sockets
      ipv4: raw: fix icmp_filter()
      ipv6: raw: fix icmpv6_filter()
      ipv6: mip6: fix mip6_mh_filter()
      l2tp: fix a typo in l2tp_eth_dev_recv()

Eric Sandeen (1):
      jbd2: don't write superblock when if its empty

Eugeni Dodonov (1):
      drm/i915: prevent possible pin leak on error path

Felix Kaechele (1):
      ALSA: hda - Add inverted internal mic quirk for Lenovo IdeaPad U310

Feng Hong (1):
      PM / Sleep: use resume event when call dpm_resume_early

Florian Fainelli (1):
      ixp4xx_hss: fix build failure due to missing linux/module.h inclusion

Florian Zumbiehl (1):
      drm/savage: re-add busmaster enable, regression fix

Frank Sch=C3=A4fer (1):
      media: gspca_pac7302: add support for device 1ae7:2001 Speedlink Snap=
py Microphone SL-6825-SBK

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

Greg Kroah-Hartman (3):
      Revert dyndbg: fix for SOH in logging messages
      Revert "drm/i915: correctly order the ring init sequence"
      Linux 3.5.7

Guennadi Liakhovetski (1):
      mmc: sh-mmcif: avoid oops on spurious interrupts

Herton Ronaldo Krzesinski (2):
      ext4: fix crash when accessing /proc/mounts concurrently
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

Lennart Sorensen (1):
      sierra_net: Endianess bug fix.

Li RongQing (1):
      xfrm: fix a read lock imbalance in make_blackhole

Lin Ming (1):
      ACPI: run _OSC after ACPI_FULL_INITIALIZATION

Linus L=C3=BCssing (1):
      batman-adv: make batadv_test_bit() return 0 or 1 only

Mark Brown (3):
      mfd: max8925: Move _IO resources out of ioport_ioresource
      ASoC: wm_hubs: Ensure volume updates are handled during class W start=
up
      ASoC: wm9712: Fix name of Capture Switch

Marko Friedemann (1):
      ALSA: USB: Support for (original) Xbox Communicator

Martin Michlmayr (1):
      drivers/scsi/atp870u.c: fix bad use of udelay

Martin Peschke (1):
      SCSI: zfcp: only access zfcp_scsi_dev for valid scsi_device

Mathias Krause (8):
      xfrm_user: return error pointer instead of NULL
      xfrm_user: return error pointer instead of NULL #2
      xfrm_user: fix info leak in copy_to_user_auth()
      xfrm_user: fix info leak in copy_to_user_state()
      xfrm_user: fix info leak in copy_to_user_policy()
      xfrm_user: fix info leak in copy_to_user_tmpl()
      xfrm_user: don't copy esn replay window twice for new states
      xfrm_user: ensure user supplied esn replay window is valid

Matthew Garrett (1):
      efi: Build EFI stub with EFI-appropriate options

Mauro Carvalho Chehab (1):
      em28xx: Make all em28xx extensions to be initialized asynchronously

Mel Gorman (2):
      mempolicy: fix a race in shared_policy_replace()
      mempolicy: fix a memory corruption by refcount imbalance in alloc_pag=
es_vma()

Michael Wang (1):
      slab: fix the DEADLOCK issue on l3 alien lock

Michal Hocko (1):
      hugetlb: do not use vma_hugecache_offset() for vma_prio_tree_foreach

Michal Kube=C4=8Dek (1):
      tcp: flush DMA queue before sk_wait_data if rcv_wnd is zero

Michal Schmidt (1):
      bnx2x: fix rx checksum validation for IPv6

Naoya Horiguchi (1):
      kpageflags: fix wrong KPF_THP on non-huge compound pages

Nicolas Dichtel (1):
      ipv6: del unreachable route when an addr is deleted on lo

Nikolay Aleksandrov (1):
      netxen: check for root bus in netxen_mask_aer_correctable

Omair Mohammed Abdullah (1):
      ALSA: aloop - add locking to timer access

Paolo Valente (1):
      pkt_sched: fix virtual-start-time update in QFQ

Paul E. McKenney (2):
      ia64: Add missing RCU idle APIs on idle loop
      rcu: Fix day-one dyntick-idle stall-warning bug

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

Srivatsa S. Bhat (1):
      CPU hotplug, cpusets, suspend: Don't modify cpusets during suspend/re=
sume

Steffen Klassert (1):
      xfrm: Workaround incompatibility of ESN and async crypto

Steffen Maier (5):
      SCSI: zfcp: Adapt to new FC_PORTSPEED semantics
      SCSI: zfcp: Make trace record tags unique
      SCSI: zfcp: Bounds checking for deferred error trace
      SCSI: zfcp: Do not wakeup while suspended
      SCSI: zfcp: restore refcount check on port_remove

Tejun Heo (1):
      workqueue: add missing smp_wmb() in process_one_work()

Theodore Ts'o (1):
      ext4: fix potential deadlock in ext4_nonda_switch()

Thomas Graf (1):
      sctp: Don't charge for data in sndbuf again when transmitting packet

Vaibhav Bedia (1):
      mmc: omap_hsmmc: Pass on the suspend failure to the PM core

Wade Farnsworth (1):
      ARM: 7548/1: include linux/sched.h in syscall.h

Wei Yongjun (1):
      ipv6: fix return value check in fib6_add()

Xiaodong Xu (1):
      pppoe: drop PPPOX_ZOMBIEs in pppoe_release

Yinghai Lu (1):
      PCI: Check P2P bridge for invalid secondary/subordinate range

Yongqiang Yang (3):
      ext4: ignore last group w/o enough space when resizing instead of BUG=
'ing
      ext4: don't copy non-existent gdt blocks when resizing
      ext4: avoid duplicate writes of the backup bg descriptor blocks

Yuta Ando (1):
      localmodconfig: Fix localyesconfig to set to 'y' not 'm'

htbegin (1):
      net: ethernet: davinci_cpdma: decrease the desc count when cleaning u=
p the remaining packets


--VbJkn9YxBvnuCH5J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQeIkMAAoJEDjbvchgkmk+EhMP/2UDlR3432q6f83E+tAgflg9
+G+VWrYZOhECOIq9AHZedwvQRWMbr9L5aWB5B5vEbIPYRRoNxS48tauCxwameIkR
/Gw+sICFSM30rE63zV3kEzKU7hkdzepx/WidVkPHYn1Vcq6TQJvrtFMMdQR5GTlw
1u2HDKn8yTZkrcm4JBLEdFpq3Var9lOuWWPuLBAk+6Cw2qlEOwqs8drp/3ppBzfc
icB9kf8/+Cn+7L3wNhBuNLdO37p6ZR7/J7SbRpU56hWDBa5Eao5gD0QWizFWu8st
rJGLyOXkYZ313SXs+xnwMF6fyiupg6kojlRmuWKxmC0rY2A27y95onl/3yeT/bIc
QGRN9T+nEWGrkXt7QOzQAmgb2L8tgzC9k8/jSQ/K55CO1qCRsfJeWMX4GJh8CCCB
fSfIRqdaZJas0rHO1cCLF4fcjAaawHFV1fCM5g+vfWo6PTzGBBPxJ4TamWhy5WIL
6jo4sBy/YlE3gDs0HE/hD8Nkyv6X7OKhG5z6nD2ZSWX65ShS0eoYKXRGvwbYMJpS
/wJXJBXs255EcgIN712VloxSAI20kCkL2ocnjUmqdAhvOw/5ZxcDq+SuxIAphwA2
MSngN/0Tz+tmAPd2WT/cH7tlbyjoHqV7SiKAK+VYgvGw3Hb1FPnZENKXGzrpkjX4
3RGi5JnDoj2Gw9VbzMpN
=zlxj
-----END PGP SIGNATURE-----

--VbJkn9YxBvnuCH5J--
