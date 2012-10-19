Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758513Ab2JSW4v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 18:56:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59835 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758322Ab2JSW4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 18:56:50 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/2] MODSIGN: Cleanup .gitignore [ver #3]
To: torvalds@linux-foundation.org, rusty@rustcorp.com.au
Cc: dhowells@redhat.com, davem@davemloft.net, linux-kernel@vger.kernel.org
Date: Fri, 19 Oct 2012 23:56:45 +0100
Message-ID: <20121019225645.4319.65377.stgit@warthog.procyon.org.uk>
In-Reply-To: <20121019225637.4319.14343.stgit@warthog.procyon.org.uk>
References: <20121019225637.4319.14343.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The module build process no longer creates intermediate files for module
signing, so remove them from .gitignore.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 .gitignore |    6 ------
 1 file changed, 6 deletions(-)


diff --git a/.gitignore b/.gitignore
index 0f2f40f..92bd0e4 100644
--- a/.gitignore
+++ b/.gitignore
@@ -14,10 +14,6 @@
 *.o.*
 *.a
 *.s
-*.ko.unsigned
-*.ko.stripped
-*.ko.stripped.dig
-*.ko.stripped.sig
 *.ko
 *.so
 *.so.dbg
@@ -95,6 +91,4 @@ GTAGS
 extra_certificates
 signing_key.priv
 signing_key.x509
-signing_key.x509.keyid
-signing_key.x509.signer
 x509.genkey

