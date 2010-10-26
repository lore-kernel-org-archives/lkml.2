Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932613Ab0JZT5p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 15:57:45 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39471 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758450Ab0JZT5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 15:57:36 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 04/22] trivial: fix typos concerning "already"
Date: Tue, 26 Oct 2010 21:57:01 +0200
Message-Id: <1288123039-22368-4-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1288123039-22368-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1288123039-22368-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 kernel/sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 41f1869..c7a394e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2568,7 +2568,7 @@ out:
  * try_to_wake_up_local - try to wake up a local task with rq lock held
  * @p: the thread to be awakened
  *
- * Put @p on the run-queue if it's not alredy there.  The caller must
+ * Put @p on the run-queue if it's not already there.  The caller must
  * ensure that this_rq() is locked, @p is bound to this_rq() and not
  * the current task.  this_rq() stays locked over invocation.
  */
-- 
1.7.2.3

