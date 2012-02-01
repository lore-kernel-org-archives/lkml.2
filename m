Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab2BAGDA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 01:03:00 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55986 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244Ab2BAGC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 01:02:59 -0500
From: Geunsik Lim <geunsik.lim@gmail.com>
To: Jiri Kosina <trivial@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] Description of task_struct.personality element
Date: Wed,  1 Feb 2012 15:02:45 +0900
Message-Id: <1328076165-17936-1-git-send-email-geunsik.lim@gmail.com>
X-Mailer: git-send-email 1.7.8.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is trivial patch for helpful description of
task_struct.personality elements. '???'description is
not suitable to understand a element meaning of data structure.

Signed-off-by: Geunsik Lim <geunsik.lim@samsung.com>
---
 include/linux/sched.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 2234985..81e9de9 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1307,8 +1307,7 @@ struct task_struct {
 	int exit_code, exit_signal;
 	int pdeath_signal;  /*  The signal sent when the parent dies  */
 	unsigned int jobctl;	/* JOBCTL_*, siglock protected */
-	/* ??? */
-	unsigned int personality;
+	unsigned int personality; /* Personality types of process */
 	unsigned did_exec:1;
 	unsigned in_execve:1;	/* Tell the LSMs that the process is doing an
 				 * execve */
-- 
1.7.8.1

