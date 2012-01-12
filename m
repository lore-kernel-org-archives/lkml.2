Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417Ab2ALR2U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 12:28:20 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:48560 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860Ab2ALR2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 12:28:19 -0500
Subject: [PATCH] sched: Update scheduler stat documentation.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: mingo@elte.hu, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 Jan 2012 23:27:02 +0600
Message-ID: <1326389222.9115.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/proc/schedstat's second field reflect to # of time context switch happened not # of times switched to the expired queue.

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
---

diff --git a/Documentation/scheduler/sched-stats.txt b/Documentation/scheduler/sched-stats.txt
index 1cd5d51..7d8e12c 100644
--- a/Documentation/scheduler/sched-stats.txt
+++ b/Documentation/scheduler/sched-stats.txt
@@ -38,7 +38,8 @@ First field is a sched_yield() statistic:
      1) # of times sched_yield() was called
 
 Next three are schedule() statistics:
-     2) # of times we switched to the expired queue and reused it
+     2) # of times context switch happened. This field is not utilized these
+	days but kept for holding userspace tools integrity.
      3) # of times schedule() was called
      4) # of times schedule() left the processor idle
 


