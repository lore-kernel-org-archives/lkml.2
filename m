Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166Ab1CGDBJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 22:01:09 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:57072 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754549Ab1CGDBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 22:01:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=kUKRtWzEXg6C2A9FIfycXY/b6DiG9qw7vYeCFq8RYkHxnRi0em/cqu9nanOT1E3ZPs
         0LzKNj4JXRvNg7OlQF3IXCeN1uoURQ84m6MYdzkyCl5qkaU2Svxi5LKS2GoC/ZZVjuVE
         3htnKAysvjf8uQHSZl4WZy1LwUvIdhFd5+ZWQ=
Subject: [PATCH 3/3] hwmon: twl4030-madc-hwmon: add "platform:" prefix for
	platform modalias
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: J Keerthy <j-keerthy@ti.com>, Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>, lm-sensors@lm-sensors.org
In-Reply-To: <1299466949.3879.0.camel@mola>
References: <1299466949.3879.0.camel@mola>
Content-Type: text/plain
Date: Mon, 07 Mar 2011 11:05:33 +0800
Message-Id: <1299467133.3879.5.camel@mola>
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
 drivers/hwmon/twl4030-madc-hwmon.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/hwmon/twl4030-madc-hwmon.c b/drivers/hwmon/twl4030-madc-hwmon.c
index 97e22be..de58191 100644
--- a/drivers/hwmon/twl4030-madc-hwmon.c
+++ b/drivers/hwmon/twl4030-madc-hwmon.c
@@ -154,4 +154,4 @@ module_exit(twl4030_madc_hwmon_exit);
 MODULE_DESCRIPTION("TWL4030 ADC Hwmon driver");
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("J Keerthy");
-MODULE_ALIAS("twl4030_madc_hwmon");
+MODULE_ALIAS("platform:twl4030_madc_hwmon");
-- 
1.7.2



