Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143Ab2LELD1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 06:03:27 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:40203 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752338Ab2LELDU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 06:03:20 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH] ACPI / PM: Fix header of acpi_dev_pm_detach() in acpi.h
Date: Wed, 05 Dec 2012 12:08:12 +0100
Message-ID: <3898205.CQSHFfLUWL@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc8; KDE/4.9.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

The header of acpi_dev_pm_detach() in include/linux/acpi.h has an
incorrect return type, which should be void.  Fix that.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 include/linux/acpi.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/include/linux/acpi.h
===================================================================
--- linux.orig/include/linux/acpi.h
+++ linux/include/linux/acpi.h
@@ -506,7 +506,7 @@ static inline int acpi_subsys_resume_ear
 
 #if defined(CONFIG_ACPI) && defined(CONFIG_PM)
 int acpi_dev_pm_attach(struct device *dev, bool power_on);
-int acpi_dev_pm_detach(struct device *dev, bool power_off);
+void acpi_dev_pm_detach(struct device *dev, bool power_off);
 #else
 static inline int acpi_dev_pm_attach(struct device *dev, bool power_on)
 {

