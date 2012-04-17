Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591Ab2DQUhd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 16:37:33 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47836 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101Ab2DQUhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 16:37:31 -0400
From: Richard Weinberger <richard@nod.at>
To: user-mode-linux-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 3/4] um: Remove CONFIG_IRQ_RELEASE_METHOD
Date: Tue, 17 Apr 2012 22:37:15 +0200
Message-Id: <1334695036-19977-3-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1334695036-19977-1-git-send-email-richard@nod.at>
References: <1334695036-19977-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

UML does no longer need CONFIG_IRQ_RELEASE_METHOD.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/um/Kconfig.common |    5 -----
 arch/um/defconfig      |    1 -
 2 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/arch/um/Kconfig.common b/arch/um/Kconfig.common
index 20a49ba..43ef890 100644
--- a/arch/um/Kconfig.common
+++ b/arch/um/Kconfig.common
@@ -56,11 +56,6 @@ config GENERIC_CLOCKEVENTS
 	bool
 	default y
 
-# Used in kernel/irq/manage.c and include/linux/irq.h
-config IRQ_RELEASE_METHOD
-	bool
-	default y
-
 config HZ
 	int
 	default 100
diff --git a/arch/um/defconfig b/arch/um/defconfig
index fdc97e2..7823ab1 100644
--- a/arch/um/defconfig
+++ b/arch/um/defconfig
@@ -12,7 +12,6 @@ CONFIG_LOCKDEP_SUPPORT=y
 CONFIG_GENERIC_CALIBRATE_DELAY=y
 CONFIG_GENERIC_BUG=y
 CONFIG_GENERIC_CLOCKEVENTS=y
-CONFIG_IRQ_RELEASE_METHOD=y
 CONFIG_HZ=100
 
 #
-- 
1.7.7.3

