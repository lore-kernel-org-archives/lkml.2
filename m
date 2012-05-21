Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757385Ab2EUJMN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 05:12:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38394 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757259Ab2EUJML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 05:12:11 -0400
Date: Mon, 21 May 2012 02:11:56 -0700
From: tip-bot for Anna-Maria Gleixner <anna-maria@glx-um.de>
Message-ID: <tip-6220443db41899606a8621215e0f6e99477f7152@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, msalter@redhat.com, anna-maria@glx-um.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, anna-maria@glx-um.de, msalter@redhat.com
In-Reply-To: <20120518163105.156595383@glx-um.de>
References: <20120518163105.156595383@glx-um.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] c6x: Use generic time config
Git-Commit-ID: 6220443db41899606a8621215e0f6e99477f7152
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 21 May 2012 02:12:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6220443db41899606a8621215e0f6e99477f7152
Gitweb:     http://git.kernel.org/tip/6220443db41899606a8621215e0f6e99477f7152
Author:     Anna-Maria Gleixner <anna-maria@glx-um.de>
AuthorDate: Fri, 18 May 2012 16:45:46 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 21 May 2012 11:01:41 +0200

c6x: Use generic time config

Signed-off-by: Anna-Maria Gleixner <anna-maria@glx-um.de>
Acked-by: Mark Salter <msalter@redhat.com>
Link: http://lkml.kernel.org/r/20120518163105.156595383@glx-um.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/c6x/Kconfig |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/arch/c6x/Kconfig b/arch/c6x/Kconfig
index 1c3ccd4..30c04c6 100644
--- a/arch/c6x/Kconfig
+++ b/arch/c6x/Kconfig
@@ -15,6 +15,7 @@ config TMS320C6X
 	select IRQ_DOMAIN
 	select OF
 	select OF_EARLY_FLATTREE
+	select GENERIC_CLOCKEVENTS
 
 config MMU
 	def_bool n
@@ -43,12 +44,6 @@ config GENERIC_CALIBRATE_DELAY
 config GENERIC_HWEIGHT
 	def_bool y
 
-config GENERIC_CLOCKEVENTS
-	def_bool y
-
-config GENERIC_CLOCKEVENTS_BROADCAST
-	bool
-
 config GENERIC_BUG
 	def_bool y
 
