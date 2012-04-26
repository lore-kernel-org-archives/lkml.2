Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405Ab2DZGoH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 02:44:07 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:55153 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397Ab2DZGoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 02:44:04 -0400
X-AuditID: 9c930197-b7ca1ae0000069e6-9c-4f98eeb141cd
From: Namhyung Kim <namhyung.kim@lge.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Namhyung Kim <namhyung@gmail.com>, Michal Marek <mmarek@suse.cz>,
        Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] .gitignore: Ingore rejected patch results
Date: Thu, 26 Apr 2012 15:43:10 +0900
Message-Id: <1335422590-12124-1-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.10
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let git ignores *.rej files created when patch failed.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 .gitignore |    1 +
 1 file changed, 1 insertion(+)

diff --git a/.gitignore b/.gitignore
index 57af07cf7e68..455244dabb99 100644
--- a/.gitignore
+++ b/.gitignore
@@ -82,5 +82,6 @@ GSYMS
 GTAGS
 
 *.orig
+*.rej
 *~
 \#*#
-- 
1.7.10

