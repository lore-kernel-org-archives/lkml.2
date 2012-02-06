Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115Ab2BFXkD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 18:40:03 -0500
Received: from smtp4.mundo-r.com ([212.51.32.151]:51604 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874Ab2BFXj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 18:39:56 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap4EADRkME9bdWOb/2dsb2JhbABDhQurP4FzAQUjBAsBIyMQJQIYDgICOQMbBgESh3+mR5IngS+JfwEFAgICCAEBBA0EBgELCQgUg0peFYJCgRYElSiFWI0E
X-IronPort-AV: E=Sophos;i="4.73,373,1325458800"; 
   d="scan'208";a="473049154"
From: =?UTF-8?q?V=C3=ADctor=20Manuel=20J=C3=A1quez=20Leal?= 
	<vjaquez@igalia.com>
To: Omar Ramirez Luna <omar.ramirez@ti.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-omap@vger.kernel.org,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: [PATCH 3/4] staging: tidspbridge: remove dbc.h
Date: Tue,  7 Feb 2012 00:39:36 +0100
Message-Id: <2ce17419b1f2e9701cb11dc81f31379f894310d8.1328563908.git.vjaquez@igalia.com>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <cover.1328563908.git.vjaquez@igalia.com>
References: <cover.1328563908.git.vjaquez@igalia.com>
In-Reply-To: <cover.1328563908.git.vjaquez@igalia.com>
References: <cover.1328563908.git.vjaquez@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the macros in dbc.h are removed now so this patch removes it completely.

Signed-off-by: Víctor Manuel Jáquez Leal <vjaquez@igalia.com>
---
 drivers/staging/tidspbridge/core/chnl_sm.c         |    3 --
 drivers/staging/tidspbridge/core/dsp-clock.c       |    3 --
 drivers/staging/tidspbridge/core/io_sm.c           |    3 --
 drivers/staging/tidspbridge/core/msg_sm.c          |    3 --
 drivers/staging/tidspbridge/core/tiomap3430.c      |    3 --
 drivers/staging/tidspbridge/core/tiomap_io.c       |    3 --
 drivers/staging/tidspbridge/gen/uuidutil.c         |    3 --
 .../staging/tidspbridge/include/dspbridge/dbc.h    |   28 --------------------
 drivers/staging/tidspbridge/pmgr/chnl.c            |    3 --
 drivers/staging/tidspbridge/pmgr/cmm.c             |    3 --
 drivers/staging/tidspbridge/pmgr/cod.c             |    3 --
 drivers/staging/tidspbridge/pmgr/dbll.c            |    2 -
 drivers/staging/tidspbridge/pmgr/dev.c             |    3 --
 drivers/staging/tidspbridge/pmgr/dmm.c             |    3 --
 drivers/staging/tidspbridge/pmgr/dspapi.c          |    3 --
 drivers/staging/tidspbridge/pmgr/io.c              |    3 --
 drivers/staging/tidspbridge/pmgr/msg.c             |    3 --
 drivers/staging/tidspbridge/rmgr/dbdcd.c           |    2 -
 drivers/staging/tidspbridge/rmgr/disp.c            |    3 --
 drivers/staging/tidspbridge/rmgr/drv.c             |    3 --
 drivers/staging/tidspbridge/rmgr/drv_interface.c   |    3 --
 drivers/staging/tidspbridge/rmgr/dspdrv.c          |    3 --
 drivers/staging/tidspbridge/rmgr/mgr.c             |    3 --
 drivers/staging/tidspbridge/rmgr/nldr.c            |    2 -
 drivers/staging/tidspbridge/rmgr/node.c            |    3 --
 drivers/staging/tidspbridge/rmgr/proc.c            |    3 --
 drivers/staging/tidspbridge/rmgr/rmm.c             |    3 --
 drivers/staging/tidspbridge/rmgr/strm.c            |    3 --
 28 files changed, 0 insertions(+), 106 deletions(-)
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/dbc.h

diff --git a/drivers/staging/tidspbridge/core/chnl_sm.c b/drivers/staging/tidspbridge/core/chnl_sm.c
index 3136e8d..e0c7e4c 100644
--- a/drivers/staging/tidspbridge/core/chnl_sm.c
+++ b/drivers/staging/tidspbridge/core/chnl_sm.c
@@ -50,9 +50,6 @@
 /*  ----------------------------------- DSP/BIOS Bridge */
 #include <dspbridge/dbdefs.h>
 
-/*  ----------------------------------- Trace & Debug */
-#include <dspbridge/dbc.h>
-
 /*  ----------------------------------- OS Adaptation Layer */
 #include <dspbridge/sync.h>
 
diff --git a/drivers/staging/tidspbridge/core/dsp-clock.c b/drivers/staging/tidspbridge/core/dsp-clock.c
index 7eb5617..c7df34e 100644
--- a/drivers/staging/tidspbridge/core/dsp-clock.c
+++ b/drivers/staging/tidspbridge/core/dsp-clock.c
@@ -29,9 +29,6 @@
 #include <dspbridge/dev.h>
 #include "_tiomap.h"
 
-/*  ----------------------------------- Trace & Debug */
-#include <dspbridge/dbc.h>
-
 /*  ----------------------------------- This */
 #include <dspbridge/clk.h>
 
diff --git a/drivers/staging/tidspbridge/core/io_sm.c b/drivers/staging/tidspbridge/core/io_sm.c
index 0930a98..d47b861 100644
--- a/drivers/staging/tidspbridge/core/io_sm.c
+++ b/drivers/staging/tidspbridge/core/io_sm.c
@@ -33,9 +33,6 @@
 /*  ----------------------------------- DSP/BIOS Bridge */
 #include <dspbridge/dbdefs.h>
 
-/* Trace & Debug */
-#include <dspbridge/dbc.h>
-
 /* Services Layer */
 #include <dspbridge/ntfy.h>
 #include <dspbridge/sync.h>
diff --git a/drivers/staging/tidspbridge/core/msg_sm.c b/drivers/staging/tidspbridge/core/msg_sm.c
index 94d9e04..ce9557e 100644
--- a/drivers/staging/tidspbridge/core/msg_sm.c
+++ b/drivers/staging/tidspbridge/core/msg_sm.c
@@ -20,9 +20,6 @@
 /*  ----------------------------------- DSP/BIOS Bridge */
 #include <dspbridge/dbdefs.h>
 
-/*  ----------------------------------- Trace & Debug */
-#include <dspbridge/dbc.h>
-
 /*  ----------------------------------- OS Adaptation Layer */
 #include <dspbridge/sync.h>
 
diff --git a/drivers/staging/tidspbridge/core/tiomap3430.c b/drivers/staging/tidspbridge/core/tiomap3430.c
index c3efc2e..fd84632 100644
--- a/drivers/staging/tidspbridge/core/tiomap3430.c
+++ b/drivers/staging/tidspbridge/core/tiomap3430.c
@@ -27,9 +27,6 @@
 /*  ----------------------------------- DSP/BIOS Bridge */
 #include <dspbridge/dbdefs.h>
 
-/*  ----------------------------------- Trace & Debug */
-#include <dspbridge/dbc.h>
-
 /*  ----------------------------------- OS Adaptation Layer */
 #include <dspbridge/drv.h>
 #include <dspbridge/sync.h>
diff --git a/drivers/staging/tidspbridge/core/tiomap_io.c b/drivers/staging/tidspbridge/core/tiomap_io.c
index 9c18873..7fda10c 100644
--- a/drivers/staging/tidspbridge/core/tiomap_io.c
+++ b/drivers/staging/tidspbridge/core/tiomap_io.c
@@ -21,9 +21,6 @@
 /*  ----------------------------------- DSP/BIOS Bridge */
 #include <dspbridge/dbdefs.h>
 
-/*  ----------------------------------- Trace & Debug */
-#include <dspbridge/dbc.h>
-
 /*  ----------------------------------- Platform Manager */
 #include <dspbridge/dev.h>
 #include <dspbridge/drv.h>
diff --git a/drivers/staging/tidspbridge/gen/uuidutil.c b/drivers/staging/tidspbridge/gen/uuidutil.c
index 5797fb5..b44656c 100644
--- a/drivers/staging/tidspbridge/gen/uuidutil.c
+++ b/drivers/staging/tidspbridge/gen/uuidutil.c
@@ -23,9 +23,6 @@
 /*  ----------------------------------- DSP/BIOS Bridge */
 #include <dspbridge/dbdefs.h>
 
-/*  ----------------------------------- Trace & Debug */
-#include <dspbridge/dbc.h>
-
 /*  ----------------------------------- This */
 #include <dspbridge/uuidutil.h>
 
diff --git a/drivers/staging/tidspbridge/include/dspbridge/dbc.h b/drivers/staging/tidspbridge/include/dspbridge/dbc.h
deleted file mode 100644
index 90c45f6..0000000
--- a/drivers/staging/tidspbridge/include/dspbridge/dbc.h
+++ /dev/null
@@ -1,28 +0,0 @@
-/*
- * dbc.h
- *
- * DSP-BIOS Bridge driver support functions for TI OMAP processors.
- *
- * "Design by Contract" programming macros.
- *
- * Notes:
- *   Requires that the GT->ERROR function has been defaulted to a valid
- *   error handler for the given execution environment.
- *
- *   Does not require that GT_init() be called.
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
-#ifndef DBC_
-#define DBC_
-
-#endif /* DBC_ */
diff --git a/drivers/staging/tidspbridge/pmgr/chnl.c b/drivers/staging/tidspbridge/pmgr/chnl.c
index 61ee0f0..825be20 100644
--- a/drivers/staging/tidspbridge/pmgr/chnl.c
+++ b/drivers/staging/tidspbridge/pmgr/chnl.c
@@ -24,9 +24,6 @@
 /*  ----------------------------------- DSP/BIOS Bridge */
 #include <dspbridge/dbdefs.h>
 
-/*  ----------------------------------- Trace & Debug */
-#include <dspbridge/dbc.h>
-
 /*  ----------------------------------- OS Adaptation Layer */
 #include <dspbridge/sync.h>
 
diff --git a/drivers/staging/tidspbridge/pmgr/cmm.c b/drivers/staging/tidspbridge/pmgr/cmm.c
index 0d19bcd..3366e60 100644
--- a/drivers/staging/tidspbridge/pmgr/cmm.c
+++ b/drivers/staging/tidspbridge/pmgr/cmm.c
@@ -35,9 +35,6 @@
 /*  ----------------------------------- DSP/BIOS Bridge */
 #include <dspbridge/dbdefs.h>
 
-/*  ----------------------------------- Trace & Debug */
-#include <dspbridge/dbc.h>
-
 /*  ----------------------------------- OS Adaptation Layer */
 #include <dspbridge/sync.h>
 
diff --git a/drivers/staging/tidspbridge/pmgr/cod.c b/drivers/staging/tidspbridge/pmgr/cod.c
index be7c777..d01fb8e 100644
--- a/drivers/staging/tidspbridge/pmgr/cod.c
+++ b/drivers/staging/tidspbridge/pmgr/cod.c
@@ -30,9 +30,6 @@
 /*  ----------------------------------- DSP/BIOS Bridge */
 #include <dspbridge/dbdefs.h>
 
-/*  ----------------------------------- Trace & Debug */
-#include <dspbridge/dbc.h>
-
 /*  ----------------------------------- Platform Manager */
 /* Include appropriate loader header file */
 #include <dspbridge/dbll.h>
diff --git a/drivers/staging/tidspbridge/pmgr/dbll.c b/drivers/staging/tidspbridge/pmgr/dbll.c
index 997feeb..071ee86 100644
--- a/drivers/staging/tidspbridge/pmgr/dbll.c
+++ b/drivers/staging/tidspbridge/pmgr/dbll.c
@@ -21,8 +21,6 @@
 /*  ----------------------------------- DSP/BIOS Bridge */
 #include <dspbridge/dbdefs.h>
 
-/*  ----------------------------------- Trace & Debug */
-#include <dspbridge/dbc.h>
 #include <dspbridge/gh.h>
 
 /*  ----------------------------------- OS Adaptation Layer */
diff --git a/drivers/staging/tidspbridge/pmgr/dev.c b/drivers/staging/tidspbridge/pmgr/dev.c
index 980bd53..883765e 100644
--- a/drivers/staging/tidspbridge/pmgr/dev.c
+++ b/drivers/staging/tidspbridge/pmgr/dev.c
@@ -24,9 +24,6 @@
 /*  ----------------------------------- DSP/BIOS Bridge */
 #include <dspbridge/dbdefs.h>
 
-/*  ----------------------------------- Trace & Debug */
-#include <dspbridge/dbc.h>
-
 /*  ----------------------------------- Platform Manager */
 #include <dspbridge/cod.h>
 #include <dspbridge/drv.h>
diff --git a/drivers/staging/tidspbridge/pmgr/dmm.c b/drivers/staging/tidspbridge/pmgr/dmm.c
index cece780..83faff8 100644
--- a/drivers/staging/tidspbridge/pmgr/dmm.c
+++ b/drivers/staging/tidspbridge/pmgr/dmm.c
@@ -28,9 +28,6 @@
 /*  ----------------------------------- DSP/BIOS Bridge */
 #include <dspbridge/dbdefs.h>
 
-/*  ----------------------------------- Trace & Debug */
-#include <dspbridge/dbc.h>
-
 /*  ----------------------------------- OS Adaptation Layer */
 #include <dspbridge/sync.h>
 
diff --git a/drivers/staging/tidspbridge/pmgr/dspapi.c b/drivers/staging/tidspbridge/pmgr/dspapi.c
index 27c14a5..2788946 100644
--- a/drivers/staging/tidspbridge/pmgr/dspapi.c
+++ b/drivers/staging/tidspbridge/pmgr/dspapi.c
@@ -24,9 +24,6 @@
 /*  ----------------------------------- DSP/BIOS Bridge */
 #include <dspbridge/dbdefs.h>
 
-/*  ----------------------------------- Trace & Debug */
-#include <dspbridge/dbc.h>
-
 /*  ----------------------------------- OS Adaptation Layer */
 #include <dspbridge/ntfy.h>
 
diff --git a/drivers/staging/tidspbridge/pmgr/io.c b/drivers/staging/tidspbridge/pmgr/io.c
index bbfe94c..a56b085 100644
--- a/drivers/staging/tidspbridge/pmgr/io.c
+++ b/drivers/staging/tidspbridge/pmgr/io.c
@@ -23,9 +23,6 @@
 /*  ----------------------------------- DSP/BIOS Bridge */
 #include <dspbridge/dbdefs.h>
 
-/*  ----------------------------------- Trace & Debug */
-#include <dspbridge/dbc.h>
-
 /*  ----------------------------------- Platform Manager */
 #include <dspbridge/dev.h>
 
diff --git a/drivers/staging/tidspbridge/pmgr/msg.c b/drivers/staging/tidspbridge/pmgr/msg.c
index 150026d..077c118 100644
--- a/drivers/staging/tidspbridge/pmgr/msg.c
+++ b/drivers/staging/tidspbridge/pmgr/msg.c
@@ -23,9 +23,6 @@
 /*  ----------------------------------- DSP/BIOS Bridge */
 #include <dspbridge/dbdefs.h>
 
-/*  ----------------------------------- Trace & Debug */
-#include <dspbridge/dbc.h>
-
 /*  ----------------------------------- Bridge Driver */
 #include <dspbridge/dspdefs.h>
 
diff --git a/drivers/staging/tidspbridge/rmgr/dbdcd.c b/drivers/staging/tidspbridge/rmgr/dbdcd.c
index 18109fc..8378b7b 100644
--- a/drivers/staging/tidspbridge/rmgr/dbdcd.c
+++ b/drivers/staging/tidspbridge/rmgr/dbdcd.c
@@ -29,8 +29,6 @@
 
 /*  ----------------------------------- DSP/BIOS Bridge */
 #include <dspbridge/dbdefs.h>
-/*  ----------------------------------- Trace & Debug */
-#include <dspbridge/dbc.h>
 
 /*  ----------------------------------- Platform Manager */
 #include <dspbridge/cod.h>
diff --git a/drivers/staging/tidspbridge/rmgr/disp.c b/drivers/staging/tidspbridge/rmgr/disp.c
index 63fdf1e..e510bb2 100644
--- a/drivers/staging/tidspbridge/rmgr/disp.c
+++ b/drivers/staging/tidspbridge/rmgr/disp.c
@@ -24,9 +24,6 @@
 /*  ----------------------------------- DSP/BIOS Bridge */
 #include <dspbridge/dbdefs.h>
 
-/*  ----------------------------------- Trace & Debug */
-#include <dspbridge/dbc.h>
-
 /*  ----------------------------------- OS Adaptation Layer */
 #include <dspbridge/sync.h>
 
diff --git a/drivers/staging/tidspbridge/rmgr/drv.c b/drivers/staging/tidspbridge/rmgr/drv.c
index cd93c12..b34dba7 100644
--- a/drivers/staging/tidspbridge/rmgr/drv.c
+++ b/drivers/staging/tidspbridge/rmgr/drv.c
@@ -24,9 +24,6 @@
 /*  ----------------------------------- DSP/BIOS Bridge */
 #include <dspbridge/dbdefs.h>
 
-/*  ----------------------------------- Trace & Debug */
-#include <dspbridge/dbc.h>
-
 /*  ----------------------------------- This */
 #include <dspbridge/drv.h>
 #include <dspbridge/dev.h>
diff --git a/drivers/staging/tidspbridge/rmgr/drv_interface.c b/drivers/staging/tidspbridge/rmgr/drv_interface.c
index f0f07ef..31b5140 100644
--- a/drivers/staging/tidspbridge/rmgr/drv_interface.c
+++ b/drivers/staging/tidspbridge/rmgr/drv_interface.c
@@ -30,9 +30,6 @@
 /*  ----------------------------------- DSP/BIOS Bridge */
 #include <dspbridge/dbdefs.h>
 
-/*  ----------------------------------- Trace & Debug */
-#include <dspbridge/dbc.h>
-
 /*  ----------------------------------- OS Adaptation Layer */
 #include <dspbridge/clk.h>
 
diff --git a/drivers/staging/tidspbridge/rmgr/dspdrv.c b/drivers/staging/tidspbridge/rmgr/dspdrv.c
index 5d25763..dc767b1 100644
--- a/drivers/staging/tidspbridge/rmgr/dspdrv.c
+++ b/drivers/staging/tidspbridge/rmgr/dspdrv.c
@@ -23,9 +23,6 @@
 /*  ----------------------------------- DSP/BIOS Bridge */
 #include <dspbridge/dbdefs.h>
 
-/*  ----------------------------------- Trace & Debug */
-#include <dspbridge/dbc.h>
-
 /*  ----------------------------------- Platform Manager */
 #include <dspbridge/drv.h>
 #include <dspbridge/dev.h>
diff --git a/drivers/staging/tidspbridge/rmgr/mgr.c b/drivers/staging/tidspbridge/rmgr/mgr.c
index b0ce0bc..938eea5 100644
--- a/drivers/staging/tidspbridge/rmgr/mgr.c
+++ b/drivers/staging/tidspbridge/rmgr/mgr.c
@@ -26,9 +26,6 @@
 /*  ----------------------------------- DSP/BIOS Bridge */
 #include <dspbridge/dbdefs.h>
 
-/*  ----------------------------------- Trace & Debug */
-#include <dspbridge/dbc.h>
-
 /*  ----------------------------------- OS Adaptation Layer */
 #include <dspbridge/sync.h>
 
diff --git a/drivers/staging/tidspbridge/rmgr/nldr.c b/drivers/staging/tidspbridge/rmgr/nldr.c
index cc20dd9..5cff46f 100644
--- a/drivers/staging/tidspbridge/rmgr/nldr.c
+++ b/drivers/staging/tidspbridge/rmgr/nldr.c
@@ -22,8 +22,6 @@
 
 #include <dspbridge/dbdefs.h>
 
-#include <dspbridge/dbc.h>
-
 /* Platform manager */
 #include <dspbridge/cod.h>
 #include <dspbridge/dev.h>
diff --git a/drivers/staging/tidspbridge/rmgr/node.c b/drivers/staging/tidspbridge/rmgr/node.c
index 83b053f..1b24589 100644
--- a/drivers/staging/tidspbridge/rmgr/node.c
+++ b/drivers/staging/tidspbridge/rmgr/node.c
@@ -26,9 +26,6 @@
 /*  ----------------------------------- DSP/BIOS Bridge */
 #include <dspbridge/dbdefs.h>
 
-/*  ----------------------------------- Trace & Debug */
-#include <dspbridge/dbc.h>
-
 /*  ----------------------------------- OS Adaptation Layer */
 #include <dspbridge/memdefs.h>
 #include <dspbridge/proc.h>
diff --git a/drivers/staging/tidspbridge/rmgr/proc.c b/drivers/staging/tidspbridge/rmgr/proc.c
index 8da5db6..b865d64 100644
--- a/drivers/staging/tidspbridge/rmgr/proc.c
+++ b/drivers/staging/tidspbridge/rmgr/proc.c
@@ -25,9 +25,6 @@
 /*  ----------------------------------- DSP/BIOS Bridge */
 #include <dspbridge/dbdefs.h>
 
-/*  ----------------------------------- Trace & Debug */
-#include <dspbridge/dbc.h>
-
 /*  ----------------------------------- OS Adaptation Layer */
 #include <dspbridge/ntfy.h>
 #include <dspbridge/sync.h>
diff --git a/drivers/staging/tidspbridge/rmgr/rmm.c b/drivers/staging/tidspbridge/rmgr/rmm.c
index fe13a74..55acfcd 100644
--- a/drivers/staging/tidspbridge/rmgr/rmm.c
+++ b/drivers/staging/tidspbridge/rmgr/rmm.c
@@ -46,9 +46,6 @@
 /*  ----------------------------------- DSP/BIOS Bridge */
 #include <dspbridge/dbdefs.h>
 
-/*  ----------------------------------- Trace & Debug */
-#include <dspbridge/dbc.h>
-
 /*  ----------------------------------- This */
 #include <dspbridge/rmm.h>
 
diff --git a/drivers/staging/tidspbridge/rmgr/strm.c b/drivers/staging/tidspbridge/rmgr/strm.c
index 80d01e5..bd684f1 100644
--- a/drivers/staging/tidspbridge/rmgr/strm.c
+++ b/drivers/staging/tidspbridge/rmgr/strm.c
@@ -24,9 +24,6 @@
 /*  ----------------------------------- DSP/BIOS Bridge */
 #include <dspbridge/dbdefs.h>
 
-/*  ----------------------------------- Trace & Debug */
-#include <dspbridge/dbc.h>
-
 /*  ----------------------------------- OS Adaptation Layer */
 #include <dspbridge/sync.h>
 
-- 
1.7.8.3

