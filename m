Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354Ab0HXHAo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 03:00:44 -0400
Received: from mail.windriver.com ([147.11.1.11]:42927 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754098Ab0HXHAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 03:00:06 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, akpm@linux-foundation.org, mingo@elte.hu,
        peterz@infradead.org, oleg@redhat.com
Subject: [RFC PATCH 1/3] timer: fix comments of try_to_del_timer_sync()
Date: Tue, 24 Aug 2010 14:58:47 +0800
Message-Id: <1282633129-9187-2-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1282633129-9187-1-git-send-email-yong.zhang0@gmail.com>
References: <1282633129-9187-1-git-send-email-yong.zhang0@gmail.com>
X-OriginalArrivalTime: 24 Aug 2010 06:58:55.0354 (UTC) FILETIME=[D157E5A0:01CB4359]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yong Zhang <yong.zhang@windriver.com>

In commit fd450b7318b75343fd76b3d95416853e34e72c95, it was saying
try_to_del_timer_sync() can be used in interrupt context. So make
the comments consistent to what it should be.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Oleg Nesterov <oleg@redhat.com>
---
 kernel/timer.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index 97bf05b..55b6a2d 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -943,8 +943,6 @@ EXPORT_SYMBOL(del_timer);
  *
  * This function tries to deactivate a timer. Upon successful (ret >= 0)
  * exit the timer is not queued and the handler is not running on any CPU.
- *
- * It must not be called from interrupt contexts.
  */
 int try_to_del_timer_sync(struct timer_list *timer)
 {
-- 
1.7.0.4

