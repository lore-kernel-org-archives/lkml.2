Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757938Ab3AIOQg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 09:16:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22603 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757811Ab3AIOQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 09:16:35 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH] cred: Remove tgcred pointer from struct cred
To: torvalds@linux-foundation.org
From: David Howells <dhowells@redhat.com>
Cc: marc.c.dionne@gmail.com, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 09 Jan 2013 14:16:30 +0000
Message-ID: <20130109141630.21956.44273.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marc Dionne <marc.c.dionne@gmail.com>

Commit 3a50597de86 in mainline removed the definition of the
thread_group_cred structure, but left a now unused pointer in
struct cred.

Signed-off-by: Marc Dionne <marc.c.dionne@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/cred.h |    1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/cred.h b/include/linux/cred.h
index abb2cd5..04421e8 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -128,7 +128,6 @@ struct cred {
 	struct key	*process_keyring; /* keyring private to this process */
 	struct key	*thread_keyring; /* keyring private to this thread */
 	struct key	*request_key_auth; /* assumed request_key authority */
-	struct thread_group_cred *tgcred; /* thread-group shared credentials */
 #endif
 #ifdef CONFIG_SECURITY
 	void		*security;	/* subjective LSM security */

