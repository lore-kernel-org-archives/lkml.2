Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758100Ab0LBVHa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 16:07:30 -0500
Received: from kroah.org ([198.145.64.141]:54186 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757938Ab0LBVH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 16:07:28 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Hans J. Koch" <hjk@hansjkoch.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 3/3] uio: Change mail address of Hans J. Koch
Date: Thu,  2 Dec 2010 13:07:24 -0800
Message-Id: <1291324044-6716-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101202205212.GA6130@kroah.com>
References: <20101202205212.GA6130@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans J. Koch <hjk@hansjkoch.de>

My old mail address doesn't exist anymore. This changes all occurrences
to my new address.

Signed-off-by: Hans J. Koch <hjk@hansjkoch.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/uio/uio.c          |    2 +-
 drivers/uio/uio_cif.c      |    2 +-
 drivers/uio/uio_netx.c     |    2 +-
 include/linux/uio_driver.h |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index a858d2b..51fe179 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -3,7 +3,7 @@
  *
  * Copyright(C) 2005, Benedikt Spranger <b.spranger@linutronix.de>
  * Copyright(C) 2005, Thomas Gleixner <tglx@linutronix.de>
- * Copyright(C) 2006, Hans J. Koch <hjk@linutronix.de>
+ * Copyright(C) 2006, Hans J. Koch <hjk@hansjkoch.de>
  * Copyright(C) 2006, Greg Kroah-Hartman <greg@kroah.com>
  *
  * Userspace IO
diff --git a/drivers/uio/uio_cif.c b/drivers/uio/uio_cif.c
index a8ea2f1..a84a451 100644
--- a/drivers/uio/uio_cif.c
+++ b/drivers/uio/uio_cif.c
@@ -1,7 +1,7 @@
 /*
  * UIO Hilscher CIF card driver
  *
- * (C) 2007 Hans J. Koch <hjk@linutronix.de>
+ * (C) 2007 Hans J. Koch <hjk@hansjkoch.de>
  * Original code (C) 2005 Benedikt Spranger <b.spranger@linutronix.de>
  *
  * Licensed under GPL version 2 only.
diff --git a/drivers/uio/uio_netx.c b/drivers/uio/uio_netx.c
index 5a18e9f..5ffdb48 100644
--- a/drivers/uio/uio_netx.c
+++ b/drivers/uio/uio_netx.c
@@ -2,7 +2,7 @@
  * UIO driver for Hilscher NetX based fieldbus cards (cifX, comX).
  * See http://www.hilscher.com for details.
  *
- * (C) 2007 Hans J. Koch <hjk@linutronix.de>
+ * (C) 2007 Hans J. Koch <hjk@hansjkoch.de>
  * (C) 2008 Manuel Traut <manut@linutronix.de>
  *
  * Licensed under GPL version 2 only.
diff --git a/include/linux/uio_driver.h b/include/linux/uio_driver.h
index d6188e5..665517c 100644
--- a/include/linux/uio_driver.h
+++ b/include/linux/uio_driver.h
@@ -3,7 +3,7 @@
  *
  * Copyright(C) 2005, Benedikt Spranger <b.spranger@linutronix.de>
  * Copyright(C) 2005, Thomas Gleixner <tglx@linutronix.de>
- * Copyright(C) 2006, Hans J. Koch <hjk@linutronix.de>
+ * Copyright(C) 2006, Hans J. Koch <hjk@hansjkoch.de>
  * Copyright(C) 2006, Greg Kroah-Hartman <greg@kroah.com>
  *
  * Userspace IO driver.
-- 
1.7.1

