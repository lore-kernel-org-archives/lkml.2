Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530Ab2H2JCg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 05:02:36 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44189 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab2H2JCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 05:02:35 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>,
        kernel@pengutronix.de, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: [PATCH] MAINTAINERS: add defconfig file to TEGRA section
Date: Wed, 29 Aug 2012 11:02:29 +0200
Message-Id: <1346230949-6051-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 94b823f..39d8a59 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6779,6 +6779,7 @@ Q:	http://patchwork.ozlabs.org/project/linux-tegra/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/swarren/linux-tegra.git
 S:	Supported
 F:	arch/arm/mach-tegra
+F:	arch/arm/configs/tegra_defconfig
 
 TEHUTI ETHERNET DRIVER
 M:	Andy Gospodarek <andy@greyhouse.net>
-- 
1.7.10.4

