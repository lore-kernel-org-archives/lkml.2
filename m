Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932271Ab2AMP1y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 10:27:54 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:53817 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932164Ab2AMP1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 10:27:53 -0500
From: Giorgos Kyprianidis <elapoueis@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-kernel@vger.kernel.org, p3100225@dias.aueb.gr
Subject: [PATCH 2/2] wireless:core fixed 2 spacing errors
Date: Fri, 13 Jan 2012 17:27:44 +0200
Message-Id: <1326468464-450-1-git-send-email-p3100225@dias.aueb.gr>
X-Mailer: git-send-email 1.7.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed 2 spacing errors
---
 net/wireless/core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index ccdfed8..a9df335 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -668,7 +668,7 @@ void wiphy_unregister(struct wiphy *wiphy)
 		mutex_lock(&rdev->devlist_mtx);
 		__count = rdev->opencount;
 		mutex_unlock(&rdev->devlist_mtx);
-		__count == 0;}));
+		__count == 0; }));
 
 	mutex_lock(&rdev->devlist_mtx);
 	BUG_ON(!list_empty(&rdev->netdev_list));
@@ -777,7 +777,7 @@ static struct device_type wiphy_type = {
 	.name	= "wlan",
 };
 
-static int cfg80211_netdev_notifier_call(struct notifier_block * nb,
+static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 					 unsigned long state,
 					 void *ndev)
 {
-- 
1.7.8.3

