Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041Ab1B0Eez (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 23:34:55 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40844 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746Ab1B0Eew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 23:34:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=mtqe8Yvd6P6cvOPoHlYSPSfX5mDgjtfWnoPYHLLNsQvlASMBFvMRHRdx4FYZZIJzyE
         tvcn1NHqA3gW02vPw/40LnsqKzyercPGAhPaJjeq0ukLf0AJVha/kOxoSxby2JTUZNDY
         JJP8umg0Uuy5xz5Gbc6zoDtyNAc0r1KCRzVCY=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        Eric Paris <eparis@redhat.com>
Subject: [PATCH 13/17]fs:notify:fanotify:fanotify_user.c Remove one to many n's in a word.
Date: Sat, 26 Feb 2011 20:34:06 -0800
Message-Id: <1298781250-2718-14-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1298781250-2718-1-git-send-email-justinmattock@gmail.com>
References: <1298781250-2718-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Patch below removes one to many "n's" in a word..

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
CC: Eric Paris <eparis@redhat.com> 
---
 fs/notify/fanotify/fanotify_user.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 8b61220..6b1305d 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -876,7 +876,7 @@ SYSCALL_ALIAS(sys_fanotify_mark, SyS_fanotify_mark);
 #endif
 
 /*
- * fanotify_user_setup - Our initialization function.  Note that we cannnot return
+ * fanotify_user_setup - Our initialization function.  Note that we cannot return
  * error because we have compiled-in VFS hooks.  So an (unlikely) failure here
  * must result in panic().
  */
-- 
1.7.4.1

