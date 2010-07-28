Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882Ab0G1Ogf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 10:36:35 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:35012 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754769Ab0G1Og3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 10:36:29 -0400
From: Ernesto Ramos <ernesto@ti.com>
To: gregkh@suse.de
Cc: omar.ramirez@ti.com, ohad@wizery.com, ameya.palande@nokia.com,
        felipe.contreras@nokia.com, fernando.lugo@ti.com,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com, nm@ti.com,
        linux-omap@vger.kernel.org, Ernesto Ramos <ernesto@ti.com>
Subject: [PATCH 1/5] staging:ti dspbridge: remove unused typedef REG16
Date: Wed, 28 Jul 2010 09:40:48 -0500
Message-Id: <1280328052-31292-2-git-send-email-ernesto@ti.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1280328052-31292-1-git-send-email-ernesto@ti.com>
References: <1280328052-31292-1-git-send-email-ernesto@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused typedef REG16 in dspbridge.

Signed-off-by: Ernesto Ramos <ernesto@ti.com>
---
 drivers/staging/tidspbridge/core/_tiomap.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/tidspbridge/core/_tiomap.h b/drivers/staging/tidspbridge/core/_tiomap.h
index b754e49..1c1f157 100644
--- a/drivers/staging/tidspbridge/core/_tiomap.h
+++ b/drivers/staging/tidspbridge/core/_tiomap.h
@@ -295,8 +295,6 @@ static const struct bpwr_clk_t bpwr_clks[] = {
 #define LOW_LEVEL                       false
 
 /* Macro's */
-#define REG16(A)    (*(reg_uword16 *)(A))
-
 #define CLEAR_BIT(reg, mask)             (reg &= ~mask)
 #define SET_BIT(reg, mask)               (reg |= mask)
 
-- 
1.5.4.5

