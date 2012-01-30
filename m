Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592Ab2A3XQP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 18:16:15 -0500
Received: from smtp4.mundo-r.com ([212.51.32.151]:38613 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371Ab2A3XMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 18:12:48 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap4EAB4jJ09bdWOb/2dsb2JhbABDhQuqUYFzAQUjDwEjIxAlAhgOAgI5AxsGARKHf6cGkV2BL4lQAQUCAgIIAQEEDQQGAQsJCBQXgzNeFYJCgRYElRqFVox8
X-IronPort-AV: E=Sophos;i="4.71,592,1320620400"; 
   d="scan'208";a="945795217"
From: =?UTF-8?q?V=C3=ADctor=20Manuel=20J=C3=A1quez=20Leal?= 
	<vjaquez@igalia.com>
To: Omar Ramirez Luna <omar.ramirez@ti.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Armando Uribe <x0095078@ti.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-omap@vger.kernel.org,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: [PATCH v2 5/8] staging: tidspbridge: remove header inclusions
Date: Tue, 31 Jan 2012 00:12:21 +0100
Message-Id: <bfe22b3bafff240ea51008b2cca4a4cdacde958e.1327964066.git.vjaquez@igalia.com>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <cover.1327964066.git.vjaquez@igalia.com>
References: <cover.1327964066.git.vjaquez@igalia.com>
In-Reply-To: <cover.1327964066.git.vjaquez@igalia.com>
References: <cover.1327964066.git.vjaquez@igalia.com>
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
index 7a6401a..4531920 100644
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

