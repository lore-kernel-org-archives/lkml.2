Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163Ab1CGC6I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 21:58:08 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:63831 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754985Ab1CGC6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 21:58:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=Kr4wZlnOpdjcBNOZHwI9G8aLe98I7CzUWGU4TpySyG3CDSlJc0zZIiLmPKF3aTrgxe
         c4g0LpnficYn2L7qgMglNZb7FcXonCb63DBTiwNIofXEAY/Zn82I64HDWXjLwbqH+t69
         Q974FGVQgo7KQwuLupQT/InvrJteiqA8Vwj4E=
Subject: [PATCH 1/3] mfd: twl4030-madc: add "platform:" prefix for platform
	modalias
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: J Keerthy <j-keerthy@ti.com>, Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain
Date: Mon, 07 Mar 2011 11:02:29 +0800
Message-Id: <1299466949.3879.0.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since 43cc71eed1250755986da4c0f9898f9a635cb3bf (platform: prefix MODALIAS
with "platform:"), the platform modalias is prefixed with "platform:".

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/twl4030-madc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/twl4030-madc.c b/drivers/mfd/twl4030-madc.c
index e9884e2..3941ddc 100644
--- a/drivers/mfd/twl4030-madc.c
+++ b/drivers/mfd/twl4030-madc.c
@@ -799,4 +799,4 @@ module_exit(twl4030_madc_exit);
 MODULE_DESCRIPTION("TWL4030 ADC driver");
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("J Keerthy");
-MODULE_ALIAS("twl4030_madc");
+MODULE_ALIAS("platform:twl4030_madc");
-- 
1.7.2



