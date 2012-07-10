Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab2GJBgT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 21:36:19 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:33916 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755373Ab2GJBf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 21:35:58 -0400
From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        klmckinney1@gmail.com, dan.carpenter@oracle.com, standby24x7@gmail.com,
        Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Subject: [PATCH 2/3] staging: bcm: Remove all commented macros
Date: Mon,  9 Jul 2012 22:32:39 -0300
Message-Id: <1341883960-21635-3-git-send-email-marcos.souza.org@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1341883960-21635-1-git-send-email-marcos.souza.org@gmail.com>
References: <1341883960-21635-1-git-send-email-marcos.souza.org@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All these macros are commented, and can be removed.

Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
---
 drivers/staging/bcm/CmHost.c     |    1 -
 drivers/staging/bcm/Debug.h      |    5 -----
 drivers/staging/bcm/Macros.h     |    1 -
 drivers/staging/bcm/PHSDefines.h |    1 -
 4 files changed, 8 deletions(-)

diff --git a/drivers/staging/bcm/CmHost.c b/drivers/staging/bcm/CmHost.c
index 9c8c9b1..b54ec97 100644
--- a/drivers/staging/bcm/CmHost.c
+++ b/drivers/staging/bcm/CmHost.c
@@ -4,7 +4,6 @@
  * Management.
  ************************************************************/
 
-/* #define CONN_MSG */
 #include "headers.h"
 
 enum E_CLASSIFIER_ACTION {
diff --git a/drivers/staging/bcm/Debug.h b/drivers/staging/bcm/Debug.h
index 420382d..8018a18 100644
--- a/drivers/staging/bcm/Debug.h
+++ b/drivers/staging/bcm/Debug.h
@@ -42,10 +42,6 @@
 #define ARP_REQ  	(TX<<5)
 #define ARP_RESP 	(TX<<6)
 
-// dhcp.c
-//#define DHCP TX
-//#define DHCP_REQ (DHCP<<7)
-
 // Leakybucket.c
 #define TOKEN_COUNTS (TX<<8)
 #define CHECK_TOKENS (TX<<9)
@@ -147,7 +143,6 @@ DriverEntry.c, bcmfwup.c, ChipDetectTask.c, HaltnReset.c, InterfaceDDR.c */
 
 #define HOST_MIBS   	(OTHERS << 28)
 #define CONN_MSG    	(CMHOST << 29)
-//#define OTHERS_MISC		(OTHERS << 29)	// ProcSupport.c
 /*-----------------END SUBTYPEs------------------------------------------*/
 
 
diff --git a/drivers/staging/bcm/Macros.h b/drivers/staging/bcm/Macros.h
index b5ca6f6..46f5f0f 100644
--- a/drivers/staging/bcm/Macros.h
+++ b/drivers/staging/bcm/Macros.h
@@ -6,7 +6,6 @@
 
 #define TX_TIMER_PERIOD 10 /*10 msec*/
 #define MAX_CLASSIFIERS 100
-/* #define MAX_CLASSIFIERS_PER_SF  20 */
 #define MAX_TARGET_DSX_BUFFERS 24
 
 #define MAX_CNTRL_PKTS    100
diff --git a/drivers/staging/bcm/PHSDefines.h b/drivers/staging/bcm/PHSDefines.h
index eed4cfc..6016fc5 100644
--- a/drivers/staging/bcm/PHSDefines.h
+++ b/drivers/staging/bcm/PHSDefines.h
@@ -27,7 +27,6 @@
 #define PHS_BUFFER_SIZE				 1532
 
 
-//#define MAX_PHS_LENGTHS 100
 #define MAX_PHSRULE_PER_SF       20
 #define MAX_SERVICEFLOWS			 17
 
-- 
1.7.10.4

