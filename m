Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760923Ab0HEW36 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:29:58 -0400
Received: from kroah.org ([198.145.64.141]:37848 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934229Ab0HEWZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:25:06 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Guenter Roeck <guenter.roeck@ericsson.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 25/28] regulator: Remove owner field from attribute initialization in regulator core driver
Date: Thu,  5 Aug 2010 15:24:15 -0700
Message-Id: <1281047058-23716-25-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <20100805213314.GB13744@kroah.com>
References: <20100805213314.GB13744@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guenter Roeck <guenter.roeck@ericsson.com>

Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/regulator/core.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 2248087..422a709 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1025,7 +1025,6 @@ static struct regulator *create_regulator(struct regulator_dev *rdev,
 		if (regulator->dev_attr.attr.name == NULL)
 			goto attr_name_err;
 
-		regulator->dev_attr.attr.owner = THIS_MODULE;
 		regulator->dev_attr.attr.mode = 0444;
 		regulator->dev_attr.show = device_requested_uA_show;
 		err = device_create_file(dev, &regulator->dev_attr);
-- 
1.7.2

