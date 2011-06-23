Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932409Ab1FWCTX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 22:19:23 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:63956 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932302Ab1FWCTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 22:19:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=OTeEnDP5r+KIEshs9XNvW2rwTs2aKJ/d/LQcmA+7lC/sL8p6wYu8bqyufXX+3y/eNn
         /kME+AkoqArSvtMNyJStwWfMMVFuSOBjWlR0mAT44WG8RJWj+ir1eRhazYsRwn44tmNw
         PO1y94b2RpRFIJmSFlZXEu0D8jivb7QVvVwLY=
Subject: [PATCH 3/3] mfd: Remove comp1_threshold and comp2_threshold sysfs
 entries in tps65911_comparator_remove
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1308795351.15248.2.camel@phoenix>
References: <1308795351.15248.2.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Jun 2011 10:19:16 +0800
Message-ID: <1308795556.15248.6.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/tps65911-comparator.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/tps65911-comparator.c b/drivers/mfd/tps65911-comparator.c
index 283ac67..e7ff783 100644
--- a/drivers/mfd/tps65911-comparator.c
+++ b/drivers/mfd/tps65911-comparator.c
@@ -157,6 +157,8 @@ static __devexit int tps65911_comparator_remove(struct platform_device *pdev)
 	struct tps65910 *tps65910;
 
 	tps65910 = dev_get_drvdata(pdev->dev.parent);
+	device_remove_file(&pdev->dev, &dev_attr_comp2_threshold);
+	device_remove_file(&pdev->dev, &dev_attr_comp1_threshold);
 
 	return 0;
 }
-- 
1.7.4.1



