Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895Ab1KFCOe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Nov 2011 22:14:34 -0400
Received: from mta11.charter.net ([216.33.127.80]:38967 "EHLO
	mta11.charter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424Ab1KFCOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Nov 2011 22:14:31 -0400
X-Authority-Analysis: v=1.1 cv=CKBBFOpPYfBSFfEY1Rl9efxuAv/fdt7oFsWUUq3BrLQ=
 c=1 sm=1 a=Pw_zP06pnsUA:10 a=lDGNyK2vIvEA:10 a=xzrYXqw+0zwiO4gHSXHcAg==:17
 a=pGLkceISAAAA:8 a=l2E7mNOSAAAA:8 a=U7shPPFNyVZDUEyMoy0A:9
 a=dGtn2BauvcRGU-f2-ygA:7 a=MSl-tDqOz04A:10 a=xzrYXqw+0zwiO4gHSXHcAg==:117
From: Gregory.Dietsche@cuw.edu
To: julia@diku.dk, Gilles.Muller@lip6.fr, npalix.work@gmail.com,
        mmarek@suse.cz
Cc: rdunlap@xenotime.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, cocci@diku.dk,
        Greg Dietsche <Gregory.Dietsche@cuw.edu>
Subject: [RESEND 1/3] coccinelle.txt: add overview section
Date: Sat,  5 Nov 2011 21:14:11 -0500
Message-Id: <1320545653-28249-2-git-send-email-Gregory.Dietsche@cuw.edu>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1320545653-28249-1-git-send-email-Gregory.Dietsche@cuw.edu>
References: <1320545653-28249-1-git-send-email-Gregory.Dietsche@cuw.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Dietsche <Gregory.Dietsche@cuw.edu>

Add an overview section to the coccinelle documentation.

Signed-off-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>
Signed-off-by: Nicolas Palix <npalix.work@gmail.com>
---
 Documentation/coccinelle.txt |   31 +++++++++++++++++++++++++++++++
 1 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/Documentation/coccinelle.txt b/Documentation/coccinelle.txt
index 96b6903..9495a4b 100644
--- a/Documentation/coccinelle.txt
+++ b/Documentation/coccinelle.txt
@@ -41,6 +41,37 @@ The semantic patches in the kernel will work best with Coccinelle version
 semantic patch code, but any results that are obtained should still be
 correct.
 
+
+ Overview / Quick Start
+~~~~~~~~~~~~~~~~~~~~~~~~
+
+There are two ways to use Coccinelle with the Linux kernel.
+
+1) Coccinelle can be used like sparse (see Documentation/sparse.txt):
+	make C=1 CHECK="scripts/coccicheck"
+	make C=2 CHECK="scripts/coccicheck"
+
+2) Coccinelle can be used via a build target in the kernel's Makefile:
+	make coccicheck
+
+There are a number of optional parameters that can be used with the build target.
+
+	make coccicheck MODE={patch,report,context,org} COCCI=? M=?
+
+MODE:
+	Determines what mode cocci operates in. If no mode is specified
+	then cocci will default to 'chain' mode which will run for each
+	available mode (patch, report, context, org).
+
+COCCI:
+	Process a specific .cocci SmPL script. If this is not set then
+	process all scripts under scripts/coccinelle/
+
+M:
+	Limit cocci to a subset of directories. This is very similar to the
+	way the build system works when building modules.
+
+
  Using Coccinelle on the Linux kernel
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
-- 
1.7.6.4

