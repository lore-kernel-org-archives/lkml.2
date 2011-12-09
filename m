Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109Ab1LIEXF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 23:23:05 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:39001 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753277Ab1LIEXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 23:23:01 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Shawn Guo <shawn.guo@linaro.org>, Chris Ball <cjb@laptop.org>,
        Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: [PATCH v3.2 07/10] MAINTAINERS: Update sdhci F: patterns
Date: Thu,  8 Dec 2011 20:21:45 -0800
Message-Id: <0a00b150590f5883bc80ada3dc632f6770ff63ce.1323401278.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1323401278.git.joe@perches.com>
References: <cover.1323401278.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 38576af1f8c ("mmc: sdhci: make sdhci-of device drivers self registered")
moved the files around. Update the patterns.

CC: Shawn Guo <shawn.guo@linaro.org>
CC: Chris Ball <cjb@laptop.org>
CC: Anton Vorontsov <avorontsov@ru.mvista.com>

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 96c354c..d7a279f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5796,13 +5796,14 @@ L:	linux-mmc@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git
 S:	Maintained
 F:	drivers/mmc/host/sdhci.*
+F:	drivers/mmc/host/sdhci-pltfm.[ch]
 
 SECURE DIGITAL HOST CONTROLLER INTERFACE, OPEN FIRMWARE BINDINGS (SDHCI-OF)
 M:	Anton Vorontsov <avorontsov@ru.mvista.com>
 L:	linuxppc-dev@lists.ozlabs.org
 L:	linux-mmc@vger.kernel.org
 S:	Maintained
-F:	drivers/mmc/host/sdhci-of.*
+F:	drivers/mmc/host/sdhci-pltfm.[ch]
 
 SECURE DIGITAL HOST CONTROLLER INTERFACE (SDHCI) SAMSUNG DRIVER
 M:	Ben Dooks <ben-linux@fluff.org>
-- 
1.7.8.111.gad25c.dirty

