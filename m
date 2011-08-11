Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006Ab1HKROU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 13:14:20 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:65186 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302Ab1HKROT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 13:14:19 -0400
From: Ralf Thielow <ralf.thielow@googlemail.com>
To: rdunlap@xenotime.net
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ralf Thielow <ralf.thielow@googlemail.com>
Subject: [PATCH] Documentation: SubmittingDrivers: Update Linus' git repository
Date: Thu, 11 Aug 2011 19:13:45 +0200
Message-Id: <1313082825-3162-1-git-send-email-ralf.thielow@googlemail.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change resource URL to new git tree -
(http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git).

Signed-off-by: Ralf Thielow <ralf.thielow@googlemail.com>
---
 Documentation/SubmittingDrivers |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/SubmittingDrivers b/Documentation/SubmittingDrivers
index 319baa8..36d16bb 100644
--- a/Documentation/SubmittingDrivers
+++ b/Documentation/SubmittingDrivers
@@ -130,7 +130,7 @@ Linux kernel master tree:
 	ftp.??.kernel.org:/pub/linux/kernel/...
 	?? == your country code, such as "us", "uk", "fr", etc.
 
-	http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git
+	http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git
 
 Linux kernel mailing list:
 	linux-kernel@vger.kernel.org
-- 
1.7.6

