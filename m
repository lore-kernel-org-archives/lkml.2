Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756944Ab2FWVSd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 17:18:33 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:37011 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756058Ab2FWVS1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 17:18:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 20/21] ACPI / PM: Drop legacy driver PM callbacks that are not used any more
Date: Sat, 23 Jun 2012 23:21:04 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        platform-driver-x86@vger.kernel.org,
        Eric Piel <eric.piel@tremplin-utc.net>,
        Mattia Dongili <malattia@linux.it>,
        Harald Welte <laforge@gnumonks.org>
References: <201206232306.06602.rjw@sisk.pl>
In-Reply-To: <201206232306.06602.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201206232321.05039.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Since the legacy ACPI driver PM callbacks included into
struct acpi_device_ops are not used any more, drop them.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 include/acpi/acpi_bus.h |    4 ----
 1 file changed, 4 deletions(-)

Index: linux/include/acpi/acpi_bus.h
===================================================================
--- linux.orig/include/acpi/acpi_bus.h
+++ linux/include/acpi/acpi_bus.h
@@ -117,8 +117,6 @@ struct acpi_device;
 typedef int (*acpi_op_add) (struct acpi_device * device);
 typedef int (*acpi_op_remove) (struct acpi_device * device, int type);
 typedef int (*acpi_op_start) (struct acpi_device * device);
-typedef int (*acpi_op_suspend) (struct acpi_device * device);
-typedef int (*acpi_op_resume) (struct acpi_device * device);
 typedef int (*acpi_op_bind) (struct acpi_device * device);
 typedef int (*acpi_op_unbind) (struct acpi_device * device);
 typedef void (*acpi_op_notify) (struct acpi_device * device, u32 event);
@@ -132,8 +130,6 @@ struct acpi_device_ops {
 	acpi_op_add add;
 	acpi_op_remove remove;
 	acpi_op_start start;
-	acpi_op_suspend suspend;
-	acpi_op_resume resume;
 	acpi_op_bind bind;
 	acpi_op_unbind unbind;
 	acpi_op_notify notify;

