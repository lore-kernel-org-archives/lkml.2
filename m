Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757226Ab1JAUKI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 16:10:08 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:59887 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982Ab1JAUE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 16:04:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jason Chagas <jason.chagas@marvell.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 06/26] ARM: pxa: add missing header inclusions
Date: Sat,  1 Oct 2011 22:03:38 +0200
Message-Id: <1317499438-14058-7-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317499438-14058-1-git-send-email-arnd@arndb.de>
References: <1317499438-14058-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:WaWUTYkSVrBWWUFo6GvWxZ2MfEO9GtMfm94V878UKYR
 5PUbx9+7ak2jHEkCDLyRbg5wP7+TXRiQw6c4bVp5k6SjaBTVjF
 +MUON/xNsZVQN2WZbK2QVdIRYh27vMeDe2z5p2aGO5VZHMnUlY
 8ViCY8CeBU1/sKPK9YkYe2cE4OJQdqx+sF/kHJQi+hZtkOTqO8
 5mDEwtlfyAzh6Selthlqz1EyzA0Zu/UXjoG8h3ijRjfqVDBtDa
 mBCbsrxqM0P4RNFdQ7t6tri1Y7Z9xnjx80Z/86OzS4Gf9htYF8
 mfFFX9/60/T1xuPcqCnRqAjcHPGvEAsU7e/85f2zVvP9MaZfw5
 GageliTDW7RQ0OQWDk4FBiQe2Q7+YX7ZOiTY2Naaq+xLoPte0x
 +fMecsamMpNKw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These resulted in build breakage in some configurations:

arch/arm/mach-pxa/irq.c:132:39: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'icip_handle_irq'

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/mach-pxa/irq.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-pxa/irq.c b/arch/arm/mach-pxa/irq.c
index b09e848..848e96d 100644
--- a/arch/arm/mach-pxa/irq.c
+++ b/arch/arm/mach-pxa/irq.c
@@ -16,6 +16,7 @@
 #include <linux/module.h>
 #include <linux/interrupt.h>
 #include <linux/syscore_ops.h>
+#include <linux/ftrace.h>
 #include <linux/io.h>
 #include <linux/irq.h>
 
-- 
1.7.5.4

