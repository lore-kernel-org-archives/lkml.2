Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974Ab0FWIr3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 04:47:29 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:33507 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367Ab0FWIr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 04:47:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=RDGp/ZZ5P7y0kf/7XsOSBjwcdQx1L6XKcCZz3KUqrrMctIl1jk+byezjxDMT6f6IDK
         l2qJvjmG97fozRNTTRcz5Js0vSGwx/pM71HLmlQ6W67y7Gp3eCCsrydo+tgg1HdEWpgu
         FxaF5rH9JdFI3Novs+4yZTzG6KOp4dx4VKj5U=
Subject: [PATCH] s6e63m0: set permissions on gamma_table file to 0444
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Richard Purdie <rpurdie@rpsys.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       InKi Dae <inki.dae@samsung.com>, Randy Dunlap <randy.dunlap@oracle.com>
Content-Type: text/plain
Date: Wed, 23 Jun 2010 16:49:19 +0800
Message-Id: <1277282959.6749.1.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gamma_table is not writable, thus set permissions to 0444.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/video/backlight/s6e63m0.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/backlight/s6e63m0.c b/drivers/video/backlight/s6e63m0.c
index a3128c9..2d83286 100644
--- a/drivers/video/backlight/s6e63m0.c
+++ b/drivers/video/backlight/s6e63m0.c
@@ -729,7 +729,7 @@ static ssize_t s6e63m0_sysfs_show_gamma_table(struct device *dev,
 
 	return strlen(buf);
 }
-static DEVICE_ATTR(gamma_table, 0644,
+static DEVICE_ATTR(gamma_table, 0444,
 		s6e63m0_sysfs_show_gamma_table, NULL);
 
 static int __init s6e63m0_probe(struct spi_device *spi)
-- 
1.5.4.3



