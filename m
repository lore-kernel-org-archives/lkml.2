Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823Ab2KTR3W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 12:29:22 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:38304 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856Ab2KTR3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 12:29:18 -0500
From: Johan Meiring <johanmeiring@gmail.com>
To: gregkh@linuxfoundation.org, a.beregalov@gmail.com, devendra.aaru@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Johan Meiring <johanmeiring@gmail.com>
Subject: [PATCH 03/10] staging: cxt1e1: musycc.h: fixes brace placement
Date: Tue, 20 Nov 2012 19:28:45 +0200
Message-Id: <1353432532-21203-3-git-send-email-johanmeiring@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353432532-21203-1-git-send-email-johanmeiring@gmail.com>
References: <1353432532-21203-1-git-send-email-johanmeiring@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit fixes incorrect brace placement.

Signed-off-by: Johan Meiring <johanmeiring@gmail.com>
---
 drivers/staging/cxt1e1/musycc.h |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/cxt1e1/musycc.h b/drivers/staging/cxt1e1/musycc.h
index 7deb607..56fb42f 100644
--- a/drivers/staging/cxt1e1/musycc.h
+++ b/drivers/staging/cxt1e1/musycc.h
@@ -48,8 +48,7 @@
 #define INT_QUEUE_SIZE    MUSYCC_NIQD
 
 /* RAM image of MUSYCC registers laid out as a C structure */
-struct musycc_groupr
-{
+struct musycc_groupr {
 	VINT32      thp[32];    /* Transmit Head Pointer [5-29]           */
 	VINT32      tmp[32];    /* Transmit Message Pointer [5-30]        */
 	VINT32      rhp[32];    /* Receive Head Pointer [5-29]            */
@@ -70,8 +69,7 @@ struct musycc_groupr
 };
 
 /* hardware MUSYCC registers laid out as a C structure */
-struct musycc_globalr
-{
+struct musycc_globalr {
 	VINT32      gbp;        /* Group Base Pointer                     */
 	VINT32      dacbp;      /* Dual Address Cycle Base Pointer        */
 	VINT32      srd;        /* Service Request Descriptor             */
-- 
1.7.10.4

