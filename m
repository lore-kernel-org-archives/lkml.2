Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751165Ab2LUFVR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 00:21:17 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:57151 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729Ab2LUFVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 00:21:10 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-41-50d3f1c58f2b
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000501cddf3a$9ba1ecb0$d2e5c610$%han@samsung.com>
In-reply-to: <000501cddf3a$9ba1ecb0$d2e5c610$%han@samsung.com>
Subject: [PATCH 06/11] backlight: lms283gf05: use spi_get_drvdata and
 spi_set_drvdata
Date: Fri, 21 Dec 2012 14:21:08 +0900
Message-id: <000a01cddf3a$fbd79800$f386c800$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3fOptdKnZ1gkj6SBm7JPAbRHnX+QAAFHKA
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCIsWRmVeSWpSXmKPExsVy+t8zI92jHy8HGNy8LW5xedccNgdGj8+b
	5AIYo7hsUlJzMstSi/TtErgyriy/zVawg6Ni7rv9bA2MLexdjJwcEgImEuenzGeGsMUkLtxb
	zwZiCwksY5ToXGAFU3N7/ySmLkYuoPgiRok9jx6wQTizmST6bn0D62ATUJP48uUw2FQRgQiJ
	5hmzgKZycDAL+EhsnqUJMdRWov3rDkYQm1PATqJ5bhMLiC0sEC7xdul5MJtFQFVi5f0L7CCt
	vED1a/ZwgoR5BQQlfky+B1bCLKAlsX7ncSYIW15i85q3YJskBNQlHv3VhTjASGLjuf1Q5SIS
	+168Y4SYLiDxbfIhFohyWYlNB5hBHpEQWMQu8aV5BjRIJCUOrrjBMoFRYhaSzbOQbJ6FZPMs
	JCsWMLKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAiJKqkdjCsbLA4xCnAwKvHwMppdDhBi
	TSwrrsw9xCjBwawkwuv/ASjEm5JYWZValB9fVJqTWnyI0Qfo8onMUqLJ+cCIzyuJNzQ2NjEz
	MTUxtzQ1N8UhrCTO2+yREiAkkJ5YkpqdmlqQWgQzjomDU6qB0WRiRqhosk117YerquEec5au
	jpQofsVqEDq/80L2m5l1xxZbJJ73rlrcP/fwlvKX28Qz0n86/+X+1LRGdGcTr7bCwi2SDUVW
	BtoPWFfrfW3Kf9N/Rmdye8WVYzuS5874ciKgv//agckSH5yCxDse99yZdXX3b462C8KLo3r2
	KnVcu1XBxiTyUImlOCPRUIu5qDgRAAVV2RbXAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsVy+t9jAd2jHy8HGLw5IGRxedccNgdGj8+b
	5AIYoxoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOA
	pioplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCesYM64sv81WsIOjYu67/WwN
	jC3sXYycHBICJhK3909igrDFJC7cW8/WxcjFISSwiFFiz6MHUM5sJom+W9/YQKrYBNQkvnw5
	DNYtIhAh0TxjFnMXIwcHs4CPxOZZmiBhIQFbifavOxhBbE4BO4nmuU0sILawQLjE26XnwWwW
	AVWJlfcvsIO08gLVr9nDCRLmFRCU+DH5HlgJs4CWxPqdx5kgbHmJzWvegm2SEFCXePRXF+IA
	I4mN5/ZDlYtI7HvxjnECo9AsJJNmIZk0C8mkWUhaFjCyrGIUTS1ILihOSs811CtOzC0uzUvX
	S87P3cQIjtpnUjsYVzZYHGIU4GBU4uFlNLscIMSaWFZcmXuIUYKDWUmE1/8DUIg3JbGyKrUo
	P76oNCe1+BCjD9CfE5mlRJPzgQklryTe0NjEzMjSyMzCyMTcHIewkjhvs0dKgJBAemJJanZq
	akFqEcw4Jg5OqQbGLsMKU2+r768SF195u2evp6/ECtV/e9+VfvKRfKP68tbN2It/5rcpXDef
	UnDMV/T9cnZ1MenjLsu2CS+9K9mp7leT3hkzx/XgibXd/zdO3nuAn8eqi9Ht0a81nDF7Psya
	9iDNZ52E94Gzjw+1HI/b33mzPbZdokTmkmre3YSUFeGlmxm7ip+IK7EUZyQaajEXFScCAPXE
	F4MHAwAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper functions for getting and setting the driver data
using spi_device instead of using dev_{get|set}_drvdata with
&spi->dev, so we can directly pass a struct spi_device.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/lms283gf05.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/backlight/lms283gf05.c b/drivers/video/backlight/lms283gf05.c
index 55819b3..4eec472 100644
--- a/drivers/video/backlight/lms283gf05.c
+++ b/drivers/video/backlight/lms283gf05.c
@@ -180,7 +180,7 @@ static int lms283gf05_probe(struct spi_device *spi)
 	st->spi = spi;
 	st->ld = ld;
 
-	dev_set_drvdata(&spi->dev, st);
+	spi_set_drvdata(spi, st);
 
 	/* kick in the LCD */
 	if (pdata)
@@ -192,7 +192,7 @@ static int lms283gf05_probe(struct spi_device *spi)
 
 static int lms283gf05_remove(struct spi_device *spi)
 {
-	struct lms283gf05_state *st = dev_get_drvdata(&spi->dev);
+	struct lms283gf05_state *st = spi_get_drvdata(spi);
 
 	lcd_device_unregister(st->ld);
 
-- 
1.7.2.5


