Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139Ab0GLW4p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 18:56:45 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:39461 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755911Ab0GLW4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 18:56:23 -0400
From: Nishanth Menon <nm@ti.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Omar Ramirez Luna <omar.ramirez@ti.com>, Ohad Ben-Cohen <ohad@wizery.com>,
        Ameya Palande <ameya.palande@nokia.com>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>, Nishanth Menon <nm@ti.com>
Subject: [PATCH 11/11] staging: tidspbridge: remove dbdefs.h
Date: Mon, 12 Jul 2010 17:56:09 -0500
Message-Id: <1278975369-7687-12-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1278975369-7687-1-git-send-email-nm@ti.com>
References: <1278975369-7687-1-git-send-email-nm@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove yet another custom definition header

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 .../staging/tidspbridge/include/dspbridge/dbdefs.h |    1 -
 .../staging/tidspbridge/include/dspbridge/dbtype.h |   69 --------------------
 .../tidspbridge/include/dspbridge/host_os.h        |    1 -
 3 files changed, 0 insertions(+), 71 deletions(-)
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/dbtype.h

diff --git a/drivers/staging/tidspbridge/include/dspbridge/dbdefs.h b/drivers/staging/tidspbridge/include/dspbridge/dbdefs.h
index b408cad..ff0ba57 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/dbdefs.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/dbdefs.h
@@ -21,7 +21,6 @@
 
 #include <linux/types.h>
 
-#include <dspbridge/dbtype.h>	/* GPP side type definitions */
 #include <dspbridge/rms_sh.h>	/* Types shared between GPP and DSP */
 
 #define PG_SIZE4K 4096
diff --git a/drivers/staging/tidspbridge/include/dspbridge/dbtype.h b/drivers/staging/tidspbridge/include/dspbridge/dbtype.h
deleted file mode 100644
index ca5eaf8..0000000
--- a/drivers/staging/tidspbridge/include/dspbridge/dbtype.h
+++ /dev/null
@@ -1,69 +0,0 @@
-/*
- * dbtype.h
- *
- * DSP-BIOS Bridge driver support functions for TI OMAP processors.
- *
- * This header defines data types for DSP/BIOS Bridge APIs and device
- * driver modules. It also defines the Hungarian prefix to use for each
- * base type.
- *
- * Copyright (C) 2008 Texas Instruments, Inc.
- *
- * This package is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
- * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
- * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
- */
-
-#ifndef DBTYPE_
-#define DBTYPE_
-
-/*===========================================================================*/
-/*  Argument specification syntax */
-/*===========================================================================*/
-
-#ifndef IN
-#define IN			/* Following parameter is for input. */
-#endif
-
-#ifndef OUT
-#define OUT			/* Following parameter is for output. */
-#endif
-
-#ifndef OPTIONAL
-#define OPTIONAL	/* Function may optionally use previous parameter. */
-#endif
-
-#ifndef CONST
-#define CONST   const
-#endif
-
-/*===========================================================================*/
-/*  NULL character   (normally used for string termination) */
-/*===========================================================================*/
-
-#ifndef NULL_CHAR
-#define NULL_CHAR    '\0'	/* Null character. */
-#endif
-
-/*===========================================================================*/
-/*  Basic Type definitions (with Prefixes for Hungarian notation) */
-/*===========================================================================*/
-
-#ifndef OMAPBRIDGE_TYPES
-#define OMAPBRIDGE_TYPES
-typedef volatile unsigned short reg_uword16;
-#endif
-
-#define TEXT(x) x
-
-#define DLLIMPORT
-#define DLLEXPORT
-
-/* Define DSPAPIDLL correctly in dspapi.h */
-#define _DSPSYSDLL32_
-
-#endif /* DBTYPE_ */
diff --git a/drivers/staging/tidspbridge/include/dspbridge/host_os.h b/drivers/staging/tidspbridge/include/dspbridge/host_os.h
index a91c136..6b4feb4 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/host_os.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/host_os.h
@@ -42,7 +42,6 @@
 #include <linux/vmalloc.h>
 #include <linux/ioport.h>
 #include <linux/platform_device.h>
-#include <dspbridge/dbtype.h>
 #include <plat/clock.h>
 #include <linux/clk.h>
 #include <plat/mailbox.h>
-- 
1.6.3.3

