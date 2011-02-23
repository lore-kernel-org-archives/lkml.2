Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267Ab1BWFmd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 00:42:33 -0500
Received: from mail.perches.com ([173.55.12.10]:3848 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672Ab1BWFm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 00:42:29 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Michael Hennerich <michael.hennerich@analog.com>
Subject: [PATCH 01/18] MAINTAINERS: Update ADP5520 pattern
Date: Tue, 22 Feb 2011 21:41:54 -0800
Message-Id: <2b8de91a65f68147b9b8cf54fd4d88139efc9f14.1298439175.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.rc3
In-Reply-To: <cover.1298439175.git.joe@perches.com>
References: <cover.1298439175.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Typo in path.

cc: Michael Hennerich <michael.hennerich@analog.com>

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2d3ebbc..74128bb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -346,7 +346,7 @@ W:	http://wiki-analog.com/ADP5520
 S:	Supported
 F:	drivers/mfd/adp5520.c
 F:	drivers/video/backlight/adp5520_bl.c
-F:	drivers/led/leds-adp5520.c
+F:	drivers/leds/leds-adp5520.c
 F:	drivers/gpio/adp5520-gpio.c
 F:	drivers/input/keyboard/adp5520-keys.c
 
-- 
1.7.4.rc3

