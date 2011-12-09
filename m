Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751Ab1LIEWZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 23:22:25 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:40440 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753218Ab1LIEWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 23:22:22 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Michael Hennerich <michael.hennerich@analog.com>
Subject: [PATCH v3.2 03/10] MAINTAINERS: Update adp gpio F: patterns
Date: Thu,  8 Dec 2011 20:21:41 -0800
Message-Id: <752ff6829eee7b258b3fd7de0a07c9f035fcf1f4.1323401278.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1323401278.git.joe@perches.com>
References: <cover.1323401278.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit c103de240439df ("gpio: reorganize drivers") renamed
the files, update the patterns.

CC: Grant Likely <grant.likely@secretlab.ca>
CC: Michael Hennerich <michael.hennerich@analog.com>

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 80167e7..bfa54c1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -347,7 +347,7 @@ S:	Supported
 F:	drivers/mfd/adp5520.c
 F:	drivers/video/backlight/adp5520_bl.c
 F:	drivers/leds/leds-adp5520.c
-F:	drivers/gpio/adp5520-gpio.c
+F:	drivers/gpio/gpio-adp5520.c
 F:	drivers/input/keyboard/adp5520-keys.c
 
 ADP5588 QWERTY KEYPAD AND IO EXPANDER DRIVER (ADP5588/ADP5587)
@@ -356,7 +356,7 @@ L:	device-drivers-devel@blackfin.uclinux.org
 W:	http://wiki.analog.com/ADP5588
 S:	Supported
 F:	drivers/input/keyboard/adp5588-keys.c
-F:	drivers/gpio/adp5588-gpio.c
+F:	drivers/gpio/gpio-adp5588.c
 
 ADP8860 BACKLIGHT DRIVER (ADP8860/ADP8861/ADP8863)
 M:	Michael Hennerich <michael.hennerich@analog.com>
-- 
1.7.8.111.gad25c.dirty

