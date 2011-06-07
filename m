Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857Ab1FGPls (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 11:41:48 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39933 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573Ab1FGPlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 11:41:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=akshayjoshi.com; s=google;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=VMhZRQnf2wapg41Ck6wU0Ohd9vmtfQvo9mLoffsAeNei1L7eKtU2O39HzcdL0+/NOK
         j4wSndfzBzw4/T5Auw7AEXMrDmdLw5yf9ZusT/YeZs5UX61ZpbfezM5RUj6GzCr9GKOg
         rKQlp3hPsOwx8QGKUAuoYMwK5zJcWxb/7ypBk=
From: Akshay Joshi <me@akshayjoshi.com>
Cc: Akshay Joshi <me@akshayjoshi.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Namhyung Kim <namhyung@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        David Howells <dhowells@redhat.com>, Hillf Danton <dhillf@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] Kernel: Fix trailing whitespace in user.c.
Date: Tue,  7 Jun 2011 11:41:06 -0400
Message-Id: <1307461267-23065-1-git-send-email-me@akshayjoshi.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1307443181-22278-2-git-send-email-me@akshayjoshi.com>
References: <1307443181-22278-2-git-send-email-me@akshayjoshi.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove trailing whitespace, as reported by checkpatch.pl, in the user.c
file.

Signed-off-by: Akshay Joshi <me@akshayjoshi.com>
Acked-by: David Howells <dhowells@redhat.com>
---
 kernel/user.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/user.c b/kernel/user.c
index 9e03e9c..94b4686 100644
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -5,7 +5,7 @@
  *
  * We have a per-user structure to keep track of how many
  * processes, files etc the user has claimed, in order to be
- * able to have per-user limits for system resources. 
+ * able to have per-user limits for system resources.
  */
 
 #include <linux/init.h>
-- 
1.7.4.4

