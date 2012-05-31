Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312Ab2EaLvr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 07:51:47 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36510 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757259Ab2EaLvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 07:51:45 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: rpurdie@rpsys.net, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux-leds@vger.kernel.org
Subject: [PATCH] MAINTAINERS: add linux-leds mail list address and git URL
Date: Thu, 31 May 2012 19:51:37 +0800
Message-Id: <1338465097-14697-1-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 64e675d..df41567 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4096,6 +4096,8 @@ F:	drivers/scsi/53c700*
 LED SUBSYSTEM
 M:	Bryan Wu <bryan.wu@canonical.com>
 M:	Richard Purdie <rpurdie@rpsys.net>
+L:	linux-leds@vger.kernel.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/cooloney/linux-leds.git
 S:	Maintained
 F:	drivers/leds/
 F:	include/linux/leds.h
-- 
1.7.9.5

