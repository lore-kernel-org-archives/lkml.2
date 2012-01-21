Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751343Ab2AUSEj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 13:04:39 -0500
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:39701 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751150Ab2AUSEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 13:04:11 -0500
Message-ID: <4F1B0BCE.4050505@xenotime.net>
Date: Sat, 21 Jan 2012 11:02:38 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 4/14] kernel-doc: fix new warning in regulator core
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix new kernel-doc warning:

Warning(drivers/regulator/core.c:2741): No description found for parameter 'of_node'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc:	Liam Girdwood <lrg@ti.com>
Cc:	Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |    1 +
 1 file changed, 1 insertion(+)

--- lnx-33-rc1.orig/drivers/regulator/core.c
+++ lnx-33-rc1/drivers/regulator/core.c
@@ -2731,6 +2731,7 @@ static void rdev_init_debugfs(struct reg
  * @dev: struct device for the regulator
  * @init_data: platform provided init data, passed through by driver
  * @driver_data: private regulator data
+ * @of_node: target of device structure (may be NULL)
  *
  * Called by regulator drivers to register a regulator.
  * Returns 0 on success.
