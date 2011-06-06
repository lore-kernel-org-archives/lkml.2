Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757681Ab1FFTAH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 15:00:07 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34179 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757506Ab1FFS6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 14:58:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=kwicl7FZl/3H6FM1ZPBlKOafOi75S7XEGla3COueoUZN5gZxN+RPBmwEcxgz6dMaaA
         psvFbVSRYFTbsCjKSi7hji3JCW2ZZz2ubX0WTLpE9O3VN81VjUqCp3EjF77gVtp9wd8A
         EemXqrsPb2paPo8viKIGaYhtoudan5MYv8fWY=
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Michal Marek <mmarek@suse.cz>, Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH 6/9] kconfig: nuke reference to SWIG
Date: Mon,  6 Jun 2011 14:58:28 -0400
Message-Id: <1307386711-8866-7-git-send-email-lacombar@gmail.com>
X-Mailer: git-send-email 1.7.3.4.574.g608b.dirty
In-Reply-To: <1307386711-8866-1-git-send-email-lacombar@gmail.com>
References: <1307386711-8866-1-git-send-email-lacombar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SWIG is not used (yet?) to create kconfig binding, so there is no point
referencing it.

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 scripts/kconfig/expr.h |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/scripts/kconfig/expr.h b/scripts/kconfig/expr.h
index 16bfae2..80fce57 100644
--- a/scripts/kconfig/expr.h
+++ b/scripts/kconfig/expr.h
@@ -172,8 +172,6 @@ struct menu {
 #define MENU_CHANGED		0x0001
 #define MENU_ROOT		0x0002
 
-#ifndef SWIG
-
 extern struct file *file_list;
 extern struct file *current_file;
 struct file *lookup_file(const char *name);
@@ -218,7 +216,6 @@ static inline int expr_is_no(struct expr *e)
 {
 	return e && (e->type == E_SYMBOL && e->left.sym == &symbol_no);
 }
-#endif
 
 #ifdef __cplusplus
 }
-- 
1.7.3.4.574.g608b.dirty

