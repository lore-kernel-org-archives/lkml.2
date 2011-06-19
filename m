Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197Ab1FSJux (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 05:50:53 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:49848 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752814Ab1FSJuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 05:50:52 -0400
X-Authenticated: #41721828
X-Provags-ID: V01U2FsdGVkX1/FLi4+IRTFEouIyjJ7x4BlC5PuWO+Ho6h5hvh0JE
	q74s8GNu5LoQVY
From: =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
To: Jiri Kosina <trivial@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
Subject: [PATCH trivial] stop_machine.h: "disables preeempt" -> "disables preemption"
Date: Sun, 19 Jun 2011 11:50:22 +0200
Message-Id: <1308477022-13299-1-git-send-email-j.neuschaefer@gmx.net>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the noun instead of a misspelled verb.

Signed-off-by: Jonathan Neuschäfer <j.neuschaefer@gmx.net>
---
 include/linux/stop_machine.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/stop_machine.h b/include/linux/stop_machine.h
index 092dc9b..2d3f0b1 100644
--- a/include/linux/stop_machine.h
+++ b/include/linux/stop_machine.h
@@ -94,7 +94,7 @@ static inline int try_stop_cpus(const struct cpumask *cpumask,
  * stop_machine "Bogolock": stop the entire machine, disable
  * interrupts.  This is a very heavy lock, which is equivalent to
  * grabbing every spinlock (and more).  So the "read" side to such a
- * lock is anything which disables preeempt.
+ * lock is anything which disables preemption.
  */
 #if defined(CONFIG_STOP_MACHINE) && defined(CONFIG_SMP)
 
-- 
1.7.5.4

