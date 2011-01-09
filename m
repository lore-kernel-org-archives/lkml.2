Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025Ab1AIXDu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 18:03:50 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:55200 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976Ab1AIXDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 18:03:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Sae3c9W5xYNGKwhTqAspRu2lRlYGDDjS5lDTrSFYmeGhAfmEJj4zPdIuO4Ma98nMVX
         Lee2na//WKvLQCgwzBXk9N91sMd8+Wsyd2NrBI8zE7PDpOwD7OnN2EB8/IDw1n2yqNyP
         qvmVLJoCBV6/1duRyiAob9VTfNc5cmiKUwAmU=
From: ahern.michael.t@gmail.com
To: gregkh@suse.de, u.kleine-koenig@pengutronix.de, julia@diku.dk,
        nikai@nikai.net, morgan.gatti@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        mah <ahern.michael.t@gmail.com>
Subject: [PATCH 2/5] Staging: comedi: whitespace
Date: Mon, 10 Jan 2011 10:03:13 +1100
Message-Id: <1294614196-6665-2-git-send-email-ahern.michael.t@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1294614196-6665-1-git-send-email-ahern.michael.t@gmail.com>
References: <1294614196-6665-1-git-send-email-ahern.michael.t@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: mah <ahern.michael.t@gmail.com>

whitespace warning found by checkpatch.pl tool

Signed-off-by: Michael Ahern <ahern.michael.t@gmail.com>
---
 drivers/staging/comedi/drivers/usbdux.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/usbdux.c b/drivers/staging/comedi/drivers/usbdux.c
index de784ff..60b2159 100644
--- a/drivers/staging/comedi/drivers/usbdux.c
+++ b/drivers/staging/comedi/drivers/usbdux.c
@@ -2447,7 +2447,7 @@ static int usbduxsub_probe(struct usb_interface *uinterf,
 		usbduxsub[index].numOfInBuffers = NUMOFINBUFFERSFULL;
 
 	usbduxsub[index].urbIn =
-	    kzalloc(sizeof(struct urb *) * usbduxsub[index].numOfInBuffers,
+	    kzalloc(sizeof(struct urb *) *usbduxsub[index].numOfInBuffers,
 		    GFP_KERNEL);
 	if (!(usbduxsub[index].urbIn)) {
 		dev_err(dev, "comedi_: usbdux: Could not alloc. urbIn array\n");
@@ -2495,7 +2495,7 @@ static int usbduxsub_probe(struct usb_interface *uinterf,
 		usbduxsub[index].numOfOutBuffers = NUMOFOUTBUFFERSFULL;
 
 	usbduxsub[index].urbOut =
-	    kzalloc(sizeof(struct urb *) * usbduxsub[index].numOfOutBuffers,
+	    kzalloc(sizeof(struct urb *) *usbduxsub[index].numOfOutBuffers,
 		    GFP_KERNEL);
 	if (!(usbduxsub[index].urbOut)) {
 		dev_err(dev, "comedi_: usbdux: "
-- 
1.7.0.4

