Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075Ab0K2VUV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 16:20:21 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:50787 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956Ab0K2VUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 16:20:20 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-next@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH] keys: add missing include file for trusted and encrypted keys
Date: Mon, 29 Nov 2010 16:20:04 -0500
Message-Id: <1291065604-9113-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the linux-next powerpc build errors as reported by
Stephen Rothwell.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Tested-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
---
 security/keys/encrypted_defined.c |    1 +
 security/keys/trusted_defined.c   |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/security/keys/encrypted_defined.c b/security/keys/encrypted_defined.c
index 0e558dc..3f40857 100644
--- a/security/keys/encrypted_defined.c
+++ b/security/keys/encrypted_defined.c
@@ -17,6 +17,7 @@
 #include <linux/slab.h>
 #include <linux/parser.h>
 #include <linux/string.h>
+#include <linux/err.h>
 #include <keys/user-type.h>
 #include <keys/trusted-type.h>
 #include <keys/encrypted-type.h>
diff --git a/security/keys/trusted_defined.c b/security/keys/trusted_defined.c
index 1bec72e..aaaa069 100644
--- a/security/keys/trusted_defined.c
+++ b/security/keys/trusted_defined.c
@@ -17,6 +17,7 @@
 #include <linux/slab.h>
 #include <linux/parser.h>
 #include <linux/string.h>
+#include <linux/err.h>
 #include <keys/user-type.h>
 #include <keys/trusted-type.h>
 #include <linux/key-type.h>
-- 
1.7.2.2

