Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756500Ab1JNM2z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 08:28:55 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:58041 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932459Ab1JNM2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 08:28:52 -0400
Subject: [PATCH 06/21] unicore32: drop unused Kconfig symbols
From: Paul Bolle <pebolle@tiscali.nl>
To: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Oct 2011 14:28:11 +0200
Message-ID: <1318595291.6132.63.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 arch/unicore32/Kconfig.debug |   14 --------------
 1 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/arch/unicore32/Kconfig.debug b/arch/unicore32/Kconfig.debug
index ae2ec33..1a36262 100644
--- a/arch/unicore32/Kconfig.debug
+++ b/arch/unicore32/Kconfig.debug
@@ -44,18 +44,4 @@ config DEBUG_OCD
 	  Say Y here if you want the debug print routines to direct their
 	  output to the UniCore On-Chip-Debugger channel using CP #1.
 
-config DEBUG_OCD_BREAKPOINT
-	bool "Breakpoint support via On-Chip-Debugger"
-	depends on DEBUG_OCD
-
-config DEBUG_UART
-	int "Kernel low-level debugging messages via serial port"
-	depends on DEBUG_LL
-	range 0 1
-	default "0"
-	help
-	  Choice for UART for kernel low-level using PKUnity UARTS,
-	  should be between zero and one. The port must have been
-	  initialised by the boot-loader before use.
-
 endmenu
-- 
1.7.4.4




