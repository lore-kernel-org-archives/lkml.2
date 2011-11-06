Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167Ab1KFAJa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Nov 2011 20:09:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52474 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752523Ab1KFAJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Nov 2011 20:09:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH] Documentation: Fix typo in freezer-subsystem.txt
Date: Sun, 6 Nov 2011 01:12:05 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201111060112.05964.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Fix a typo in Documentation/cgroups/freezer-subsystem.txt.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 Documentation/cgroups/freezer-subsystem.txt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-3.0-SLE11-SP2/Documentation/cgroups/freezer-subsystem.txt
===================================================================
--- linux-3.0-SLE11-SP2.orig/Documentation/cgroups/freezer-subsystem.txt
+++ linux-3.0-SLE11-SP2/Documentation/cgroups/freezer-subsystem.txt
@@ -33,9 +33,9 @@ demonstrate this problem using nested ba
 
 	From a second, unrelated bash shell:
 	$ kill -SIGSTOP 16690
-	$ kill -SIGCONT 16990
+	$ kill -SIGCONT 16690
 
-	<at this point 16990 exits and causes 16644 to exit too>
+	<at this point 16690 exits and causes 16644 to exit too>
 
 This happens because bash can observe both signals and choose how it
 responds to them.
