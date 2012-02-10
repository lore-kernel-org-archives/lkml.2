Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599Ab2BJPJq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 10:09:46 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:42863
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750845Ab2BJPJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 10:09:44 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: rdunlap@xenotime.net, linux-doc@vger.kernel.org
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org, standby24x7@gmail.com
Subject: [PATCH] [trivial] Documentation: Fix typo in watchdog-kernel-api.txt
Date: Sat, 11 Feb 2012 00:09:20 +0900
Message-Id: <1328886560-3464-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "retruns" to "returns" in
Documentations/watchdog/watchdog-kernel-api.txt

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 Documentation/watchdog/watchdog-kernel-api.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/watchdog/watchdog-kernel-api.txt b/Documentation/watchdog/watchdog-kernel-api.txt
index 4b93c28..9e16246 100644
--- a/Documentation/watchdog/watchdog-kernel-api.txt
+++ b/Documentation/watchdog/watchdog-kernel-api.txt
@@ -167,4 +167,4 @@ driver specific data to and a pointer to the data itself.
 
 The watchdog_get_drvdata function allows you to retrieve driver specific data.
 The argument of this function is the watchdog device where you want to retrieve
-data from. The function retruns the pointer to the driver specific data.
+data from. The function returns the pointer to the driver specific data.
-- 
1.7.6.5

