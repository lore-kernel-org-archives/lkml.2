Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932559Ab0JLTYu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 15:24:50 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:36210 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932349Ab0JLTYt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 15:24:49 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTi=s8tr5Mnx8GeX9Sp6N5CR3NQE7VOdJ9u+7+V8w@mail.gmail.com>
References: <AANLkTi=s8tr5Mnx8GeX9Sp6N5CR3NQE7VOdJ9u+7+V8w@mail.gmail.com>
Date: Tue, 12 Oct 2010 12:24:45 -0700
Message-ID: <AANLkTinxgurYfHosAgEETggCAirjMDEaG3YSE4dKdOad@mail.gmail.com>
Subject: Kconfig.preempt advertises no longer existing hardirq-preempt option
 and related proc entries.
From: Blaise Gassend <blaise@willowgarage.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seems like the documentation for PREEMPT_HARDIRQS has fallen behind
the code. I would like to submit the following patch to fix that
situation. Anybody happen to know why the option and proc entry were
removed? I would have loved to have used them...

Signed-off-by: Blaise Gassend <blaise@willowgarage.com>

diff -ru linux-2.6.33.7-rt29/kernel/Kconfig.preempt
linux-2.6.33.7-rt29-modified/kernel/Kconfig.preempt
--- linux-2.6.33.7-rt29/kernel/Kconfig.preempt  2010-10-12
09:59:18.335119093 -0700
+++ linux-2.6.33.7-rt29-modified/kernel/Kconfig.preempt 2010-10-12
10:01:17.185554319 -0700
@@ -113,10 +113,4 @@
          in their own kernel thread context. While this helps latency,
          this feature can also reduce performance.

-          The threading of hardirqs can also be controlled via the
-          /proc/sys/kernel/hardirq_preemption runtime flag and the
-          hardirq-preempt=0/1 boot-time option. Per-irq threading can
-          be enabled/disable via the /proc/irq/<IRQ>/<handler>/threaded
-          runtime flags.
-
         Say N if you are unsure.
