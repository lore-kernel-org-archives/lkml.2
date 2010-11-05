Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab0KER74 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 13:59:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:39977 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752573Ab0KER7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 13:59:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,304,1286175600"; 
   d="scan'208";a="674743149"
From: Mark Allyn <mark.a.allyn@intel.com>
To: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Cc: Mark Allyn <mark.a.allyn@intel.com>
Subject: [PATCH 1/1] crypto: api.c: doc on crypto_alg_lookup, crypto_larval_lookup, and crypto_alg_mod_lookup
Date: Fri,  5 Nov 2010 11:05:46 -0700
Message-Id: <1288980346-15961-1-git-send-email-mark.a.allyn@intel.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resubmit due to errors on patch submitted 11/4/2010

Signed-off-by: Mark A. Allyn <mark.a.allyn@intel.com>
---
 crypto/api.c |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/crypto/api.c b/crypto/api.c
index 033a714..d8a7c35 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -193,6 +193,14 @@ static struct crypto_alg *crypto_larval_wait(struct crypto_alg *alg)
 	return alg;
 }
 
+/**
+ * crypto_alg_lookup() - get the crypto_alg structure for an algorithm
+ * @name:	text string containing name of algorithm
+ * @type:	crypto type defined in include/linux/crypto.h
+ * @mask:	mask of allowable crypto types (use or'd list
+ *		of types as defined in include/linux/crypto.h)
+ * @returns:	pointer to crypto_alg structure
+ */
 struct crypto_alg *crypto_alg_lookup(const char *name, u32 type, u32 mask)
 {
 	struct crypto_alg *alg;
@@ -205,6 +213,15 @@ struct crypto_alg *crypto_alg_lookup(const char *name, u32 type, u32 mask)
 }
 EXPORT_SYMBOL_GPL(crypto_alg_lookup);
 
+/**
+ * crypto_larval_lookup() - gets large value (larval) crypto_alg
+ *	structure for an algorithm
+ * @name:	text string containing name of algorithm
+ * @type:	crypto type defined in include/linux/crypto.h
+ * @mask:	mask of allowable crypto types (use or'd list
+ *		of types as defined in include/linux/crypto.h)
+ * @returns:	pointer to crypto_alg structure
+ */
 struct crypto_alg *crypto_larval_lookup(const char *name, u32 type, u32 mask)
 {
 	struct crypto_alg *alg;
@@ -247,6 +264,14 @@ int crypto_probing_notify(unsigned long val, void *v)
 }
 EXPORT_SYMBOL_GPL(crypto_probing_notify);
 
+/**
+ * crypto_alg_mod_lookup() - gets the algorithm module
+ * @name:	text string containing name of algorithm
+ * @type:	crypto type defined in include/linux/crypto.h
+ * @mask:	mask of allowable crypto types (use or'd list
+ *		of types as defined in include/linux/crypto.h)
+ * @returns:	pointer to crypto_alg structure
+ */
 struct crypto_alg *crypto_alg_mod_lookup(const char *name, u32 type, u32 mask)
 {
 	struct crypto_alg *alg;
-- 
1.6.3.3

