Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053Ab2AMMmy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 07:42:54 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:50702 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910Ab2AMMmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 07:42:53 -0500
From: giorgos kyprianidis <elapoueis@gmail.com>
To: balbi@ti.com
Cc: linux-kernel@vger.kernel.org, p3100225@dias.aueb.gr
Subject: [PATCH] drivers:usb:gadget:f_audio.c fixed a 'space before tab' warning
Date: Fri, 13 Jan 2012 14:42:44 +0200
Message-Id: <1326458564-25533-1-git-send-email-p3100225@dias.aueb.gr>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <n>
References: <n>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: bstrds <p3100225@dias.aueb.gr>

---
 drivers/usb/gadget/f_audio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/gadget/f_audio.c b/drivers/usb/gadget/f_audio.c
index ec7ffcd..9e654a7 100644
--- a/drivers/usb/gadget/f_audio.c
+++ b/drivers/usb/gadget/f_audio.c
@@ -192,7 +192,7 @@ static struct uac_iso_endpoint_descriptor as_iso_out_desc __initdata = {
 	.bLength =		UAC_ISO_ENDPOINT_DESC_SIZE,
 	.bDescriptorType =	USB_DT_CS_ENDPOINT,
 	.bDescriptorSubtype =	UAC_EP_GENERAL,
-	.bmAttributes = 	1,
+	.bmAttributes =		1,
 	.bLockDelayUnits =	1,
 	.wLockDelay =		__constant_cpu_to_le16(1),
 };
-- 
1.7.8.3

