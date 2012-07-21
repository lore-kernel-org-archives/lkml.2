Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470Ab2GUSTO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 14:19:14 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:50848 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401Ab2GUSTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 14:19:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] Remove SYSTEM_SUSPEND_DISK system state
Date: Sat, 21 Jul 2012 20:24:52 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201207212024.53012.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The SYSTEM_SUSPEND_DISK system state is never used, so drop it.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 include/linux/kernel.h |    1 -
 1 file changed, 1 deletion(-)

Index: linux/include/linux/kernel.h
===================================================================
--- linux.orig/include/linux/kernel.h
+++ linux/include/linux/kernel.h
@@ -377,7 +377,6 @@ extern enum system_states {
 	SYSTEM_HALT,
 	SYSTEM_POWER_OFF,
 	SYSTEM_RESTART,
-	SYSTEM_SUSPEND_DISK,
 } system_state;
 
 #define TAINT_PROPRIETARY_MODULE	0
