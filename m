Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757168Ab1JAUJH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 16:09:07 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:52273 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755231Ab1JAUFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 16:05:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jason Chagas <jason.chagas@marvell.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 20/26] ARM: pxa: select FB_PXA on saar and tevorevb
Date: Sat,  1 Oct 2011 22:03:52 +0200
Message-Id: <1317499438-14058-21-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317499438-14058-1-git-send-email-arnd@arndb.de>
References: <1317499438-14058-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:BHAIwCqWOpbVq8MC23Pma4iP9BednfqtunqQpgs6W9g
 WKYvxYAWn4g5K7OBuMfIRK0uX7oXAdEqcOSAo2RpTUf4XZLtvg
 OHayfRJbdUQsJn5rwo3oQ/EVLpMXmk3HNp2K7VhxijNc3MAnRC
 NcjwLN2RZFgPm8So6iKMLpTPmjNUBMcJpZoqUUEj4d2xzQAl/I
 cymdn8oMPEG/GwopCpyHnVNyY66xK9ZyerSnfaexIwUxrFloiT
 uL7N8vHuLrQEUuaQe7Gjo0dZglnXgoEd+t09qoI3T3nLwGQkoF
 EtIrW9fIxE/s6cf7LRccR1JzDaElmfLJXxyryLJiTb5euCPJ6e
 qOGcYVWzhqoX/M/gKsJCl5yY3T0kAXWICSNuD2SaC/b8zKdKMJ
 5t1S/vtBhed6Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The saar and tevorevb platforms call pxafb_smart_flush from board
code, and that function is defined in the framebuffer code, so it
cannot be disabled.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/mach-pxa/Kconfig |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-pxa/Kconfig b/arch/arm/mach-pxa/Kconfig
index bb310d0..cd94f2f 100644
--- a/arch/arm/mach-pxa/Kconfig
+++ b/arch/arm/mach-pxa/Kconfig
@@ -61,11 +61,15 @@ config MACH_TAVOREVB
 	bool "PXA930 Evaluation Board (aka TavorEVB)"
 	select PXA3xx
 	select CPU_PXA930
+	select FB_PXA
+	select FB
 
 config MACH_SAAR
 	bool "PXA930 Handheld Platform (aka SAAR)"
 	select PXA3xx
 	select CPU_PXA930
+	select FB_PXA
+	select FB
 
 comment "Third Party Dev Platforms (sorted by vendor name)"
 
-- 
1.7.5.4

