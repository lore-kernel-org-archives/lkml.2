Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154Ab1JLMvP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 08:51:15 -0400
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:57428 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941Ab1JLMvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 08:51:14 -0400
Subject: [PATCH] [TRIVIAL] parisc: Kconfig: cleanup Kernel page size default
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Oct 2011 14:51:12 +0200
Message-ID: <1318423872.2336.19.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
"Kernel page size" still defaults to "4KB", for both 32 and 64 bit
processors, when tested with "make ARCH=parisc menuconfig", which is
good.

 arch/parisc/Kconfig |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index e077b0b..fdfd8be 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -169,9 +169,7 @@ config 64BIT
 
 choice
 	prompt "Kernel page size"
-	default PARISC_PAGE_SIZE_4KB  if !64BIT
-	default PARISC_PAGE_SIZE_4KB  if 64BIT
-#	default PARISC_PAGE_SIZE_16KB if 64BIT
+	default PARISC_PAGE_SIZE_4KB
 
 config PARISC_PAGE_SIZE_4KB
 	bool "4KB"
-- 
1.7.4.4

