Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755627Ab2FIR0K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 13:26:10 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51052 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754929Ab2FIRZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 13:25:26 -0400
Date: Sat, 9 Jun 2012 08:52:40 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 3.0.34
Message-ID: <20120609155240.GA987@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C7zPtVaVf+AK4Oqc"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.0.34 kernel.

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

 Makefile                                  |    2=20
 arch/parisc/kernel/entry.S                |   30 +++++++------
 arch/parisc/kernel/vmlinux.lds.S          |    6 +-
 arch/x86/include/asm/pgtable-3level.h     |   50 ++++++++++++++++++++++
 drivers/acpi/battery.c                    |   10 +++-
 drivers/atm/solos-pci.c                   |    4 +
 drivers/bluetooth/ath3k.c                 |    6 ++
 drivers/bluetooth/btusb.c                 |   16 ++++++-
 drivers/gpu/drm/i915/intel_sdvo.c         |   12 +++--
 drivers/gpu/drm/i915/intel_sdvo_regs.h    |    5 ++
 drivers/gpu/drm/i915/intel_tv.c           |    5 ++
 drivers/gpu/drm/radeon/evergreen.c        |    9 +++
 drivers/gpu/drm/radeon/evergreend.h       |    1=20
 drivers/gpu/drm/radeon/radeon_atombios.c  |    4 +
 drivers/gpu/drm/radeon/rv770.c            |    2=20
 drivers/gpu/drm/radeon/rv770d.h           |    1=20
 drivers/gpu/drm/ttm/ttm_bo.c              |    1=20
 drivers/mtd/nand/nand_bbt.c               |    1=20
 drivers/net/macvlan.c                     |    2=20
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |    1=20
 drivers/net/wireless/wl1251/sdio.c        |    2=20
 drivers/net/wireless/wl1251/spi.c         |    3 -
 drivers/scsi/scsi_lib.c                   |   11 +++-
 drivers/scsi/scsi_wait_scan.c             |    2=20
 fs/cifs/cifsglob.h                        |    1=20
 fs/cifs/file.c                            |   57 ++++++++++++++-----------
 fs/ext4/ioctl.c                           |   13 +++--
 fs/ext4/mballoc.c                         |    6 +-
 fs/ext4/super.c                           |    4 +
 fs/namespace.c                            |    3 -
 fs/nfs/nfs4proc.c                         |    2=20
 include/asm-generic/pgtable.h             |   22 ++++++++-
 include/drm/drm_pciids.h                  |    2=20
 include/linux/netdevice.h                 |    9 ---
 include/linux/skbuff.h                    |    2=20
 include/net/dst.h                         |    1=20
 include/net/sctp/sctp.h                   |   13 +++++
 mm/vmscan.c                               |    2=20
 net/8021q/vlan_dev.c                      |    2=20
 net/core/dev.c                            |   36 ++-------------
 net/core/pktgen.c                         |   10 +++-
 net/ipv4/esp4.c                           |   24 +++-------
 net/ipv4/fib_semantics.c                  |   20 +++++---
 net/ipv4/fib_trie.c                       |    2=20
 net/ipv6/esp6.c                           |   18 +++----
 net/ipv6/ip6_output.c                     |   68 ++++++++++++++++++++++---=
-----
 net/l2tp/l2tp_ip.c                        |   30 ++++++++++---
 net/mac80211/util.c                       |   12 ++---
 net/sctp/output.c                         |    4 -
 net/sctp/transport.c                      |   17 -------
 net/xfrm/xfrm_policy.c                    |    3 +
 sound/usb/pcm.c                           |    3 +
 52 files changed, 374 insertions(+), 198 deletions(-)

Al Viro (1):
      vfs: umount_tree() might be called on subtree that had never made it

Alex Deucher (3):
      drm/radeon: fix XFX quirk
      drm/radeon: properly program gart on rv740, juniper, cypress, barts, =
hemlock
      drm/radeon/kms: add new BTC PCI ids

Andrea Arcangeli (1):
      mm: pmd_read_atomic: fix 32bit PAE pmd walk vs pmd_populate SMP race =
condition

Andy Whitcroft (1):
      ACPI battery: only refresh the sysfs files when pertinent information=
 changes

Benjamin Poirier (1):
      xfrm: take net hdr len into account for esp payload size calculation

Clemens Ladisch (1):
      ALSA: usb-audio: fix rate_list memory leak

Daniel Vetter (2):
      drm/i915: properly handle interlaced bit for sdvo dtd conversion
      drm/i915: wait for a vblank to pass after tv detect

David S. Miller (2):
      ipv4: Do not use dead fib_info entries.
      Revert "net: maintain namespace isolation between vlan and real devic=
e"

David Woodhouse (1):
      solos-pci: Fix DMA support

Dmitry Maluka (1):
      mtd: nand: fix scan_read_raw_oob

Don Zickus (1):
      Bluetooth: btusb: typo in Broadcom SoftSailing id

Eric Dumazet (2):
      pktgen: fix crash at module unload
      pktgen: fix module unload for good

Eric Sandeen (1):
      ext4: force ro mount if ext4_setup_super() fails

Eyal Shapira (1):
      mac80211: fix ADDBA declined after suspend with wowlan

Felix Fietkau (1):
      skb: avoid unnecessary reallocations in __skb_cow

Gao feng (1):
      ipv6: fix incorrect ipsec fragment

Grazvydas Ignotas (1):
      wl1251: fix oops on early interrupt

Greg Kroah-Hartman (1):
      Linux 3.0.34

James Bottomley (2):
      SCSI: fix scsi_wait_scan
      PARISC: fix TLB fault path on PA2.0 narrow systems

James Chapman (1):
      l2tp: fix oops in L2TP IP sockets for connect() AF_UNSPEC case

James M. Leddy (1):
      Bluetooth: btusb: add support for BCM20702A0 [0a5c:21e6]

Jerome Glisse (1):
      drm/radeon: fix HD6790, HD6570 backend programming

Jesse Sung (1):
      Bluetooth: Add support for BCM20702A0 [0a5c:21e3]

John David Anglin (1):
      PARISC: fix boot failure on 32-bit systems caused by branch stubs pla=
ced before .text

Jo=E3o Paulo Rechi Vita (1):
      Bluetooth: btusb: Add USB device ID "0a5c 21e8"

Jun'ichi Nomura (1):
      SCSI: Fix dm-multipath starvation when scsi host is busy

Manoj Iyer (2):
      Bluetooth: btusb: Add vendor specific ID (0a5c 21f3) for BCM20702A0
      Bluetooth: btusb: Add vendor specific ID (0489 e042) for BCM20702A0

Meenakshi Venkataraman (1):
      iwlwifi: update BT traffic load states correctly

Michael Gruetzner (1):
      Bluetooth: Add support for Foxconn/Hon Hai AR5BBU22 0489:E03C

Michal Hocko (1):
      mm: consider all swapped back pages in used-once logic

Nicolas Dichtel (1):
      sctp: check cached dst before using it

Salman Qazi (2):
      ext4: add ext4_mb_unload_buddy in the error path
      ext4: remove mb_groups before tearing down the buddy_cache

Shirish Pargaonkar (1):
      cifs: fix oops while traversing open file list (try #4)

Steven Harms (1):
      Add Foxconn / Hon Hai IDs for btusb module

Tao Ma (1):
      ext4: don't set i_flags in EXT4_IOC_SETFLAGS

Theodore Ts'o (2):
      ext4: add missing save_error_info() to ext4_error()
      ext4: don't trash state flags in EXT4_IOC_SETFLAGS

Thomas Hellstrom (1):
      drm/ttm: Fix spinlock imbalance

Trond Myklebust (1):
      NFSv4: Map NFS4ERR_SHARE_DENIED into an EACCES error instead of EIO

Wen-chien Jesse Sung (1):
      Bluetooth: Add support for Broadcom BCM20702A0

Yanmin Zhang (1):
      ipv4: fix the rcu race between free_fib_info and ip_route_output_slow


--C7zPtVaVf+AK4Oqc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJP03FIAAoJEDjbvchgkmk+j7YP/jwNyOtpGMRMn+/HEGJnZdlq
fqkXuvl09lFCAaFFOYgH9li1DH2Nlbt5bQLMxGQ28I9vuncgMb+NLN/YSC7Zelcl
QDv6EBN4RcI/ijVQSHuSgtKX+qX2L4auOgFVWdA+Ad4GH2KPY4M/JfJter/LxqKQ
HAaa23OxallFMkllIUVK9b3+9ajIaP9ajbkId1sCUOQaUQeoH5SHLRuUKqA9Sxq8
LfODC3Goyd59eFNEpze7WWj2KJuHc3f7StpFBxOpo/bOMqdQhPr+F7nokjOx9SKw
wbJ5ysX7ZotYhjgtfjgC7Z75/cqiznyNF8332MH3J9vc5UQ1uH45EbNbnSMWkCeV
1cjB0lqk4ocPhWaixdfXgxxzgFBpn03JHBRvHkYdir42B3NDuCVEYMWe0x2XzaUj
hNpS3l2IEaDfnkrutaZwxGtu/ZVtYjLBM2r6eRPRfUZtf/33OXqELNdxJt3inWm8
/KL8klERkDyPOkIQz2eQtdpkwQgDiWNPFiwkh1H4kVJTwFDabbnn6k7UAaVp34qF
i3sTfaOFFvIgz1eHYeB4+ladaGX5NJZZbSZyXRQ1PkP8ME2+9yeq2it0H6I5CxLP
abwDUsw0Nbbvyf3YYnEJXbjVwTcVUSPADP+/t4u9eqLFBMtI9verFhkqww/WBB72
YnI7yon3Ce0hi+LUaxgr
=9BXx
-----END PGP SIGNATURE-----

--C7zPtVaVf+AK4Oqc--
