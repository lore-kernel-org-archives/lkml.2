Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069Ab0ITJHx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 05:07:53 -0400
Received: from relay.atmel.no ([194.19.124.36]:5533 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752864Ab0ITJHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 05:07:52 -0400
X-Greylist: delayed 1711 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Sep 2010 05:07:52 EDT
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: linux-kernel@vger.kernel.org
Cc: haavard.skinnemoen@atmel.com,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Subject: [PATCH] MAINTAINERS: change AVR32 and AT32AP maintainer
Date: Mon, 20 Sep 2010 10:39:03 +0200
Message-Id: <1284971943-23653-1-git-send-email-hans-christian.egtvedt@atmel.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch alters the maintainer of the AVR32 architecture and the AVR32/AT32AP
machine support to me. Håvard is moving on to new challenges, and we've found
it better to transfer the maintainer part to me. I will have good contact with
Håvard anyway.

Signed-off-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
---
 MAINTAINERS |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 411b0d0..7accc34 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1220,7 +1220,7 @@ F:	drivers/auxdisplay/
 F:	include/linux/cfag12864b.h
 
 AVR32 ARCHITECTURE
-M:	Haavard Skinnemoen <hskinnemoen@atmel.com>
+M:	Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
 W:	http://www.atmel.com/products/AVR32/
 W:	http://avr32linux.org/
 W:	http://avrfreaks.net/
@@ -1228,7 +1228,7 @@ S:	Supported
 F:	arch/avr32/
 
 AVR32/AT32AP MACHINE SUPPORT
-M:	Haavard Skinnemoen <hskinnemoen@atmel.com>
+M:	Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
 S:	Supported
 F:	arch/avr32/mach-at32ap/
 
-- 
1.7.0.4

