Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934467Ab0HFKMy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 06:12:54 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43943 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933047Ab0HFKMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 06:12:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=QKPogXz36Fq3Fz8zHBvKTFdAqJnLtnfolIPnZPZKd/jvv455ezp0BUZ34n2xF5nkkH
         tXPjIiPiH6+HzMRn8Ot7iNbzt5Rw6zQbp6uP//g1aOaqiyB/8ZHV/993jS7sM5mWLIfp
         Zp2tWm3VH6UwMSD6G0LgvZxpakzQJFA1qdXpU=
From: Neil Munro <neilmunro@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Niadh <neilmunro@gmail.com>
Subject: [PATCH 983/983] Staging: RT2860: Fixed both errors in eeprom.h
Date: Fri,  6 Aug 2010 11:18:38 +0100
Message-Id: <1281089918-3154-1-git-send-email-neilmunro@gmail.com>
X-Mailer: git-send-email 1.7.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Niadh <neilmunro@gmail.com>

Fixed two errors in the form of pointer style issues in eeprom.h.

Signed-off-by: Neil Munro <neilmunro@gmail.com>
---
 drivers/staging/rt2860/eeprom.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rt2860/eeprom.h b/drivers/staging/rt2860/eeprom.h
index 039801a..72c8fb9 100644
--- a/drivers/staging/rt2860/eeprom.h
+++ b/drivers/staging/rt2860/eeprom.h
@@ -42,7 +42,7 @@
   *	Public function declarations for prom-based chipset
   ************************************************************************/
 int rtmp_ee_prom_read16(struct rt_rtmp_adapter *pAd,
-			u16 Offset, u16 * pValue);
+			u16 Offset, u16 *pValue);
 #endif /* RTMP_PCI_SUPPORT // */
 #ifdef RTMP_USB_SUPPORT
 /*************************************************************************
@@ -55,7 +55,7 @@ int RTUSBReadEEPROM16(struct rt_rtmp_adapter *pAd,
 #ifdef RT30xx
 #ifdef RTMP_EFUSE_SUPPORT
 int rtmp_ee_efuse_read16(struct rt_rtmp_adapter *pAd,
-			 u16 Offset, u16 * pValue);
+			 u16 Offset, u16 *pValue);
 #endif /* RTMP_EFUSE_SUPPORT // */
 #endif /* RT30xx // */

--
1.7.2.1

