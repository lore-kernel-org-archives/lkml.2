Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832Ab0DYNUu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 09:20:50 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:39329 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475Ab0DYNUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 09:20:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=D1k33LcgIEBq4oJ8OS2YzHpVCAfuPn3US51yTu/sNInx2nxMXtb2h4c3P10SfipPwK
         0zseiBCw5VSKlJSxr8fs5PauZM7612YVLcmyl5GpFJV9E6vTsDpNQ2gsPc0swtnQd4du
         2O/3n5IIE3r8fdwIYVTSJk5GzK4PhDQjggP/M=
From: Roel Van Nyen <roel.vannyen@gmail.com>
To: gregkh@suse.de
Cc: bzolnier@gmail.com, Larry.Finger@lwfinger.net,
       bernhard@schiffner-limbach.de, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org, Roel Van Nyen <roel.vannyen@gmail.com>
Subject: [PATCH] Staging: rtl8187se: fix coding style errors of r8180_rtl8225z2.c
Date: Sun, 25 Apr 2010 15:18:26 +0200
Message-Id: <1272201506-3232-1-git-send-email-roel.vannyen@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roel Van Nyen <roel@roel-laptop.(none)>

Fix coding style errors

Signed-off-by: Roel Van Nyen <roel.vannyen@gmail.com>
---
 drivers/staging/rtl8187se/r8180_rtl8225z2.c |   58 ++++++++++++++-------------
 1 files changed, 30 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8180_rtl8225z2.c b/drivers/staging/rtl8187se/r8180_rtl8225z2.c
index 6edf5a4..9c38b3a 100644
--- a/drivers/staging/rtl8187se/r8180_rtl8225z2.c
+++ b/drivers/staging/rtl8187se/r8180_rtl8225z2.c
@@ -225,7 +225,7 @@ static void rtl8225_SetTXPowerLevel(struct net_device *dev, short ch)
 }
 
 static const u8 rtl8225z2_threshold[] = {
-        0x8d, 0x8d, 0x8d, 0x8d, 0x9d, 0xad, 0xbd,
+	0x8d, 0x8d, 0x8d, 0x8d, 0x9d, 0xad, 0xbd,
 };
 
 static const u8 rtl8225z2_gain_bg[] = {
@@ -307,7 +307,7 @@ static u32 read_rtl8225(struct net_device *dev, u8 adr)
 	u32 data2Write = ((u32)(adr & 0x1f)) << 27;
 	u32 dataRead;
 	u32 mask;
-	u16 oval,oval2,oval3,tmp;
+	u16 oval, oval2, oval3, tmp;
 	int i;
 	short bit, rw;
 	u8 wLength = 6;
@@ -325,9 +325,9 @@ static u32 read_rtl8225(struct net_device *dev, u8 adr)
 
 	oval &= ~0xf;
 
-	write_nic_word(dev, RFPinsOutput, oval | BB_HOST_BANG_EN ); udelay(4);
+	write_nic_word(dev, RFPinsOutput, oval | BB_HOST_BANG_EN); udelay(4);
 
-	write_nic_word(dev, RFPinsOutput, oval ); udelay(5);
+	write_nic_word(dev, RFPinsOutput, oval); udelay(5);
 
 	rw = 0;
 
@@ -340,7 +340,7 @@ static u32 read_rtl8225(struct net_device *dev, u8 adr)
 		write_nic_word(dev, RFPinsOutput, bit|oval | BB_HOST_BANG_CLK | rw); udelay(2);
 		write_nic_word(dev, RFPinsOutput, bit|oval | BB_HOST_BANG_CLK | rw); udelay(2);
 
-		mask = (low2high) ? (mask<<1): (mask>>1);
+		mask = (low2high) ? (mask<<1) : (mask>>1);
 
 		if (i == 2) {
 			rw = BB_HOST_BANG_RW;
@@ -349,12 +349,12 @@ static u32 read_rtl8225(struct net_device *dev, u8 adr)
 			break;
 		}
 
-		bit = ((data2Write&mask) != 0) ? 1: 0;
+		bit = ((data2Write&mask) != 0) ? 1 : 0;
 
-		write_nic_word(dev, RFPinsOutput, oval|bit|rw| BB_HOST_BANG_CLK); udelay(2);
-		write_nic_word(dev, RFPinsOutput, oval|bit|rw| BB_HOST_BANG_CLK); udelay(2);
+		write_nic_word(dev, RFPinsOutput, oval | bit | rw | BB_HOST_BANG_CLK); udelay(2);
+		write_nic_word(dev, RFPinsOutput, oval | bit | rw | BB_HOST_BANG_CLK); udelay(2);
 
-		write_nic_word(dev, RFPinsOutput, oval| bit |rw); udelay(1);
+		write_nic_word(dev, RFPinsOutput, oval | bit | rw); udelay(1);
 
 		mask = (low2high) ? (mask<<1) : (mask>>1);
 	}
@@ -426,7 +426,7 @@ void rtl8225z2_rf_close(struct net_device *dev)
 s8 DbmToTxPwrIdx(struct r8180_priv *priv, WIRELESS_MODE WirelessMode,
 		 s32 PowerInDbm)
 {
- 	bool bUseDefault = true;
+	bool bUseDefault = true;
 	s8 TxPwrIdx = 0;
 
 	/*
@@ -524,7 +524,7 @@ void rtl8225z2_SetTXPowerLevel(struct net_device *dev, short ch)
 	if (ofdm_power_level <= 11) {
 		write_phy_ofdm(dev, 0x07, 0x5c);
 		write_phy_ofdm(dev, 0x09, 0x5c);
-        }
+	}
 
 	if (ofdm_power_level <= 17) {
 		write_phy_ofdm(dev, 0x07, 0x54);
@@ -610,10 +610,10 @@ static void rtl8225_rf_set_chan(struct net_device *dev, short ch)
 void rtl8225z2_rf_init(struct net_device *dev)
 {
 	struct r8180_priv *priv = ieee80211_priv(dev);
-	int i;
-	short channel = 1;
+	int	i;
+	short	channel = 1;
 	u16	brsr;
-	u32	data,addr;
+	u32	data, addr;
 
 	priv->chan = channel;
 
@@ -740,7 +740,7 @@ void rtl8225z2_rf_init(struct net_device *dev)
 	write_phy_ofdm(dev, 0x26, 0x90); mdelay(1);
 	write_phy_ofdm(dev, 0x27, 0x88); mdelay(1);
 
-	rtl8225z2_set_gain(dev,4);
+	rtl8225z2_set_gain(dev, 4);
 
 	write_phy_cck(dev, 0x0, 0x98); mdelay(1);
 	write_phy_cck(dev, 0x3, 0x20); mdelay(1);
@@ -803,12 +803,12 @@ void rtl8225z2_rf_set_mode(struct net_device *dev)
 		write_phy_ofdm(dev, 0xf, 0x20);
 		write_phy_ofdm(dev, 0x11, 0x7);
 
-		rtl8225z2_set_gain(dev,4);
+		rtl8225z2_set_gain(dev, 4);
 
-		write_phy_ofdm(dev,0x15, 0x40);
-		write_phy_ofdm(dev,0x17, 0x40);
+		write_phy_ofdm(dev, 0x15, 0x40);
+		write_phy_ofdm(dev, 0x17, 0x40);
 
-		write_nic_dword(dev, 0x94,0x10000000);
+		write_nic_dword(dev, 0x94, 0x10000000);
 	} else {
 		write_rtl8225(dev, 0x5, 0x1864);
 		write_nic_dword(dev, RF_PARA, 0x10044);
@@ -819,18 +819,18 @@ void rtl8225z2_rf_set_mode(struct net_device *dev)
 		write_phy_ofdm(dev, 0xf, 0x20);
 		write_phy_ofdm(dev, 0x11, 0x7);
 
-		rtl8225z2_set_gain(dev,4);
+		rtl8225z2_set_gain(dev, 4);
 
-		write_phy_ofdm(dev,0x15, 0x40);
-		write_phy_ofdm(dev,0x17, 0x40);
+		write_phy_ofdm(dev, 0x15, 0x40);
+		write_phy_ofdm(dev, 0x17, 0x40);
 
-		write_nic_dword(dev, 0x94,0x04000002);
+		write_nic_dword(dev, 0x94, 0x04000002);
 	}
 }
 
-#define MAX_DOZE_WAITING_TIMES_85B 		20
-#define MAX_POLLING_24F_TIMES_87SE 		10
-#define LPS_MAX_SLEEP_WAITING_TIMES_87SE 	5
+#define MAX_DOZE_WAITING_TIMES_85B		20
+#define MAX_POLLING_24F_TIMES_87SE		10
+#define LPS_MAX_SLEEP_WAITING_TIMES_87SE	5
 
 bool SetZebraRFPowerState8185(struct net_device *dev,
 			      RT_RF_POWER_STATE eRFPowerState)
@@ -935,7 +935,8 @@ bool SetZebraRFPowerState8185(struct net_device *dev,
 			if (bTurnOffBB) {
 				/* turn off BB */
 				u1bTmp = read_nic_byte(dev, 0x24E);
-				write_nic_byte(dev, 0x24E, (u1bTmp | BIT5 | BIT6));
+				write_nic_byte(dev, 0x24E,
+						(u1bTmp | BIT5 | BIT6));
 
 				/* turn off AFE PLL */
 				write_nic_byte(dev, 0x54, 0xFC);
@@ -945,7 +946,8 @@ bool SetZebraRFPowerState8185(struct net_device *dev,
 		break;
 	case eRfOff:
 		for (QueueID = 0, i = 0; QueueID < 6;) {
-			if (get_curr_tx_free_desc(dev, QueueID) == priv->txringcount) {
+			if (get_curr_tx_free_desc(dev, QueueID) ==
+							priv->txringcount) {
 				QueueID++;
 				continue;
 			} else {
-- 
1.6.3.3

