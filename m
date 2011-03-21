Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957Ab1CUT0B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 15:26:01 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:47302 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751803Ab1CUT0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 15:26:00 -0400
X-Authenticated: #41721828
X-Provags-ID: V01U2FsdGVkX1+4uZBcqGK4xfNSD25pB1RYsDR5xWx43xhKzd6DT0
	FvKUiUbDGoAom2
From: =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Kosina <trivial@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
Subject: [PATCH v2] sched.h: fix a typo ("its")
Date: Mon, 21 Mar 2011 20:24:47 +0100
Message-Id: <1300735487-2406-1-git-send-email-j.neuschaefer@gmx.net>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <20110321180845.GC4849@elte.hu>
References: <20110321180845.GC4849@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sentence uses the possessive pronoun, which is spelled without
an apostrophe.

Signed-off-by: Jonathan Neuschäfer <j.neuschaefer@gmx.net>
---
 v2: correctly spell "sentence" in the commit message itself

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

