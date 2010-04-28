Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459Ab0D1Jam (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 05:30:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:48498 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750762Ab0D1Jal (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 05:30:41 -0400
Message-ID: <4BD80037.9060704@kernel.org>
Date: Wed, 28 Apr 2010 11:30:31 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: trivial@kernel.org, lkml <linux-kernel@vger.kernel.org>
CC: Paul Mackerras <paulus@au1.ibm.com>
Subject: [PATCH] trivial: use (C) instead of \251
Content-Type: multipart/mixed;
 boundary="------------030506030609000800010201"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 28 Apr 2010 09:30:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030506030609000800010201
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

The latin-1 copyright character \251 is invalid in ASCII or UTF-8 and
causes annoying problems with some editors and tools.  Use (C)
instead.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Paul Mackerras <paulus@au1.ibm.com>
---
I'm not really sure this would survive transport over mail in
appliable form, attaching the patch too just in case.

 kernel/perf_event.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 2f3fbf8..827ec53 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4,7 +4,7 @@
  *  Copyright (C) 2008 Thomas Gleixner <tglx@linutronix.de>
  *  Copyright (C) 2008-2009 Red Hat, Inc., Ingo Molnar
  *  Copyright (C) 2008-2009 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
- *  Copyright  ©  2009 Paul Mackerras, IBM Corp. <paulus@au1.ibm.com>
+ *  Copyright (C) 2009 Paul Mackerras, IBM Corp. <paulus@au1.ibm.com>
  *
  * For licensing details see kernel-base/COPYING
  */

--------------030506030609000800010201
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
 filename="patch"

Subject: [PATCH] trivial: use (C) instead of \251

The latin-1 copyright character \251 is invalid in ASCII or UTF-8 and
causes annoying problems with some editors and tools.  Use (C)
instead.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Paul Mackerras <paulus@au1.ibm.com>
---
 kernel/perf_event.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 2f3fbf8..827ec53 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4,7 +4,7 @@
  *  Copyright (C) 2008 Thomas Gleixner <tglx@linutronix.de>
  *  Copyright (C) 2008-2009 Red Hat, Inc., Ingo Molnar
  *  Copyright (C) 2008-2009 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
- *  Copyright  ©  2009 Paul Mackerras, IBM Corp. <paulus@au1.ibm.com>
+ *  Copyright (C) 2009 Paul Mackerras, IBM Corp. <paulus@au1.ibm.com>
  *
  * For licensing details see kernel-base/COPYING
  */

--------------030506030609000800010201--
