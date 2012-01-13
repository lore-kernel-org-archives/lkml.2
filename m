Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758211Ab2AMOFe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 09:05:34 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63099 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757860Ab2AMOF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 09:05:29 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: Felipe Balbi <balbi@ti.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drivers: usb: update Michal Nazarewicz's email address
Date: Fri, 13 Jan 2012 15:05:16 +0100
Message-Id: <c29768d070313ce590395418442a346c91fe41f8.1326463041.git.mina86@mina86.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The m.nazarewicz@samsung.com email address is no longer valid,
so this commit replaces it with mina86@mina86.com which is
employer-agnostic and thus should be valid for foreseeable
feature.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
I probably should have sent it year ago...  This is based on v3.2.


 drivers/usb/gadget/f_acm.c          |    2 +-
 drivers/usb/gadget/f_fs.c           |    2 +-
 drivers/usb/gadget/f_mass_storage.c |    2 +-
 drivers/usb/gadget/f_rndis.c        |    2 +-
 drivers/usb/gadget/g_ffs.c          |    2 +-
 drivers/usb/gadget/mass_storage.c   |    2 +-
 drivers/usb/gadget/multi.c          |    2 +-
 drivers/usb/gadget/storage_common.c |    2 +-
 tools/usb/ffs-test.c                |    2 +-
 tools/usb/testusb.c                 |    2 +-
 10 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/gadget/f_acm.c b/drivers/usb/gadget/f_acm.c
index 3f88493..e482121 100644
--- a/drivers/usb/gadget/f_acm.c
+++ b/drivers/usb/gadget/f_acm.c
@@ -5,7 +5,7 @@
  * Copyright (C) 2008 by David Brownell
  * Copyright (C) 2008 by Nokia Corporation
  * Copyright (C) 2009 by Samsung Electronics
- * Author: Michal Nazarewicz (m.nazarewicz@samsung.com)
+ * Author: Michal Nazarewicz (mina86@mina86.com)
  *
  * This software is distributed under the terms of the GNU General
  * Public License ("GPL") as published by the Free Software Foundation,
diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
index acb3800..371e974 100644
--- a/drivers/usb/gadget/f_fs.c
+++ b/drivers/usb/gadget/f_fs.c
@@ -2,7 +2,7 @@
  * f_fs.c -- user mode file system API for USB composite function controllers
  *
  * Copyright (C) 2010 Samsung Electronics
- * Author: Michal Nazarewicz <m.nazarewicz@samsung.com>
+ * Author: Michal Nazarewicz <mina86@mina86.com>
  *
  * Based on inode.c (GadgetFS) which was:
  * Copyright (C) 2003-2004 David Brownell
diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
index 1a6f415..61a4650 100644
--- a/drivers/usb/gadget/f_mass_storage.c
+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -3,7 +3,7 @@
  *
  * Copyright (C) 2003-2008 Alan Stern
  * Copyright (C) 2009 Samsung Electronics
- *                    Author: Michal Nazarewicz <m.nazarewicz@samsung.com>
+ *                    Author: Michal Nazarewicz <mina86@mina86.com>
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/usb/gadget/f_rndis.c b/drivers/usb/gadget/f_rndis.c
index 704d1d9..7b1cf18 100644
--- a/drivers/usb/gadget/f_rndis.c
+++ b/drivers/usb/gadget/f_rndis.c
@@ -5,7 +5,7 @@
  * Copyright (C) 2003-2004 Robert Schwebel, Benedikt Spranger
  * Copyright (C) 2008 Nokia Corporation
  * Copyright (C) 2009 Samsung Electronics
- *                    Author: Michal Nazarewicz (m.nazarewicz@samsung.com)
+ *                    Author: Michal Nazarewicz (mina86@mina86.com)
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/usb/gadget/g_ffs.c b/drivers/usb/gadget/g_ffs.c
index 0519d77..331cd67 100644
--- a/drivers/usb/gadget/g_ffs.c
+++ b/drivers/usb/gadget/g_ffs.c
@@ -2,7 +2,7 @@
  * g_ffs.c -- user mode file system API for USB composite function controllers
  *
  * Copyright (C) 2010 Samsung Electronics
- * Author: Michal Nazarewicz <m.nazarewicz@samsung.com>
+ * Author: Michal Nazarewicz <mina86@mina86.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/usb/gadget/mass_storage.c b/drivers/usb/gadget/mass_storage.c
index e24f72f..1f376eb 100644
--- a/drivers/usb/gadget/mass_storage.c
+++ b/drivers/usb/gadget/mass_storage.c
@@ -3,7 +3,7 @@
  *
  * Copyright (C) 2003-2008 Alan Stern
  * Copyright (C) 2009 Samsung Electronics
- *                    Author: Michal Nazarewicz <m.nazarewicz@samsung.com>
+ *                    Author: Michal Nazarewicz <mina86@mina86.com>
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/usb/gadget/multi.c b/drivers/usb/gadget/multi.c
index 7e7f515..c37fb33 100644
--- a/drivers/usb/gadget/multi.c
+++ b/drivers/usb/gadget/multi.c
@@ -4,7 +4,7 @@
  * Copyright (C) 2008 David Brownell
  * Copyright (C) 2008 Nokia Corporation
  * Copyright (C) 2009 Samsung Electronics
- * Author: Michal Nazarewicz (m.nazarewicz@samsung.com)
+ * Author: Michal Nazarewicz (mina86@mina86.com)
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/usb/gadget/storage_common.c b/drivers/usb/gadget/storage_common.c
index c7f291a..9d450fe 100644
--- a/drivers/usb/gadget/storage_common.c
+++ b/drivers/usb/gadget/storage_common.c
@@ -3,7 +3,7 @@
  *
  * Copyright (C) 2003-2008 Alan Stern
  * Copyeight (C) 2009 Samsung Electronics
- * Author: Michal Nazarewicz (m.nazarewicz@samsung.com)
+ * Author: Michal Nazarewicz (mina86@mina86.com)
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/tools/usb/ffs-test.c b/tools/usb/ffs-test.c
index b9c7986..53452c3 100644
--- a/tools/usb/ffs-test.c
+++ b/tools/usb/ffs-test.c
@@ -2,7 +2,7 @@
  * ffs-test.c.c -- user mode filesystem api for usb composite function
  *
  * Copyright (C) 2010 Samsung Electronics
- *                    Author: Michal Nazarewicz <m.nazarewicz@samsung.com>
+ *                    Author: Michal Nazarewicz <mina86@mina86.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/tools/usb/testusb.c b/tools/usb/testusb.c
index f08e894..6e0f567 100644
--- a/tools/usb/testusb.c
+++ b/tools/usb/testusb.c
@@ -3,7 +3,7 @@
 /*
  * Copyright (c) 2002 by David Brownell
  * Copyright (c) 2010 by Samsung Electronics
- * Author: Michal Nazarewicz <m.nazarewicz@samsung.com>
+ * Author: Michal Nazarewicz <mina86@mina86.com>
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the
-- 
1.7.7.3

