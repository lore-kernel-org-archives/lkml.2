Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934813Ab1IOUKt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 16:10:49 -0400
Received: from mga02.intel.com ([134.134.136.20]:46846 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934778Ab1IOUKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 16:10:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="48873457"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 27/27] Initconst section fixes for lib
Date: Thu, 15 Sep 2011 13:09:54 -0700
Message-Id: <1316117394-21666-28-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1316117394-21666-1-git-send-email-andi@firstfloor.org>
References: <1316117394-21666-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 lib/test-kstrtox.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/test-kstrtox.c b/lib/test-kstrtox.c
index d55769d..bea3f3f 100644
--- a/lib/test-kstrtox.c
+++ b/lib/test-kstrtox.c
@@ -11,7 +11,7 @@ struct test_fail {
 };
 
 #define DEFINE_TEST_FAIL(test)	\
-	const struct test_fail test[] __initdata
+	const struct test_fail test[] __initconst
 
 #define DECLARE_TEST_OK(type, test_type)	\
 	test_type {				\
@@ -21,7 +21,7 @@ struct test_fail {
 	}
 
 #define DEFINE_TEST_OK(type, test)	\
-	const type test[] __initdata
+	const type test[] __initconst
 
 #define TEST_FAIL(fn, type, fmt, test)					\
 {									\
-- 
1.7.4.4

