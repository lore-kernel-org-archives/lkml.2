Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758031Ab2HHMR2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 08:17:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40410 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757976Ab2HHMR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 08:17:27 -0400
Message-ID: <1344428238.3199.1.camel@phoenix>
Subject: [PATCH 1/7] regulator: Update comment for set_current_limit
 callback of struct regulator_ops
From: Axel Lin <axel.lin@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Cyril Chemparathy <cyril@ti.com>, "Milo(Woogyom) Kim" <milo.kim@ti.com>,
        David Dajun Chen <dchen@diasemi.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Date: Wed, 08 Aug 2012 20:17:18 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regulators should be tending to the maximum in the available range and
consumers should specify the widest range possible.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 include/linux/regulator/driver.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index bac4c87..c10012f 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -58,6 +58,7 @@ enum regulator_status {
  *	regulator_desc.n_voltages.  Voltages may be reported in any order.
  *
  * @set_current_limit: Configure a limit for a current-limited regulator.
+ *                     The driver should select the current closest to max_uA.
  * @get_current_limit: Get the configured limit for a current-limited regulator.
  *
  * @set_mode: Set the configured operating mode for the regulator.
-- 
1.7.9.5



