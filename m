Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522Ab2KMSKz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 13:10:55 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:58085 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967Ab2KMSKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 13:10:52 -0500
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <b-cousson@ti.com>, <devel@driverdev.osuosl.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCHv2 1/5] staging: omap-thermal: fix compilation
Date: Tue, 13 Nov 2012 14:10:00 -0400
Message-ID: <1352830204-21546-2-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
In-Reply-To: <1352830204-21546-1-git-send-email-eduardo.valentin@ti.com>
References: <1352830204-21546-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because we are not including linux/io.h, the driver is not compiling.
This patch adds the missing header.

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/staging/omap-thermal/omap-bandgap.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/omap-thermal/omap-bandgap.c b/drivers/staging/omap-thermal/omap-bandgap.c
index 368a2e1..1cae5ed 100644
--- a/drivers/staging/omap-thermal/omap-bandgap.c
+++ b/drivers/staging/omap-thermal/omap-bandgap.c
@@ -38,6 +38,7 @@
 #include <linux/of_device.h>
 #include <linux/of_platform.h>
 #include <linux/of_irq.h>
+#include <linux/io.h>
 
 #include "omap-bandgap.h"
 
-- 
1.7.7.1.488.ge8e1c

