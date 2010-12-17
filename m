Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246Ab0LQXiy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 18:38:54 -0500
Received: from complete.lackof.org ([198.49.126.79]:41971 "EHLO
	complete.lackof.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754880Ab0LQXiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 18:38:52 -0500
From: dann frazier <dann.frazier@canonical.com>
To: Corey Minyard <minyard@acm.org>
Cc: openipmi-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        dann frazier <dann.frazier@canonical.com>
Subject: [PATCH] Add missing space in start_now parameter description
Date: Fri, 17 Dec 2010 16:38:27 -0700
Message-Id: <1292629107-26337-1-git-send-email-dann.frazier@canonical.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: dann frazier <dann.frazier@canonical.com>
---
 drivers/char/ipmi/ipmi_watchdog.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_watchdog.c b/drivers/char/ipmi/ipmi_watchdog.c
index f4d334f..9b12da5 100644
--- a/drivers/char/ipmi/ipmi_watchdog.c
+++ b/drivers/char/ipmi/ipmi_watchdog.c
@@ -314,7 +314,7 @@ MODULE_PARM_DESC(preop, "Pretimeout driver operation.  One of: "
 		 "preop_none, preop_panic, preop_give_data.");
 
 module_param(start_now, int, 0444);
-MODULE_PARM_DESC(start_now, "Set to 1 to start the watchdog as"
+MODULE_PARM_DESC(start_now, "Set to 1 to start the watchdog as "
 		 "soon as the driver is loaded.");
 
 module_param(nowayout, int, 0644);
-- 
1.7.2.3

