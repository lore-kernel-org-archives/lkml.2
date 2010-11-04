Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056Ab0KDTn7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 15:43:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:58631 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752586Ab0KDTnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 15:43:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,297,1286175600"; 
   d="scan'208";a="570449640"
From: Mark Allyn <mark.a.allyn@intel.com>
To: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Cc: Mark Allyn <mark.a.allyn@intel.com>
Subject: [PATCH 1/1] crypto: api.c: add comments to crypto_alg_lookup and crypto_alg_larval_lookup
Date: Thu,  4 Nov 2010 12:49:48 -0700
Message-Id: <1288900188-19034-1-git-send-email-mark.a.allyn@intel.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is resubmitted due to errors in style

Signed-off-by: Mark A. Allyn <mark.a.allyn@intel.com>
---
 crypto/api.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/crypto/api.c b/crypto/api.c
index 033a714..0314083 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -193,6 +193,13 @@ static struct crypto_alg *crypto_larval_wait(struct crypto_alg *alg)
 	return alg;
 }
 
+/**
+ * crypto_alg_lookup() - return crypto_alg structure for an algorithm
+ * @name:	text string containing name of algorithm
+ * @type:	crypto type defined in include/linux/crypto.h
+ * @mask:	mask of allowable crypto types (use or'd list
+ *		of types as defined in include/linux/crypto.h)
+ */
 struct crypto_alg *crypto_alg_lookup(const char *name, u32 type, u32 mask)
 {
 	struct crypto_alg *alg;
@@ -205,6 +212,14 @@ struct crypto_alg *crypto_alg_lookup(const char *name, u32 type, u32 mask)
 }
 EXPORT_SYMBOL_GPL(crypto_alg_lookup);
 
+/**
+ * crypto_alg_larval_lookup() - returns large value (larval) crypto_alg
+ *	structure for an algorithm
+ * @name:	text string containing name of algorithm
+ * @type:	crypto type defined in include/linux/crypto.h
+ * @mask:	mask of allowable crypto types (use or'd list
+ *		of types as defined in include/linux/crypto.h)
+ */
 struct crypto_alg *crypto_larval_lookup(const char *name, u32 type, u32 mask)
 {
 	struct crypto_alg *alg;
-- 
1.6.3.3

