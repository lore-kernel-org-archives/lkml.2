Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663Ab2AXXgF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 18:36:05 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:46062 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753315Ab2AXXgD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 18:36:03 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>, Len Brown <len.brown@intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] thermal_sys: Remove unnecessary line continuations
Date: Tue, 24 Jan 2012 15:35:35 -0800
Message-Id: <4afc2738bbc7690440312921d8ae8ddf0e14e2dc.1327447797.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1327447797.git.joe@perches.com>
References: <cover.1327447797.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Line continations are not necessary in function calls
or statements.  Remove them.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/thermal/thermal_sys.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index dd9a574..7326baa 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -283,8 +283,7 @@ passive_show(struct device *dev, struct device_attribute *attr,
 static DEVICE_ATTR(type, 0444, type_show, NULL);
 static DEVICE_ATTR(temp, 0444, temp_show, NULL);
 static DEVICE_ATTR(mode, 0644, mode_show, mode_store);
-static DEVICE_ATTR(passive, S_IRUGO | S_IWUSR, passive_show, \
-		   passive_store);
+static DEVICE_ATTR(passive, S_IRUGO | S_IWUSR, passive_show, passive_store);
 
 static struct device_attribute trip_point_attrs[] = {
 	__ATTR(trip_point_0_type, 0444, trip_point_type_show, NULL),
@@ -1314,8 +1313,8 @@ int generate_netlink_event(u32 orig, enum events event)
 	int result;
 
 	/* allocate memory */
-	size = nla_total_size(sizeof(struct thermal_genl_event)) + \
-				nla_total_size(0);
+	size = nla_total_size(sizeof(struct thermal_genl_event)) +
+	       nla_total_size(0);
 
 	skb = genlmsg_new(size, GFP_ATOMIC);
 	if (!skb)
@@ -1331,8 +1330,8 @@ int generate_netlink_event(u32 orig, enum events event)
 	}
 
 	/* fill the data */
-	attr = nla_reserve(skb, THERMAL_GENL_ATTR_EVENT, \
-			sizeof(struct thermal_genl_event));
+	attr = nla_reserve(skb, THERMAL_GENL_ATTR_EVENT,
+			   sizeof(struct thermal_genl_event));
 
 	if (!attr) {
 		nlmsg_free(skb);
-- 
1.7.8.111.gad25c.dirty

