Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201Ab1K2Sio (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 13:38:44 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42281 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756086Ab1K2Sin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 13:38:43 -0500
Subject: [PATCH] mfd: tc6393xb - add depend on HAVE_CLK
From: Christoph Fritz <chf.fritz@googlemail.com>
To: Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Baryshkov <dbaryshkov@gmail.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
Date: Tue, 29 Nov 2011 19:38:38 +0100
Message-ID: <1322591918.2182.35.camel@mars>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds HAVE_CLK to the required dependencies of tc6393xb.

Signed-off-by: Christoph Fritz <chf.fritz@googlemail.com>
---
 drivers/mfd/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index f1391c2..833ed2c 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -311,7 +311,7 @@ config MFD_TC6387XB
 
 config MFD_TC6393XB
 	bool "Support Toshiba TC6393XB"
-	depends on GPIOLIB && ARM
+	depends on GPIOLIB && ARM && HAVE_CLK
 	select MFD_CORE
 	select MFD_TMIO
 	help
-- 
1.7.2.5



