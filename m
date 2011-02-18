Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197Ab1BRQHR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 11:07:17 -0500
Received: from hera.kernel.org ([140.211.167.34]:48841 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752856Ab1BRQHN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 11:07:13 -0500
Date: Fri, 18 Feb 2011 16:06:56 GMT
From: tip-bot for Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        bigeasy@linutronix.de, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, bigeasy@linutronix.de
In-Reply-To: <1292600033-12271-16-git-send-email-bigeasy@linutronix.de>
References: <1292600033-12271-16-git-send-email-bigeasy@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86/pci: Remove unused variable
Message-ID: <tip-13884c6680973f0ce3483dc59b636b4962d6dafe@git.kernel.org>
Git-Commit-ID: 13884c6680973f0ce3483dc59b636b4962d6dafe
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 18 Feb 2011 16:06:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  13884c6680973f0ce3483dc59b636b4962d6dafe
Gitweb:     http://git.kernel.org/tip/13884c6680973f0ce3483dc59b636b4962d6dafe
Author:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
AuthorDate: Fri, 17 Dec 2010 16:33:53 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 18 Feb 2011 16:57:18 +0100

x86/pci: Remove unused variable

|arch/x86/pci/ce4100.c: In function `ce4100_conf_read':
|arch/x86/pci/ce4100.c:257:9: warning: unused variable `retval'

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: dirk.brandewie@gmail.com
LKML-Reference: <1292600033-12271-16-git-send-email-bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/pci/ce4100.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/pci/ce4100.c b/arch/x86/pci/ce4100.c
index 85b68ef..c63c6d3 100644
--- a/arch/x86/pci/ce4100.c
+++ b/arch/x86/pci/ce4100.c
@@ -254,7 +254,7 @@ int bridge_read(unsigned int devfn, int reg, int len, u32 *value)
 static int ce4100_conf_read(unsigned int seg, unsigned int bus,
 			    unsigned int devfn, int reg, int len, u32 *value)
 {
-	int i, retval = 1;
+	int i;
 
 	if (bus == 1) {
 		for (i = 0; i < ARRAY_SIZE(bus1_fixups); i++) {
