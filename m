Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066Ab1IPSDx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 14:03:53 -0400
Received: from svenfoo.org ([82.94.215.22]:55705 "EHLO mail.zonque.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753089Ab1IPSDw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 14:03:52 -0400
X-Greylist: delayed 335 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Sep 2011 14:03:52 EDT
From: Daniel Mack <zonque@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Daniel Mack <zonque@gmail.com>, Wolfgang Grandegger <wg@grandegger.com>,
        netdev@vger.kernel.org
Subject: [PATCH] can: ti_hecc: include linux/io.h
Date: Fri, 16 Sep 2011 19:57:43 +0200
Message-Id: <1316195863-18695-1-git-send-email-zonque@gmail.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a build breakage for OMAP3 boards.

Signed-off-by: Daniel Mack <zonque@gmail.com>
Cc: Wolfgang Grandegger <wg@grandegger.com>
Cc: netdev@vger.kernel.org
---
 drivers/net/can/ti_hecc.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/can/ti_hecc.c b/drivers/net/can/ti_hecc.c
index a812492..2adc294 100644
--- a/drivers/net/can/ti_hecc.c
+++ b/drivers/net/can/ti_hecc.c
@@ -46,6 +46,7 @@
 #include <linux/skbuff.h>
 #include <linux/platform_device.h>
 #include <linux/clk.h>
+#include <linux/io.h>
 
 #include <linux/can/dev.h>
 #include <linux/can/error.h>
-- 
1.7.6

