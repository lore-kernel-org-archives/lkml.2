Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659Ab0LIQ5g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 11:57:36 -0500
Received: from mail-px0-f179.google.com ([209.85.212.179]:57912 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753902Ab0LIQ5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 11:57:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ThAybq4sxwvDZwAWKcDs2rAMMkyXKek7Anhw2ZA12D/jnkFSgAEz/g0i8bpy9GxH36
         lTSDsgfn+Yj1bRH+BXRpw7jl16RXoFV/Ks0QACLEKs7YX5kG0gk/FjLi70opIugjY0y1
         vBii4fIGzBBgeVN6vFSYqGOZj1fgfmEVefF1Q=
From: Namhyung Kim <namhyung@gmail.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH UPDATED] poll: fix a typo in comment
Date: Fri, 10 Dec 2010 01:57:07 +0900
Message-Id: <1291913827-13558-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.3.3.400.g93cef
In-Reply-To: <AANLkTimUJ0mOkNe+ATAxDze_zHbWU8R1cJinEfX98Azw@mail.gmail.com>
References: <AANLkTimUJ0mOkNe+ATAxDze_zHbWU8R1cJinEfX98Azw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert duplicated sys_poll to select. As Kosaki suggests, sys_poll() and
sys_select() are now hidden by SYSCALL_DEFINEx() macros so it would be
better to use plain select/poll syscall name.

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
+ * Structures and helpers for select/poll syscall
  */
 struct poll_wqueues {
 	poll_table pt;
-- 
1.7.3.3.400.g93cef

