Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678Ab2EAWay (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 18:30:54 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:52746 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853Ab2EAWax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 18:30:53 -0400
From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Marcos Paulo de Souza <marcos.souza.org@gmail.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Rob Landley <rob@landley.net>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH] Documentation: power: suspend-and-cpuhotplug.txt: Fix typo
Date: Tue,  1 May 2012 19:27:52 -0300
Message-Id: <1335911272-5907-1-git-send-email-marcos.souza.org@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sysfs was expected in this context.

Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Rob Landley <rob@landley.net>
Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
---
 Documentation/power/suspend-and-cpuhotplug.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/power/suspend-and-cpuhotplug.txt b/Documentation/power/suspend-and-cpuhotplug.txt
index f28f9a6..e13dafc 100644
--- a/Documentation/power/suspend-and-cpuhotplug.txt
+++ b/Documentation/power/suspend-and-cpuhotplug.txt
@@ -29,7 +29,7 @@ More details follow:
 
                                   Write 'mem' to
                                 /sys/power/state
-                                    syfs file
+                                    sysfs file
                                         |
                                         v
                                Acquire pm_mutex lock
-- 
1.7.5.4

