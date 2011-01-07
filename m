Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952Ab1AGArv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 19:47:51 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38180 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754577Ab1AGArr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 19:47:47 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH 3/5] ACPI / PM: Update file information and the list of includes in nvs.c
Date: Fri, 7 Jan 2011 01:44:28 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37+; KDE/4.4.4; x86_64; ; )
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        Jiri Slaby <jirislaby@gmail.com>
References: <201101070141.02951.rjw@sisk.pl>
In-Reply-To: <201101070141.02951.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201101070144.28641.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The file information and the list of include in drivers/acpi/nvs.c
are outdated, so update them.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/nvs.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6/drivers/acpi/nvs.c
===================================================================
--- linux-2.6.orig/drivers/acpi/nvs.c
+++ linux-2.6/drivers/acpi/nvs.c
@@ -1,7 +1,7 @@
 /*
- * linux/kernel/power/hibernate_nvs.c - Routines for handling NVS memory
+ * nvs.c - Routines for saving and restoring ACPI NVS memory region
  *
- * Copyright (C) 2008,2009 Rafael J. Wysocki <rjw@sisk.pl>, Novell Inc.
+ * Copyright (C) 2008-2011 Rafael J. Wysocki <rjw@sisk.pl>, Novell Inc.
  *
  * This file is released under the GPLv2.
  */
@@ -11,7 +11,7 @@
 #include <linux/list.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
-#include <linux/suspend.h>
+#include <linux/acpi.h>
 
 /*
  * Platforms, like ACPI, may want us to save some memory used by them during

