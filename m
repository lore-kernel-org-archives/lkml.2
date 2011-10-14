Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932118Ab1JNM2e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 08:28:34 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:57951 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756368Ab1JNM2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 08:28:31 -0400
Subject: [PATCH 04/21] um: drop unused Kconfig symbol
From: Paul Bolle <pebolle@tiscali.nl>
To: Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Oct 2011 14:27:47 +0200
Message-ID: <1318595267.6132.60.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 arch/um/Kconfig.x86 |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/um/Kconfig.x86 b/arch/um/Kconfig.x86
index 21bebe6..1d97bd8 100644
--- a/arch/um/Kconfig.x86
+++ b/arch/um/Kconfig.x86
@@ -57,9 +57,6 @@ config ARCH_HAS_SC_SIGNALS
 config ARCH_REUSE_HOST_VSYSCALL_AREA
 	def_bool !64BIT
 
-config SMP_BROKEN
-	def_bool 64BIT
-
 config GENERIC_HWEIGHT
 	def_bool y
 
-- 
1.7.4.4




