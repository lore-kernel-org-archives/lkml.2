Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302Ab1F3XoH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 19:44:07 -0400
Received: from mta21.charter.net ([216.33.127.81]:44390 "EHLO
	mta21.charter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417Ab1F3XoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 19:44:03 -0400
X-Authority-Analysis: v=1.1 cv=G6Q69DB3AUoJKS2BpLRaz8MQ2NORN7h5HRzrJMPOhRw=
 c=1 sm=1 a=kge-9xan5_IA:10 a=lDGNyK2vIvEA:10 a=xzrYXqw+0zwiO4gHSXHcAg==:17
 a=pyR_tkqvhZ_ySJ0FD5EA:9 a=xzrYXqw+0zwiO4gHSXHcAg==:117
From: Greg Dietsche <Gregory.Dietsche@cuw.edu>
To: mmarek@suse.cz
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Dietsche <Gregory.Dietsche@cuw.edu>
Subject: [PATCH] gitignore: ignore debian build directory
Date: Thu, 30 Jun 2011 18:42:50 -0500
Message-Id: <1309477370-5866-1-git-send-email-Gregory.Dietsche@cuw.edu>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Have git ignore the Debian directory created when running:
	make deb-pkg

Signed-off-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>
---
 .gitignore |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/.gitignore b/.gitignore
index 9dacde0..dc243a6 100644
--- a/.gitignore
+++ b/.gitignore
@@ -46,6 +46,11 @@ modules.builtin
 /Module.symvers
 
 #
+#Debian directory (make deb-pkg)
+#
+/debian/
+
+#
 # git files that we don't want to ignore even it they are dot-files
 #
 !.gitignore
-- 
1.7.2.5

