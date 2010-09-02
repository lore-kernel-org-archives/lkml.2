Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149Ab0IBUjN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 16:39:13 -0400
Received: from smtp5-g21.free.fr ([212.27.42.5]:60141 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932111Ab0IBUjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 16:39:12 -0400
Message-ID: <4C800D37.6080703@fnac.net>
Date: Thu, 02 Sep 2010 22:46:47 +0200
From: Paul Chavent <paul.chavent@fnac.net>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        costa.antonior@gmail.com, plagnioj@jcrosoft.com,
        nicolas.ferre@atmel.com, linux@maxim.org.za, linux@arm.linux.org.uk
Subject: [PATCH] arm mach-at91 use choice keyword for board type selection
 in Kconfig
Content-Type: multipart/mixed;
 boundary="------------030809070601060108010309"
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030809070601060108010309
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

It seems that we can select more than one board for one kernel.

This patch use a choice keyword for board type selection in Kconfig.


Signed-off-by: Paul Chavent <paul.chavent@fnac.net>

--------------030809070601060108010309
Content-Type: text/plain;
 name="linux-2.6.35.4-arm_at91_board_choice.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="linux-2.6.35.4-arm_at91_board_choice.patch"

diff -abBruN linux-2.6.35.4.orig/arch/arm/mach-at91/Kconfig linux-2.6.35.4.mod/arch/arm/mach-at91/Kconfig
--- linux-2.6.35.4.orig/arch/arm/mach-at91/Kconfig	2010-09-02 17:35:13.009000142 +0200
+++ linux-2.6.35.4.mod/arch/arm/mach-at91/Kconfig	2010-09-02 18:58:53.723000246 +0200
@@ -99,7 +99,8 @@
 
 if ARCH_AT91RM9200
 
-comment "AT91RM9200 Board Type"
+choice
+	prompt "AT91RM9200 Board Type"
 
 config MACH_ONEARM
 	bool "Ajeco 1ARM Single Board Computer"
@@ -185,6 +186,8 @@
 	help
 	  Select this if you are using the eco920 board
 
+endchoice
+
 endif
 
 # ----------------------------------------------------------
@@ -199,7 +202,8 @@
 	  Select this if you are using Atmel's AT91SAM9XE System-on-Chip.
 	  They are basically AT91SAM9260s with various sizes of embedded Flash.
 
-comment "AT91SAM9260 / AT91SAM9XE Board Type"
+choice
+	prompt "AT91SAM9260 / AT91SAM9XE Board Type"
 
 config MACH_AT91SAM9260EK
 	bool "Atmel AT91SAM9260-EK / AT91SAM9XE Evaluation Kit"
@@ -248,13 +252,16 @@
 	  Select this if you are using a Eukrea Electromatique's
 	  CPU9260 Board <http://www.eukrea.com/>
 
+endchoice
+
 endif
 
 # ----------------------------------------------------------
 
 if ARCH_AT91SAM9261
 
-comment "AT91SAM9261 Board Type"
+choice
+	prompt "AT91SAM9261 Board Type"
 
 config MACH_AT91SAM9261EK
 	bool "Atmel AT91SAM9261-EK Evaluation Kit"
@@ -264,13 +271,16 @@
 	  Select this if you are using Atmel's AT91SAM9261-EK Evaluation Kit.
 	  <http://www.atmel.com/dyn/products/tools_card.asp?tool_id=3820>
 
+endchoice
+
 endif
 
 # ----------------------------------------------------------
 
 if ARCH_AT91SAM9G10
 
-comment "AT91SAM9G10 Board Type"
+choice
+	prompt "AT91SAM9G10 Board Type"
 
 config MACH_AT91SAM9G10EK
 	bool "Atmel AT91SAM9G10-EK Evaluation Kit"
@@ -280,13 +290,16 @@
 	  Select this if you are using Atmel's AT91SAM9G10-EK Evaluation Kit.
 	  <http://www.atmel.com/dyn/products/tools_card.asp?tool_id=4588>
 
+endchoice
+
 endif
 
 # ----------------------------------------------------------
 
 if ARCH_AT91SAM9263
 
-comment "AT91SAM9263 Board Type"
+choice
+	prompt "AT91SAM9263 Board Type"
 
 config MACH_AT91SAM9263EK
 	bool "Atmel AT91SAM9263-EK Evaluation Kit"
@@ -308,26 +321,32 @@
 	help
 	  Select this if you are using the Adeneo Neocore 926 board.
 
+endchoice
+
 endif
 
 # ----------------------------------------------------------
 
 if ARCH_AT91SAM9RL
 
-comment "AT91SAM9RL Board Type"
+choice
+	prompt "AT91SAM9RL Board Type"
 
 config MACH_AT91SAM9RLEK
 	bool "Atmel AT91SAM9RL-EK Evaluation Kit"
 	help
 	  Select this if you are using Atmel's AT91SAM9RL-EK Evaluation Kit.
 
+endchoice
+
 endif
 
 # ----------------------------------------------------------
 
 if ARCH_AT91SAM9G20
 
-comment "AT91SAM9G20 Board Type"
+choice
+	prompt "AT91SAM9G20 Board Type"
 
 config MACH_AT91SAM9G20EK
 	bool "Atmel AT91SAM9G20-EK Evaluation Kit"
@@ -364,13 +383,16 @@
 	  evaluation board.
 	  <http://www.taskit.de/en/>
 
+endchoice
+
 endif
 
 # ----------------------------------------------------------
 
 if ARCH_AT91SAM9G45
 
-comment "AT91SAM9G45 Board Type"
+choice
+	prompt "AT91SAM9G45 Board Type"
 
 config MACH_AT91SAM9G45EKES
 	bool "Atmel AT91SAM9G45-EKES Evaluation Kit"
@@ -380,13 +402,16 @@
 	  "ES" at the end of the name means that this board is an
 	  Engineering Sample.
 
+endchoice
+
 endif
 
 # ----------------------------------------------------------
 
 if ARCH_AT91CAP9
 
-comment "AT91CAP9 Board Type"
+choice
+	prompt "AT91CAP9 Board Type"
 
 config MACH_AT91CAP9ADK
 	bool "Atmel AT91CAP9A-DK Evaluation Kit"
@@ -396,13 +421,16 @@
 	  Select this if you are using Atmel's AT91CAP9A-DK Evaluation Kit.
 	  <http://www.atmel.com/dyn/products/tools_card.asp?tool_id=4138>
 
+endchoice
+
 endif
 
 # ----------------------------------------------------------
 
 if ARCH_AT572D940HF
 
-comment "AT572D940HF Board Type"
+choice
+	prompt "AT572D940HF Board Type"
 
 config MACH_AT572D940HFEB
 	bool "AT572D940HF-EK"
@@ -413,13 +441,16 @@
 	  Select this if you are using Atmel's AT572D940HF-EK evaluation kit.
 	  <http://www.atmel.com/products/diopsis/default.asp>
 
+endchoice
+
 endif
 
 # ----------------------------------------------------------
 
 if ARCH_AT91X40
 
-comment "AT91X40 Board Type"
+choice
+	prompt "AT91X40 Board Type"
 
 config MACH_AT91EB01
 	bool "Atmel AT91EB01 Evaluation Kit"
@@ -429,6 +460,8 @@
 	  ARM simulator (commonly known as the ARMulator) and the
 	  Skyeye simulator.
 
+endchoice
+
 endif
 
 # ----------------------------------------------------------

--------------030809070601060108010309--
