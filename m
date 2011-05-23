Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342Ab1EWGn1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 02:43:27 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:4188 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264Ab1EWGnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 02:43:25 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6354"; a="92929417"
From: Tatyana Brokhman <tlinder@codeaurora.org>
To: greg@kroah.com
Cc: linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org, balbi@ti.com,
        ablay@codeaurora.org, Tatyana Brokhman <tlinder@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v12 8/8] usb:gadget: coding style fixes
Date: Mon, 23 May 2011 09:41:17 +0300
Message-Id: <1306132882-9668-9-git-send-email-tlinder@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1306132882-9668-1-git-send-email-tlinder@codeaurora.org>
References: <1306132882-9668-1-git-send-email-tlinder@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>

---
 drivers/usb/gadget/composite.c |   20 +++++++++++----
 drivers/usb/gadget/dummy_hcd.c |   52 ++++++++++++++++++++++++++++++----------
 2 files changed, 54 insertions(+), 18 deletions(-)

diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
index 7738302..bee33d2 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -629,11 +629,21 @@ static int set_config(struct usb_composite_dev *cdev,
 	INFO(cdev, "%s speed config #%d: %s\n",
 		({ char *speed;
 		switch (gadget->speed) {
-		case USB_SPEED_LOW:	speed = "low"; break;
-		case USB_SPEED_FULL:	speed = "full"; break;
-		case USB_SPEED_HIGH:	speed = "high"; break;
-		case USB_SPEED_SUPER:	speed = "super"; break;
-		default:		speed = "?"; break;
+		case USB_SPEED_LOW:
+			speed = "low";
+			break;
+		case USB_SPEED_FULL:
+			speed = "full";
+			break;
+		case USB_SPEED_HIGH:
+			speed = "high";
+			break;
+		case USB_SPEED_SUPER:
+			speed = "super";
+			break;
+		default:
+			speed = "?";
+			break;
 		} ; speed; }), number, c ? c->label : "unconfigured");
 
 	if (!c)
diff --git a/drivers/usb/gadget/dummy_hcd.c b/drivers/usb/gadget/dummy_hcd.c
index c2731d3..abfafd6 100644
--- a/drivers/usb/gadget/dummy_hcd.c
+++ b/drivers/usb/gadget/dummy_hcd.c
@@ -546,10 +546,18 @@ dummy_enable (struct usb_ep *_ep, const struct usb_endpoint_descriptor *desc)
 		(desc->bEndpointAddress & USB_DIR_IN) ? "in" : "out",
 		({ char *val;
 		 switch (desc->bmAttributes & 0x03) {
-		 case USB_ENDPOINT_XFER_BULK: val = "bulk"; break;
-		 case USB_ENDPOINT_XFER_ISOC: val = "iso"; break;
-		 case USB_ENDPOINT_XFER_INT: val = "intr"; break;
-		 default: val = "ctrl"; break;
+		 case USB_ENDPOINT_XFER_BULK:
+			 val = "bulk";
+			 break;
+		 case USB_ENDPOINT_XFER_ISOC:
+			 val = "iso";
+			 break;
+		 case USB_ENDPOINT_XFER_INT:
+			 val = "intr";
+			 break;
+		 default:
+			 val = "ctrl";
+			 break;
 		 }; val; }),
 		max);
 
@@ -2151,19 +2159,37 @@ show_urb (char *buf, size_t size, struct urb *urb)
 		urb,
 		({ char *s;
 		 switch (urb->dev->speed) {
-		 case USB_SPEED_LOW:	s = "ls"; break;
-		 case USB_SPEED_FULL:	s = "fs"; break;
-		 case USB_SPEED_HIGH:	s = "hs"; break;
-		 case USB_SPEED_SUPER:	s = "ss"; break;
-		 default:		s = "?"; break;
+		 case USB_SPEED_LOW:
+			s = "ls";
+			break;
+		 case USB_SPEED_FULL:
+			s = "fs";
+			break;
+		 case USB_SPEED_HIGH:
+			s = "hs";
+			break;
+		 case USB_SPEED_SUPER:
+			s = "ss";
+			break;
+		 default:
+			s = "?";
+			break;
 		 }; s; }),
 		ep, ep ? (usb_pipein (urb->pipe) ? "in" : "out") : "",
 		({ char *s; \
 		 switch (usb_pipetype (urb->pipe)) { \
-		 case PIPE_CONTROL:	s = ""; break; \
-		 case PIPE_BULK:	s = "-bulk"; break; \
-		 case PIPE_INTERRUPT:	s = "-int"; break; \
-		 default: 		s = "-iso"; break; \
+		 case PIPE_CONTROL: \
+			s = ""; \
+			break; \
+		 case PIPE_BULK: \
+			s = "-bulk"; \
+			break; \
+		 case PIPE_INTERRUPT: \
+			s = "-int"; \
+			break; \
+		 default: \
+			s = "-iso"; \
+			break; \
 		}; s;}),
 		urb->actual_length, urb->transfer_buffer_length);
 }
-- 
1.7.3.3

--
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
