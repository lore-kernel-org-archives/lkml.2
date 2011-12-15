Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932429Ab1LOJzs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 04:55:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38014 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756082Ab1LOJzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 04:55:46 -0500
Date: Thu, 15 Dec 2011 01:55:12 -0800
From: tip-bot for Joerg Roedel <joerg.roedel@amd.com>
Message-ID: <tip-969df4b82904a30fef19a67398a0c854d223ea67@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        joerg.roedel@amd.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        joerg.roedel@amd.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1323875574-17881-1-git-send-email-joerg.roedel@amd.com>
References: <1323875574-17881-1-git-send-email-joerg.roedel@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86: Report cpb and eff_freq_ro flags correctly
Git-Commit-ID: 969df4b82904a30fef19a67398a0c854d223ea67
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 15 Dec 2011 01:55:21 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  969df4b82904a30fef19a67398a0c854d223ea67
Gitweb:     http://git.kernel.org/tip/969df4b82904a30fef19a67398a0c854d223ea67
Author:     Joerg Roedel <joerg.roedel@amd.com>
AuthorDate: Wed, 14 Dec 2011 16:12:54 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 15 Dec 2011 08:14:49 +0100

x86: Report cpb and eff_freq_ro flags correctly

Add the flags to get rid of the [9] and [10] feature names
in cpuinfo's 'power management' fields and replace them with
meaningful names.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Link: http://lkml.kernel.org/r/1323875574-17881-1-git-send-email-joerg.roedel@amd.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/powerflags.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/powerflags.c b/arch/x86/kernel/cpu/powerflags.c
index 5abbea2..7b3fe56 100644
--- a/arch/x86/kernel/cpu/powerflags.c
+++ b/arch/x86/kernel/cpu/powerflags.c
@@ -16,5 +16,6 @@ const char *const x86_power_flags[32] = {
 	"100mhzsteps",
 	"hwpstate",
 	"",	/* tsc invariant mapped to constant_tsc */
-		/* nothing */
+	"cpb",  /* core performance boost */
+	"eff_freq_ro", /* Readonly aperf/mperf */
 };
