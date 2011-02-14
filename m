Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882Ab1BNSl4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 13:41:56 -0500
Received: from hera.kernel.org ([140.211.167.34]:38529 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751050Ab1BNSly (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 13:41:54 -0500
Date: Mon, 14 Feb 2011 18:41:20 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, jdike@addtoit.com, hpa@zytor.com,
        mingo@redhat.com, akpm@linux-foundation.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, jdike@addtoit.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        tglx@linutronix.de
In-Reply-To: <20110206224515.430825903@linutronix.de>
References: <20110206224515.430825903@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:um/irq] um: Select GENERIC_HARDIRQS_NO_DEPRECATED
Message-ID: <tip-53c39ce56d203d80ba8217a16bb024b25185fb7e@git.kernel.org>
Git-Commit-ID: 53c39ce56d203d80ba8217a16bb024b25185fb7e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 14 Feb 2011 18:41:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  53c39ce56d203d80ba8217a16bb024b25185fb7e
Gitweb:     http://git.kernel.org/tip/53c39ce56d203d80ba8217a16bb024b25185fb7e
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sun, 6 Feb 2011 22:45:38 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 14 Feb 2011 19:37:40 +0100

um: Select GENERIC_HARDIRQS_NO_DEPRECATED

irq chips converted and proper accessor functions used.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <20110206224515.430825903@linutronix.de>
---
 arch/um/Kconfig.common |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/um/Kconfig.common b/arch/um/Kconfig.common
index e351e14..1e78940 100644
--- a/arch/um/Kconfig.common
+++ b/arch/um/Kconfig.common
@@ -7,6 +7,7 @@ config UML
 	bool
 	default y
 	select HAVE_GENERIC_HARDIRQS
+	select GENERIC_HARDIRQS_NO_DEPRECATED
 
 config MMU
 	bool
