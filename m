Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751324Ab0KDQ0t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 12:26:49 -0400
Received: from mga02.intel.com ([134.134.136.20]:56424 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953Ab0KDQ0r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 12:26:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,296,1286175600"; 
   d="scan'208";a="674313781"
From: Mark Allyn <mark.a.allyn@intel.com>
To: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Cc: Mark Allyn <mark.a.allyn@intel.com>
Subject: [PATCH 1/1] crypto: api.c: adding doxygen comments to api
Date: Thu,  4 Nov 2010 09:32:42 -0700
Message-Id: <1288888362-10599-1-git-send-email-mark.a.allyn@intel.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark A. Allyn <mark.a.allyn@intel.com>
---
 crypto/api.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/crypto/api.c b/crypto/api.c
index 033a714..a11939f 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -193,6 +193,13 @@ static struct crypto_alg *crypto_larval_wait(struct crypto_alg *alg)
 	return alg;
 }
 
+/**
+ * This gets the crypto_alg structure for an algorithm
+ * it return struct crypto_alg
+ * @name: name of the algorithm
+ * @type: crypto type (defined at about line 31 of include/linux/crypto.h)
+ * @mask: mask of allowable crypto types
+ */
 struct crypto_alg *crypto_alg_lookup(const char *name, u32 type, u32 mask)
 {
 	struct crypto_alg *alg;
@@ -205,6 +212,13 @@ struct crypto_alg *crypto_alg_lookup(const char *name, u32 type, u32 mask)
 }
 EXPORT_SYMBOL_GPL(crypto_alg_lookup);
 
+/**
+ * This gets the large value crypto_alg structure for an algorithm
+ * it return struct crypto_alg
+ * @name: name of the algorithm
+ * @type: crypto type (defined at about line 31 of include/linux/crypto.h)
+ * @mask: mask of allowable crypto types
+ */
 struct crypto_alg *crypto_larval_lookup(const char *name, u32 type, u32 mask)
 {
 	struct crypto_alg *alg;
-- 
1.6.3.3

