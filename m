Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636Ab2KDNCM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 08:02:12 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:49060 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799Ab2KDNA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 08:00:29 -0500
From: Luming Yu <luming.yu@gmail.com>
To: arnd@arndb.de, linux-kernel@vger.kernel.org
Cc: Luming Yu <luming.yu@gmail.com>, Luming Yu <luming.yu@intel.com>
Subject: [PATCH 07/13] HW-latency: delete too many "Fast TSC calibration using PIT" in cpufreq sampling
Date: Sun,  4 Nov 2012 20:59:38 -0500
Message-Id: <1352080784-30839-8-git-send-email-luming.yu@gmail.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1352080784-30839-1-git-send-email-luming.yu@gmail.com>
References: <1352080784-30839-1-git-send-email-luming.yu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Fast TSC calibration using PIT" should be a devel info.

Signed-off-by: Luming Yu <luming.yu@intel.com>
---
 arch/x86/kernel/tsc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index cfa5d4f..7765546 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -393,7 +393,7 @@ success:
 	 */
 	delta *= PIT_TICK_RATE;
 	do_div(delta, i*256*1000);
-	pr_info("Fast TSC calibration using PIT\n");
+	pr_devel("Fast TSC calibration using PIT\n");
 	return delta;
 }
 
-- 
1.7.12.1

