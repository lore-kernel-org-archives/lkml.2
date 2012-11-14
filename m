Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933081Ab2KNUpt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 15:45:49 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:46838 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754505Ab2KNUnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 15:43:33 -0500
From: Len Brown <lenb@kernel.org>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>
Subject: [PATCH 1/7] tools/power turbostat: Repair Segmentation fault when using -i option
Date: Wed, 14 Nov 2012 15:43:18 -0500
Message-Id: <39300ffb9b6666714c60735cf854e1280e4e75f4.1352925508.git.len.brown@intel.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1352925804-6746-1-git-send-email-lenb@kernel.org>
References: <1352925804-6746-1-git-send-email-lenb@kernel.org>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

Fix regression caused by commit 8e180f3cb6b7510a3bdf14e16ce87c9f5d86f102
(tools/power turbostat: add [-d MSR#][-D MSR#] options to print counter
deltas)

Signed-off-by: Len Brown <len.brown@intel.com>
---
 tools/power/x86/turbostat/turbostat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 2655ae9..9942dee 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -1594,7 +1594,7 @@ void cmdline(int argc, char **argv)
 
 	progname = argv[0];
 
-	while ((opt = getopt(argc, argv, "+pPSvisc:sC:m:M:")) != -1) {
+	while ((opt = getopt(argc, argv, "+pPSvi:sc:sC:m:M:")) != -1) {
 		switch (opt) {
 		case 'p':
 			show_core_only++;
-- 
1.8.0

