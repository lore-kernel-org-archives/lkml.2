Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934268Ab0J2Wgu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 18:36:50 -0400
Received: from static.200.77.63.178.clients.your-server.de ([178.63.77.200]:34290
	"EHLO Debian-50-lenny-64-minimal" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933092Ab0J2Wgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 18:36:48 -0400
Date: Sat, 30 Oct 2010 00:36:47 +0200
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@suse.de>
Subject: [PATCH 6/6] uio: Change mail address of Hans J. Koch
Message-ID: <20101029223647.GG4331@local>
References: <20101029221231.GA4331@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101029221231.GA4331@local>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My old mail address doesn't exist anymore. This changes all occurrences
to my new address.

Signed-off-by: Hans J. Koch <hjk@hansjkoch.de>
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

