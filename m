Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964865Ab2B2W3J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 17:29:09 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:51339 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932292Ab2B2W3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 17:29:06 -0500
Message-ID: <1330554543.23314.2.camel@joe2Laptop>
Subject: [PATCH] MAINTAINERS: Add "S: Maintained" to clkdev and clk sections
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Russell King <linux@arm.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>
Date: Wed, 29 Feb 2012 14:29:03 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King seems to be maintaining these.
Might as well mark them with the appropriate S: entry

CC: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 5d3ae86..677ef2f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -715,6 +715,7 @@ S:	Maintained
 ARM/CLKDEV SUPPORT
 M:	Russell King <linux@arm.linux.org.uk>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
+S:	Maintained
 F:	arch/arm/include/asm/clkdev.h
 F:	drivers/clk/clkdev.c
 
@@ -1821,6 +1822,7 @@ F:	sound/soc/codecs/cs4270*
 
 CLK API
 M:	Russell King <linux@arm.linux.org.uk>
+S:	Maintained
 F:	include/linux/clk.h
 
 CISCO FCOE HBA DRIVER


