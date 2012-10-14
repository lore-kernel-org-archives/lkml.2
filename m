Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab2JNOwQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 10:52:16 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:49365 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754743Ab2JNOwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:52:12 -0400
From: Sangho Yi <antiroot@gmail.com>
To: devel@driverdev.osuosl.org
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Sangho Yi <antiroot@gmail.com>
Subject: [PATCH 2/2] Drivers: Stating: CSR: Removed unnecessary typedef struct
Date: Sun, 14 Oct 2012 23:50:02 +0900
Message-Id: <1350226202-30158-2-git-send-email-antiroot@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350226202-30158-1-git-send-email-antiroot@gmail.com>
References: <n>
 <1350226202-30158-1-git-send-email-antiroot@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I removed the unnecessary typedef struct from the csr_time.h.
There is no actual usage of the typedef definition.

Signed-off-by: Sangho Yi <antiroot@gmail.com>
---
 drivers/staging/csr/csr_time.h |   18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/drivers/staging/csr/csr_time.h b/drivers/staging/csr/csr_time.h
index 7ded6dd..d856154 100644
--- a/drivers/staging/csr/csr_time.h
+++ b/drivers/staging/csr/csr_time.h
@@ -29,24 +29,6 @@ DESCRIPTION
 *******************************************************************************/
 typedef u32 CsrTime;
 
-
-/*******************************************************************************
-
-NAME
-	CsrTimeUtc
-
-DESCRIPTION
-	Type to hold a value describing a UTC wallclock time expressed in
-	seconds and milliseconds elapsed since midnight January 1st 1970.
-
-*******************************************************************************/
-typedef struct
-{
-    u32 sec;
-    u16 msec;
-} CsrTimeUtc;
-
-
 /*******************************************************************************
 
 NAME
-- 
1.7.9.5

