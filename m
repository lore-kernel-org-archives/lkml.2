Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601Ab0HYWQS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 18:16:18 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:39312 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754384Ab0HYWQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 18:16:15 -0400
From: Ivan Gomez Castellanos <ivan.gomez@ti.com>
To: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org, gregkh@suse.de
Cc: Hiroshi.DOYU@nokia.com, ameya.palande@nokia.com,
        felipe.contreras@nokia.com, omar.ramirez@ti.com, ohad@wizery.com,
        rene.sapiens@ti.com, nm@ti.com, ernesto@ti.com, x0095078@ti.com,
        Ivan Gomez Castellanos <ivan.gomez@ti.com>
Subject: [PATCH 01/11] staging: tidspbridge: Move sync.c from services to core
Date: Wed, 25 Aug 2010 17:08:54 -0500
Message-Id: <1282774144-11628-2-git-send-email-ivan.gomez@ti.com>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <1282774144-11628-1-git-send-email-ivan.gomez@ti.com>
References: <1282774144-11628-1-git-send-email-ivan.gomez@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the services directory is going to be removed, the file sync.c is moved
from services to core.

Signed-off-by: Ivan Gomez Castellanos <ivan.gomez@ti.com>
---
 drivers/staging/tidspbridge/Makefile               |    4 ++--
 .../staging/tidspbridge/{services => core}/sync.c  |    0
 2 files changed, 2 insertions(+), 2 deletions(-)
 rename drivers/staging/tidspbridge/{services => core}/sync.c (100%)

diff --git a/drivers/staging/tidspbridge/Makefile b/drivers/staging/tidspbridge/Makefile
index 6567172..50be983 100644
--- a/drivers/staging/tidspbridge/Makefile
+++ b/drivers/staging/tidspbridge/Makefile
@@ -1,11 +1,11 @@
 obj-$(CONFIG_TIDSPBRIDGE)	+= bridgedriver.o
 
 libgen = gen/gb.o gen/gs.o gen/gh.o gen/uuidutil.o
-libservices = services/sync.o services/cfg.o \
+libservices = services/cfg.o \
 		services/ntfy.o services/services.o
 libcore = core/chnl_sm.o core/msg_sm.o core/io_sm.o core/tiomap3430.o \
 		core/tiomap3430_pwr.o core/tiomap_io.o \
-		core/ue_deh.o core/wdt.o core/dsp-clock.o
+		core/ue_deh.o core/wdt.o core/dsp-clock.o core/sync.o
 libpmgr = pmgr/chnl.o pmgr/io.o pmgr/msg.o pmgr/cod.o pmgr/dev.o pmgr/dspapi.o \
 		pmgr/dmm.o pmgr/cmm.o pmgr/dbll.o
 librmgr = rmgr/dbdcd.o rmgr/disp.o rmgr/drv.o rmgr/mgr.o rmgr/node.o \
diff --git a/drivers/staging/tidspbridge/services/sync.c b/drivers/staging/tidspbridge/core/sync.c
similarity index 100%
rename from drivers/staging/tidspbridge/services/sync.c
rename to drivers/staging/tidspbridge/core/sync.c
-- 
1.7.0.3

