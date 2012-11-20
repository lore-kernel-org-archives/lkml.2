Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740Ab2KTR3O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 12:29:14 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:34109 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856Ab2KTR3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 12:29:12 -0500
From: Johan Meiring <johanmeiring@gmail.com>
To: gregkh@linuxfoundation.org, a.beregalov@gmail.com, devendra.aaru@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Johan Meiring <johanmeiring@gmail.com>
Subject: [PATCH 02/10] staging: cxt1e1: musycc.h: fixes coding style issues
Date: Tue, 20 Nov 2012 19:28:44 +0200
Message-Id: <1353432532-21203-2-git-send-email-johanmeiring@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353432532-21203-1-git-send-email-johanmeiring@gmail.com>
References: <1353432532-21203-1-git-send-email-johanmeiring@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit fixes instances of spaces being used for indentation
instead of tabs.

Signed-off-by: Johan Meiring <johanmeiring@gmail.com>
---
 drivers/staging/cxt1e1/musycc.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/cxt1e1/musycc.h b/drivers/staging/cxt1e1/musycc.h
index b6a282b..7deb607 100644
--- a/drivers/staging/cxt1e1/musycc.h
+++ b/drivers/staging/cxt1e1/musycc.h
@@ -48,8 +48,8 @@
 #define INT_QUEUE_SIZE    MUSYCC_NIQD
 
 /* RAM image of MUSYCC registers laid out as a C structure */
-    struct musycc_groupr
-    {
+struct musycc_groupr
+{
 	VINT32      thp[32];    /* Transmit Head Pointer [5-29]           */
 	VINT32      tmp[32];    /* Transmit Message Pointer [5-30]        */
 	VINT32      rhp[32];    /* Receive Head Pointer [5-29]            */
@@ -67,11 +67,11 @@
 	VINT32      mpd;        /* Memory Protection Descriptor [5-18]    */
 	VINT32      mld;        /* Message Length Descriptor [5-20]       */
 	VINT32      pcd;        /* Port Configuration Descriptor [5-19]   */
-    };
+};
 
 /* hardware MUSYCC registers laid out as a C structure */
-    struct musycc_globalr
-    {
+struct musycc_globalr
+{
 	VINT32      gbp;        /* Group Base Pointer                     */
 	VINT32      dacbp;      /* Dual Address Cycle Base Pointer        */
 	VINT32      srd;        /* Service Request Descriptor             */
@@ -100,7 +100,7 @@
 	VINT32      pcd;        /* Port Configuration Descriptor [5-19]   */
 	VINT32      rbist;      /* Receive BIST status [5-4]              */
 	VINT32      tbist;      /* Receive BIST status [5-4]              */
-    };
+};
 
 /* Global Config Descriptor bit macros */
 #define MUSYCC_GCD_ECLK_ENABLE  0x00000800      /* EBUS clock enable */
-- 
1.7.10.4

