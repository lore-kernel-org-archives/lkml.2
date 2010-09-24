Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458Ab0IXSUO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 14:20:14 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51363 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757391Ab0IXSTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 14:19:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=O8D4Z8cB0Y0f/CNbmiU0grbUp+YzpTHFUl8VLEFNt4E8bD8gQfeLE4NgSiYgHnbuRs
         iZIHZeY07+ghtmfNkC206CKlmYm4MoARHOop7sDWZN8FpXk/jHDUXdq0RVHucTzayDxp
         k91H3zF3XN5ZqBgkrVFXfh0vdPke/+cTj8ON8=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 17/21] Staging: usbip: Makefile: cleaned up makefile cflag lines
Date: Fri, 24 Sep 2010 14:18:30 -0400
Message-Id: <1285352314-5939-17-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1285352314-5939-1-git-send-email-tdent48227@gmail.com>
References: <1285352314-5939-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed to use proper ccflags-y option

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/usbip/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/usbip/Makefile b/drivers/staging/usbip/Makefile
index 6f2916b..0627d09 100644
--- a/drivers/staging/usbip/Makefile
+++ b/drivers/staging/usbip/Makefile
@@ -8,5 +8,5 @@ obj-$(CONFIG_USB_IP_HOST) += usbip.o
 usbip-objs := stub_dev.o stub_main.o stub_rx.o stub_tx.o
 
 ifeq ($(CONFIG_USB_IP_DEBUG_ENABLE),y)
-	EXTRA_CFLAGS += -DDEBUG
+	ccflags-y += -DDEBUG
 endif
-- 
1.7.3

