Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967364Ab2EQQlj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 12:41:39 -0400
Received: from mail.windriver.com ([147.11.1.11]:40085 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967339Ab2EQQlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 12:41:36 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: JBottomley@parallels.com, Paul Gortmaker <paul.gortmaker@windriver.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 1/5] arm: remove ability to select CONFIG_MCA
Date: Thu, 17 May 2012 12:40:37 -0400
Message-Id: <1337272841-25931-2-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1337272841-25931-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337272841-25931-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It isn't clear to me why this ever existed, as I've never heard
of an ARM board with an MCA bus.  Regardless, the MCA bus support
is going away, so remove the ability to select it from ARM.

Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/arm/Kconfig |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 36586dba..695cc39 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -101,14 +101,6 @@ config EISA
 config SBUS
 	bool
 
-config MCA
-	bool
-	help
-	  MicroChannel Architecture is found in some IBM PS/2 machines and
-	  laptops.  It is a bus system similar to PCI or ISA. See
-	  <file:Documentation/mca.txt> (and especially the web page given
-	  there) before attempting to build an MCA bus kernel.
-
 config STACKTRACE_SUPPORT
 	bool
 	default y
-- 
1.7.9.1

