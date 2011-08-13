Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640Ab1HMA1m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 20:27:42 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45030 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563Ab1HMA1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 20:27:40 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 02/10]arch:powerpc:kernel:rtasd.c Remove pointless "@" from various parts of the kernel
Date: Fri, 12 Aug 2011 17:27:07 -0700
Message-Id: <1313195235-4522-2-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1313195235-4522-1-git-send-email-justinmattock@gmail.com>
References: <1313195235-4522-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

The patch series below removes some pointless "@"'s in various parts of the kernel.
Note: some might be useful, but then again, some just seemed a waste of space.
(and since the kernel is become bloated, might as well diet! even if it's a few bits)

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 arch/powerpc/kernel/rtasd.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kernel/rtasd.c b/arch/powerpc/kernel/rtasd.c
index 481ef06..64d83ab 100644
--- a/arch/powerpc/kernel/rtasd.c
+++ b/arch/powerpc/kernel/rtasd.c
@@ -210,7 +210,7 @@ void pSeries_log_error(char *buf, unsigned int err_type, int fatal)
 		break;
 	case ERR_TYPE_KERNEL_PANIC:
 	default:
-		WARN_ON_ONCE(!irqs_disabled()); /* @@@ DEBUG @@@ */
+		WARN_ON_ONCE(!irqs_disabled()); /* DEBUG */
 		spin_unlock_irqrestore(&rtasd_log_lock, s);
 		return;
 	}
@@ -232,7 +232,7 @@ void pSeries_log_error(char *buf, unsigned int err_type, int fatal)
 	/* Check to see if we need to or have stopped logging */
 	if (fatal || !logging_enabled) {
 		logging_enabled = 0;
-		WARN_ON_ONCE(!irqs_disabled()); /* @@@ DEBUG @@@ */
+		WARN_ON_ONCE(!irqs_disabled()); /* DEBUG */
 		spin_unlock_irqrestore(&rtasd_log_lock, s);
 		return;
 	}
@@ -255,13 +255,13 @@ void pSeries_log_error(char *buf, unsigned int err_type, int fatal)
 		else
 			rtas_log_start += 1;
 
-		WARN_ON_ONCE(!irqs_disabled()); /* @@@ DEBUG @@@ */
+		WARN_ON_ONCE(!irqs_disabled()); /* DEBUG */
 		spin_unlock_irqrestore(&rtasd_log_lock, s);
 		wake_up_interruptible(&rtas_log_wait);
 		break;
 	case ERR_TYPE_KERNEL_PANIC:
 	default:
-		WARN_ON_ONCE(!irqs_disabled()); /* @@@ DEBUG @@@ */
+		WARN_ON_ONCE(!irqs_disabled()); /* DEBUG */
 		spin_unlock_irqrestore(&rtasd_log_lock, s);
 		return;
 	}
-- 
1.7.6

