Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202Ab0JVWcj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 18:32:39 -0400
Received: from mail.perches.com ([173.55.12.10]:3518 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145Ab0JVWci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 18:32:38 -0400
Subject: [RFC PATCH] MAINTAINERS: Remove Alexey Starikovskiy from ACPI
 maintainers
From: Joe Perches <joe@perches.com>
To: Len Brown <lenb@kernel.org>
Cc: Alexey Starikovskiy <astarikovskiy@suse.de>, linux-acpi@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Oct 2010 15:32:36 -0700
Message-ID: <1287786756.28393.32.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

His email bounces.
Maybe he's got a new one?

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index b618b1e..230fac1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -242,18 +242,14 @@ F:	include/linux/acpi.h
 F:	include/acpi/
 
 ACPI BATTERY DRIVERS
-M:	Alexey Starikovskiy <astarikovskiy@suse.de>
 L:	linux-acpi@vger.kernel.org
 W:	http://www.lesswatts.org/projects/acpi/
-S:	Supported
 F:	drivers/acpi/battery.c
 F:	drivers/acpi/*sbs*
 
 ACPI EC DRIVER
-M:	Alexey Starikovskiy <astarikovskiy@suse.de>
 L:	linux-acpi@vger.kernel.org
 W:	http://www.lesswatts.org/projects/acpi/
-S:	Supported
 F:	drivers/acpi/ec.c
 
 ACPI FAN DRIVER


