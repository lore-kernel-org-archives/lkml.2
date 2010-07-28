Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373Ab0G1OnI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 10:43:08 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:60547 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754941Ab0G1Okx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 10:40:53 -0400
From: Ernesto Ramos <ernesto@ti.com>
To: gregkh@suse.de
Cc: omar.ramirez@ti.com, ohad@wizery.com, ameya.palande@nokia.com,
        felipe.contreras@nokia.com, fernando.lugo@ti.com,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com, nm@ti.com,
        linux-omap@vger.kernel.org, Ernesto Ramos <ernesto@ti.com>
Subject: [PATCH 10/10] staging:ti dspbridge: remove DSP_FAILED macro definition
Date: Wed, 28 Jul 2010 09:45:33 -0500
Message-Id: <1280328333-31336-11-git-send-email-ernesto@ti.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1280328333-31336-10-git-send-email-ernesto@ti.com>
References: <1280328333-31336-1-git-send-email-ernesto@ti.com>
 <1280328333-31336-2-git-send-email-ernesto@ti.com>
 <1280328333-31336-3-git-send-email-ernesto@ti.com>
 <1280328333-31336-4-git-send-email-ernesto@ti.com>
 <1280328333-31336-5-git-send-email-ernesto@ti.com>
 <1280328333-31336-6-git-send-email-ernesto@ti.com>
 <1280328333-31336-7-git-send-email-ernesto@ti.com>
 <1280328333-31336-8-git-send-email-ernesto@ti.com>
 <1280328333-31336-9-git-send-email-ernesto@ti.com>
 <1280328333-31336-10-git-send-email-ernesto@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since status succeeded is now 0 macro DSP_FAILED
is not necessary anymore. This patch removes this
define.

Signed-off-by: Ernesto Ramos <ernesto@ti.com>
---
 .../staging/tidspbridge/include/dspbridge/dbdefs.h |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/tidspbridge/include/dspbridge/dbdefs.h b/drivers/staging/tidspbridge/include/dspbridge/dbdefs.h
index 2ccbfe1..5af075d 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/dbdefs.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/dbdefs.h
@@ -91,9 +91,6 @@
 #define DSPWORD       unsigned char
 #define DSPWORDSIZE     sizeof(DSPWORD)
 
-/* Failure macro */
-#define DSP_FAILED(status)         unlikely((s32)(status) < 0)
-
 /* Power control enumerations */
 #define PROC_PWRCONTROL             0x8070
 
-- 
1.5.4.5

