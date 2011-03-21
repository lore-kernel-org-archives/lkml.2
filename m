Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402Ab1CUM5i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 08:57:38 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:51391 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753334Ab1CUM5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 08:57:37 -0400
X-Authenticated: #41721828
X-Provags-ID: V01U2FsdGVkX1+x7C1Uap+xENy6VnxLZMdoQcM1Tkuc6XhSNJMZov
	mp75FlcVZf+ixX
From: =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
To: Jiri Kosina <trivial@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
Subject: [PATCH] sched.h: fix a typo ("its")
Date: Mon, 21 Mar 2011 13:54:00 +0100
Message-Id: <1300712040-7778-1-git-send-email-j.neuschaefer@gmx.net>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sectence uses the possessive pronoun, which is spelled without
an apostrophe.

Signed-off-by: Jonathan Neuschäfer <j.neuschaefer@gmx.net>
---
 include/linux/sched.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index c15936f..e89f129 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -516,7 +516,7 @@ struct thread_group_cputimer {
 struct autogroup;
 
 /*
- * NOTE! "signal_struct" does not have it's own
+ * NOTE! "signal_struct" does not have its own
  * locking, because a shared signal_struct always
  * implies a shared sighand_struct, so locking
  * sighand_struct is always a proper superset of
-- 
1.7.4.1

