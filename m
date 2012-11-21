Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688Ab2KUN3P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 08:29:15 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:40476 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147Ab2KUN3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 08:29:14 -0500
From: MAACHE Mehdi <mehdi.maache@gmail.com>
To: greg@kroah.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        tdent48227@gmail.com, dan.carpenter@oracle.com,
        MAACHE Mehdi <mehdi.maache@gmail.com>
Subject: [PATCH] Staging: rtl8187se: bugfix in r8180_wx.c
Date: Wed, 21 Nov 2012 14:20:42 +0100
Message-Id: <1353504042-9422-1-git-send-email-mehdi.maache@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This bug was introduced in de171bd6ff "Staging: rtl8187se: r8180_wx: fixed a lot of checkpatch.pl issues".

Signed-off-by: Mehdi MAACHE <mehdi.maache@gmail.com>
---
 drivers/staging/rtl8187se/r8180_wx.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8180_wx.c b/drivers/staging/rtl8187se/r8180_wx.c
index 52f63d7..156b758 100644
--- a/drivers/staging/rtl8187se/r8180_wx.c
+++ b/drivers/staging/rtl8187se/r8180_wx.c
@@ -59,8 +59,6 @@ int r8180_wx_set_key(struct net_device *dev, struct iw_request_info *info,
 	if (priv->ieee80211->bHwRadioOff)
 		return 0;
 
-	if (erq->flags & IW_ENCODE_DISABLED)
-
 	if (erq->length > 0) {
 		u32* tkey = (u32*) key;
 		priv->key0[0] = tkey[0];
-- 
1.7.1

