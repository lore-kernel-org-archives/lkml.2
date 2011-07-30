Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039Ab1G3OS7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 10:18:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57683 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751901Ab1G3OSy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 10:18:54 -0400
Date: Sat, 30 Jul 2011 10:18:48 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] watchdog: Cleanup WATCHDOG_CORE help text
Message-ID: <20110730141848.GB2285@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The newly added WATCHDOG_CORE option is a bool, but the help text suggests
it can be built as a module.  Fix it up.

Signed-off-by: Josh Boyer <jwboyer@redhat.com>

---

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index f441726..86b0735 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -36,9 +36,6 @@ config WATCHDOG_CORE
 	  and gives them the /dev/watchdog interface (and later also the
 	  sysfs interface).
 
-	  To compile this driver as a module, choose M here: the module will
-	  be called watchdog.
-
 config WATCHDOG_NOWAYOUT
 	bool "Disable watchdog shutdown on close"
 	help
