Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063Ab1BIARm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 19:17:42 -0500
Received: from mga11.intel.com ([192.55.52.93]:60791 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755995Ab1BIARl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 19:17:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,444,1291622400"; 
   d="scan'208";a="885669221"
From: james_p_freyensee@linux.intel.com
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, suhail.ahmed@intel.com,
        james_p_freyensee@linux.intel.com
Subject: [PATCH 05/12] PTI misc Makefile addition.
Date: Tue,  8 Feb 2011 16:17:10 -0800
Message-Id: <1297210637-5934-5-git-send-email-james_p_freyensee@linux.intel.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1297210637-5934-4-git-send-email-james_p_freyensee@linux.intel.com>
References: <james_p_freyensee@linux.intel.com>
 <1297210637-5934-2-git-send-email-james_p_freyensee@linux.intel.com>
 <1297210637-5934-3-git-send-email-james_p_freyensee@linux.intel.com>
 <1297210637-5934-4-git-send-email-james_p_freyensee@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: J Freyensee <james_p_freyensee@linux.intel.com>

This allows the Intel implementation of the PTI standard to be compiled.

Signed-off-by: J Freyensee <james_p_freyensee@linux.intel.com>
---
 drivers/misc/Makefile |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 98009cc..cae0463 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -6,6 +6,7 @@ obj-$(CONFIG_IBM_ASM)		+= ibmasm/
 obj-$(CONFIG_AD525X_DPOT)	+= ad525x_dpot.o
 obj-$(CONFIG_AD525X_DPOT_I2C)	+= ad525x_dpot-i2c.o
 obj-$(CONFIG_AD525X_DPOT_SPI)	+= ad525x_dpot-spi.o
+obj-$(CONFIG_INTEL_MID_PTI)     += pti.o
 obj-$(CONFIG_ATMEL_PWM)		+= atmel_pwm.o
 obj-$(CONFIG_ATMEL_SSC)		+= atmel-ssc.o
 obj-$(CONFIG_ATMEL_TCLIB)	+= atmel_tclib.o
-- 
1.6.6.1

