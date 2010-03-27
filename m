Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731Ab0C0CaR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 22:30:17 -0400
Received: from mail.perches.com ([173.55.12.10]:1130 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752663Ab0C0C2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 22:28:00 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Mike Frysinger <vapier@gentoo.org>,
       uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 2/9] arch/blackfin: Fix continuation lines
Date: Fri, 26 Mar 2010 19:27:51 -0700
Message-Id: <5a74fdb0392254b257cb966ba23cc7f63c3b783b.1269655208.git.joe@perches.com>
X-Mailer: git-send-email 1.7.0.14.g7e948
In-Reply-To: <cover.1269655208.git.joe@perches.com>
References: <cover.1269655208.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/blackfin/mach-common/smp.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/blackfin/mach-common/smp.c b/arch/blackfin/mach-common/smp.c
index 7803f22..f58a554 100644
--- a/arch/blackfin/mach-common/smp.c
+++ b/arch/blackfin/mach-common/smp.c
@@ -169,8 +169,8 @@ static irqreturn_t ipi_handler(int irq, void *dev_instance)
 			kfree(msg);
 			break;
 		default:
-			printk(KERN_CRIT "CPU%u: Unknown IPI message \
-			0x%lx\n", cpu, msg->type);
+			printk(KERN_CRIT "CPU%u: Unknown IPI message 0x%lx\n",
+			       cpu, msg->type);
 			kfree(msg);
 			break;
 		}
-- 
1.7.0.14.g7e948

