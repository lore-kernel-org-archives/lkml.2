Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178Ab0JBQjj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 12:39:39 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41672 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932507Ab0JBQia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 12:38:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=YE3/X3wb/XAslIN21p8jj9cDlHleTJ+1B+vqqTSU73UCzK1w9RzgEFbI6b1yn56oKW
         4NR6phM5Z5rhhJ90p7gI53Ohftkd4PsDURVaTBXBfa859kpbrDGU1pubpsd6t8+ISAl4
         SENm8+qawCpnB9V1szHVU+f7xR45sHms1YyYA=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        sam@ravnborg.org, Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH v3 16/20] Staging: usbip: Makefile: cleaned up Makefile cflag lines
Date: Sat,  2 Oct 2010 12:38:05 -0400
Message-Id: <1286037489-28439-16-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1286037489-28439-1-git-send-email-tdent48227@gmail.com>
References: <1286037489-28439-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed to use the proper ccflags-y option

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/usbip/Makefile |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/usbip/Makefile b/drivers/staging/usbip/Makefile
index 6f2916b..10307f8 100644
--- a/drivers/staging/usbip/Makefile
+++ b/drivers/staging/usbip/Makefile
@@ -7,6 +7,5 @@ vhci-hcd-objs := vhci_sysfs.o vhci_tx.o vhci_rx.o vhci_hcd.o
 obj-$(CONFIG_USB_IP_HOST) += usbip.o
 usbip-objs := stub_dev.o stub_main.o stub_rx.o stub_tx.o
 
-ifeq ($(CONFIG_USB_IP_DEBUG_ENABLE),y)
-	EXTRA_CFLAGS += -DDEBUG
-endif
+ccflags-$(CONFIG_USB_IP_DEBUG_ENABLE) := -DDEBUG
+
-- 
1.7.3.1.50.g1e633

