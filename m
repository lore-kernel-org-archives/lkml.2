Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154Ab0LIEU3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 23:20:29 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:37157 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631Ab0LIEU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 23:20:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=omg88vPdJy6BxNZ48efeLdIQ5Y0z5dGXI6N+whRuvnKsVS9ZXIGZXtU+rdEhzrOEyr
         UF2O/5uMmNTntxpJHAabGzOzRJ3Vl+DAVpIU+eJJqARvFnpWvr4c1CG9sdtAF9d/3+Qz
         fjRZArvzbNFmfhqy8qt+OO0O8pJrz+Dr10sIs=
From: Namhyung Kim <namhyung@gmail.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] poll: fix a typo in comment
Date: Thu,  9 Dec 2010 13:20:01 +0900
Message-Id: <1291868401-32237-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.3.3.400.g93cef
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 include/linux/poll.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/poll.h b/include/linux/poll.h
index 56e76af78102..afd3375e58ee 100644
--- a/include/linux/poll.h
+++ b/include/linux/poll.h
@@ -57,7 +57,7 @@ struct poll_table_entry {
 };
 
 /*
- * Structures and helpers for sys_poll/sys_poll
+ * Structures and helpers for sys_select/sys_poll
  */
 struct poll_wqueues {
 	poll_table pt;
-- 
1.7.3.3.400.g93cef

