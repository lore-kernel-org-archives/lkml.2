Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932343Ab1FGW1m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 18:27:42 -0400
Received: from mga09.intel.com ([134.134.136.24]:26716 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753991Ab1FGW1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 18:27:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,334,1304319600"; 
   d="scan'208";a="10400864"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>, jeffrey.t.kirsher@intel.com,
        jesse.brandeburg@intel.com, gregory.v.rose@intel.com
Subject: [PATCH 4/5] ixgbe: Fix incorrect declaration of ixgbevf_mbx_ops
Date: Tue,  7 Jun 2011 15:26:32 -0700
Message-Id: <1307485593-27196-4-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1307485593-27196-1-git-send-email-andi@firstfloor.org>
References: <1307485593-27196-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

The header extern type of ixgbevf_mbx_ops disagreed with
the actual declaration. Fix this here.

This is rather scary. I haven't tested it. Did this
ever work?

Cc: jeffrey.t.kirsher@intel.com
Cc: jesse.brandeburg@intel.com
Cc: gregory.v.rose@intel.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/net/ixgbevf/ixgbevf.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ixgbevf/ixgbevf.h b/drivers/net/ixgbevf/ixgbevf.h
index b703f60..a2bbbb3 100644
--- a/drivers/net/ixgbevf/ixgbevf.h
+++ b/drivers/net/ixgbevf/ixgbevf.h
@@ -279,7 +279,7 @@ enum ixgbevf_boards {
 
 extern struct ixgbevf_info ixgbevf_82599_vf_info;
 extern struct ixgbevf_info ixgbevf_X540_vf_info;
-extern struct ixgbe_mac_operations ixgbevf_mbx_ops;
+extern struct ixgbe_mbx_operations ixgbevf_mbx_ops;
 
 /* needed by ethtool.c */
 extern char ixgbevf_driver_name[];
-- 
1.7.4.4

