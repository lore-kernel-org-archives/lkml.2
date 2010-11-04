Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014Ab0KDRBb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 13:01:31 -0400
Received: from mga03.intel.com ([143.182.124.21]:11663 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751757Ab0KDRB1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 13:01:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,296,1286175600"; 
   d="scan'208";a="344679638"
From: Mark Allyn <mark.a.allyn@intel.com>
To: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Cc: Mark Allyn <mark.a.allyn@intel.com>
Subject: [PATCH 1/1] crypto: api.c adding kernel-doc comments
Date: Thu,  4 Nov 2010 10:07:22 -0700
Message-Id: <1288890442-11208-1-git-send-email-mark.a.allyn@intel.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add comments to crypto_alg_lookup and crypto_larval_lookup

I am re-submitting this due to errors

Signed-off-by: Mark A. Allyn <mark.a.allyn@intel.com>
---
 crypto/api.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/crypto/api.c b/crypto/api.c
index 033a714..71c389d 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -193,6 +193,15 @@ static struct crypto_alg *crypto_larval_wait(struct crypto_alg *alg)
 	return alg;
 }
 
+/**
+ * crypto_alg_lookup() return crypto_alg structure for an algorithm
+ * @name:	text string containing name of algorithm
+ * @type:	crypto type (defined at about line 31 of
+ *		include/linux/crypto.h)
+ * @mask:	mask of allowable crypto types (use or'd list
+ *		of types as defined at about line 31 of
+ *		include/linux/crypto.h)
+ */
 struct crypto_alg *crypto_alg_lookup(const char *name, u32 type, u32 mask)
 {
 	struct crypto_alg *alg;
@@ -205,6 +214,16 @@ struct crypto_alg *crypto_alg_lookup(const char *name, u32 type, u32 mask)
 }
 EXPORT_SYMBOL_GPL(crypto_alg_lookup);
 
+/**
+ * crypto_alg_larval lookup() return large value (larval) crypto_alg
+ *	structure for an algorithm
+ * @name:	text string containing name of algorithm
+ * @type:	crypto type (defined at about line 31 of
+ *		include/linux/crypto.h)
+ * @mask:	mask of allowable crypto types (use or'd list
+ *		of types as defined at about line 31 of
+ *		include/linux/crypto.h)
+ */
 struct crypto_alg *crypto_larval_lookup(const char *name, u32 type, u32 mask)
 {
 	struct crypto_alg *alg;
-- 
1.6.3.3

