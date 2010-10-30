Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565Ab0J3VRT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 17:17:19 -0400
Received: from mail.perches.com ([173.55.12.10]:3705 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691Ab0J3VJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 17:09:23 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 04/39] arch/powerpc: Update WARN uses
Date: Sat, 30 Oct 2010 14:08:21 -0700
Message-Id: <c6c46b5924e1cc9720d3ad76e6c11e982bd661e5.1288471898.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1288471897.git.joe@perches.com>
References: <cover.1288471897.git.joe@perches.com>
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
1.7.3.1.g432b3.dirty

