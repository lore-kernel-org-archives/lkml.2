Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933739Ab0KOUOe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 15:14:34 -0500
Received: from mail.perches.com ([173.55.12.10]:1337 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933633Ab0KOUON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 15:14:13 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 10/11] drivers/usb/host/uhci-hcd.c: Remove unnecessary casts of pci_get_drvdata
Date: Mon, 15 Nov 2010 12:14:01 -0800
Message-Id: <1a734720c779c15cc09e1fb5e757f24c96196ca7.1289851770.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1289851770.git.joe@perches.com>
References: <cover.1289851770.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/usb/host/uhci-hcd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/host/uhci-hcd.c b/drivers/usb/host/uhci-hcd.c
index f52d04d..cee8678 100644
--- a/drivers/usb/host/uhci-hcd.c
+++ b/drivers/usb/host/uhci-hcd.c
@@ -569,7 +569,7 @@ static int uhci_init(struct usb_hcd *hcd)
  */
 static void uhci_shutdown(struct pci_dev *pdev)
 {
-	struct usb_hcd *hcd = (struct usb_hcd *) pci_get_drvdata(pdev);
+	struct usb_hcd *hcd = pci_get_drvdata(pdev);
 
 	uhci_hc_died(hcd_to_uhci(hcd));
 }
-- 
1.7.3.1.g432b3.dirty

