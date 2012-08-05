Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946Ab2HEUMm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 16:12:42 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:42474 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754905Ab2HEUMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 16:12:41 -0400
From: Sami Kerola <kerolasa@iki.fi>
To: len.brown@intel.com
Cc: linux-kernel@vger.kernel.org, Sami Kerola <kerolasa@iki.fi>
Subject: [PATCH] tools/power/x86: add .gitignore files
Date: Sun,  5 Aug 2012 22:12:39 +0200
Message-Id: <1344197559-5913-1-git-send-email-kerolasa@iki.fi>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make resulted to untraced files, which where the binaries make
produced, such need to be ignored.

Signed-off-by: Sami Kerola <kerolasa@iki.fi>
---
 tools/power/x86/turbostat/.gitignore              | 1 +
 tools/power/x86/x86_energy_perf_policy/.gitignore | 1 +
 2 files changed, 2 insertions(+)
 create mode 100644 tools/power/x86/turbostat/.gitignore
 create mode 100644 tools/power/x86/x86_energy_perf_policy/.gitignore

diff --git a/tools/power/x86/turbostat/.gitignore b/tools/power/x86/turbostat/.gitignore
new file mode 100644
index 0000000..f54ea83
--- /dev/null
+++ b/tools/power/x86/turbostat/.gitignore
@@ -0,0 +1 @@
+/turbostat
diff --git a/tools/power/x86/x86_energy_perf_policy/.gitignore b/tools/power/x86/x86_energy_perf_policy/.gitignore
new file mode 100644
index 0000000..1f0efa4
--- /dev/null
+++ b/tools/power/x86/x86_energy_perf_policy/.gitignore
@@ -0,0 +1 @@
+/x86_energy_perf_policy
-- 
1.7.11.4

