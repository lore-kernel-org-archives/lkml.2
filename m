Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621Ab2KHNw4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 08:52:56 -0500
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:59384 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751505Ab2KHNwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 08:52:55 -0500
From: Tao Ma <tm@tao.ma>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Rob Landley <rob@landley.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 1/5] Documentation: Remove reference to feature-removal-schedule.txt.
Date: Thu,  8 Nov 2012 21:50:31 +0800
Message-Id: <1352382635-2773-1-git-send-email-tm@tao.ma>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1352382402-2706-1-git-send-email-tm@tao.ma>
References: <1352382402-2706-1-git-send-email-tm@tao.ma>
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 122.224.222.226 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tao Ma <boyu.mt@taobao.com>

In 9c0ece069, Linus removed feature-removal-schedule.txt from Documentation,
but there is still some reference to this file. So remove them.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Rob Landley <rob@landley.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 Documentation/00-INDEX   |    2 --
 Documentation/ABI/README |    3 ---
 2 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/Documentation/00-INDEX b/Documentation/00-INDEX
index ceb1ff7..8afe64f 100644
--- a/Documentation/00-INDEX
+++ b/Documentation/00-INDEX
@@ -136,8 +136,6 @@ fault-injection/
 	- dir with docs about the fault injection capabilities infrastructure.
 fb/
 	- directory with info on the frame buffer graphics abstraction layer.
-feature-removal-schedule.txt
-	- list of files and features that are going to be removed.
 filesystems/
 	- info on the vfs and the various filesystems that Linux supports.
 firmware_class/
diff --git a/Documentation/ABI/README b/Documentation/ABI/README
index 9feaf16..1006982 100644
--- a/Documentation/ABI/README
+++ b/Documentation/ABI/README
@@ -36,9 +36,6 @@ The different levels of stability are:
 	the kernel, but are marked to be removed at some later point in
 	time.  The description of the interface will document the reason
 	why it is obsolete and when it can be expected to be removed.
-	The file Documentation/feature-removal-schedule.txt may describe
-	some of these interfaces, giving a schedule for when they will
-	be removed.
 
   removed/
 	This directory contains a list of the old interfaces that have
-- 
1.7.0.4

