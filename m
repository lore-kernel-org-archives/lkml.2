Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758695Ab1LODXl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 22:23:41 -0500
Received: from ozlabs.org ([203.10.76.45]:38363 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758652Ab1LODXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 22:23:38 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH 9/15] kernel/async: remove redundant declaration.
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 15 Dec 2011 13:42:15 +1030
Message-ID: <87mxausf3k.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's in linux/init.h, and I'm about to change it to a bool.

Cc: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 kernel/async.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/async.c b/kernel/async.c
--- a/kernel/async.c
+++ b/kernel/async.c
@@ -78,8 +78,6 @@ static DECLARE_WAIT_QUEUE_HEAD(async_don
 
 static atomic_t entry_count;
 
-extern int initcall_debug;
-
 
 /*
  * MUST be called with the lock held!
