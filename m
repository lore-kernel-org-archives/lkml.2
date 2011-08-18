Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533Ab1HRKsg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 06:48:36 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46519 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755213Ab1HRKsf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 06:48:35 -0400
From: Anand Gadiyar <gadiyar@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
CC: Anand Gadiyar <gadiyar@ti.com>, Felipe Balbi <balbi@ti.com>,
        Tony Lindgren <tony@atomide.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH] MAINTAINERS: add myself as co-maintainer for OMAP USB
Date: Thu, 18 Aug 2011 16:18:24 +0530
Message-ID: <1313664504-956-1-git-send-email-gadiyar@ti.com>
X-Mailer: git-send-email 1.5.6.6
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'd like to help co-maintain OMAP USB support. I've helped
out in the past when Felipe was away and would like make
it official.

Signed-off-by: Anand Gadiyar <gadiyar@ti.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6/MAINTAINERS
===================================================================
--- linux-2.6.orig/MAINTAINERS
+++ linux-2.6/MAINTAINERS
@@ -4326,6 +4326,7 @@ F:	include/linux/isicom.h
 
 MUSB MULTIPOINT HIGH SPEED DUAL-ROLE CONTROLLER
 M:	Felipe Balbi <balbi@ti.com>
+M:	Anand Gadiyar <gadiyar@ti.com>
 L:	linux-usb@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git
 S:	Maintained
@@ -4656,6 +4657,7 @@ F:	drivers/media/video/omap3isp/*
 
 OMAP USB SUPPORT
 M:	Felipe Balbi <balbi@ti.com>
+M:	Anand Gadiyar <gadiyar@ti.com>
 L:	linux-usb@vger.kernel.org
 L:	linux-omap@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git
