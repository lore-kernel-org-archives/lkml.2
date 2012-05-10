Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761475Ab2EJA0j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 20:26:39 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49929 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab2EJA0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 20:26:37 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: rpurdie@rpsys.net, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        arnd.bergmann@linaro.org
Subject: [PATCH] MAINTAINERS: Add maintainer for LED subsystem
Date: Thu, 10 May 2012 08:26:32 +0800
Message-Id: <1336609592-3825-1-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Bryan Wu as the primary maintainer for drivers/leds

Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
---
 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7071633..de4e280 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4034,6 +4034,7 @@ F:	Documentation/scsi/53c700.txt
 F:	drivers/scsi/53c700*
 
 LED SUBSYSTEM
+M:	Bryan Wu <bryan.wu@canonical.com>
 M:	Richard Purdie <rpurdie@rpsys.net>
 S:	Maintained
 F:	drivers/leds/
-- 
1.7.9.5

