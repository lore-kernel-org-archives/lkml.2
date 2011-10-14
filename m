Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932748Ab1JNM2q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 08:28:46 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:57992 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932533Ab1JNM2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 08:28:44 -0400
Subject: [PATCH 05/21] sh: drop unused Kconfig symbol
From: Paul Bolle <pebolle@tiscali.nl>
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Oct 2011 14:28:00 +0200
Message-ID: <1318595280.6132.61.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 arch/sh/Kconfig |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index ff9177c..2d39594 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -101,10 +101,6 @@ config GENERIC_LOCKBREAK
 	def_bool y
 	depends on SMP && PREEMPT
 
-config SYS_SUPPORTS_PM
-	bool
-	depends on !SMP
-
 config ARCH_SUSPEND_POSSIBLE
 	def_bool n
 
-- 
1.7.4.4




