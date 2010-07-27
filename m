Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab0G0XwJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 19:52:09 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:44601 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969Ab0G0Xv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 19:51:59 -0400
From: dann frazier <dannf@hp.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-kernel@vger.kernel.org, Thomas Mingarelli <thomas.mingarelli@hp.com>,
        dann frazier <dannf@hp.com>
Subject: [PATCH 06/15] Group options that affect watchdog behavior together
Date: Tue, 27 Jul 2010 17:50:54 -0600
Message-Id: <1280274663-9160-7-git-send-email-dannf@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1280274663-9160-1-git-send-email-dannf@hp.com>
References: <1280274663-9160-1-git-send-email-dannf@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reorganization only.

Signed-off-by: dann frazier <dannf@hp.com>
---
 drivers/watchdog/hpwdt.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index b8b791f..796fcb8 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -808,13 +808,13 @@ MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
 module_param(soft_margin, int, 0);
 MODULE_PARM_DESC(soft_margin, "Watchdog timeout in seconds");
 
-module_param(allow_kdump, int, 0);
-MODULE_PARM_DESC(allow_kdump, "Start a kernel dump after NMI occurs");
-
 module_param(nowayout, int, 0);
 MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default="
 		__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
+module_param(allow_kdump, int, 0);
+MODULE_PARM_DESC(allow_kdump, "Start a kernel dump after NMI occurs");
+
 module_param(priority, int, 0);
 MODULE_PARM_DESC(priority, "The hpwdt driver handles NMIs first or last"
 		" (default = 0/Last)\n");
-- 
1.7.1

