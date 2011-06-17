Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759127Ab1FQWNh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 18:13:37 -0400
Received: from mga02.intel.com ([134.134.136.20]:22457 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756700Ab1FQWNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 18:13:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,383,1304319600"; 
   d="scan'208";a="14917993"
From: james_p_freyensee@linux.intel.com
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, christophe.guerard@intel.com,
        james_p_freyensee@linux.intel.com, rocher.jeremy@gmail.com
Subject: [PATCH] 0 for o PTI Makefile bug.
Date: Fri, 17 Jun 2011 15:13:33 -0700
Message-Id: <1308348813-19932-1-git-send-email-james_p_freyensee@linux.intel.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <james_p_freyensee@linux.intel.com>
References: <james_p_freyensee@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: J Freyensee <james_p_freyensee@linux.intel.com>

This patch fixes an issue where 'obj' was actually
spelled '0bj' and would skip compiling the pti driver.

Signed-off-by: J Freyensee <james_p_freyensee@linux.intel.com>
---
 drivers/misc/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 5f03172..fa429f5 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -6,7 +6,7 @@ obj-$(CONFIG_IBM_ASM)		+= ibmasm/
 obj-$(CONFIG_AD525X_DPOT)	+= ad525x_dpot.o
 obj-$(CONFIG_AD525X_DPOT_I2C)	+= ad525x_dpot-i2c.o
 obj-$(CONFIG_AD525X_DPOT_SPI)	+= ad525x_dpot-spi.o
-0bj-$(CONFIG_INTEL_MID_PTI)	+= pti.o
+obj-$(CONFIG_INTEL_MID_PTI)	+= pti.o
 obj-$(CONFIG_ATMEL_PWM)		+= atmel_pwm.o
 obj-$(CONFIG_ATMEL_SSC)		+= atmel-ssc.o
 obj-$(CONFIG_ATMEL_TCLIB)	+= atmel_tclib.o
-- 
1.7.2.3

