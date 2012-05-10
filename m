Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932963Ab2EJXj4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 19:39:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47582 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932854Ab2EJXjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 19:39:54 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 04/29] KEYS: Reorganise keys Makefile [ver #4]
To: rusty@rustcorp.com.au
Cc: kyle@mcmartin.ca, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        David Howells <dhowells@redhat.com>
Date: Fri, 11 May 2012 00:39:45 +0100
Message-ID: <20120510233945.4137.88102.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120510233901.4137.19023.stgit@warthog.procyon.org.uk>
References: <20120510233901.4137.19023.stgit@warthog.procyon.org.uk>
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

