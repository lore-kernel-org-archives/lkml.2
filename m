Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966280Ab2CAN3P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 08:29:15 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:62281 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966222Ab2CAN3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 08:29:14 -0500
Date: Thu, 1 Mar 2012 14:28:57 +0100
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Alan Cox <alan@linux.intel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: [PATCH 3/4] amba: use the new linux/sizes.h
Message-ID: <77a3185dda7be993be3538c9e5cc59e6d95f14aa.1330607068.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
References: <cover.1330607068.git.rubini@gnudd.com>
In-Reply-To: <cover.1330607068.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Alan Cox <alan@linux.intel.com>
---
 drivers/amba/bus.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/amba/bus.c b/drivers/amba/bus.c
index 01c2cf4..d7fe84a 100644
--- a/drivers/amba/bus.c
+++ b/drivers/amba/bus.c
@@ -18,7 +18,7 @@
 #include <linux/amba/bus.h>
 
 #include <asm/irq.h>
-#include <asm/sizes.h>
+#include <linux/sizes.h>
 
 #define to_amba_driver(d)	container_of(d, struct amba_driver, drv)
 
-- 
1.7.7.2
