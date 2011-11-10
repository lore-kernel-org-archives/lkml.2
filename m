Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932829Ab1KJSuA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 13:50:00 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42850 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932774Ab1KJSt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 13:49:57 -0500
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
        linux-kernel@vger.kernel.org
Cc: David Daney <david.daney@cavium.com>
Subject: [PATCH Resend 2/2] MIPS: Randomize PIE load address
Date: Thu, 10 Nov 2011 10:49:50 -0800
Message-Id: <1320950990-10827-2-git-send-email-david.daney@cavium.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1320950990-10827-1-git-send-email-david.daney@cavium.com>
References: <1320950990-10827-1-git-send-email-david.daney@cavium.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... by selecting ARCH_BINFMT_ELF_RANDOMIZE_PIE

Signed-off-by: David Daney <david.daney@cavium.com>
---
 arch/mips/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 8f1b76a..64934ad 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -25,6 +25,7 @@ config MIPS
 	select GENERIC_IRQ_SHOW
 	select HAVE_ARCH_JUMP_LABEL
 	select IRQ_FORCED_THREADING
+	select ARCH_BINFMT_ELF_RANDOMIZE_PIE
 
 menu "Machine selection"
 
-- 
1.7.2.3

