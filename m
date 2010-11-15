Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932720Ab0KODFj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 22:05:39 -0500
Received: from mail.perches.com ([173.55.12.10]:1164 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932652Ab0KODFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 22:05:36 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        PJ Waskiewicz <peter.p.waskiewicz.jr@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 14/44] drivers/net/ixgbe: Remove unnecessary semicolons
Date: Sun, 14 Nov 2010 19:04:33 -0800
Message-Id: <7d2c334daa75c5221946a17d45c9de1901cf06e7.1289789604.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1289789604.git.joe@perches.com>
References: <cover.1289789604.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/ixgbe/ixgbe_sriov.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ixgbe/ixgbe_sriov.c b/drivers/net/ixgbe/ixgbe_sriov.c
index 5428153..93f40bc 100644
--- a/drivers/net/ixgbe/ixgbe_sriov.c
+++ b/drivers/net/ixgbe/ixgbe_sriov.c
@@ -68,7 +68,7 @@ static int ixgbe_set_vf_multicasts(struct ixgbe_adapter *adapter,
 	 * addresses
 	 */
 	for (i = 0; i < entries; i++) {
-		vfinfo->vf_mc_hashes[i] = hash_list[i];;
+		vfinfo->vf_mc_hashes[i] = hash_list[i];
 	}
 
 	for (i = 0; i < vfinfo->num_vf_mc_hashes; i++) {
-- 
1.7.3.1.g432b3.dirty

