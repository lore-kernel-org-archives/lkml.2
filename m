Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518Ab0DLN2W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 09:28:22 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:59615 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750740Ab0DLN2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 09:28:21 -0400
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Jean Delvare <khali@linux-fr.org>
Cc: nicolas@boichat.ch, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH] hwmon: Switch applesmc maintainer
Date: Mon, 12 Apr 2010 15:27:48 +0200
Message-Id: <1271078868-3699-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.6.3.3
X-Originating-IP: 83.248.129.72
X-Scan-Result: No virus found in message 1O1JgE-0007KB-9e.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1O1JgE-0007KB-9e 8a249c011671829c5af4da35f5f3738a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas has expressed a wish to be relieved from the maintenance
of applesmc, so we simply switch maintainer with this patch.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 MAINTAINERS |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7a9ccda..13c5688 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -485,8 +485,8 @@ S:	Maintained
 F:	drivers/input/mouse/bcm5974.c
 
 APPLE SMC DRIVER
-M:	Nicolas Boichat <nicolas@boichat.ch>
-L:	mactel-linux-devel@lists.sourceforge.net
+M:	Henrik Rydberg <rydberg@euromail.se>
+L:	lm-sensors@lm-sensors.org
 S:	Maintained
 F:	drivers/hwmon/applesmc.c
 
-- 
1.6.3.3

