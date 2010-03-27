Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875Ab0C0C2G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 22:28:06 -0400
Received: from mail.perches.com ([173.55.12.10]:1130 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752696Ab0C0C2B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 22:28:01 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Faisal Latif <faisal.latif@intel.com>,
       Chien Tung <chien.tin.tung@intel.com>,
       Roland Dreier <rolandd@cisco.com>, Sean Hefty <sean.hefty@intel.com>,
       Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org
Subject: [PATCH 3/9] drivers/infiniband: Fix continuation lines
Date: Fri, 26 Mar 2010 19:27:52 -0700
Message-Id: <f0b8a02c42d9923131076626f562af0e5074b761.1269655208.git.joe@perches.com>
X-Mailer: git-send-email 1.7.0.14.g7e948
In-Reply-To: <cover.1269655208.git.joe@perches.com>
References: <cover.1269655208.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/infiniband/hw/nes/nes_nic.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_nic.c b/drivers/infiniband/hw/nes/nes_nic.c
index 91fdde3..9963676 100644
--- a/drivers/infiniband/hw/nes/nes_nic.c
+++ b/drivers/infiniband/hw/nes/nes_nic.c
@@ -902,9 +902,8 @@ static void nes_netdev_set_multicast_list(struct net_device *netdev)
 					nesvnic->nic_index &&
 					mc_index < max_pft_entries_avaiable) {
 						nes_debug(NES_DBG_NIC_RX,
-					"mc_index=%d skipping nic_index=%d,\
-					used for=%d \n", mc_index,
+					"mc_index=%d skipping nic_index=%d, "
+					"used for=%d\n", mc_index,
 					nesvnic->nic_index,
 					nesadapter->pft_mcast_map[mc_index]);
 				mc_index++;
-- 
1.7.0.14.g7e948

