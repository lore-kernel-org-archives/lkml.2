Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235Ab1LPLfD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 06:35:03 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47636 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab1LPLe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 06:34:58 -0500
Date: Fri, 16 Dec 2011 03:34:35 -0800
From: tip-bot for Alan Cox <alan@linux.intel.com>
Message-ID: <tip-r0oc1knlvzuqr69artaeq8s8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, alan@linux.intel.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86: Fix INTEL_MID silly
Git-Commit-ID: 3e8f9451d3db669d7c0d8b330d4f5770149d90d5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 16 Dec 2011 03:34:42 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3e8f9451d3db669d7c0d8b330d4f5770149d90d5
Gitweb:     http://git.kernel.org/tip/3e8f9451d3db669d7c0d8b330d4f5770149d90d5
Author:     Alan Cox <alan@linux.intel.com>
AuthorDate: Thu, 15 Dec 2011 22:19:41 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 16 Dec 2011 09:33:17 +0100

x86: Fix INTEL_MID silly

Doh.. pass the brown paper bags - preferably filled with mince
pies..

This fixes occasional build failures.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Link: http://lkml.kernel.org/n/tip-r0oc1knlvzuqr69artaeq8s8@git.kernel.org
[ extended the changelog a bit ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index faf39a0..2b54a2f 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -429,6 +429,7 @@ config X86_MDFLD
 	select SPI
 	select INTEL_SCU_IPC
 	select X86_PLATFORM_DEVICES
+	select X86_INTEL_MID
 	---help---
 	  Medfield is Intel's Low Power Intel Architecture (LPIA) based Moblin
 	  Internet Device(MID) platform. 
