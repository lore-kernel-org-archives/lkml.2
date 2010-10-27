Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758882Ab0J0AAK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 20:00:10 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:40629 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752577Ab0J0AAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 20:00:08 -0400
Date: Tue, 26 Oct 2010 17:00:04 -0700
From: Andres Salomon <dilinger@queued.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, dsd@laptop.org
Subject: x86: OLPC: make OLPC_OPENFIRMWARE depend upon OLPC again
Message-ID: <20101026170004.7de97bcd@queued.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Commit 3e3c4860 changed CONFIG_OLPC_OPENFIRMWARE to no longer depend upon
CONFIG_OLPC.  We don't want CONFIG_OLPC_OPENFIRMWARE to show up on non-OLPC
configs, so re-add this dependency.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 arch/x86/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index dfabfef..0c4eced 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2044,7 +2044,7 @@ config OLPC_XO1
 
 config OLPC_OPENFIRMWARE
 	bool "Support for OLPC's Open Firmware"
-	depends on !X86_64 && !X86_PAE
+	depends on !X86_64 && !X86_PAE && OLPC
 	default n
 	help
 	  This option adds support for the implementation of Open Firmware
-- 
1.7.1

