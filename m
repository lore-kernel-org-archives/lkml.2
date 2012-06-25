Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892Ab2FYPQW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 11:16:22 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:60552 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752408Ab2FYPPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 11:15:41 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAGl/6E9bdWOb/2dsb2JhbABEtiyBB4IZAQV5EFFXBhOID7hKkTUDlS6QAYJh
X-IronPort-AV: E=Sophos;i="4.77,472,1336341600"; 
   d="scan'208";a="932086482"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] Staging: ipack/devices/ipoctal: remove unneeded includes
Date: Mon, 25 Jun 2012 17:15:45 +0200
Message-Id: <1340637347-14303-2-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1340637347-14303-1-git-send-email-siglesias@igalia.com>
References: <1340637347-14303-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/devices/ipoctal.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/staging/ipack/devices/ipoctal.c b/drivers/staging/ipack/devices/ipoctal.c
index 7fe1c93..b11126d 100644
--- a/drivers/staging/ipack/devices/ipoctal.c
+++ b/drivers/staging/ipack/devices/ipoctal.c
@@ -13,16 +13,12 @@
 
 #include <linux/device.h>
 #include <linux/module.h>
-#include <linux/moduleparam.h>
 #include <linux/interrupt.h>
-#include <linux/fs.h>
-#include <linux/delay.h>
 #include <linux/sched.h>
 #include <linux/tty.h>
 #include <linux/serial.h>
 #include <linux/tty_flip.h>
 #include <linux/slab.h>
-#include <linux/uaccess.h>
 #include <linux/atomic.h>
 #include "../ipack.h"
 #include "ipoctal.h"
-- 
1.7.10

