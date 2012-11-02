Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550Ab2KBH3a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 03:29:30 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:58849 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274Ab2KBH32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 03:29:28 -0400
From: Kumar Amit Mehta <gmate.amit@gmail.com>
To: jic23@cam.ac.uk
Cc: gregkh@linuxfoundation.org, lars@metafoo.de, michael.hennerich@analog.com,
        thomas@m3y3r.de, linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] staging: iio: adc: ad7280a.c: fixed macro coding style
Date: Fri,  2 Nov 2012 00:28:53 -0700
Message-Id: <1351841333-30581-1-git-send-email-gmate.amit@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove unnecessary semicolon from the macro definition

Signed-off-by: Kumar Amit Mehta <gmate.amit@gmail.com>
---
 drivers/staging/iio/adc/ad7280a.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/iio/adc/ad7280a.c b/drivers/staging/iio/adc/ad7280a.c
index cfc39a7..e7cb3b2 100644
--- a/drivers/staging/iio/adc/ad7280a.c
+++ b/drivers/staging/iio/adc/ad7280a.c
@@ -117,7 +117,7 @@
  */
 #define POLYNOM		0x2F
 #define POLYNOM_ORDER	8
-#define HIGHBIT		1 << (POLYNOM_ORDER - 1);
+#define HIGHBIT		(1 << (POLYNOM_ORDER - 1))
 
 struct ad7280_state {
 	struct spi_device		*spi;
-- 
1.7.9.5

