Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355Ab2BBUK7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 15:10:59 -0500
Received: from static-212-123-84-234.clienti.tiscali.it ([212.123.84.234]:33198
	"EHLO mail.m31.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797Ab2BBUK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 15:10:58 -0500
From: Fabio Baltieri <fabio.baltieri@gmail.com>
To: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Fabio Baltieri <fabio.baltieri@gmail.com>
Subject: [PATCH RESEND] avr32: select generic atomic64_t support
Date: Thu,  2 Feb 2012 21:11:38 +0100
Message-Id: <1328213498-8534-1-git-send-email-fabio.baltieri@gmail.com>
X-Mailer: git-send-email 1.7.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable use of the generic atomic64 implementation on AVR32 platforms.
Without this the kernel fails to build as the architecture does not
provide its version.

Signed-off-by: Fabio Baltieri <fabio.baltieri@gmail.com>
Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>
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

