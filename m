Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544Ab1HPWeY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 18:34:24 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63029 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562Ab1HPWeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 18:34:23 -0400
From: Arun Thomas <arun.thomas@gmail.com>
To: Len Brown <len.brown@intel.com>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
        Arun Thomas <arun.thomas@gmail.com>
Subject: [PATCH] tools/power turbostat: update fields in manpage
Date: Wed, 17 Aug 2011 00:34:14 +0200
Message-Id: <1313534054-9252-1-git-send-email-arun.thomas@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Field names were shortened: "pkg" is now "pk", "core" is now "cr"

Signed-off-by: Arun Thomas <arun.thomas@gmail.com>
---
 tools/power/x86/turbostat/turbostat.8 |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/power/x86/turbostat/turbostat.8 b/tools/power/x86/turbostat/turbostat.8
index ff75125..555c69a 100644
--- a/tools/power/x86/turbostat/turbostat.8
+++ b/tools/power/x86/turbostat/turbostat.8
@@ -38,8 +38,8 @@ displays the statistics gathered since it was forked.
 .PP
 .SH FIELD DESCRIPTIONS
 .nf
-\fBpkg\fP processor package number.
-\fBcore\fP processor core number.
+\fBpk\fP processor package number.
+\fBcr\fP processor core number.
 \fBCPU\fP Linux CPU (logical processor) number.
 \fB%c0\fP percent of the interval that the CPU retired instructions.
 \fBGHz\fP average clock rate while the CPU was in c0 state.
@@ -58,7 +58,7 @@ Subsequent rows show per-CPU statistics.
 
 .nf
 [root@x980]# ./turbostat
-core CPU   %c0   GHz  TSC   %c1    %c3    %c6   %pc3   %pc6
+cr   CPU   %c0   GHz  TSC   %c1    %c3    %c6   %pc3   %pc6
           0.04 1.62 3.38   0.11   0.00  99.85   0.00  95.07
   0   0   0.04 1.62 3.38   0.06   0.00  99.90   0.00  95.07
   0   6   0.02 1.62 3.38   0.08   0.00  99.90   0.00  95.07
@@ -102,7 +102,7 @@ until ^C while the other CPUs are mostly idle:
 .nf
 [root@x980 lenb]# ./turbostat cat /dev/zero > /dev/null
 
-^Ccore CPU   %c0   GHz  TSC   %c1    %c3    %c6   %pc3   %pc6
+^Ccr   CPU   %c0   GHz  TSC   %c1    %c3    %c6   %pc3   %pc6
            8.49 3.63 3.38  16.23   0.66  74.63   0.00   0.00
    0   0   1.22 3.62 3.38  32.18   0.00  66.60   0.00   0.00
    0   6   0.40 3.61 3.38  33.00   0.00  66.60   0.00   0.00
-- 
1.7.4.1

