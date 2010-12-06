Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637Ab0LFWFz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 17:05:55 -0500
Received: from mail.perches.com ([173.55.12.10]:2356 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754456Ab0LFWFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 17:05:24 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 28/29] net/rfkill/input.c: Update WARN uses
Date: Mon,  6 Dec 2010 14:05:18 -0800
Message-Id: <441f72a7103bf553a0768cf3485d064071eac14f.1291670106.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.3.398.g0b0cd.dirty
In-Reply-To: <cover.1291670104.git.joe@perches.com>
References: <cover.1291670104.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Coalesce long formats.
Align arguments.

Signed-off-by: Joe Perches <joe@perches.com>
---
 net/rfkill/input.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/rfkill/input.c b/net/rfkill/input.c
index 1bca6d4..4343f59 100644
--- a/net/rfkill/input.c
+++ b/net/rfkill/input.c
@@ -75,9 +75,8 @@ static void __rfkill_handle_global_op(enum rfkill_sched_op op)
 	default:
 		/* memory corruption or bug, fail safely */
 		rfkill_epo();
-		WARN(1, "Unknown requested operation %d! "
-			"rfkill Emergency Power Off activated\n",
-			op);
+		WARN(1, "Unknown requested operation %d! rfkill Emergency Power Off activated\n",
+		     op);
 	}
 }
 
-- 
1.7.3.2.245.g03276.dirty

