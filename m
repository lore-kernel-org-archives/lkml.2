Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410Ab2KPPUx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 10:20:53 -0500
Received: from smtp4.mundo-r.com ([212.51.32.151]:37263 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996Ab2KPPUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 10:20:36 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAJZZplBbdWOb/2dsb2JhbABEwmaBCIIfAQEEAQJ2EB00KCEOBhOHewMTB7RHIYlAkUADk0+CLYEcjyeCcA
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        Jens Taprogge <jens.taprogge@taprogge.org>
Subject: [PATCH 2/2] MAINTAINERS: Add maintainers for Industry Pack subsystem
Date: Fri, 16 Nov 2012 16:19:59 +0100
Message-Id: <1353079199-11282-2-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353079199-11282-1-git-send-email-siglesias@igalia.com>
References: <1353079199-11282-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Samuel Iglesias Gonsalvez, Jens Taprogge and Greg Kroah-Hartman as
maintainers for the Industry Pack subsystem.

Cc: Jens Taprogge <jens.taprogge@taprogge.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 MAINTAINERS |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 59203e7..1e052df 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3740,6 +3740,17 @@ M:	Stanislaw Gruszka <stf_xl@wp.pl>
 S:	Maintained
 F:	drivers/usb/atm/ueagle-atm.c
 
+INDUSTRY PACK SUBSYSTEM (IPACK)
+M:	Samuel Iglesias Gonsalvez <siglesias@igalia.com>
+M:	Jens Taprogge <jens.taprogge@taprogge.org>
+M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
+L:	industrypack-devel@lists.sourceforge.net
+W:	http://industrypack.sourceforge.net
+S:	Maintained
+T:	git git://git.code.sf.net/p/industrypack/code
+F:	drivers/ipack/
+F:	include/linux/ipack*
+
 INTEGRITY MEASUREMENT ARCHITECTURE (IMA)
 M:	Mimi Zohar <zohar@us.ibm.com>
 S:	Supported
-- 
1.7.10.4

