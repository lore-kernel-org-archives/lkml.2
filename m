Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab0I1Rrx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 13:47:53 -0400
Received: from mail.perches.com ([173.55.12.10]:2495 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752237Ab0I1Rrw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 13:47:52 -0400
Subject: [PATCH] MAINTAINERS: Use "T:	git" and whitespace trivia
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Sep 2010 10:47:50 -0700
Message-ID: <1285696070.1866.77.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing git as a prefix for git repositories
in the few places it wasn't already used.
Convert a space delimiter to a tab.

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index ceba39b..f0385c6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -655,7 +655,7 @@ ARM/FARADAY FA526 PORT
 M:	Hans Ulli Kroll <ulli.kroll@googlemail.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
-T:	git://git.berlios.de/gemini-board
+T:	git git://git.berlios.de/gemini-board
 F:	arch/arm/mm/*-fa*
 
 ARM/FOOTBRIDGE ARCHITECTURE
@@ -670,7 +670,7 @@ ARM/FREESCALE IMX / MXC ARM ARCHITECTURE
 M:	Sascha Hauer <kernel@pengutronix.de>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
-T:	git://git.pengutronix.de/git/imx/linux-2.6.git
+T:	git git://git.pengutronix.de/git/imx/linux-2.6.git
 F:	arch/arm/mach-mx*/
 F:	arch/arm/plat-mxc/
 
@@ -3772,7 +3772,7 @@ F:	drivers/net/wireless/mwl8k.c
 MARVELL SOC MMC/SD/SDIO CONTROLLER DRIVER
 M:	Nicolas Pitre <nico@fluxnic.net>
 S:	Odd Fixes
-F: drivers/mmc/host/mvsdio.*
+F:	drivers/mmc/host/mvsdio.*
 
 MARVELL YUKON / SYSKONNECT DRIVER
 M:	Mirko Lindner <mlindner@syskonnect.de>
@@ -4824,7 +4824,7 @@ RCUTORTURE MODULE
 M:	Josh Triplett <josh@freedesktop.org>
 M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
 S:	Supported
-T:	git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git
 F:	Documentation/RCU/torture.txt
 F:	kernel/rcutorture.c
 
@@ -4849,7 +4849,7 @@ M:	Dipankar Sarma <dipankar@in.ibm.com>
 M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
 W:	http://www.rdrop.com/users/paulmck/rclock/
 S:	Supported
-T:	git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git
 F:	Documentation/RCU/
 F:	include/linux/rcu*
 F:	include/linux/srcu*


