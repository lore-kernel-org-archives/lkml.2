Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932817Ab1JNMaU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 08:30:20 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:58509 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932180Ab1JNMaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 08:30:14 -0400
Subject: [PATCH 13/21] openrisc: drop unused Kconfig symbols
From: Paul Bolle <pebolle@tiscali.nl>
To: Jonas Bonn <jonas@southpole.se>
Cc: linux@openrisc.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Oct 2011 14:29:43 +0200
Message-ID: <1318595383.6132.71.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 arch/openrisc/Kconfig |   12 ------------
 1 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/arch/openrisc/Kconfig b/arch/openrisc/Kconfig
index 4558baf..fe4b912 100644
--- a/arch/openrisc/Kconfig
+++ b/arch/openrisc/Kconfig
@@ -19,9 +19,6 @@ config OPENRISC
 config MMU
 	def_bool y
 
-config WISHBONE_BUS_BIG_ENDIAN
-	def_bool y
-
 config SYMBOL_PREFIX
         string
         default ""
@@ -160,15 +157,6 @@ config JUMP_UPON_UNHANDLED_EXCEPTION
 
 	  Say Y if you are unsure.
 
-config OPENRISC_EXCEPTION_DEBUG
-	bool "Print processor state at each exception"
-	default n
-	help
-	  This option will make your kernel unusable for all but kernel
-	  debugging.
-
-	  Say N if you are unsure.
-
 config OPENRISC_ESR_EXCEPTION_BUG_CHECK
 	bool "Check for possible ESR exception bug"
 	default n
-- 
1.7.4.4




