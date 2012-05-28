Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978Ab2E1Qhq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 12:37:46 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:43100 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754906Ab2E1Qhn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 12:37:43 -0400
Date: Mon, 28 May 2012 18:37:25 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Alan Cox <alan@linux.intel.com>, Russell King <linux@arm.linux.org.uk>,
        x86@kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [PATCH V2 2/6] amba: use the new linux/sizes.h
Message-ID: <47bf886a2bc4d9e65b14a5700d5aa874232ec32a.1338222461.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
References: <cover.1338222460.git.rubini@gnudd.com>
In-Reply-To: <cover.1338222460.git.rubini@gnudd.com>
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
index b7e7285..e8eb91b 100644
--- a/drivers/amba/bus.c
+++ b/drivers/amba/bus.c
@@ -16,9 +16,9 @@
 #include <linux/pm.h>
 #include <linux/pm_runtime.h>
 #include <linux/amba/bus.h>
+#include <linux/sizes.h>
 
 #include <asm/irq.h>
-#include <asm/sizes.h>
 
 #define to_amba_driver(d)	container_of(d, struct amba_driver, drv)
 
-- 
1.7.7.2
