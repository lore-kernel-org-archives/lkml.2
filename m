Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554Ab0ILFLv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 01:11:51 -0400
Received: from mail.perches.com ([173.55.12.10]:1743 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322Ab0ILFLH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 01:11:07 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 06/11] arch/x86: Remove pr_<level> uses of KERN_<level>
Date: Sat, 11 Sep 2010 22:10:54 -0700
Message-Id: <d40c60f4b036a26db8492848695bdafaa3b42791.1284267142.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.rc1
In-Reply-To: <cover.1284267142.git.joe@perches.com>
References: <cover.1284267142.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/x86/kernel/apb_timer.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apb_timer.c b/arch/x86/kernel/apb_timer.c
index 8dd7780..4004417 100644
--- a/arch/x86/kernel/apb_timer.c
+++ b/arch/x86/kernel/apb_timer.c
@@ -398,7 +398,7 @@ static int apbt_cpuhp_notify(struct notifier_block *n,
 		}
 		break;
 	default:
-		pr_debug(KERN_INFO "APBT notified %lu, no action\n", action);
+		pr_debug("APBT notified %lu, no action\n", action);
 	}
 	return NOTIFY_OK;
 }
@@ -552,7 +552,7 @@ bad_count:
 		pr_debug("APB CS going back %lx:%lx:%lx ",
 			 t2, last_read, t2 - last_read);
 bad_count_x3:
-		pr_debug(KERN_INFO "tripple check enforced\n");
+		pr_debug("triple check enforced\n");
 		t0 = apbt_readl(phy_cs_timer_id,
 				APBTMR_N_CURRENT_VALUE);
 		udelay(1);
-- 
1.7.3.rc1

