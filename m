Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963Ab1C2EtN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 00:49:13 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59996 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775Ab1C2EtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 00:49:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=IZdlh6MmUeD/Zdwv0E3z8GfI7fWgp9T1WGG4rq8r85LeeldmuJ2oXJ8HXjMvF9yvJC
         6oXEd6hx69icYTW5ojBFvECfK5UMGz+xzwuBQyFCKncMNYOc6glR+L41dRWBS13nMflW
         xfzXFCkhejpiOTewuAjmjVXee9LzguL/W7v6k=
Subject: [PATCH] regulator: Add missing platform_set_drvdata in
 tps6105x_regulator_probe
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Mar 2011 12:49:03 +0800
Message-ID: <1301374144.13301.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps6105x-regulator.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/tps6105x-regulator.c b/drivers/regulator/tps6105x-regulator.c
index 1661499..5f975c2 100644
--- a/drivers/regulator/tps6105x-regulator.c
+++ b/drivers/regulator/tps6105x-regulator.c
@@ -158,6 +158,7 @@ static int __devinit tps6105x_regulator_probe(struct platform_device *pdev)
 			"failed to register regulator\n");
 		return ret;
 	}
+	platform_set_drvdata(pdev, tps6105x);
 
 	return 0;
 }
-- 
1.7.1



