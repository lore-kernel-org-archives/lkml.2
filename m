Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451Ab2GJWiQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 18:38:16 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35489 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753511Ab2GJWiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 18:38:15 -0400
From: Jon Mason <jdmason@kudzu.us>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [trivial PATCH 6/7] dt3155v4l: use PCI_VENDOR_ID_INTEL
Date: Tue, 10 Jul 2012 15:31:31 -0700
Message-Id: <1341959492-31389-6-git-send-email-jdmason@kudzu.us>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1341959492-31389-1-git-send-email-jdmason@kudzu.us>
References: <1341959492-31389-1-git-send-email-jdmason@kudzu.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use PCI_VENDOR_ID_INTEL instead of creating its own vendor ID #define.

Signed-off-by: Jon Mason <jdmason@kudzu.us>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/media/dt3155v4l/dt3155v4l.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/media/dt3155v4l/dt3155v4l.c b/drivers/staging/media/dt3155v4l/dt3155v4l.c
index c365cdf..76faa85 100644
--- a/drivers/staging/media/dt3155v4l/dt3155v4l.c
+++ b/drivers/staging/media/dt3155v4l/dt3155v4l.c
@@ -30,7 +30,6 @@
 
 #include "dt3155v4l.h"
 
-#define DT3155_VENDOR_ID 0x8086
 #define DT3155_DEVICE_ID 0x1223
 
 /* DT3155_CHUNK_SIZE is 4M (2^22) 8 full size buffers */
@@ -959,7 +958,7 @@ dt3155_remove(struct pci_dev *pdev)
 }
 
 static DEFINE_PCI_DEVICE_TABLE(pci_ids) = {
-	{ PCI_DEVICE(DT3155_VENDOR_ID, DT3155_DEVICE_ID) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, DT3155_DEVICE_ID) },
 	{ 0, /* zero marks the end */ },
 };
 MODULE_DEVICE_TABLE(pci, pci_ids);
-- 
1.7.9.5

