Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759780Ab0FQKiN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 06:38:13 -0400
Received: from lider.pardus.org.tr ([193.140.100.216]:48192 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759754Ab0FQKiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 06:38:11 -0400
From: =?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>
To: linux-kernel@vger.kernel.org
Cc: linux-wireless@vger.kernel.org, flamingice@sourmilk.net
Subject: [PATCH] p54usb: Drop duplicate USBID 0xcde:0x0006
Date: Thu, 17 Jun 2010 13:37:29 +0300
Message-Id: <1276771049-2187-1-git-send-email-ozan@pardus.org.tr>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drop the duplicate USB ID 0xcde:0x0006 which is written at two
different places in p54usb.c

Signed-off-by: Ozan Çağlayan <ozan@pardus.org.tr>
---
 drivers/net/wireless/p54/p54usb.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
index 7307325..d6d8713 100644
--- a/drivers/net/wireless/p54/p54usb.c
+++ b/drivers/net/wireless/p54/p54usb.c
@@ -69,7 +69,6 @@ static struct usb_device_id p54u_table[] __devinitdata = {
 	{USB_DEVICE(0x0915, 0x2002)},	/* Cohiba Proto board */
 	{USB_DEVICE(0x0baf, 0x0118)},   /* U.S. Robotics U5 802.11g Adapter*/
 	{USB_DEVICE(0x0bf8, 0x1009)},   /* FUJITSU E-5400 USB D1700*/
-	{USB_DEVICE(0x0cde, 0x0006)},   /* Medion MD40900 */
 	{USB_DEVICE(0x0cde, 0x0008)},	/* Sagem XG703A */
 	{USB_DEVICE(0x0cde, 0x0015)},	/* Zcomax XG-705A */
 	{USB_DEVICE(0x0d8e, 0x3762)},	/* DLink DWL-G120 Cohiba */
-- 
1.7.1

