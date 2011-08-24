Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154Ab1HXUpK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 16:45:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35621 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752116Ab1HXUpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 16:45:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH] PM / Runtime: Correct documentation of pm_runtime_irq_safe()
Date: Wed, 24 Aug 2011 22:46:41 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Kevin Hilman <khilman@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201108242246.41574.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The description of pm_runtime_irq_safe() has to be updated to follow
the code after commit 02b2677 (PM / Runtime: Allow _put_sync() from
interrupts-disabled context).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 Documentation/power/runtime_pm.txt |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux/Documentation/power/runtime_pm.txt
===================================================================
--- linux.orig/Documentation/power/runtime_pm.txt
+++ linux/Documentation/power/runtime_pm.txt
@@ -431,8 +431,7 @@ drivers/base/power/runtime.c and include
 
   void pm_runtime_irq_safe(struct device *dev);
     - set the power.irq_safe flag for the device, causing the runtime-PM
-      suspend and resume callbacks (but not the idle callback) to be invoked
-      with interrupts disabled
+      callbacks to be invoked with interrupts off
 
   void pm_runtime_mark_last_busy(struct device *dev);
     - set the power.last_busy field to the current time
