Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034Ab2GRJUt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 05:20:49 -0400
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:54472 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752602Ab2GRJUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 05:20:20 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, peter.ujfalusi@ti.com
Subject: [PATCH 1/3] mfd: twl6040: Fix GPO mask
Date: Wed, 18 Jul 2012 11:20:18 +0200
Message-Id: <1342603220-13287-2-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1342603220-13287-1-git-send-email-peter.ujfalusi@ti.com>
References: <1342603220-13287-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 include/linux/mfd/twl6040.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/mfd/twl6040.h b/include/linux/mfd/twl6040.h
index eaad49f..269b706 100644
--- a/include/linux/mfd/twl6040.h
+++ b/include/linux/mfd/twl6040.h
@@ -143,7 +143,7 @@
 
 #define TWL6040_GPO1			0x01
 #define TWL6040_GPO2			0x02
-#define TWL6040_GPO3			0x03
+#define TWL6040_GPO3			0x04
 
 /* ACCCTL (0x2D) fields */
 
-- 
1.7.8.6

