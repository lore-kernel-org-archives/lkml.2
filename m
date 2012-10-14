Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab2JNOvr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 10:51:47 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:33237 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754784Ab2JNOvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:51:43 -0400
From: Sangho Yi <antiroot@gmail.com>
To: devel@driverdev.osuosl.org
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Sangho Yi <antiroot@gmail.com>
Subject: [PATCH 1/2] Drivers: Staging: CSR: fixed indentation warnings based on coding style
Date: Sun, 14 Oct 2012 23:50:01 +0900
Message-Id: <1350226202-30158-1-git-send-email-antiroot@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <n>
References: <n>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I fixed the indentation warnings on csr_time.h.

Signed-off-by: Sangho Yi <antiroot@gmail.com>
---
 drivers/staging/csr/csr_time.h |   63 ++++++++++++++++++++--------------------
 1 file changed, 32 insertions(+), 31 deletions(-)

diff --git a/drivers/staging/csr/csr_time.h b/drivers/staging/csr/csr_time.h
index 2a45f3e..7ded6dd 100644
--- a/drivers/staging/csr/csr_time.h
+++ b/drivers/staging/csr/csr_time.h
@@ -2,11 +2,11 @@
 #define CSR_TIME_H__
 /*****************************************************************************
 
-            (c) Cambridge Silicon Radio Limited 2010
-            All rights reserved and confidential information of CSR
+(c) Cambridge Silicon Radio Limited 2010
+All rights reserved and confidential information of CSR
 
-            Refer to LICENSE.txt included with this source for details
-            on the license terms.
+Refer to LICENSE.txt included with this source for details
+on the license terms.
 
 *****************************************************************************/
 
@@ -18,13 +18,13 @@ extern "C" {
 
 /*******************************************************************************
 
-    NAME
-        CsrTime
+NAME
+	CsrTime
 
-    DESCRIPTION
-        Type to hold a value describing the current system time, which is a
-        measure of time elapsed since some arbitrarily defined fixed time
-        reference, usually associated with system startup.
+DESCRIPTION
+	Type to hold a value describing the current system time, which is a
+	measure of time elapsed since some arbitrarily defined fixed time
+	reference, usually associated with system startup.
 
 *******************************************************************************/
 typedef u32 CsrTime;
@@ -32,12 +32,12 @@ typedef u32 CsrTime;
 
 /*******************************************************************************
 
-    NAME
-        CsrTimeUtc
+NAME
+	CsrTimeUtc
 
-    DESCRIPTION
-        Type to hold a value describing a UTC wallclock time expressed in
-        seconds and milliseconds elapsed since midnight January 1st 1970.
+DESCRIPTION
+	Type to hold a value describing a UTC wallclock time expressed in
+	seconds and milliseconds elapsed since midnight January 1st 1970.
 
 *******************************************************************************/
 typedef struct
@@ -49,27 +49,28 @@ typedef struct
 
 /*******************************************************************************
 
-    NAME
-        CsrTimeGet
+NAME
+	CsrTimeGet
 
-    DESCRIPTION
-        Returns the current system time in a low and a high part. The low part
-        is expressed in microseconds. The high part is incremented when the low
-        part wraps to provide an extended range.
+DESCRIPTION
+	Returns the current system time in a low and a high part. The low part
+	is expressed in microseconds. The high part is incremented when the low
+	part wraps to provide an extended range.
 
-        The caller may provide a NULL pointer as the high parameter. In this case
-        the function just returns the low part and ignores the high parameter.
+	The caller may provide a NULL pointer as the high parameter.
+	In this case the function just returns the low part and ignores the
+	high parameter.
 
-        Although the time is expressed in microseconds the actual resolution is
-        platform dependent and can be less. It is recommended that the
-        resolution is at least 10 milliseconds.
+	Although the time is expressed in microseconds the actual resolution is
+	platform dependent and can be less. It is recommended that the
+	resolution is at least 10 milliseconds.
 
-    PARAMETERS
-        high - Pointer to variable that will receive the high part of the
-               current system time. Passing NULL is valid.
+PARAMETERS
+	high - Pointer to variable that will receive the high part of the
+	       current system time. Passing NULL is valid.
 
-    RETURNS
-        Low part of current system time in microseconds.
+RETURNS
+	Low part of current system time in microseconds.
 
 *******************************************************************************/
 CsrTime CsrTimeGet(CsrTime *high);
-- 
1.7.9.5

