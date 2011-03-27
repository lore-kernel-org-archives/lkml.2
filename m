Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481Ab1C0Nm6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 09:42:58 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:60626 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408Ab1C0Nm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 09:42:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=MVmBKidpdDLSiPVS99rFa7X/ZODyr/Q+nzK7zbh1RBwXv36Rsr1Tkloqm9YQ1N9lil
         2HWzRixXrmg7Y8Qdn9CJvF1gQFRnkvO07KIHusoOSazpA74SnAZM6Qg4EeLbYn1L6rbj
         VBzKnC5KmkNLnxAu+iYAdEa+ebpDBuwKAWfYg=
From: wanlong.gao@gmail.com
To: greg@kroah.com, harryxiyou@gmail.com
Cc: linux-kernel@vger.kernel.org, Wanlong Gao <wanlong.gao@gmail.com>
Subject: [PATCH] Fixed the format: lines over 80 characters .
Date: Sun, 27 Mar 2011 11:07:24 +0800
Message-Id: <1301195244-4606-1-git-send-email-wanlong.gao@gmail.com>
X-Mailer: git-send-email 1.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanlong Gao <wanlong.gao@gmail.com>

    Lines over 80 characters
        FILE: janz-cmodio.c:273

Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
---
 drivers/mfd/janz-cmodio.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/janz-cmodio.c b/drivers/mfd/janz-cmodio.c
index 36a166b..fb29d23 100644
--- a/drivers/mfd/janz-cmodio.c
+++ b/drivers/mfd/janz-cmodio.c
@@ -270,8 +270,10 @@ static void __devexit cmodio_pci_remove(struct pci_dev *dev)
 
 /* The list of devices that this module will support */
 static DEFINE_PCI_DEVICE_TABLE(cmodio_pci_ids) = {
-	{ PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_9030, PCI_VENDOR_ID_JANZ, 0x0101 },
-	{ PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_9050, PCI_VENDOR_ID_JANZ, 0x0100 },
+	{ PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_9030,
+			PCI_VENDOR_ID_JANZ, 0x0101 },
+	{ PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_9050,
+			PCI_VENDOR_ID_JANZ, 0x0100 },
 	{ 0, }
 };
 MODULE_DEVICE_TABLE(pci, cmodio_pci_ids);
-- 
1.7.3

