Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab1FBTJT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 15:09:19 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:22688 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361Ab1FBTJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 15:09:18 -0400
Date: Thu, 2 Jun 2011 21:09:07 +0200
From: Jean Delvare <khali@linux-fr.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] MAINTAINERS: Add entry for legacy eeprom driver
Message-ID: <20110602210907.201e02b5@endymion.delvare>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I shall maintain the legacy eeprom driver, until we finally get rid of
it.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
 MAINTAINERS |    6 ++++++
 1 file changed, 6 insertions(+)

--- linux-3.0-rc1.orig/MAINTAINERS	2011-05-30 20:45:03.000000000 +0200
+++ linux-3.0-rc1/MAINTAINERS	2011-06-02 21:01:45.000000000 +0200
@@ -3820,6 +3820,12 @@ S:	Maintained
 F:	drivers/leds/
 F:	include/linux/leds.h
 
+LEGACY EEPROM DRIVER
+M:	Jean Delvare <khali@linux-fr.org>
+S:	Maintained
+F:	Documentation/misc-devices/eeprom
+F:	drivers/misc/eeprom/eeprom.c
+
 LEGO USB Tower driver
 M:	Juergen Stuber <starblue@users.sourceforge.net>
 L:	legousb-devel@lists.sourceforge.net


-- 
Jean Delvare
