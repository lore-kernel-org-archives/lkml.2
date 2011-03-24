Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934240Ab1CXUWw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 16:22:52 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:56204 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934119Ab1CXUTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 16:19:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=rZWLhc1jvgY50AmewSPL8wNA1x9Q+uLmbxSvPrdxzetPJQrtlvUD1h2Ap2YU69RjWI
         A1ltvm6z3v/L5NqDKN+VlSnl20iDbVWOLo+VTF83c2hiQnt7KobdBFji4vMcBMSzs0cc
         tlz2DXCEit2h84SgRPXdAPYhOFbGbVmzm1/8k=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [RFC V2 07/21]drivers:xen Remove extra semi-colon.
Date: Thu, 24 Mar 2011 13:18:26 -0700
Message-Id: <1300997920-31573-7-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300997920-31573-1-git-send-email-justinmattock@gmail.com>
References: <1300997920-31573-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes an extra semi-colon from various parts 
of the kernel. Please have a look when you have time, and let
me know if its legit or not.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/xen/evtchn.c      |    2 +-
 drivers/xen/swiotlb-xen.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/evtchn.c b/drivers/xen/evtchn.c
index ef11daf..dbc13e9 100644
--- a/drivers/xen/evtchn.c
+++ b/drivers/xen/evtchn.c
@@ -470,7 +470,7 @@ static int evtchn_open(struct inode *inode, struct file *filp)
 
 	filp->private_data = u;
 
-	return nonseekable_open(inode, filp);;
+	return nonseekable_open(inode, filp);
 }
 
 static int evtchn_release(struct inode *inode, struct file *filp)
diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index 54469c3..65ea21a 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -54,7 +54,7 @@ u64 start_dma_addr;
 
 static dma_addr_t xen_phys_to_bus(phys_addr_t paddr)
 {
-	return phys_to_machine(XPADDR(paddr)).maddr;;
+	return phys_to_machine(XPADDR(paddr)).maddr;
 }
 
 static phys_addr_t xen_bus_to_phys(dma_addr_t baddr)
-- 
1.7.4.1

