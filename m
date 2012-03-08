Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793Ab2CHKTi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 05:19:38 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51013 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652Ab2CHKTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 05:19:36 -0500
Date: Thu, 8 Mar 2012 02:18:54 -0800
From: tip-bot for Jan Beulich <JBeulich@suse.com>
Message-ID: <tip-a240ada241dafe290e7532d1ddeb98fdf1419068@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        jbeulich@suse.com, JBeulich@suse.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        JBeulich@suse.com, jbeulich@suse.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <4F5888F902000078000770F1@nat28.tlf.novell.com>
References: <4F5888F902000078000770F1@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86: Include probe_roms.h in probe_roms.c
Git-Commit-ID: a240ada241dafe290e7532d1ddeb98fdf1419068
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 08 Mar 2012 02:19:21 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a240ada241dafe290e7532d1ddeb98fdf1419068
Gitweb:     http://git.kernel.org/tip/a240ada241dafe290e7532d1ddeb98fdf1419068
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Thu, 8 Mar 2012 09:24:57 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 8 Mar 2012 10:57:35 +0100

x86: Include probe_roms.h in probe_roms.c

... to ensure that declarations and definitions are in sync.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Link: http://lkml.kernel.org/r/4F5888F902000078000770F1@nat28.tlf.novell.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/probe_roms.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/probe_roms.c b/arch/x86/kernel/probe_roms.c
index 34e06e8..0bc72e2 100644
--- a/arch/x86/kernel/probe_roms.c
+++ b/arch/x86/kernel/probe_roms.c
@@ -12,6 +12,7 @@
 #include <linux/pci.h>
 #include <linux/export.h>
 
+#include <asm/probe_roms.h>
 #include <asm/pci-direct.h>
 #include <asm/e820.h>
 #include <asm/mmzone.h>
