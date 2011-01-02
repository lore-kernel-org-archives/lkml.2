Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab1ABIGw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 03:06:52 -0500
Received: from mail.windriver.com ([147.11.1.11]:34501 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448Ab1ABHWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:22:07 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Jason Detring <jason.detring@navico.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 048/260] USB: cp210x: Add B&G H3000 link cable ID
Date: Sun,  2 Jan 2011 02:15:44 -0500
Message-Id: <1293952756-15010-49-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:20:58.0351 (UTC) FILETIME=[9A0677F0:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Detring <jason.detring@navico.com>

commit 0bf7a81c5d447c21db434be35363c44c0a30f598 upstream.

This is the cable between an H3000 navigation unit and a multi-function display.
http://www.bandg.com/en/Products/H3000/Spares-and-Accessories/Cables/H3000-CPU-USB-Cable-Pack/

Signed-off-by: Jason Detring <jason.detring@navico.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/serial/cp210x.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index 3521aa6..c39349f 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -90,6 +90,7 @@ static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x10C4, 0x8149) }, /* West Mountain Radio Computerized Battery Analyzer */
 	{ USB_DEVICE(0x10C4, 0x814A) }, /* West Mountain Radio RIGblaster P&P */
 	{ USB_DEVICE(0x10C4, 0x814B) }, /* West Mountain Radio RIGtalk */
+	{ USB_DEVICE(0x10C4, 0x8156) }, /* B&G H3000 link cable */
 	{ USB_DEVICE(0x10C4, 0x815E) }, /* Helicomm IP-Link 1220-DVM */
 	{ USB_DEVICE(0x10C4, 0x818B) }, /* AVIT Research USB to TTL */
 	{ USB_DEVICE(0x10C4, 0x819F) }, /* MJS USB Toslink Switcher */
-- 
1.7.3.3

