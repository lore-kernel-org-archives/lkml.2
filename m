Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106Ab2JIQLL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 12:11:11 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48886 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753932Ab2JIQLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 12:11:09 -0400
From: Adil Mujeeb <mujeeb.adil@gmail.com>
To: pavel@ucw.cz
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Adil Mujeeb <mujeeb.adil@gmail.com>
Subject: [PATCH] Staging: winbond: wbusb: Fixed coding style issue
Date: Tue,  9 Oct 2012 21:40:55 +0530
Message-Id: <1349799055-4496-1-git-send-email-mujeeb.adil@gmail.com>
X-Mailer: git-send-email 1.7.6.msysgit.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Repalces printk's with pr_debug

Signed-off-by: Adil Mujeeb <mujeeb.adil@gmail.com>
---
 linux-3.6-rc7/drivers/staging/winbond/wbusb.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/linux-3.6-rc7/drivers/staging/winbond/wbusb.c b/linux-3.6-rc7/drivers/staging/winbond/wbusb.c
index 0ca857a..48fe622 100644
--- a/linux-3.6-rc7/drivers/staging/winbond/wbusb.c
+++ b/linux-3.6-rc7/drivers/staging/winbond/wbusb.c
@@ -79,18 +79,18 @@ static int wbsoft_add_interface(struct ieee80211_hw *dev,
 static void wbsoft_remove_interface(struct ieee80211_hw *dev,
 				    struct ieee80211_vif *vif)
 {
-	printk("wbsoft_remove interface called\n");
+	pr_debug("wbsoft_remove interface called\n");
 }
 
 static void wbsoft_stop(struct ieee80211_hw *hw)
 {
-	printk(KERN_INFO "%s called\n", __func__);
+	pr_debug("%s called\n", __func__);
 }
 
 static int wbsoft_get_stats(struct ieee80211_hw *hw,
 			    struct ieee80211_low_level_stats *stats)
 {
-	printk(KERN_INFO "%s called\n", __func__);
+	pr_debug("%s called\n", __func__);
 	return 0;
 }
 
@@ -177,7 +177,7 @@ static void hal_set_current_channel_ex(struct hw_data *pHwData, struct chan_info
 	if (pHwData->SurpriseRemove)
 		return;
 
-	printk("Going to channel: %d/%d\n", channel.band, channel.ChanNo);
+	pr_debug("Going to channel: %d/%d\n", channel.band, channel.ChanNo);
 
 	RFSynthesizer_SwitchingChannel(pHwData, channel); /* Switch channel */
 	pHwData->Channel = channel.ChanNo;
@@ -262,7 +262,7 @@ static int wbsoft_config(struct ieee80211_hw *dev, u32 changed)
 	struct wbsoft_priv *priv = dev->priv;
 	struct chan_info ch;
 
-	printk("wbsoft_config called\n");
+	pr_debug("wbsoft_config called\n");
 
 	/* Should use channel_num, or something, as that is already pre-translated */
 	ch.band = 1;
@@ -280,7 +280,7 @@ static int wbsoft_config(struct ieee80211_hw *dev, u32 changed)
 
 static u64 wbsoft_get_tsf(struct ieee80211_hw *dev, struct ieee80211_vif *vif)
 {
-	printk("wbsoft_get_tsf called\n");
+	pr_debug("wbsoft_get_tsf called\n");
 	return 0;
 }
 
@@ -781,7 +781,7 @@ static int wb35_probe(struct usb_interface *intf,
 	endpoint = &interface->endpoint[0].desc;
 
 	if (endpoint[2].wMaxPacketSize == 512)
-		printk("[w35und] Working on USB 2.0\n");
+		pr_debug("[w35und] Working on USB 2.0\n");
 
 	err = wb35_hw_init(dev);
 	if (err)
-- 
1.7.7.3

