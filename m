Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152Ab1B0Efp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 23:35:45 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:60433 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab1B0Eex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 23:34:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=GKBSpzPJ1+EYxegGqSJNZ6+fVaUoP1duJVZR5s1n2dZ6SOQpXTDl0MxMXaAaOlbQT5
         fEXuhyvv2f6tz1T9gINMXnTXE4T2+quKw7rxaYDdv/T1CVmGVljlmuzZdSE36kmE0G78
         9ko1yM8gQLn1nMUWWbXHMNxMA6OFdiFuSLo4k=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        John McCutchan <john@johnmccutchan.com>, Robert Love <rlove@rlove.org>
Subject: [PATCH 14/17]fs:notify:inotify:inotify_user.c Remove one to many n's in a word.
Date: Sat, 26 Feb 2011 20:34:07 -0800
Message-Id: <1298781250-2718-15-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1298781250-2718-1-git-send-email-justinmattock@gmail.com>
References: <1298781250-2718-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Patch below removes one to many "n's" in a word..

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
CC: John McCutchan <john@johnmccutchan.com>
CC: Robert Love <rlove@rlove.org>
---
 fs/notify/inotify/inotify_user.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index 4cd5d5d..bd46e7c 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -841,7 +841,7 @@ out:
 }
 
 /*
- * inotify_user_setup - Our initialization function.  Note that we cannnot return
+ * inotify_user_setup - Our initialization function.  Note that we cannot return
  * error because we have compiled-in VFS hooks.  So an (unlikely) failure here
  * must result in panic().
  */
-- 
1.7.4.1

