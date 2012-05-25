Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933336Ab2EYPse (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 11:48:34 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:51478 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933002Ab2EYPsc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 11:48:32 -0400
Date: Fri, 25 May 2012 17:48:12 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Alan Cox <alan@linux.intel.com>, Russell King <linux@arm.linux.org.uk>,
        x86@kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [PATCH 2/6] amba: use the new linux/sizes.h
Message-ID: <0e1b40d651ffbc654616173f2c3bf89888db21a5.1337959750.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
References: <cover.1337959750.git.rubini@gnudd.com>
In-Reply-To: <cover.1337959750.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
Cc: Russell King <linux@arm.linux.org.uk>
---
 drivers/amba/bus.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/amba/bus.c b/drivers/amba/bus.c
index b7e7285..e29bfa7 100644
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
