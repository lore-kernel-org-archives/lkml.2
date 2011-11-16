Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940Ab1KPTi1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 14:38:27 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:53261 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751383Ab1KPTi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 14:38:26 -0500
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/5] Use ETH_ALEN
Date: Wed, 16 Nov 2011 11:38:01 -0800
Message-Id: <cover.1321472142.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.405.gc1be0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove other #defines and uses in favor of ETH_ALEN

Joe Perches (5):
  ethernet: Convert MAC_ADDR_LEN uses to ETH_ALEN
  ethernet: Convert ETHER_ADDR_LEN uses to ETH_ALEN
  bna: Convert MAC_ADDRLEN uses to ETH_ALEN
  amd8111e:  Convert ETH_ADDR_LEN uses to ETH_ALEN
  ucc_geth: Convert ENET_NUM_OCTETS_PER_ADDRESS uses to ETH_ALEN

 drivers/net/ethernet/8390/8390.h           |    2 -
 drivers/net/ethernet/8390/apne.c           |    2 +-
 drivers/net/ethernet/8390/ax88796.c        |    5 +-
 drivers/net/ethernet/8390/es3210.c         |    2 +-
 drivers/net/ethernet/8390/hp-plus.c        |    2 +-
 drivers/net/ethernet/8390/hp.c             |    2 +-
 drivers/net/ethernet/8390/hydra.c          |    2 +-
 drivers/net/ethernet/8390/lne390.c         |    4 +-
 drivers/net/ethernet/8390/ne-h8300.c       |    2 +-
 drivers/net/ethernet/8390/ne.c             |    4 +-
 drivers/net/ethernet/8390/ne2.c            |    2 +-
 drivers/net/ethernet/8390/ne3210.c         |    2 +-
 drivers/net/ethernet/8390/stnic.c          |    2 +-
 drivers/net/ethernet/8390/zorro8390.c      |    2 +-
 drivers/net/ethernet/amd/amd8111e.c        |    6 +-
 drivers/net/ethernet/amd/amd8111e.h        |    1 -
 drivers/net/ethernet/amd/nmclan_cs.c       |   12 ++---
 drivers/net/ethernet/broadcom/sb1250-mac.c |    3 +-
 drivers/net/ethernet/brocade/bna/cna.h     |    3 +-
 drivers/net/ethernet/freescale/gianfar.c   |   12 +++---
 drivers/net/ethernet/freescale/gianfar.h   |    3 -
 drivers/net/ethernet/freescale/ucc_geth.c  |    2 +-
 drivers/net/ethernet/freescale/ucc_geth.h  |    6 +-
 drivers/net/ethernet/micrel/ksz884x.c      |   59 +++++++++++++--------------
 drivers/net/ethernet/realtek/r8169.c       |    5 +--
 drivers/net/ethernet/sis/sis190.c          |    8 +--
 26 files changed, 68 insertions(+), 87 deletions(-)

-- 
1.7.6.405.gc1be0

