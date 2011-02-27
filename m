Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695Ab1B0QD4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 11:03:56 -0500
Received: from hera.kernel.org ([140.211.167.34]:58546 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752543Ab1B0QBo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 11:01:44 -0500
From: Guan Xuetao <epip@hera.kernel.org>
To: arnd@arndb.de
Cc: GuanXuetao <gxt@mprc.pku.edu.cn>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, greg@kroah.com
Subject: [PATCH 07/17] unicore32: remove unused lines in arch/unicore32/include/asm/irq.h
Date: Sun, 27 Feb 2011 15:59:35 +0000
Message-Id: <2205620026b05c58580b437968981b3e20935aa3.1298821856.git.epip@hera.kernel.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <cover.1298821856.git.epip@hera.kernel.org>
References: <cover.1298821856.git.epip@hera.kernel.org>
In-Reply-To: <cover.1298821856.git.epip@hera.kernel.org>
References: <cover.1298821856.git.epip@hera.kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 27 Feb 2011 16:01:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: GuanXuetao <gxt@mprc.pku.edu.cn>

Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
---
 arch/unicore32/include/asm/irq.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/unicore32/include/asm/irq.h b/arch/unicore32/include/asm/irq.h
index ade8bb8..baea93e 100644
--- a/arch/unicore32/include/asm/irq.h
+++ b/arch/unicore32/include/asm/irq.h
@@ -95,9 +95,7 @@
 #define IRQ_SD_CD               IRQ_GPIO6 /* falling or rising trigger */
 
 #ifndef __ASSEMBLY__
-struct irqaction;
 struct pt_regs;
-extern void migrate_irqs(void);
 
 extern void asm_do_IRQ(unsigned int, struct pt_regs *);
 
-- 
1.7.4.1

