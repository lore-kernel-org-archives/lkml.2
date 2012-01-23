Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357Ab2AWUVA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 15:21:00 -0500
Received: from smtp4.mundo-r.com ([212.51.32.151]:45245 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754205Ab2AWUTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 15:19:52 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap4EAGO9HU9bdWOb/2dsb2JhbABChQmqJoFzAQUjDwEjIxAlAhgOAgI5AxsGARKHfqcNkTGBL4lhgRYElRmFVox6
X-IronPort-AV: E=Sophos;i="4.71,557,1320620400"; 
   d="scan'208";a="865381580"
From: =?UTF-8?q?V=C3=ADctor=20Manuel=20J=C3=A1quez=20Leal?= 
	<vjaquez@igalia.com>
To: Omar Ramirez Luna <omar.ramirez@ti.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Armando Uribe <x0095078@ti.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-omap@vger.kernel.org,
        Felipe Contreras <felipe.contreras@gmail.com>,
        "Nishanth Menon" <nm@ti.com>
Subject: [PATCH 5/5] staging: tidspbridge: remove header inclusions
Date: Mon, 23 Jan 2012 22:09:48 +0200
Message-Id: <ec2918bc4e35efdc693be2d86832b9b47f9fd10b.1327348286.git.vjaquez@igalia.com>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <cover.1327348286.git.vjaquez@igalia.com>
References: <cover.1327348286.git.vjaquez@igalia.com>
In-Reply-To: <cover.1327348286.git.vjaquez@igalia.com>
References: <cover.1327348286.git.vjaquez@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drv_interface.c include several header files that are not really used.

Signed-off-by: Víctor Manuel Jáquez Leal <vjaquez@igalia.com>
---
 drivers/staging/tidspbridge/rmgr/drv_interface.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/tidspbridge/rmgr/drv_interface.c b/drivers/staging/tidspbridge/rmgr/drv_interface.c
index 3bbe443..96cc2e9 100644
--- a/drivers/staging/tidspbridge/rmgr/drv_interface.c
+++ b/drivers/staging/tidspbridge/rmgr/drv_interface.c
@@ -16,11 +16,8 @@
  * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
  */
 
-/*  ----------------------------------- Host OS */
-
 #include <plat/dsp.h>
 
-#include <dspbridge/host_os.h>
 #include <linux/types.h>
 #include <linux/platform_device.h>
 #include <linux/pm.h>
@@ -38,10 +35,8 @@
 
 /*  ----------------------------------- OS Adaptation Layer */
 #include <dspbridge/clk.h>
-#include <dspbridge/sync.h>
 
 /*  ----------------------------------- Platform Manager */
-#include <dspbridge/dspapi-ioctl.h>
 #include <dspbridge/dspapi.h>
 #include <dspbridge/dspdrv.h>
 
@@ -49,10 +44,8 @@
 #include <dspbridge/pwr.h>
 
 #include <dspbridge/resourcecleanup.h>
-#include <dspbridge/chnl.h>
 #include <dspbridge/proc.h>
 #include <dspbridge/dev.h>
-#include <dspbridge/drv.h>
 
 #ifdef CONFIG_TIDSPBRIDGE_DVFS
 #include <mach-omap2/omap3-opp.h>
-- 
1.7.8.3

