Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751433Ab2AYGgf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 01:36:35 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61577 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895Ab2AYGge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 01:36:34 -0500
MIME-Version: 1.0
From: Daniel J Blueman <daniel@numascale-asia.com>
To: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>
Cc: Steffen Persvold <sp@numascale.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Daniel J Blueman <daniel@numascale-asia.com>
Subject: [PATCH] Drop unnecessary NumaChip conflict with EDAC
Date: Wed, 25 Jan 2012 14:35:49 +0800
Message-Id: <1327473349-28395-1-git-send-email-daniel@numascale-asia.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

EDAC detection no longer crashes multi-node systems, so don't
conflict on it with NumaChip.

Signed-off-by: Daniel J Blueman <daniel@numascale-asia.com>
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
-- 
1.7.5.4

