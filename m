Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768092Ab2KOOiF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 09:38:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43452 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767975Ab2KOOiD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 09:38:03 -0500
From: Michal Marek <mmarek@suse.cz>
To: dhowells@redhat.com
Cc: herbert@gondor.hengli.com.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] X.509: Do not rely on implicit time.h include
Date: Thu, 15 Nov 2012 15:37:50 +0100
Message-Id: <1352990270-25825-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x509_parser.h needs struct tm, so include the header that declares it.

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 crypto/asymmetric_keys/x509_parser.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/asymmetric_keys/x509_parser.h b/crypto/asymmetric_keys/x509_parser.h
index f86dc5f..9383923 100644
--- a/crypto/asymmetric_keys/x509_parser.h
+++ b/crypto/asymmetric_keys/x509_parser.h
@@ -10,6 +10,7 @@
  */
 
 #include <crypto/public_key.h>
+#include <linux/time.h>
 
 struct x509_certificate {
 	struct x509_certificate *next;
-- 
1.7.10.4

