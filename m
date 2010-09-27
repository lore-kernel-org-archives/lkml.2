Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932628Ab0I0Cf6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 22:35:58 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:40215 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758772Ab0I0Cfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 22:35:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=Xdu1Asxz8rj/hu4QjJFFPOttGb7ehXAH4Kso/FYInLDc68lLjX6NjM2TyGFfcYEJxg
         mmcfPr2yDdq5kxwzkbqEqxCnJ+NhXnp0J/AL9TcxS4G5gpGEyE/STR4kUze7ORraIXLs
         dfP3C0iPJFU0aXSRd6oFV42bEWqq8eG+IjhpA=
From: Otavio Salvador <otavio@ossystems.com.br>
To: linux-kernel@vger.kernel.org
Cc: Otavio Salvador <otavio@ossystems.com.br>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 2/4] USB: cdc-acm: fix code indentation
Date: Sun, 26 Sep 2010 23:35:05 -0300
Message-Id: <1285554907-4495-2-git-send-email-otavio@ossystems.com.br>
X-Mailer: git-send-email 1.7.2.3.313.gcd15
In-Reply-To: <1285554907-4495-1-git-send-email-otavio@ossystems.com.br>
References: <1285554907-4495-1-git-send-email-otavio@ossystems.com.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Otavio Salvador <otavio@ossystems.com.br>
---
 drivers/usb/class/cdc-acm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index bc62fae..d6ede98 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1614,7 +1614,7 @@ static const struct usb_device_id acm_ids[] = {
 	/* Support Lego NXT using pbLua firmware */
 	{ USB_DEVICE(0x0694, 0xff00),
 	.driver_info = NOT_A_MODEM,
-       	},
+	},
 
 	/* control interfaces without any protocol set */
 	{ USB_INTERFACE_INFO(USB_CLASS_COMM, USB_CDC_SUBCLASS_ACM,
-- 
1.7.2.3.313.gcd15

