Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932373Ab2JQOQn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 10:16:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22067 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932204Ab2JQOQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 10:16:40 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 10/10] UAPI: Make arch/sparc/include/uapi/asm/sigcontext.h
 non-empty
To: torvalds@osdl.org
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Date: Wed, 17 Oct 2012 15:16:35 +0100
Message-ID: <20121017141635.29084.8654.stgit@warthog.procyon.org.uk>
In-Reply-To: <20121017141521.29084.36722.stgit@warthog.procyon.org.uk>
References: <20121017141521.29084.36722.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/sparc/include/uapi/asm/sigcontext.h was emitted by the UAPI disintegration
script as an empty file because the parent file had no UAPI stuff in it,
despite being marked with "header-y".

Unfortunately, the patch program deletes resultant empty files when applying a
kernel patch.

So just stick a comment in there as a placeholder.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: David S. Miller <davem@davemloft.net>
cc: sparclinux@vger.kernel.org
---

 arch/sparc/include/uapi/asm/sigcontext.h |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/sparc/include/uapi/asm/sigcontext.h b/arch/sparc/include/uapi/asm/sigcontext.h
index e69de29..ae5704f 100644
--- a/arch/sparc/include/uapi/asm/sigcontext.h
+++ b/arch/sparc/include/uapi/asm/sigcontext.h
@@ -0,0 +1,4 @@
+/*
+ * There isn't anything here anymore, but the file must not be empty or patch
+ * will delete it.
+ */

