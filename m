Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757194Ab2EYNiQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 09:38:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40060 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756068Ab2EYNiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 09:38:14 -0400
Date: Fri, 25 May 2012 06:37:57 -0700
From: tip-bot for Jan Beulich <JBeulich@suse.com>
Message-ID: <tip-1b38a3a10f2ad96a3c0130f63b7f3610bab7090d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jbeulich@suse.com, JBeulich@suse.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        JBeulich@suse.com, jbeulich@suse.com, tglx@linutronix.de
In-Reply-To: <4FBF7DA902000078000861EE@nat28.tlf.novell.com>
References: <4FBF7DA902000078000861EE@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: hpet:
  Fix copy-and-paste mistake in earlier change
Git-Commit-ID: 1b38a3a10f2ad96a3c0130f63b7f3610bab7090d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 25 May 2012 06:38:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1b38a3a10f2ad96a3c0130f63b7f3610bab7090d
Gitweb:     http://git.kernel.org/tip/1b38a3a10f2ad96a3c0130f63b7f3610bab7090d
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Fri, 25 May 2012 11:40:09 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 25 May 2012 15:32:29 +0200

x86: hpet: Fix copy-and-paste mistake in earlier change

This fixes an oversight in 396e2c6fed4ff13b53ce0e573105531cf53b0cad
("x86: Clear HPET configuration registers on startup"), noticed by
Thomas Gleixner.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Link: http://lkml.kernel.org/r/4FBF7DA902000078000861EE@nat28.tlf.novell.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/x86/kernel/hpet.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 9cc7b43..1460a5d 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -870,7 +870,7 @@ int __init hpet_enable(void)
 	else
 		pr_warn("HPET initial state will not be saved\n");
 	cfg &= ~(HPET_CFG_ENABLE | HPET_CFG_LEGACY);
-	hpet_writel(cfg, HPET_Tn_CFG(i));
+	hpet_writel(cfg, HPET_CFG);
 	if (cfg)
 		pr_warn("HPET: Unrecognized bits %#x set in global cfg\n",
 			cfg);
