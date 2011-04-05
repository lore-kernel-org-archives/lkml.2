Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627Ab1DES4r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 14:56:47 -0400
Received: from www.hansjkoch.de ([178.63.77.200]:41941 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752702Ab1DES4p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 14:56:45 -0400
Date: Tue, 5 Apr 2011 20:56:22 +0200
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] MAINTAINERS: Resend: Change mail adress of Hans J. Koch
Message-ID: <20110405185621.GE7028@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My old mail address doesn't exist anymore. This patch changes all occurences
in MAINTAINERS to my new address. I already sent this in Oct. 2010, but it
somehow never made it to mainline (is there a MAINTAINERS maintainer?)

Signed-off-by: Hans J. Koch <hjk@hansjkoch.de>
---
 MAINTAINERS |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6b4b9cd..b96f3b3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1063,7 +1063,7 @@ F:	arch/arm/mach-shmobile/
 F:	drivers/sh/
 
 ARM/TELECHIPS ARM ARCHITECTURE
-M:	"Hans J. Koch" <hjk@linutronix.de>
+M:	"Hans J. Koch" <hjk@hansjkoch.de>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 F:	arch/arm/plat-tcc/
@@ -4077,7 +4077,7 @@ F:	drivers/video/matrox/matroxfb_*
 F:	include/linux/matroxfb.h
 
 MAX6650 HARDWARE MONITOR AND FAN CONTROLLER DRIVER
-M:	"Hans J. Koch" <hjk@linutronix.de>
+M:	"Hans J. Koch" <hjk@hansjkoch.de>
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
 F:	Documentation/hwmon/max6650
@@ -6618,7 +6618,7 @@ F:	fs/hostfs/
 F:	fs/hppfs/
 
 USERSPACE I/O (UIO)
-M:	"Hans J. Koch" <hjk@linutronix.de>
+M:	"Hans J. Koch" <hjk@hansjkoch.de>
 M:	Greg Kroah-Hartman <gregkh@suse.de>
 S:	Maintained
 F:	Documentation/DocBook/uio-howto.tmpl
-- 
1.7.1

