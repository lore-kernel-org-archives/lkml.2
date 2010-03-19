Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751346Ab0CSSLY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 14:11:24 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:4954 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab0CSSLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 14:11:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=N1ea9EeMufh0m3nobWgh8DSlA99F+mXkcCrOlZ/j9mDaLlCob+Idjs0zaEdKMkQIuH
         AdJTUcGP7EHz0bT5Y6bBaAwSYPsrsSgoq+40EJAHHTkbBn4go+GxumwAoCiKRXvjNquv
         OHW/Li3c6XeD5se/keklhYUK9+7gmyLfyWWnU=
From: Gorskin Ilya <revent82@gmail.com>
To: gregkh@suse.de, bzolnier@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Gorskin Ilya <revent82@gmail.com>
Subject: [PATCH 5/5] Staging:rt2860: fix coding style issue in rt_pci_rbus.c This is a patch to the rt_pci_rbus.c file that fixes up errors found by the checkpatch.pl tool
Date: Fri, 19 Mar 2010 23:10:32 +0500
Message-Id: <1269022232-25734-1-git-send-email-revent82@gmail.com>
X-Mailer: git-send-email 1.7.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Gorskin Ilya <revent82@gmail.com>
---
 drivers/staging/rt2860/rt_pci_rbus.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/rt2860/rt_pci_rbus.c b/drivers/staging/rt2860/rt_pci_rbus.c
index e0a0aee..7d63b85 100644
--- a/drivers/staging/rt2860/rt_pci_rbus.c
+++ b/drivers/staging/rt2860/rt_pci_rbus.c
@@ -81,7 +81,7 @@ void RTMP_AllocateTxDescMemory(struct rt_rtmp_adapter *pAd,
 			       u32 Index,
 			       unsigned long Length,
 			       IN BOOLEAN Cached,
-			       void ** VirtualAddress,
+			       void **VirtualAddress,
 			       dma_addr_t *PhysicalAddress)
 {
 	struct os_cookie *pObj = (struct os_cookie *)pAd->OS_Cookie;
@@ -96,7 +96,7 @@ void RTMP_AllocateTxDescMemory(struct rt_rtmp_adapter *pAd,
 void RTMP_AllocateMgmtDescMemory(struct rt_rtmp_adapter *pAd,
 				 unsigned long Length,
 				 IN BOOLEAN Cached,
-				 void ** VirtualAddress,
+				 void **VirtualAddress,
 				 dma_addr_t *PhysicalAddress)
 {
 	struct os_cookie *pObj = (struct os_cookie *)pAd->OS_Cookie;
@@ -111,7 +111,7 @@ void RTMP_AllocateMgmtDescMemory(struct rt_rtmp_adapter *pAd,
 void RTMP_AllocateRxDescMemory(struct rt_rtmp_adapter *pAd,
 			       unsigned long Length,
 			       IN BOOLEAN Cached,
-			       void ** VirtualAddress,
+			       void **VirtualAddress,
 			       dma_addr_t *PhysicalAddress)
 {
 	struct os_cookie *pObj = (struct os_cookie *)pAd->OS_Cookie;
@@ -139,7 +139,7 @@ void RTMP_AllocateFirstTxBuffer(struct rt_rtmp_adapter *pAd,
 				u32 Index,
 				unsigned long Length,
 				IN BOOLEAN Cached,
-				void ** VirtualAddress,
+				void **VirtualAddress,
 				dma_addr_t *PhysicalAddress)
 {
 	struct os_cookie *pObj = (struct os_cookie *)pAd->OS_Cookie;
@@ -173,7 +173,7 @@ void RTMP_FreeFirstTxBuffer(struct rt_rtmp_adapter *pAd,
 void RTMP_AllocateSharedMemory(struct rt_rtmp_adapter *pAd,
 			       unsigned long Length,
 			       IN BOOLEAN Cached,
-			       void ** VirtualAddress,
+			       void **VirtualAddress,
 			       dma_addr_t *PhysicalAddress)
 {
 	struct os_cookie *pObj = (struct os_cookie *)pAd->OS_Cookie;
@@ -197,7 +197,7 @@ void RTMP_AllocateSharedMemory(struct rt_rtmp_adapter *pAd,
 void *RTMP_AllocateRxPacketBuffer(struct rt_rtmp_adapter *pAd,
 					 unsigned long Length,
 					 IN BOOLEAN Cached,
-					 void ** VirtualAddress,
+					 void **VirtualAddress,
 					 OUT dma_addr_t *
 					 PhysicalAddress)
 {
-- 
1.7.0.2

