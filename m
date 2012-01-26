Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346Ab2AZNjJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 08:39:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36074 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390Ab2AZNjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 08:39:07 -0500
Date: Thu, 26 Jan 2012 05:38:45 -0800
From: tip-bot for Daniel J Blueman <daniel@numascale-asia.com>
Message-ID: <tip-3fe54564a61f72982032423d24041dca30617ca2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        sp@numascale.com, tglx@linutronix.de, mingo@elte.hu,
        daniel@numascale-asia.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, sp@numascale.com, daniel@numascale-asia.com,
        mingo@elte.hu
In-Reply-To: <1327473349-28395-1-git-send-email-daniel@numascale-asia.com>
References: <1327473349-28395-1-git-send-email-daniel@numascale-asia.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/numachip: Drop unnecessary conflict with EDAC
Git-Commit-ID: 3fe54564a61f72982032423d24041dca30617ca2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 26 Jan 2012 05:38:51 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3fe54564a61f72982032423d24041dca30617ca2
Gitweb:     http://git.kernel.org/tip/3fe54564a61f72982032423d24041dca30617ca2
Author:     Daniel J Blueman <daniel@numascale-asia.com>
AuthorDate: Wed, 25 Jan 2012 14:35:49 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 26 Jan 2012 11:03:03 +0100

x86/numachip: Drop unnecessary conflict with EDAC

EDAC detection no longer crashes multi-node systems, so don't
conflict on it with NumaChip.

Signed-off-by: Daniel J Blueman <daniel@numascale-asia.com>
Cc: Steffen Persvold <sp@numascale.com>
Link: http://lkml.kernel.org/r/1327473349-28395-1-git-send-email-daniel@numascale-asia.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 864cc6e..5bed94e 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -360,7 +360,6 @@ config X86_NUMACHIP
 	depends on NUMA
 	depends on SMP
 	depends on X86_X2APIC
-	depends on !EDAC_AMD64
 	---help---
 	  Adds support for Numascale NumaChip large-SMP systems. Needed to
 	  enable more than ~168 cores.
