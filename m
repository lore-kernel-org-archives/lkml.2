Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932310Ab1GMBZq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 21:25:46 -0400
Received: from mta11.charter.net ([216.33.127.80]:39259 "EHLO
	mta11.charter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756576Ab1GMBZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 21:25:44 -0400
X-Authority-Analysis: v=1.1 cv=1b2X7W/SifksZeClH/haT1SUt4udqxFGF00pZw2/jJk=
 c=1 sm=1 a=fYxzoYjCm8EA:10 a=lDGNyK2vIvEA:10 a=xzrYXqw+0zwiO4gHSXHcAg==:17
 a=l2E7mNOSAAAA:8 a=gLV9QiDOUN7PfshxCEQA:9 a=n90IYmf1nUhKVLhq:21
 a=EtbA5xyKN7sf-Pm2:21 a=xzrYXqw+0zwiO4gHSXHcAg==:117
From: Greg Dietsche <Gregory.Dietsche@cuw.edu>
To: julia@diku.dk, Gilles.Muller@lip6.fr, npalix.work@gmail.com
Cc: rdunlap@xenotime.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, cocci@diku.dk,
        Greg Dietsche <Gregory.Dietsche@cuw.edu>
Subject: [PATCH 2/3] coccinelle.txt: add documentation of PARALLEL= flag
Date: Tue, 12 Jul 2011 20:26:44 -0500
Message-Id: <1310520405-1558-3-git-send-email-Gregory.Dietsche@cuw.edu>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1310520405-1558-1-git-send-email-Gregory.Dietsche@cuw.edu>
References: <1310520405-1558-1-git-send-email-Gregory.Dietsche@cuw.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document the new PARALLEL= option of Coccinelle which
allows running SmPL scripts in parallel.

Signed-off-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>
---
 Documentation/coccinelle.txt |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/Documentation/coccinelle.txt b/Documentation/coccinelle.txt
index 9495a4b..3bccb50 100644
--- a/Documentation/coccinelle.txt
+++ b/Documentation/coccinelle.txt
@@ -56,7 +56,7 @@ There are two ways to use Coccinelle with the Linux kernel.
 
 There are a number of optional parameters that can be used with the build target.
 
-	make coccicheck MODE={patch,report,context,org} COCCI=? M=?
+	make coccicheck MODE={patch,report,context,org} COCCI=? M=? PARALLEL=?
 
 MODE:
 	Determines what mode cocci operates in. If no mode is specified
@@ -71,6 +71,10 @@ M:
 	Limit cocci to a subset of directories. This is very similar to the
 	way the build system works when building modules.
 
+PARALLEL:
+	Number of *.cocci SmPL scripts found under scripts/coccinelle/ to run
+	at the same time.
+
 
  Using Coccinelle on the Linux kernel
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- 
1.7.2.5

