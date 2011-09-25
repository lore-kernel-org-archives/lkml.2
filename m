Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300Ab1IYLXM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 07:23:12 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48432 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab1IYLXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 07:23:11 -0400
Message-ID: <4E7F0BE2.5070707@gmail.com>
Date: Sun, 25 Sep 2011 16:39:22 +0530
From: Navin P <zicrim@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.21) Gecko/20110831 Lightning/1.0b2 Thunderbird/3.1.13
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: kernel-janitors@vger.kernel.org, sameo@linux.intel.com,
        rabin.vincent@stericsson.com, hanumath.prasad@stericsson.com
Subject: [PATCH] Remove redundant const in tc3589x.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Remove the redundant const as SIMPLE_DEV_PM_OPS defines const
 struct.
 Signed-off-by: Navin P <zicrim@gmail.com>

---
 drivers/mfd/tc3589x.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/tc3589x.c b/drivers/mfd/tc3589x.c
index c27e515..e87020f 100644
--- a/drivers/mfd/tc3589x.c
+++ b/drivers/mfd/tc3589x.c
@@ -385,7 +385,7 @@ static int tc3589x_resume(struct device *dev)
 	return ret;
 }
 
-static const SIMPLE_DEV_PM_OPS(tc3589x_dev_pm_ops, tc3589x_suspend,
+static SIMPLE_DEV_PM_OPS(tc3589x_dev_pm_ops, tc3589x_suspend,
 						tc3589x_resume);
 
 static const struct i2c_device_id tc3589x_id[] = {
-- 
1.7.0.4


