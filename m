Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064Ab2BOTT6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 14:19:58 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:60082 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755032Ab2BOTTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 14:19:54 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Danny Kukawka <dkukawka@suse.de>, Kevin Cernekee <cernekee@gmail.com>,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: [PATCH] arch/mips/kernel/smp-bmips.c included linux/init.h twice
Date: Wed, 15 Feb 2012 20:19:49 +0100
Message-Id: <1329333589-31828-1-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.8.3
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1329333594;24d9c331;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/mips/kernel/smp-bmips.c included 'linux/init.h' twice,
remove the duplicate.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 arch/mips/kernel/smp-bmips.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/mips/kernel/smp-bmips.c b/arch/mips/kernel/smp-bmips.c
index 58fe71a..64978e9 100644
--- a/arch/mips/kernel/smp-bmips.c
+++ b/arch/mips/kernel/smp-bmips.c
@@ -16,7 +16,6 @@
 #include <linux/smp.h>
 #include <linux/interrupt.h>
 #include <linux/spinlock.h>
-#include <linux/init.h>
 #include <linux/cpu.h>
 #include <linux/cpumask.h>
 #include <linux/reboot.h>
-- 
1.7.8.3

