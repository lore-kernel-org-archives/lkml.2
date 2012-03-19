Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932319Ab2CSDiK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 23:38:10 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:56296 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754324Ab2CSDiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 23:38:08 -0400
From: Joe Perches <joe@perches.com>
To: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net
Subject: [PATCH 0/4] driver: net: Use ETH_ALEN 
Date: Sun, 18 Mar 2012 20:37:55 -0700
Message-Id: <cover.1332128181.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just some neatening

Joe Perches (4):
  if_vlan: Remove VLAN_ETH_ALEN define and the 1 use of it
  atlx: Use ETH_ALEN
  igbvf: Use ETH_ALEN
  rtlwifi: Remove unused ETH_ADDR_LEN defines

 drivers/net/ethernet/atheros/atlx/atl2.c     |   13 +++++--------
 drivers/net/ethernet/atheros/atlx/atl2.h     |    5 ++---
 drivers/net/ethernet/atheros/atlx/atlx.h     |    1 -
 drivers/net/ethernet/intel/igbvf/defines.h   |    4 ----
 drivers/net/ethernet/intel/igbvf/vf.c        |    7 ++-----
 drivers/net/wireless/rtlwifi/rtl8192ce/reg.h |    1 -
 drivers/net/wireless/rtlwifi/rtl8192de/reg.h |    1 -
 include/linux/if_vlan.h                      |    7 +++----
 8 files changed, 12 insertions(+), 27 deletions(-)

-- 
1.7.8.111.gad25c.dirty

