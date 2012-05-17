Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030448Ab2EQWQg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 18:16:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:65435 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967760Ab2EQWOB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 18:14:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="145320392"
From: "H.J. Lu" <hjl.tools@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: torvalds@linux-foundation.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, "H.J. Lu" <hjl.tools@gmail.com>
Subject: [PATCH 01/10] Use __kernel_long_t in struct timex
Date: Thu, 17 May 2012 15:13:27 -0700
Message-Id: <1337292816-10839-2-git-send-email-hjl.tools@gmail.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1337292816-10839-1-git-send-email-hjl.tools@gmail.com>
References: <1337292816-10839-1-git-send-email-hjl.tools@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H.J. Lu" <hjl.tools@gmail.com>

Replace long with __kernel_long_t in struct timex for user space.

Signed-off-by: H.J. Lu <hjl.tools@gmail.com>
---
 include/linux/timex.h |   34 +++++++++++++++++-----------------
 1 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/include/linux/timex.h b/include/linux/timex.h
index 99bc88b..22c57ac 100644
--- a/include/linux/timex.h
+++ b/include/linux/timex.h
@@ -63,27 +63,27 @@
  */
 struct timex {
 	unsigned int modes;	/* mode selector */
-	long offset;		/* time offset (usec) */
-	long freq;		/* frequency offset (scaled ppm) */
-	long maxerror;		/* maximum error (usec) */
-	long esterror;		/* estimated error (usec) */
+	__kernel_long_t offset;	/* time offset (usec) */
+	__kernel_long_t freq;	/* frequency offset (scaled ppm) */
+	__kernel_long_t maxerror; /* maximum error (usec) */
+	__kernel_long_t esterror; /* estimated error (usec) */
 	int status;		/* clock command/status */
-	long constant;		/* pll time constant */
-	long precision;		/* clock precision (usec) (read only) */
-	long tolerance;		/* clock frequency tolerance (ppm)
-				 * (read only)
-				 */
+	__kernel_long_t constant; /* pll time constant */
+	__kernel_long_t precision; /* clock precision (usec) (read only) */
+	__kernel_long_t tolerance; /* clock frequency tolerance (ppm)
+				    * (read only)
+				    */
 	struct timeval time;	/* (read only, except for ADJ_SETOFFSET) */
-	long tick;		/* (modified) usecs between clock ticks */
+	__kernel_long_t tick;	/* (modified) usecs between clock ticks */
 
-	long ppsfreq;           /* pps frequency (scaled ppm) (ro) */
-	long jitter;            /* pps jitter (us) (ro) */
+	__kernel_long_t ppsfreq; /* pps frequency (scaled ppm) (ro) */
+	__kernel_long_t jitter; /* pps jitter (us) (ro) */
 	int shift;              /* interval duration (s) (shift) (ro) */
-	long stabil;            /* pps stability (scaled ppm) (ro) */
-	long jitcnt;            /* jitter limit exceeded (ro) */
-	long calcnt;            /* calibration intervals (ro) */
-	long errcnt;            /* calibration errors (ro) */
-	long stbcnt;            /* stability limit exceeded (ro) */
+	__kernel_long_t stabil; /* pps stability (scaled ppm) (ro) */
+	__kernel_long_t jitcnt; /* jitter limit exceeded (ro) */
+	__kernel_long_t calcnt; /* calibration intervals (ro) */
+	__kernel_long_t errcnt; /* calibration errors (ro) */
+	__kernel_long_t stbcnt; /* stability limit exceeded (ro) */
 
 	int tai;		/* TAI offset (ro) */
 
-- 
1.7.6.5

