Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884Ab0ILHeb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 03:34:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:53316 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501Ab0ILHea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 03:34:30 -0400
Date: Sun, 12 Sep 2010 07:34:01 GMT
From: tip-bot for Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        trivial@kernel.org, joe@perches.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        joe@perches.com, trivial@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <d40c60f4b036a26db8492848695bdafaa3b42791.1284267142.git.joe@perches.com>
References: <d40c60f4b036a26db8492848695bdafaa3b42791.1284267142.git.joe@perches.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/debug] x86: Remove pr_<level> uses of KERN_<level>
Message-ID: <tip-d0ed0c32662e756e7daf85e70a5a27a9c1111331@git.kernel.org>
Git-Commit-ID: d0ed0c32662e756e7daf85e70a5a27a9c1111331
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 12 Sep 2010 07:34:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d0ed0c32662e756e7daf85e70a5a27a9c1111331
Gitweb:     http://git.kernel.org/tip/d0ed0c32662e756e7daf85e70a5a27a9c1111331
Author:     Joe Perches <joe@perches.com>
AuthorDate: Sat, 11 Sep 2010 22:10:54 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 12 Sep 2010 09:32:31 +0200

x86: Remove pr_<level> uses of KERN_<level>

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <trivial@kernel.org>
LKML-Reference: <d40c60f4b036a26db8492848695bdafaa3b42791.1284267142.git.joe@perches.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
