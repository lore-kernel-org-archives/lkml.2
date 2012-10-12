Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404Ab2JLVTn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 17:19:43 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:56658 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283Ab2JLVTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 17:19:41 -0400
Date: Sat, 13 Oct 2012 06:19:35 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.0.46
Message-ID: <20121012211935.GA2885@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EVF5PPMfhYS0aIcm"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.0.46 kernel.

All users of the 3.0 kernel series must upgrade.

The updated 3.0.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.0.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------

 Makefile                                |    2=20
 arch/mn10300/Makefile                   |    2=20
 arch/x86/include/asm/pgtable.h          |   11=20
 drivers/acpi/bus.c                      |    8=20
 drivers/block/aoe/aoecmd.c              |    1=20
 drivers/gpu/drm/radeon/radeon_irq_kms.c |   10=20
 drivers/gpu/drm/radeon/radeon_pm.c      |    8=20
 drivers/media/rc/ite-cir.c              |    2=20
 drivers/mtd/maps/autcpu12-nvram.c       |   19 -
 drivers/mtd/nand/nand_bbt.c             |    2=20
 drivers/mtd/nand/nandsim.c              |    1=20
 drivers/mtd/nand/omap2.c                |    3=20
 drivers/net/davinci_cpdma.c             |    1=20
 drivers/net/netxen/netxen_nic_main.c    |    4=20
 drivers/net/pppoe.c                     |    2=20
 drivers/net/r8169.c                     |  444 ++++++++++++++++++++++++---=
-----
 drivers/net/tg3.c                       |   14 -
 drivers/net/usb/sierra_net.c            |    2=20
 drivers/net/wan/ixp4xx_hss.c            |    1=20
 drivers/pci/hotplug/acpiphp_glue.c      |    7=20
 drivers/pci/probe.c                     |    6=20
 drivers/s390/scsi/zfcp_aux.c            |    1=20
 drivers/s390/scsi/zfcp_ccw.c            |   73 ++++-
 drivers/s390/scsi/zfcp_cfdc.c           |    2=20
 drivers/s390/scsi/zfcp_dbf.c            |   20 +
 drivers/s390/scsi/zfcp_dbf.h            |    1=20
 drivers/s390/scsi/zfcp_def.h            |    2=20
 drivers/s390/scsi/zfcp_ext.h            |    2=20
 drivers/s390/scsi/zfcp_fsf.c            |   23 +
 drivers/s390/scsi/zfcp_sysfs.c          |   18 +
 drivers/s390/scsi/zfcp_unit.c           |   36 +-
 drivers/scsi/atp870u.c                  |   11=20
 fs/ext4/inode.c                         |    8=20
 fs/ext4/move_extent.c                   |    7=20
 fs/ext4/namei.c                         |    2=20
 include/linux/mempolicy.h               |    2=20
 include/linux/xfrm.h                    |    2=20
 include/net/xfrm.h                      |    3=20
 kernel/cpuset.c                         |    3=20
 kernel/rcutree.c                        |    4=20
 kernel/sched.c                          |   40 ++
 kernel/sys.c                            |    1=20
 kernel/workqueue.c                      |    2=20
 lib/gcd.c                               |    3=20
 mm/mempolicy.c                          |  137 ++++++---
 mm/truncate.c                           |    3=20
 net/8021q/vlan_core.c                   |    3=20
 net/core/dev.c                          |   14 -
 net/core/sock.c                         |    3=20
 net/ipv4/raw.c                          |   14 -
 net/ipv4/tcp.c                          |   10=20
 net/ipv6/mip6.c                         |   20 -
 net/ipv6/raw.c                          |   21 -
 net/ipv6/route.c                        |   11=20
 net/l2tp/l2tp_eth.c                     |    2=20
 net/netrom/af_netrom.c                  |    7=20
 net/sched/sch_cbq.c                     |    5=20
 net/sched/sch_qfq.c                     |    5=20
 net/sctp/output.c                       |   21 +
 net/xfrm/xfrm_input.c                   |    2=20
 net/xfrm/xfrm_policy.c                  |    2=20
 net/xfrm/xfrm_replay.c                  |   15 +
 net/xfrm/xfrm_user.c                    |   57 +++-
 scripts/Kbuild.include                  |    2=20
 sound/drivers/aloop.c                   |    6=20
 sound/soc/codecs/wm9712.c               |    2=20
 sound/usb/mixer.c                       |    7=20
 sound/usb/quirks-table.h                |   53 +++
 68 files changed, 944 insertions(+), 294 deletions(-)

Alan Cox (1):
      netrom: copy_datagram_iovec can fail

Alex Deucher (3):
      drm/radeon: only adjust default clocks on NI GPUs
      drm/radeon: Add MSI quirk for gateway RS690
      drm/radeon: force MSIs on RS690 asics

Alexander Shiyan (1):
      mtd: autcpu12-nvram: Fix compile breakage

Andrea Arcangeli (1):
      mm: thp: fix pmd_present for split_huge_page and PROT_NONE with THP

Andreas Bie=C3=9Fmann (2):
      mtd: omap2: fix omap_nand_remove segfault
      mtd: omap2: fix module loading

Antonio Quartulli (1):
      8021q: fix mac_len recomputation in vlan_untag()

Ben Hutchings (1):
      media: rc: ite-cir: Initialise ite_dev::rdev earlier

Bernd Schubert (1):
      ext4: always set i_op in ext4_mknod()

Bjorn Helgaas (1):
      PCI: acpiphp: check whether _ADR evaluation succeeded

Chema Gonzalez (1):
      net: small bug on rxhash calculation

David Henningsson (1):
      ALSA: usb - disable broken hw volume for Tenx TP6911

Davidlohr Bueso (1):
      lib/gcd.c: prevent possible div by 0

Devendra Naga (1):
      r8169: call netif_napi_del at errpaths and at driver unload

Dmitry Monakhov (1):
      ext4: online defrag is not supported for journaled files

Ed L. Cashin (2):
      net: do not disable sg for packets requiring no checksum
      aoe: assert AoE packets marked as requiring no checksum

Eric Dumazet (6):
      net-sched: sch_cbq: avoid infinite loop
      net: guard tcp_set_keepalive() to tcp sockets
      ipv4: raw: fix icmp_filter()
      ipv6: raw: fix icmpv6_filter()
      ipv6: mip6: fix mip6_mh_filter()
      l2tp: fix a typo in l2tp_eth_dev_recv()

Florian Fainelli (1):
      ixp4xx_hss: fix build failure due to missing linux/module.h inclusion

Francois Romieu (7):
      r8169: remove erroneous processing of always set bit.
      r8169: jumbo fixes.
      r8169: expand received packet length indication.
      r8169: Rx FIFO overflow fixes.
      r8169: missing barriers.
      r8169: Config1 is read-only on 8168c and later.
      r8169: 8168c and later require bit 0x20 to be set in Config2 for PME =
signaling.

Gao feng (1):
      ipv6: release reference of ip6_null_entry's dst entry in __ip6_del_rt

Geert Uytterhoeven (1):
      mn10300: only add -mmem-funcs to KBUILD_CFLAGS if gcc supports it

Greg Kroah-Hartman (1):
      Linux 3.0.46

Hayes Wang (2):
      r8169: fix wake on lan setting for non-8111E.
      r8169: don't enable rx when shutdown.

Hugh Dickins (1):
      mm: fix invalidate_complete_page2() lock ordering

Jan Kara (1):
      ext4: fix fdatasync() for files with only i_size changes

Julia Lawall (1):
      SCSI: zfcp: remove invalid reference to list iterator variable

Julien Ducourthial (1):
      r8169: fix unsigned int wraparound with TSO

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

Mark Brown (1):
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

Matt Carlson (1):
      tg3: Fix TSO CAP for 5704 devs w / ASF enabled

Mel Gorman (2):
      mempolicy: fix a race in shared_policy_replace()
      mempolicy: fix a memory corruption by refcount imbalance in alloc_pag=
es_vma()

Michal Kube=C4=8Dek (1):
      tcp: flush DMA queue before sk_wait_data if rcv_wnd is zero

Nikolay Aleksandrov (1):
      netxen: check for root bus in netxen_mask_aer_correctable

Omair Mohammed Abdullah (1):
      ALSA: aloop - add locking to timer access

Paolo Valente (1):
      pkt_sched: fix virtual-start-time update in QFQ

Paul E. McKenney (1):
      rcu: Fix day-one dyntick-idle stall-warning bug

Richard Genoud (1):
      mtd: nandsim: bugfix: fail if overridesize is too big

Sascha Hauer (1):
      kbuild: make: fix if_changed when command contains backslashes

Shawn Guo (1):
      kernel/sys.c: call disable_nonboot_cpus() in kernel_restart()

Shmulik Ladkani (1):
      mtd: nand: Use the mirror BBT descriptor when reading its version

Srivatsa S. Bhat (1):
      CPU hotplug, cpusets, suspend: Don't modify cpusets during suspend/re=
sume

Steffen Klassert (1):
      xfrm: Workaround incompatibility of ESN and async crypto

Steffen Maier (3):
      SCSI: zfcp: Make trace record tags unique
      SCSI: zfcp: Do not wakeup while suspended
      SCSI: zfcp: restore refcount check on port_remove

Tejun Heo (1):
      workqueue: add missing smp_wmb() in process_one_work()

Thomas Graf (1):
      sctp: Don't charge for data in sndbuf again when transmitting packet

Xiaodong Xu (1):
      pppoe: drop PPPOX_ZOMBIEs in pppoe_release

Yinghai Lu (1):
      PCI: Check P2P bridge for invalid secondary/subordinate range

fran=C3=A7ois romieu (2):
      r8169: fix Config2 MSIEnable bit setting.
      r8169: runtime resume before shutdown.

hayeswang (1):
      r8169: increase the delay parameter of pm_schedule_suspend

htbegin (1):
      net: ethernet: davinci_cpdma: decrease the desc count when cleaning u=
p the remaining packets


--EVF5PPMfhYS0aIcm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQeIlnAAoJEDjbvchgkmk+57gP/R5+y4qqglHbGSXzcvuZXqsD
iMheou4wZG07GQ85Nm1efvzJAAHXqghGaqeyKQouW5mDJbFJLYGnjfdaVImrHykR
LKY8nntQykUmoHTZuHl33gyi/5YM6EzeE0GtL0WzB7DZWtLDiOJwaXhGX2GKag5s
fGfyFM+ItQp9XDjCUyK1gg+Jr6yZ1U9iP7tluT+wuRc95LFWKW1nk5zBI2OnTM9o
bo78k8asXk+s1Qe3CSSfN0/mnpf8OhxPARC+SV9R5J7VBZVdPGYNu/vEj2Zgz2Ey
KhqoLtziG/7yQXYvbawT6YaTpyvVGMaIg6QRdLi1x5VOb0qzv4BICFYivQ1GDbWV
zCdYv71GLjACwsl7KtrnCZ/kF1FTpfjdjKBeDRlqKuwsfVGq5aDLkwJ/bKQ/lQEc
/LbuyPSswoJ7RA40w3XC260/voiJ3Qmyph5D2c9VtDDTztPo6ygSX/Lo/6x3XuwI
Whpa0iwQXFyMJMtFwQhl1TbDCevaonMjD65Wjd5Y8UbNPFR1c8cykdkgL5FCw9vu
zKKhV/VcNBHHkMis4AtZBGMkGCxyi694kMNNTLpQ3veXK7AxRZIVMrsE71yYDmgS
J5tdwJ5SwAYjV5h2I+gpLgHS2lv6Mgucy/2THkAKoZeH0uBoJtYHbRmk/HIL1qs/
OSpkQFrh9j+Y9WjBK99u
=/m72
-----END PGP SIGNATURE-----

--EVF5PPMfhYS0aIcm--
