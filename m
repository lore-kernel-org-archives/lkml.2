Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967867Ab2ERJWT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 05:22:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39843 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967579Ab2ERJWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 05:22:17 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: rpurdie@rpsys.net, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, arnd.bergmann@linaro.org
Subject: [PATCH] MAINTAINERS: add linux-leds mail list address and git URL
Date: Fri, 18 May 2012 17:22:07 +0800
Message-Id: <1337332927-13315-1-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
---
 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index b362709..7abd8c4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4038,6 +4038,8 @@ F:	drivers/scsi/53c700*
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

