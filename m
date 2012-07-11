Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932764Ab2GKPLd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 11:11:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38909 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932139Ab2GKPLb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 11:11:31 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] MN10300: Fix a missing semicolon
To: torvalds@osdl.org
Cc: dhowells@redhat.com, linux-am33-list@redhat.com,
        linux-kernel@vger.kernel.org
Date: Wed, 11 Jul 2012 16:11:20 +0100
Message-ID: <20120711151120.25703.18598.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The declaration of arch_release_thread_info() needs a semicolon.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/include/asm/thread_info.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mn10300/include/asm/thread_info.h b/arch/mn10300/include/asm/thread_info.h
index 08251d6..ac519bb 100644
--- a/arch/mn10300/include/asm/thread_info.h
+++ b/arch/mn10300/include/asm/thread_info.h
@@ -123,7 +123,7 @@ static inline unsigned long current_stack_pointer(void)
 }
 
 #ifndef CONFIG_KGDB
-void arch_release_thread_info(struct thread_info *ti)
+void arch_release_thread_info(struct thread_info *ti);
 #endif
 #define get_thread_info(ti)	get_task_struct((ti)->task)
 #define put_thread_info(ti)	put_task_struct((ti)->task)

