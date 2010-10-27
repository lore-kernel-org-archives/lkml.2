Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760284Ab0J0IRJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 04:17:09 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36575 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751Ab0J0IRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 04:17:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=gpEZHldDjOMcPxC0iKI28H6ykVguflewn7FiwrlMoYLIiXvFObFvE893WkGxGmVFBA
         L+NXROVQlCGCovoNz4iXIJdpAkUx4lVYoqi+PJszFuWefN+YjIfpP+0FKJYSDbppKAQh
         KOrvcN6jM6wY9xQw6Mw6AApmTuDf0JFGO6BZE=
From: Marek Belisko <marek.belisko@gmail.com>
To: David Brownell <dbrownell@users.sourceforge.net>
Cc: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@gmail.com>
Subject: [PATCH] USB: gadget: composite: Typo fix.
Date: Wed, 27 Oct 2010 10:19:01 +0200
Message-Id: <1288167541-12786-1-git-send-email-marek.belisko@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@gmail.com>
---
 drivers/usb/gadget/composite.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
index 7b5cc16..d3493fe 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -1126,7 +1126,7 @@ static int composite_bind(struct usb_gadget *gadget)
 	cdev->desc = *composite->dev;
 	cdev->desc.bMaxPacketSize0 = gadget->ep0->maxpacket;
 
-	/* stirng overrides */
+	/* string overrides */
 	if (iManufacturer || !cdev->desc.iManufacturer) {
 		if (!iManufacturer && !composite->iManufacturer &&
 		    !*composite_manufacturer)
-- 
1.7.1

