Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635Ab2CCOTK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 09:19:10 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64897 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254Ab2CCOTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 09:19:08 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of luciarosculete@gmail.com designates 10.213.17.77 as permitted sender) smtp.mail=luciarosculete@gmail.com; dkim=pass header.i=luciarosculete@gmail.com
From: Lucia Rosculete <luciarosculete@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, Lucia Rosculete <luciarosculete@gmail.com>
Subject: [PATCH] semaphore: fix comment
Date: Sat,  3 Mar 2012 16:18:47 +0200
Message-Id: <1330784327-7172-1-git-send-email-luciarosculete@gmail.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	 Replace "mutex" with "semaphore" in down_trylock comment

Signed-off-by: Lucia Rosculete <luciarosculete@gmail.com>
---
 kernel/semaphore.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/semaphore.c b/kernel/semaphore.c
index 60636a4..4567fc0 100644
--- a/kernel/semaphore.c
+++ b/kernel/semaphore.c
@@ -118,7 +118,7 @@ EXPORT_SYMBOL(down_killable);
  * down_trylock - try to acquire the semaphore, without waiting
  * @sem: the semaphore to be acquired
  *
- * Try to acquire the semaphore atomically.  Returns 0 if the mutex has
+ * Try to acquire the semaphore atomically.  Returns 0 if the semaphore has
  * been acquired successfully or 1 if it it cannot be acquired.
  *
  * NOTE: This return value is inverted from both spin_trylock and
-- 
1.7.6.3

