Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791Ab0LFWJR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 17:09:17 -0500
Received: from mail.perches.com ([173.55.12.10]:2334 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754188Ab0LFWFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 17:05:22 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 04/29] arch/powerpc: Update WARN uses
Date: Mon,  6 Dec 2010 14:04:54 -0800
Message-Id: <4db2ff2bed284d48d76dc0322169f7b5558e1259.1291670105.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.3.398.g0b0cd.dirty
In-Reply-To: <cover.1291670104.git.joe@perches.com>
References: <cover.1291670104.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Coalesce long formats.
Align arguments.
Add missing newlines.

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/powerpc/kernel/hw_breakpoint.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/hw_breakpoint.c b/arch/powerpc/kernel/hw_breakpoint.c
index 5ecd040..d7343a7 100644
--- a/arch/powerpc/kernel/hw_breakpoint.c
+++ b/arch/powerpc/kernel/hw_breakpoint.c
@@ -270,8 +270,8 @@ int __kprobes hw_breakpoint_handler(struct die_args *args)
 	 * message to let the user know about it.
 	 */
 	if (!stepped) {
-		WARN(1, "Unable to handle hardware breakpoint. Breakpoint at "
-			"0x%lx will be disabled.", info->address);
+		WARN(1, "Unable to handle hardware breakpoint. Breakpoint at 0x%lx will be disabled.\n",
+		     info->address);
 		perf_event_disable(bp);
 		goto out;
 	}
-- 
1.7.3.2.245.g03276.dirty

