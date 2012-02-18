Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638Ab2BROx1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 09:53:27 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:39337 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147Ab2BROxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 09:53:25 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of axel.lin@gmail.com designates 10.68.219.99 as permitted sender) smtp.mail=axel.lin@gmail.com; dkim=pass header.i=axel.lin@gmail.com
Message-ID: <1329576795.2399.1.camel@phoenix>
Subject: [PATCH] regulator: Remove obsolete consumer_dev related comment
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Sat, 18 Feb 2012 22:53:15 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

consumer_dev is remove by commit 737f36
"regulator: Remove support for supplies specified by struct device".
Thus remove the obsolete comment.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/core.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 73204e8..fecda41 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1006,8 +1006,6 @@ static int set_supply(struct regulator_dev *rdev,
  * sources to symbolic names for supplies for use by devices.  Devices
  * should use these symbolic names to request regulators, avoiding the
  * need to provide board-specific regulator names as platform data.
- *
- * Only one of consumer_dev and consumer_dev_name may be specified.
  */
 static int set_consumer_device_supply(struct regulator_dev *rdev,
 				      const char *consumer_dev_name,
-- 
1.7.5.4



