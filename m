Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab2JNLVw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 07:21:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52886 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385Ab2JNLVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 07:21:50 -0400
From: Sangho Yi <antiroot@gmail.com>
To: devel@driverdev.osuosl.org
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Sangho Yi <antiroot@gmail.com>
Subject: [PATCH] Drivers: Staging: CSR: made corrections on the indentation errors
Date: Sun, 14 Oct 2012 20:20:11 +0900
Message-Id: <1350213611-19806-1-git-send-email-antiroot@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <n>
References: <n>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Originally there were a lot mis-indentation, so I made changes to use
only the tabs (no spaces) on indenting code.
- Still, the typedef struct ... tells warning message on checkpatch.pl.

Signed-off-by: Sangho Yi <antiroot@gmail.com>
---
 drivers/staging/csr/csr_time.h |   54 ++++++++++++++++++++--------------------
 1 file changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/csr/csr_time.h b/drivers/staging/csr/csr_time.h
index 2a45f3e..e3cae82 100644
--- a/drivers/staging/csr/csr_time.h
+++ b/drivers/staging/csr/csr_time.h
@@ -2,11 +2,11 @@
 #define CSR_TIME_H__
 /*****************************************************************************
 
-            (c) Cambridge Silicon Radio Limited 2010
-            All rights reserved and confidential information of CSR
+	(c) Cambridge Silicon Radio Limited 2010
+	All rights reserved and confidential information of CSR
 
-            Refer to LICENSE.txt included with this source for details
-            on the license terms.
+	Refer to LICENSE.txt included with this source for details
+	on the license terms.
 
 *****************************************************************************/
 
@@ -19,12 +19,12 @@ extern "C" {
 /*******************************************************************************
 
     NAME
-        CsrTime
+	CsrTime
 
     DESCRIPTION
-        Type to hold a value describing the current system time, which is a
-        measure of time elapsed since some arbitrarily defined fixed time
-        reference, usually associated with system startup.
+	Type to hold a value describing the current system time, which is a
+	measure of time elapsed since some arbitrarily defined fixed time
+	reference, usually associated with system startup.
 
 *******************************************************************************/
 typedef u32 CsrTime;
@@ -33,43 +33,43 @@ typedef u32 CsrTime;
 /*******************************************************************************
 
     NAME
-        CsrTimeUtc
+	CsrTimeUtc
 
     DESCRIPTION
-        Type to hold a value describing a UTC wallclock time expressed in
-        seconds and milliseconds elapsed since midnight January 1st 1970.
+	Type to hold a value describing a UTC wallclock time expressed in
+	seconds and milliseconds elapsed since midnight January 1st 1970.
 
 *******************************************************************************/
-typedef struct
-{
-    u32 sec;
-    u16 msec;
+typedef struct _CsrTimeUtc {
+	u32 sec;
+	u16 msec;
 } CsrTimeUtc;
 
 
 /*******************************************************************************
 
     NAME
-        CsrTimeGet
+	CsrTimeGet
 
     DESCRIPTION
-        Returns the current system time in a low and a high part. The low part
-        is expressed in microseconds. The high part is incremented when the low
-        part wraps to provide an extended range.
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
 
     PARAMETERS
-        high - Pointer to variable that will receive the high part of the
-               current system time. Passing NULL is valid.
+	high - Pointer to variable that will receive the high part of the
+	       current system time. Passing NULL is valid.
 
     RETURNS
-        Low part of current system time in microseconds.
+	Low part of current system time in microseconds.
 
 *******************************************************************************/
 CsrTime CsrTimeGet(CsrTime *high);
-- 
1.7.9.5

