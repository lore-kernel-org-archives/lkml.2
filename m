Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228Ab2FTRGa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 13:06:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38697 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678Ab2FTRG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 13:06:29 -0400
Date: Wed, 20 Jun 2012 10:06:14 -0700
From: tip-bot for Jan Beulich <JBeulich@suse.com>
Message-ID: <tip-0d26d1d873a302828e064737746c53a2689e6c0f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jbeulich@suse.com, JBeulich@suse.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        JBeulich@suse.com, jbeulich@suse.com, tglx@linutronix.de
In-Reply-To: <4FDF1F5C020000780008A661@nat28.tlf.novell.com>
References: <4FDF1F5C020000780008A661@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/debug] x86/mm: Mark free_initrd_mem() as __init
Git-Commit-ID: 0d26d1d873a302828e064737746c53a2689e6c0f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 20 Jun 2012 10:06:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0d26d1d873a302828e064737746c53a2689e6c0f
Gitweb:     http://git.kernel.org/tip/0d26d1d873a302828e064737746c53a2689e6c0f
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Mon, 18 Jun 2012 11:30:20 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 20 Jun 2012 14:33:47 +0200

x86/mm: Mark free_initrd_mem() as __init

... matching various other architectures.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Link: http://lkml.kernel.org/r/4FDF1F5C020000780008A661@nat28.tlf.novell.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/mm/init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index bc4e9d8..e0e6990 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -385,7 +385,7 @@ void free_initmem(void)
 }
 
 #ifdef CONFIG_BLK_DEV_INITRD
-void free_initrd_mem(unsigned long start, unsigned long end)
+void __init free_initrd_mem(unsigned long start, unsigned long end)
 {
 	/*
 	 * end could be not aligned, and We can not align that,
