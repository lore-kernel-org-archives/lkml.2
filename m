Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932268Ab1LBSn4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 13:43:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35694 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932160Ab1LBSnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 13:43:51 -0500
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 06/21] KEYS: Reorganise keys Makefile [ver #3]
To: keyrings@linux-nfs.org
Cc: linux-crypto@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmitry.kasatkin@intel.com,
        zohar@linux.vnet.ibm.com, arjan.van.de.ven@intel.com,
        alan.cox@intel.com, David Howells <dhowells@redhat.com>
Date: Fri, 02 Dec 2011 18:43:42 +0000
Message-ID: <20111202184342.21874.10960.stgit@warthog.procyon.org.uk>
In-Reply-To: <20111202184229.21874.25782.stgit@warthog.procyon.org.uk>
References: <20111202184229.21874.25782.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reorganise the keys directory Makefile to put all the core bits together and
the type-specific bits after.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 security/keys/Makefile |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)


diff --git a/security/keys/Makefile b/security/keys/Makefile
index a56f1ff..504aaa0 100644
--- a/security/keys/Makefile
+++ b/security/keys/Makefile
@@ -2,6 +2,9 @@
 # Makefile for key management
 #
 
+#
+# Core
+#
 obj-y := \
 	gc.o \
 	key.o \
@@ -12,9 +15,12 @@ obj-y := \
 	request_key.o \
 	request_key_auth.o \
 	user_defined.o
-
-obj-$(CONFIG_TRUSTED_KEYS) += trusted.o
-obj-$(CONFIG_ENCRYPTED_KEYS) += encrypted-keys/
 obj-$(CONFIG_KEYS_COMPAT) += compat.o
 obj-$(CONFIG_PROC_FS) += proc.o
 obj-$(CONFIG_SYSCTL) += sysctl.o
+
+#
+# Key types
+#
+obj-$(CONFIG_TRUSTED_KEYS) += trusted.o
+obj-$(CONFIG_ENCRYPTED_KEYS) += encrypted-keys/

