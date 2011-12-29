Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069Ab1L2TDL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 14:03:11 -0500
Received: from juliette.telenet-ops.be ([195.130.137.74]:56008 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646Ab1L2TDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 14:03:08 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] m68k/mac: Make CONFIG_HEARTBEAT unavailable on Mac
Date: Thu, 29 Dec 2011 20:03:03 +0100
Message-Id: <1325185383-19449-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mac_heartbeat() was never really implemented.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/Kconfig.devices |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/m68k/Kconfig.devices b/arch/m68k/Kconfig.devices
index c3bd7e2..a8eff5a 100644
--- a/arch/m68k/Kconfig.devices
+++ b/arch/m68k/Kconfig.devices
@@ -8,8 +8,8 @@ config ARCH_MAY_HAVE_PC_FDC
 menu "Platform devices"
 
 config HEARTBEAT
-	bool "Use power LED as a heartbeat" if AMIGA || APOLLO || ATARI || MAC ||Q40
-	default y if !AMIGA && !APOLLO && !ATARI && !MAC && !Q40 && HP300
+	bool "Use power LED as a heartbeat" if AMIGA || APOLLO || ATARI || Q40
+	default y if !AMIGA && !APOLLO && !ATARI && !Q40 && HP300
 	help
 	  Use the power-on LED on your machine as a load meter.  The exact
 	  behavior is platform-dependent, but normally the flash frequency is
-- 
1.7.0.4

