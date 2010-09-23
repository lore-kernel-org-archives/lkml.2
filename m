Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828Ab0IWREp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 13:04:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28613 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753758Ab0IWREo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 13:04:44 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/2] MN10300: Fix SIGRTMAX
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-am33-list@redhat.com, linux-kernel@vger.kernel.org,
        Mark Salter <msalter@redhat.com>, David Howells <dhowells@redhat.com>
Date: Thu, 23 Sep 2010 18:04:28 +0100
Message-ID: <20100923170428.7022.35221.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Salter <msalter@redhat.com>

SIGRTMAX should be _NSIG not _NSIG-1.

Signed-off-by: Mark Salter <msalter@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/include/asm/signal.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/arch/mn10300/include/asm/signal.h b/arch/mn10300/include/asm/signal.h
index 7e891fc..1865d72 100644
--- a/arch/mn10300/include/asm/signal.h
+++ b/arch/mn10300/include/asm/signal.h
@@ -78,7 +78,7 @@ typedef unsigned long sigset_t;
 
 /* These should not be considered constants from userland.  */
 #define SIGRTMIN	32
-#define SIGRTMAX	(_NSIG-1)
+#define SIGRTMAX	_NSIG
 
 /*
  * SA_FLAGS values:

