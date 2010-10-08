Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741Ab0JHACv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 20:02:51 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59236 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756693Ab0JHACs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 20:02:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=vgD9HvBA2iM/9W2dL/EOcFqDS5jB3ZHXf2iM6Tr9SfZ6CPGHiTvasJZ0AdzzgZgQOm
         Q+uymVr08S1rSNBZf/GzsKu+oXSTwHkcGsEi0RhZ31z5CtV//ULOwrj/W/PVdbEu+d4W
         WZTs1HtHJT2VBLBjvMUZ9p9iURDpUKwYeo4T4=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        sam@ravnborg.org, linux-kbuild@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 29/33] Staging: usbip: Makefile: replace the use of <module>-objs with <module>-y
Date: Thu,  7 Oct 2010 20:01:49 -0400
Message-Id: <1286496113-11897-29-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1286496113-11897-1-git-send-email-tdent48227@gmail.com>
References: <1286496113-11897-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed <module>-objs to <module>-y in Makefile.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/usbip/Makefile |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/usbip/Makefile b/drivers/staging/usbip/Makefile
index 10307f8..279f3cc 100644
--- a/drivers/staging/usbip/Makefile
+++ b/drivers/staging/usbip/Makefile
@@ -1,11 +1,11 @@
 obj-$(CONFIG_USB_IP_COMMON) += usbip_common_mod.o
-usbip_common_mod-objs := usbip_common.o usbip_event.o
+usbip_common_mod-y := usbip_common.o usbip_event.o
 
 obj-$(CONFIG_USB_IP_VHCI_HCD) += vhci-hcd.o
-vhci-hcd-objs := vhci_sysfs.o vhci_tx.o vhci_rx.o vhci_hcd.o
+vhci-hcd-y := vhci_sysfs.o vhci_tx.o vhci_rx.o vhci_hcd.o
 
 obj-$(CONFIG_USB_IP_HOST) += usbip.o
-usbip-objs := stub_dev.o stub_main.o stub_rx.o stub_tx.o
+usbip-y := stub_dev.o stub_main.o stub_rx.o stub_tx.o
 
 ccflags-$(CONFIG_USB_IP_DEBUG_ENABLE) := -DDEBUG
 
-- 
1.7.3.1.50.g1e633

