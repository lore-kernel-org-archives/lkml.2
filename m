Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507Ab0LLKqo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 05:46:44 -0500
Received: from mail-iw0-f170.google.com ([209.85.214.170]:54084 "EHLO
	mail-iw0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151Ab0LLKqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 05:46:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=m3p66CkQZ8j/kFeEITfKAcg0q1w23Ny3cNNVkk30mrN/Vdvvz3zuixRjnfeeBk0eeX
         NeP52jJSkg9tIDITHsWpIwXKv+yR0/k3PuSTgm5lUoMZEeV/jpMujLDxDw7QjdVMrJeC
         MTZllA1okF/OanFnYXpNCHBqj1RYu4pGmfXBk=
From: bookjovi@gmail.com
To: akpm@linux-foundation.org, hidave.darkstar@gmail.com, davem@davemloft.net,
        mingo@elte.hu, eparis@redhat.com, linux-kernel@vger.kernel.org
Cc: Jovi Zhang <bookjovi@gmail.com>
Subject: [PATCH 2/2] sysctl: remove invalid comments
Date: Fri, 10 Dec 2010 22:06:36 -0500
Message-Id: <1292036796-3051-1-git-send-email-bookjovi@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ctl_unnumbered.txt have been removed in Documentation directory
so just also remove this invalid comments

Signed-off-by: Jovi Zhang <bookjovi@gmail.com>

 kernel/sysctl.c |   17 -----------------
 1 files changed, 0 insertions(+), 17 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 5abfa15..108c1d8 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -245,10 +245,6 @@ static struct ctl_table root_table[] = {
 		.mode		= 0555,
 		.child		= dev_table,
 	},
-/*
- * NOTE: do not add new entries to this table unless you have read
- * Documentation/sysctl/ctl_unnumbered.txt
- */
 	{ }
 };
 
@@ -963,10 +959,6 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 #endif
-/*
- * NOTE: do not add new entries to this table unless you have read
- * Documentation/sysctl/ctl_unnumbered.txt
- */
 	{ }
 };
 
@@ -1327,11 +1319,6 @@ static struct ctl_table vm_table[] = {
 		.extra2		= &one,
 	},
 #endif
-
-/*
- * NOTE: do not add new entries to this table unless you have read
- * Documentation/sysctl/ctl_unnumbered.txt
- */
 	{ }
 };
 
@@ -1487,10 +1474,6 @@ static struct ctl_table fs_table[] = {
 		.proc_handler	= &pipe_proc_fn,
 		.extra1		= &pipe_min_size,
 	},
-/*
- * NOTE: do not add new entries to this table unless you have read
- * Documentation/sysctl/ctl_unnumbered.txt
- */
 	{ }
 };
 
