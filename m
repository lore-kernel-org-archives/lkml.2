Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932591Ab2KXA1O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 19:27:14 -0500
Received: from smtp-02.mandic.com.br ([200.225.81.133]:40796 "EHLO
	smtp-02.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932524Ab2KXA1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 19:27:11 -0500
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: linux-kernel@vger.kernel.org
Cc: Cesar Eduardo Barros <cesarb@cesarb.net>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH 03/24] MAINTAINERS: remove arch/arm/plat-s5p/
Date: Fri, 23 Nov 2012 22:26:27 -0200
Message-Id: <1353716808-16375-4-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1353716808-16375-1-git-send-email-cesarb@cesarb.net>
References: <1353716808-16375-1-git-send-email-cesarb@cesarb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These files were merged into plat-samsung.

Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-samsung-soc@vger.kernel.org
Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
---
 MAINTAINERS | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 041872a..9bdd5f3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1074,7 +1074,6 @@ W:	http://www.fluff.org/ben/linux/
 S:	Maintained
 F:	arch/arm/plat-samsung/
 F:	arch/arm/plat-s3c24xx/
-F:	arch/arm/plat-s5p/
 F:	arch/arm/mach-s3c24*/
 F:	arch/arm/mach-s3c64xx/
 F:	drivers/*/*s3c2410*
@@ -1105,7 +1104,6 @@ M:	Sylwester Nawrocki <s.nawrocki@samsung.com>
 L:	linux-arm-kernel@lists.infradead.org
 L:	linux-media@vger.kernel.org
 S:	Maintained
-F:	arch/arm/plat-s5p/dev-fimc*
 F:	arch/arm/plat-samsung/include/plat/*fimc*
 F:	drivers/media/platform/s5p-fimc/
 
@@ -1116,7 +1114,7 @@ M:	Jeongtae Park <jtp.park@samsung.com>
 L:	linux-arm-kernel@lists.infradead.org
 L:	linux-media@vger.kernel.org
 S:	Maintained
-F:	arch/arm/plat-s5p/dev-mfc.c
+F:	arch/arm/plat-samsung/s5p-dev-mfc.c
 F:	drivers/media/platform/s5p-mfc/
 
 ARM/SAMSUNG S5P SERIES TV SUBSYSTEM SUPPORT
-- 
1.7.11.7

