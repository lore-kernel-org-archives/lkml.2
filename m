Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932753Ab0CXSql (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 14:46:41 -0400
Received: from cpsmtpm-eml102.kpnxchange.com ([195.121.3.6]:51020 "EHLO
	CPSMTPM-EML102.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932446Ab0CXSqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 14:46:37 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Cc: Frans Pop <elendil@planet.nl>, libertas-dev@lists.infradead.org
Subject: [PATCH 7/7] wireless/libertas: remove trailing space in debugfs header
Date: Wed, 24 Mar 2010 19:46:35 +0100
Message-Id: <1269456395-15343-7-git-send-email-elendil@planet.nl>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <201003241927.12434.elendil@planet.nl>
References: <201003241927.12434.elendil@planet.nl>
X-OriginalArrivalTime: 24 Mar 2010 18:46:36.0719 (UTC) FILETIME=[551643F0:01CACB82]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Frans Pop <elendil@planet.nl>
Cc: libertas-dev@lists.infradead.org
---
 drivers/net/wireless/libertas/debugfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/libertas/debugfs.c b/drivers/net/wireless/libertas/debugfs.c
index 587b0cb..9c3c2f8 100644
--- a/drivers/net/wireless/libertas/debugfs.c
+++ b/drivers/net/wireless/libertas/debugfs.c
@@ -74,7 +74,7 @@ static ssize_t lbs_getscantable(struct file *file, char __user *userbuf,
 		return -ENOMEM;
 
 	pos += snprintf(buf+pos, len-pos,
-		"# | ch  | rssi |       bssid       |   cap    | Qual | SSID \n");
+		"# | ch  | rssi |       bssid       |   cap    | Qual | SSID\n");
 
 	mutex_lock(&priv->lock);
 	list_for_each_entry (iter_bss, &priv->network_list, list) {
-- 
1.6.6.1

