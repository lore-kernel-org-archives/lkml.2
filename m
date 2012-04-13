Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757170Ab2DMHcQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 03:32:16 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38709 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756721Ab2DMHcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 03:32:14 -0400
Message-ID: <1334302325.2879.1.camel@phoenix>
Subject: [PATCH] regulator: Update regulator_register() API signature in
 Documentation
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Fri, 13 Apr 2012 15:32:05 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit c172708 "regulator: core: Use a struct to pass in regulator runtime
configuration" changed the regulator_register() API signature.

Update the Documentation accordingly to reflect the change in the function
signature.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 Documentation/power/regulator/regulator.txt |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/Documentation/power/regulator/regulator.txt b/Documentation/power/regulator/regulator.txt
index e272d99..1390277 100644
--- a/Documentation/power/regulator/regulator.txt
+++ b/Documentation/power/regulator/regulator.txt
@@ -11,8 +11,7 @@ Registration
 Drivers can register a regulator by calling :-
 
 struct regulator_dev *regulator_register(struct regulator_desc *regulator_desc,
-	struct device *dev, struct regulator_init_data *init_data,
-	void *driver_data, struct device_node *of_node);
+					 const struct regulator_config *config);
 
 This will register the regulators capabilities and operations to the regulator
 core.
-- 
1.7.5.4



