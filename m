Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932248Ab0FULBc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 07:01:32 -0400
Received: from lider.pardus.org.tr ([193.140.100.216]:41496 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932185Ab0FULBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 07:01:31 -0400
From: =?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>
To: linux-kernel@vger.kernel.org
Cc: gregkh@suse.de
Subject: [PATCH] rt2870: add device id for Zyxel NWD-270N
Date: Mon, 21 Jun 2010 14:00:56 +0300
Message-Id: <1277118056-21367-1-git-send-email-ozan@pardus.org.tr>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device id for Zyxel NWD-270N USB dongle.

Signed-off-by: Ozan Çağlayan <ozan@pardus.org.tr>
---
 drivers/staging/rt2860/usb_main_dev.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/rt2860/usb_main_dev.c b/drivers/staging/rt2860/usb_main_dev.c
index b740662..674769d 100644
--- a/drivers/staging/rt2860/usb_main_dev.c
+++ b/drivers/staging/rt2860/usb_main_dev.c
@@ -77,6 +77,7 @@ struct usb_device_id rtusb_usb_id[] = {
 	{USB_DEVICE(0x083A, 0x7522)},	/* Arcadyan */
 	{USB_DEVICE(0x0CDE, 0x0022)},	/* ZCOM */
 	{USB_DEVICE(0x0586, 0x3416)},	/* Zyxel */
+	{USB_DEVICE(0x0586, 0x341a)},	/* Zyxel NWD-270N */
 	{USB_DEVICE(0x0CDE, 0x0025)},	/* Zyxel */
 	{USB_DEVICE(0x1740, 0x9701)},	/* EnGenius */
 	{USB_DEVICE(0x1740, 0x9702)},	/* EnGenius */
-- 
1.7.1

