Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059Ab2AVO5D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 09:57:03 -0500
Received: from static-212-123-84-234.clienti.tiscali.it ([212.123.84.234]:33856
	"EHLO mail.m31.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897Ab2AVO5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 09:57:02 -0500
X-Greylist: delayed 611 seconds by postgrey-1.27 at vger.kernel.org; Sun, 22 Jan 2012 09:57:02 EST
From: Fabio Baltieri <fabio.baltieri@gmail.com>
To: Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: linux-kernel@vger.kernel.org, Fabio Baltieri <fabio.baltieri@gmail.com>
Subject: [PATCH] avr32: select generic atomic64_t support
Date: Sun, 22 Jan 2012 15:46:33 +0100
Message-Id: <1327243593-29215-1-git-send-email-fabio.baltieri@gmail.com>
X-Mailer: git-send-email 1.7.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable use of the generic atomic64 implementation on AVR32 platforms.
Without this the kernel fails to build as the architecture does not
provide its version.

Signed-off-by: Fabio Baltieri <fabio.baltieri@gmail.com>
---
 arch/avr32/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/avr32/Kconfig b/arch/avr32/Kconfig
index 197e96f..3dea7231 100644
--- a/arch/avr32/Kconfig
+++ b/arch/avr32/Kconfig
@@ -8,6 +8,7 @@ config AVR32
 	select HAVE_KPROBES
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_PROBE
+	select GENERIC_ATOMIC64
 	select HARDIRQS_SW_RESEND
 	select GENERIC_IRQ_SHOW
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
-- 
1.7.5.1

