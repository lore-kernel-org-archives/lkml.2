Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254Ab2GIOhm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 10:37:42 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38071 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754139Ab2GIOhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 10:37:40 -0400
Message-Id: <20120709143116.348975190@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 09 Jul 2012 15:31:16 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 00/48] 3.2.23-stable review
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.2.23 release.
There are 48 patches in this series, which will be posted as responses
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed Jul 11 20:00:00 UTC 2012.
Anything received after that time might be too late.

A combined patch relative to 3.2.22 will be posted as an additional
response to this, and the diffstat can be found below.

Ben.

-------------
 Makefile                                           |    4 +-
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
 drivers/net/dummy.c                                |    4 +-
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
 fs/udf/super.c                                     |  102 ++++++++++++--------
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
 56 files changed, 439 insertions(+), 185 deletions(-)

-- 
Ben Hutchings
No political challenge can be met by shopping. - George Monbiot

