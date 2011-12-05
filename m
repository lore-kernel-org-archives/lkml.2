Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144Ab1LEHSH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 02:18:07 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:52098 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049Ab1LEHSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 02:18:05 -0500
From: Rajendra Nayak <rnayak@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <broonie@opensource.wolfsonmicro.com>
CC: <rdunlap@xenotime.net>, <thomas.abraham@linaro.org>,
        Rajendra Nayak <rnayak@ti.com>
Subject: [PATCH] Documentation: Fix regulator_register() API signature
Date: Mon, 5 Dec 2011 12:47:42 +0530
Message-ID: <1323069462-8490-1-git-send-email-rnayak@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit 2c043bcbf287 ("regulator: pass additional of_node to
regulator_register()") added an additional parameter to the
regulator_register() API.
Update the Documentation accordingly to reflect the change
in the function signature.

Reported-by: Thomas Abraham <thomas.abraham@linaro.org>
Signed-off-by: Rajendra Nayak <rnayak@ti.com>
---
 Documentation/power/regulator/regulator.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/power/regulator/regulator.txt b/Documentation/power/regulator/regulator.txt
index 3f8b528..e272d99 100644
--- a/Documentation/power/regulator/regulator.txt
+++ b/Documentation/power/regulator/regulator.txt
@@ -12,7 +12,7 @@ Drivers can register a regulator by calling :-
 
 struct regulator_dev *regulator_register(struct regulator_desc *regulator_desc,
 	struct device *dev, struct regulator_init_data *init_data,
-	void *driver_data);
+	void *driver_data, struct device_node *of_node);
 
 This will register the regulators capabilities and operations to the regulator
 core.
-- 
1.7.1

