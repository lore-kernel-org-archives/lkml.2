Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932150Ab1C1Qaw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 12:30:52 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39860 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932103Ab1C1Qau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 12:30:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=w1b9rMxT0/xmmCkr8bIaXkpMxqR7FhzkXCWoLHTvzAaFU4QGLWBwP6cGfpN9xWxWVQ
         TPxp5Q+cUOmaMRXuqnz1PayHbsLb3fygGrNhEjIU9I0VViR54xSsNO8b7wRzYdiaQPRV
         qPxucKHnVWJF60mBVNM/r40XuwMCxRHy+/cI8=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 23/25]lib:dynamic_debug.c Remove version.h since it is unused.
Date: Mon, 28 Mar 2011 09:29:46 -0700
Message-Id: <1301329788-3423-24-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1301329788-3423-1-git-send-email-justinmattock@gmail.com>
References: <1301329788-3423-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes <linux/version.h> since it is nolonger
in the kernel.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 lib/dynamic_debug.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 75ca78f..79fc20b 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -14,7 +14,6 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/kallsyms.h>
-#include <linux/version.h>
 #include <linux/types.h>
 #include <linux/mutex.h>
 #include <linux/proc_fs.h>
-- 
1.7.4.1

