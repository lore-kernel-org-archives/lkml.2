Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758111Ab2JSFIB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 01:08:01 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:54452 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752932Ab2JSFH7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 01:07:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Len Brown <lenb@kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: MAINTAINERS: Add Rafael's address to ACPI maintainers
Date: Fri, 19 Oct 2012 07:11:44 +0200
Message-ID: <4293795.KzBmWitzil@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.6.2-6-desktop; KDE/4.8.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Since I will be maintaining ACPI together with Len from now on, add my
address to the ACPI maintainers list in the MAINTAINERS file (this is
the address to send patches to).

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

Index: linux-pm/MAINTAINERS
===================================================================
--- linux-pm.orig/MAINTAINERS
+++ linux-pm/MAINTAINERS
@@ -235,6 +235,7 @@ F:	drivers/platform/x86/acer-wmi.c
 
 ACPI
 M:	Len Brown <lenb@kernel.org>
+M:	Rafael J. Wysocki <rjw@sisk.pl>
 L:	linux-acpi@vger.kernel.org
 W:	http://www.lesswatts.org/projects/acpi/
 Q:	http://patchwork.kernel.org/project/linux-acpi/list/

