Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252Ab0FWNNf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 09:13:35 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:39241 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081Ab0FWNNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 09:13:33 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: Greg KH <greg@kroah.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
       Hebbar Shivananda <x0hebbar@ti.com>,
       Ramos Falcon Ernesto <ernesto@ti.com>, Anna Suman <s-anna@ti.com>,
       Kanigeri Hari <h-kanigeri2@ti.com>,
       Felipe Contreras <felipe.contreras@gmail.com>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Hiroshi DOYU <Hiroshi.DOYU@nokia.com>, Gupta Ramesh <grgupta@ti.com>,
       Guzman Lugo Fernando <fernando.lugo@ti.com>,
       Tony Lindgren <tony@atomide.com>,
       Ameya Palande <ameya.palande@nokia.com>,
       Gomez Castellanos Ivan <ivan.gomez@ti.com>,
       Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
       Armando Uribe De Leon <x0095078@ti.com>,
       Deepak Chitriki <deepak.chitriki@ti.com>, Menon Nishanth <nm@ti.com>,
       Phil Carmody <ext-phil.2.carmody@nokia.com>,
       Pitney Gilbert <gpitney@ti.com>, Bhavin Shah <bshah@ti.com>,
       Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH 10/11] staging: ti dspbridge: add TODO file
Date: Wed, 23 Jun 2010 16:13:22 +0300
Message-Id: <1277298802-18456-1-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1277298125-17991-1-git-send-email-ohad@wizery.com>
References: <1277298125-17991-1-git-send-email-ohad@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a general cleaning roadmap TODO file to TI's DSP Bridge
staging driver.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
I can also be reached at <  ohadb at ti dot com  >

 drivers/staging/tidspbridge/TODO |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/tidspbridge/TODO

diff --git a/drivers/staging/tidspbridge/TODO b/drivers/staging/tidspbridge/TODO
new file mode 100644
index 0000000..54f4a29
--- /dev/null
+++ b/drivers/staging/tidspbridge/TODO
@@ -0,0 +1,18 @@
+* Migrate to (and if necessary, extend) existing upstream code such as 
+  iommu, wdt, mcbsp, gptimers
+* Decouple hardware-specific code (e.g. bridge_brd_start/stop/delete/monitor)
+* DOFF binary loader: consider pushing to user space. at the very least
+  eliminate the direct filesystem access
+* Eliminate general services and libraries - use or extend existing kernel
+  libraries instead (e.g. gcf/lcm in nldr.c, global helpers in gen/)
+* Eliminate direct manipulation of OMAP_SYSC_BASE
+* Eliminate list.h : seem like a redundant wrapper to existing kernel lists
+* Eliminate DSP_SUCCEEDED macros and their imposed redundant indentations
+  (adopt the kernel way of checking for return values)
+* Audit interfaces exposed to user space
+* Audit and clean up header files folder
+* Use kernel coding style
+* checkpatch.pl fixes
+
+Please send any patches to Greg Kroah-Hartman <greg@kroah.com>
+and Omar Ramirez Luna <omar.ramirez@ti.com>.
-- 
1.7.0.4

