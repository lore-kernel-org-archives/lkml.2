Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756973Ab1FFNHy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 09:07:54 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:60020 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756802Ab1FFNHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 09:07:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=akshayjoshi.com; s=google;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Z1XbLOIxOpY9EAOn4x8kcpqmp2Hz/smzDC4AaMndCW8qRz04zxFAXX5nd5gxeui9f/
         DMa0i1ntsg8a4WWaWY9z7FIU5RKIxQMqLL5MssZQfhk0r53IRz1mOh4wGC/GhqRSQT/v
         6bc0G/ZBUT2SHhF64O7EpOCtp5ZzjPFLsTx6I=
From: Akshay Joshi <me@akshayjoshi.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Akshay Joshi <me@akshayjoshi.com>
Subject: [PATCH] USBIP: Remove unnecessary whitespace before newline characters.
Date: Mon,  6 Jun 2011 09:07:31 -0400
Message-Id: <1307365651-13715-1-git-send-email-me@akshayjoshi.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In this file, in certain places, newline characters in pr_debug() calls had
whitespace before them. This patch removes this extraneous whitespace.

Signed-off-by: Akshay Joshi <me@akshayjoshi.com>
---
 drivers/staging/usbip/usbip_common.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/usbip/usbip_common.c b/drivers/staging/usbip/usbip_common.c
index 433a3b6..7182700 100644
--- a/drivers/staging/usbip/usbip_common.c
+++ b/drivers/staging/usbip/usbip_common.c
@@ -204,7 +204,7 @@ static void usbip_dump_usb_ctrlrequest(struct usb_ctrlrequest *cmd)
 			pr_debug("CLEAR_FEAT\n");
 			break;
 		case USB_REQ_SET_FEATURE:
-			pr_debug("SET_FEAT  \n");
+			pr_debug("SET_FEAT\n");
 			break;
 		case USB_REQ_SET_ADDRESS:
 			pr_debug("SET_ADDRRS\n");
@@ -231,14 +231,14 @@ static void usbip_dump_usb_ctrlrequest(struct usb_ctrlrequest *cmd)
 			pr_debug("SYNC_FRAME\n");
 			break;
 		default:
-			pr_debug("REQ(%02X) \n", cmd->bRequest);
+			pr_debug("REQ(%02X)\n", cmd->bRequest);
 			break;
 		}
 		usbip_dump_request_type(cmd->bRequestType);
 	} else if ((cmd->bRequestType & USB_TYPE_MASK) == USB_TYPE_CLASS) {
-		pr_debug("CLASS   \n");
+		pr_debug("CLASS\n");
 	} else if ((cmd->bRequestType & USB_TYPE_MASK) == USB_TYPE_VENDOR) {
-		pr_debug("VENDOR  \n");
+		pr_debug("VENDOR\n");
 	} else if ((cmd->bRequestType & USB_TYPE_MASK) == USB_TYPE_RESERVED) {
 		pr_debug("RESERVED\n");
 	}
-- 
1.7.4.4

