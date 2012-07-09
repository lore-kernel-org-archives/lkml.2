Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438Ab2GIMIV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 08:08:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53401 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341Ab2GIMIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 08:08:20 -0400
Date: Mon, 9 Jul 2012 05:08:05 -0700
From: tip-bot for Jean Delvare <jdelvare@suse.de>
Message-ID: <tip-2a8ac745e3171889d364235b8203342e28526d2c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        arjan@linux.intel.com, jdelvare@suse.de, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        arjan@linux.intel.com, tglx@linutronix.de, jdelvare@suse.de
In-Reply-To: <1341583705.4655.18.camel@amber.site>
References: <1341583705.4655.18.camel@amber.site>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: CONFIG_CC_STACKPROTECTOR=
 y is no longer experimental
Git-Commit-ID: 2a8ac745e3171889d364235b8203342e28526d2c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 09 Jul 2012 05:08:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2a8ac745e3171889d364235b8203342e28526d2c
Gitweb:     http://git.kernel.org/tip/2a8ac745e3171889d364235b8203342e28526d2c
Author:     Jean Delvare <jdelvare@suse.de>
AuthorDate: Fri, 6 Jul 2012 16:08:25 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 9 Jul 2012 13:59:53 +0200

x86: CONFIG_CC_STACKPROTECTOR=y is no longer experimental

This feature has been around for over 5 years now, and has no
CONFIG_EXPERIMENTAL dependency anymore, so remove the '(EXPERIMENTAL)'
tag from the help text as well.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Acked-by: Arjan van de Ven <arjan@linux.intel.com>
Link: http://lkml.kernel.org/r/1341583705.4655.18.camel@amber.site
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index c70684f..b03fe17 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1525,7 +1525,7 @@ config SECCOMP
 	  If unsure, say Y. Only embedded should say N here.
 
 config CC_STACKPROTECTOR
-	bool "Enable -fstack-protector buffer overflow detection (EXPERIMENTAL)"
+	bool "Enable -fstack-protector buffer overflow detection"
 	---help---
 	  This option turns on the -fstack-protector GCC feature. This
 	  feature puts, at the beginning of functions, a canary value on
