Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932602Ab2GMBW6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 21:22:58 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:44132 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753271Ab2GMBW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 21:22:56 -0400
Message-ID: <1342142571.25597.366.camel@deadeye.wl.decadent.org.uk>
Subject: Linux 3.2.23
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Date: Fri, 13 Jul 2012 02:22:51 +0100
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-/PU4iv/ppTKAsISU3GzW"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-/PU4iv/ppTKAsISU3GzW
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.2.23 kernel.

All users of the 3.2 kernel series should upgrade.

The updated 3.2.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.2.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git

Ben.

------------

 Makefile                                           |    2 +-
 arch/arm/kernel/smp.c                              |   10 +-
 arch/powerpc/kvm/book3s_hv_rmhandlers.S            |    2 +-
 arch/powerpc/xmon/xmon.c                           |    2 +-
 drivers/block/umem.c                               |   40 ++++++++
 drivers/gpu/drm/i915/i915_dma.c                    |   37 +++++--
 drivers/md/persistent-data/dm-space-map-checker.c  |   54 ++++++-----
 drivers/md/persistent-data/dm-space-map-disk.c     |   11 ++-
 .../md/persistent-data/dm-transaction-manager.c    |   11 ++-
 drivers/md/raid10.c                                |   12 ++-
 drivers/md/raid5.c                                 |   10 +-
 drivers/mtd/nand/cafe_nand.c                       |    2 +-
 drivers/net/bonding/bond_main.c                    |    9 +-
 drivers/net/dummy.c                                |    5 +-
 drivers/net/ethernet/emulex/benet/be_main.c        |    5 +-
 drivers/net/ethernet/marvell/sky2.c                |   10 +-
 drivers/net/wireless/ath/ath.h                     |    1 +
 drivers/net/wireless/ath/ath9k/hw.c                |    2 +-
 drivers/net/wireless/ath/ath9k/recv.c              |    3 +-
 drivers/net/wireless/ath/key.c                     |    4 +
 drivers/net/wireless/mwifiex/11n_rxreorder.c       |    5 +-
 drivers/net/wireless/mwifiex/11n_rxreorder.h       |    7 ++
 drivers/net/wireless/mwifiex/cfg80211.c            |   21 ++--
 drivers/net/wireless/mwifiex/wmm.c                 |   12 ++-
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c        |    3 +
 drivers/target/tcm_fc/tfc_sess.c                   |    3 +-
 fs/btrfs/tree-log.c                                |    6 ++
 fs/cifs/connect.c                                  |    9 +-
 fs/ocfs2/file.c                                    |    4 +-
 fs/open.c                                          |    6 +-
 fs/splice.c                                        |   35 ++++---
 fs/udf/super.c                                     |  102 ++++++++++++----=
----
 include/linux/aio.h                                |    1 +
 include/linux/splice.h                             |    8 +-
 include/net/cipso_ipv4.h                           |   29 +++++-
 include/net/sch_generic.h                          |    7 +-
 kernel/relay.c                                     |    5 +-
 kernel/trace/trace.c                               |    8 +-
 mm/madvise.c                                       |   16 ++-
 mm/shmem.c                                         |    3 +-
 net/bridge/br_if.c                                 |    1 +
 net/bridge/br_netlink.c                            |    2 +-
 net/bridge/br_private.h                            |    1 +
 net/core/ethtool.c                                 |    1 +
 net/core/netpoll.c                                 |   11 ++-
 net/core/skbuff.c                                  |    3 +-
 net/core/sock.c                                    |    7 +-
 net/ipv6/route.c                                   |   41 ++++++--
 net/l2tp/l2tp_eth.c                                |    2 +
 net/l2tp/l2tp_ip.c                                 |    9 +-
 net/mac80211/rx.c                                  |    5 +-
 net/nfc/nci/ntf.c                                  |    4 +-
 net/nfc/rawsock.c                                  |    5 +-
 sound/pci/hda/patch_sigmatel.c                     |    4 +-
 sound/soc/codecs/tlv320aic3x.c                     |    4 +-
 sound/soc/codecs/tlv320aic3x.h                     |    1 +
 56 files changed, 439 insertions(+), 184 deletions(-)

Andy Lutomirski (1):
      mm: Hold a file reference in madvise_remove

Anton Blanchard (1):
      powerpc/xmon: Use cpumask iterator to avoid warning

Ben Hutchings (1):
      Linux 3.2.23

Bing Zhao (1):
      mwifiex: fix wrong return values in add_virtual_intf() error cases

Chris Mason (1):
      Btrfs: run delayed directory updates during log replay

Dan Carpenter (1):
      mtd: cafe_nand: fix an & vs | mistake

Dan Rosenberg (1):
      NFC: Prevent multiple buffer overflows in NCI

Daniel Vetter (1):
      drm/i915: kick any firmware framebuffers before claiming the gtt

Eric Dumazet (8):
      splice: fix racy pipe->buffers uses
      NFC: Return from rawsock_release when sk is NULL
      net: l2tp_eth: fix kernel panic on rmmod l2tp_eth
      l2tp: fix a race in l2tp_ip_sendmsg()
      be2net: fix a race in be_xmit()
      dummy: fix rcu_sched self-detected stalls
      bonding: Fix corrupted queue_mapping
      netpoll: fix netpoll_send_udp() bugs

Felix Fietkau (1):
      ath9k: fix dynamic WEP related regression

Hebbar, Gururaja (1):
      ASoC: tlv320aic3x: Fix codec pll configure bug

Jan Kara (3):
      udf: Use 'ret' instead of abusing 'i' in udf_load_logicalvol()
      udf: Avoid run away loop when partition table length is corrupted
      udf: Fortify loading of sparing table

Jason Wang (1):
      net: sock: validate data_len before allocating skb in sock_alloc_send=
_pskb()

Jeff Layton (1):
      cifs: when server doesn't set CAP_LARGE_READ_X, cap default rsize at =
MaxBufferSize

Johannes Berg (1):
      mac80211: correct behaviour on unrecognised action frames

Junxiao Bi (2):
      ocfs2: clear unaligned io flag when dio fails
      aio: make kiocb->private NUll in init_sync_kiocb()

Larry Finger (1):
      rtlwifi: rtl8192cu: New USB IDs

Linus Torvalds (1):
      vfs: make O_PATH file descriptors usable for 'fchdir()'

Mark Rustad (1):
      tcm_fc: Resolve suspicious RCU usage warnings

Michael Neuling (1):
      powerpc/kvm: sldi should be sld

Micha=C5=82 Miros=C5=82aw (1):
      ethtool: allow ETHTOOL_GSSET_INFO for users

Mike Snitzer (3):
      dm persistent data: fix shadow_info_leak on dm_tm_destroy
      dm persistent data: handle space map checker creation failure
      dm persistent data: fix allocation failure in space map checker init

NeilBrown (2):
      md/raid10: Don't try to recovery unmatched (and unused) chunks.
      md/raid10: fix failure when trying to repair a read error.

Panayiotis Karabassis (1):
      ath9k: enable serialize_regmode for non-PCIE AR9287

Paul Moore (1):
      cipso: handle CIPSO options correctly when NetLabel is disabled

Russell King (1):
      ARM: fix rcu stalls on SMP platforms

Stone Piao (2):
      mwifiex: fix 11n rx packet drop issue
      mwifiex: fix WPS eapol handshake failure

Takashi Iwai (1):
      ALSA: hda - Fix power-map regression for HP dv6 & co

Tao Guo (1):
      umem: fix up unplugging

Thomas Graf (1):
      ipv6: Move ipv6 proc file registration to end of init order

Vaibhav Nagarnaik (1):
      tracing: change CPU ring buffer state from tracing_cpumask

majianpeng (2):
      md/raid5: Do not add data_offset before call to is_badblock
      md/raid5: In ops_run_io, inc nr_pending before calling md_wait_for_bl=
ocked_rdev

stephen hemminger (2):
      sky2: fix checksum bit management on some chips
      bridge: Assign rtnl_link_ops to bridge devices created via ioctl (v2)


--=20
Ben Hutchings
The generation of random numbers is too important to be left to chance.
                                                            - Robert Coveyo=
u

--=-/PU4iv/ppTKAsISU3GzW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT/94a+e/yOyVhhEJAQohMw/+JMF1C4tpTsudjvLXmhvqasItGChvYCwD
nCy7gP3OG08j4lfQwoxkUDs5Uc2VnY/vgyzqnaX0GdPNEo33C+Sj0ev5SFZxj0eP
dD8j03AXSYh/z/jKFI0BKIsmkRT4hhgK9GQxyBE6hwZEC/6keOjLhlgo6fi0jXed
L7k8//OUTRA1Um0blmPruWVUXqUpcCUZtSZcXwm2iKgaJsVEWiUcwtJUt/cUXLvQ
jpF++Q4F8aQfPbOZ5uE0bv6Gk2yR4SNgf5RA0vJl3Tn5EsC2Sk9EGF5Nldv/9D1s
W2CA8YCRY0BeGKFNTCqls5VAgf5z4pPIPiM7mELuBE098ntzSuWNuOjf2N02APXb
OM1hgHOmTCZ5JrnyQDRcjRqMv8Ox2F8Di8haqWmpmpOHePnUqesfyjHJpc0Fc4bN
yrOQ1yxYfHT9Z8sEmyQsFLxT+sj/+qn9uBIvWS49W31bHbS6ZPYAb1bg+r4X65Qv
4sKOTSUCH667AlegrrzK8fEN0pAdzfyN4o+mVFeNqij85DkdQBsPzv2G/CxQ7Wh8
OSZWuPZl7K7U2kakEMvpt8Lo/BRN55bmrrvtVK+IogHegre/VIWMc0ZGR4/MA+GL
YkADlMc2GfzG46hAWJtuuYGVn78hKsgd06KSsjnW22+IzKjkOA7YsvZYeq5Fe7Ha
jLs+7uGSPgU=
=1HDV
-----END PGP SIGNATURE-----

--=-/PU4iv/ppTKAsISU3GzW--
