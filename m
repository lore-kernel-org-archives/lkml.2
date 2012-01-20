Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756435Ab2ATUhQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 15:37:16 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:40046 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756400Ab2ATUhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 15:37:12 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH 5/5] MAINTAINERS: Fix REMOTEPROC F: typo
Date: Fri, 20 Jan 2012 12:36:21 -0800
Message-Id: <2986429c3ff06a59f8f037ea77397c73126b817c.1327091633.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1327091633.git.joe@perches.com>
References: <cover.1327091633.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remoteproc.txt should have been .h

cc: Ohad Ben-Cohen <ohad@wizery.com>
Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index ff21f0a..d615fef 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5562,7 +5562,7 @@ M:	Ohad Ben-Cohen <ohad@wizery.com>
 S:	Maintained
 F:	drivers/remoteproc/
 F:	Documentation/remoteproc.txt
-F:	include/linux/remoteproc.txt
+F:	include/linux/remoteproc.h
 
 RFKILL
 M:	Johannes Berg <johannes@sipsolutions.net>
-- 
1.7.8.111.gad25c.dirty

