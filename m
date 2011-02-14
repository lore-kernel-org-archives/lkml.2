Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751475Ab1BNSkp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 13:40:45 -0500
Received: from hera.kernel.org ([140.211.167.34]:37930 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750980Ab1BNSkn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 13:40:43 -0500
Date: Mon, 14 Feb 2011 18:39:59 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, jdike@addtoit.com, hpa@zytor.com,
        mingo@redhat.com, akpm@linux-foundation.org, peterz@infradead.org,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, jdike@addtoit.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <20110206224515.135703209@linutronix.de>
References: <20110206224515.135703209@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:um/irq] um: Remove stale irq_chip.end
Message-ID: <tip-6ea96e7e4946f790330557e4b7c4c8a174c1c6d2@git.kernel.org>
Git-Commit-ID: 6ea96e7e4946f790330557e4b7c4c8a174c1c6d2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 14 Feb 2011 18:40:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6ea96e7e4946f790330557e4b7c4c8a174c1c6d2
Gitweb:     http://git.kernel.org/tip/6ea96e7e4946f790330557e4b7c4c8a174c1c6d2
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sun, 6 Feb 2011 22:45:31 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 14 Feb 2011 19:37:39 +0100

um: Remove stale irq_chip.end

irq_chip.end got obsolete with the remnoval of __do_IRQ().

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <20110206224515.135703209@linutronix.de>
---
 arch/um/kernel/irq.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/um/kernel/irq.c b/arch/um/kernel/irq.c
index 3f0ac9e..c916748 100644
--- a/arch/um/kernel/irq.c
+++ b/arch/um/kernel/irq.c
@@ -374,7 +374,6 @@ static struct irq_chip normal_irq_type = {
 	.disable = dummy,
 	.enable = dummy,
 	.ack = dummy,
-	.end = dummy
 };
 
 static struct irq_chip SIGVTALRM_irq_type = {
@@ -384,7 +383,6 @@ static struct irq_chip SIGVTALRM_irq_type = {
 	.disable = dummy,
 	.enable = dummy,
 	.ack = dummy,
-	.end = dummy
 };
 
 void __init init_IRQ(void)
