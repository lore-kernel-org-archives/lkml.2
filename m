Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030448Ab2CIU0y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 15:26:54 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48917 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030386Ab2CITqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:46:06 -0500
Message-Id: <20120309190203.379561466@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:02:15 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "Jett.Zhou" <jtzhou@marvell.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 13/95] regulator: fix the ldo configure according to 88pm860x spec
In-Reply-To: <20120309194424.GA2134@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Jett.Zhou" <jtzhou@marvell.com>

commit 3380643b0eaa7ecf99c4f095bdfcb6e5df471616 upstream.

Signed-off-by: Jett.Zhou <jtzhou@marvell.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/regulator/88pm8607.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/regulator/88pm8607.c
+++ b/drivers/regulator/88pm8607.c
@@ -196,7 +196,7 @@ static const unsigned int LDO12_suspend_
 };
 
 static const unsigned int LDO13_table[] = {
-	1300000, 1800000, 2000000, 2500000, 2800000, 3000000, 0, 0,
+	1200000, 1300000, 1800000, 2000000, 2500000, 2800000, 3000000, 0,
 };
 
 static const unsigned int LDO13_suspend_table[] = {
@@ -389,10 +389,10 @@ static struct pm8607_regulator_info pm86
 	PM8607_LDO( 7,         LDO7, 0, 3, SUPPLIES_EN12, 1),
 	PM8607_LDO( 8,         LDO8, 0, 3, SUPPLIES_EN12, 2),
 	PM8607_LDO( 9,         LDO9, 0, 3, SUPPLIES_EN12, 3),
-	PM8607_LDO(10,        LDO10, 0, 3, SUPPLIES_EN12, 4),
+	PM8607_LDO(10,        LDO10, 0, 4, SUPPLIES_EN12, 4),
 	PM8607_LDO(12,        LDO12, 0, 4, SUPPLIES_EN12, 5),
 	PM8607_LDO(13, VIBRATOR_SET, 1, 3,  VIBRATOR_SET, 0),
-	PM8607_LDO(14,        LDO14, 0, 4, SUPPLIES_EN12, 6),
+	PM8607_LDO(14,        LDO14, 0, 3, SUPPLIES_EN12, 6),
 };
 
 static int __devinit pm8607_regulator_probe(struct platform_device *pdev)


