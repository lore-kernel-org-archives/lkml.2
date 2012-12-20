Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691Ab2LTGfU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 01:35:20 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:22809 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab2LTGfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 01:35:16 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-4d-50d2b1a3aae6
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000901cdde7b$db4f6690$91ee33b0$%han@samsung.com>
In-reply-to: <000901cdde7b$db4f6690$91ee33b0$%han@samsung.com>
Subject: [PATCH 4/6] backlight: s6e63m0: replace EFAULT with EINVAL
Date: Thu, 20 Dec 2012 15:35:14 +0900
Message-id: <000c01cdde7c$2b5627f0$820277d0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3ee9s5WLGjeuuhRceS0Ez4r5xE9AAAEI2g
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKIsWRmVeSWpSXmKPExsVy+t8zY93FGy8FGLw6yWxxedccNgdGj8+b
	5AIYo7hsUlJzMstSi/TtErgy1nxYx1zQwlXx5/QE5gbGmRxdjJwcEgImEh2r+lkhbDGJC/fW
	s3UxcnEICSxjlPj96ScrTNG7i2+ZQWwhgUWMEj9+aUMUzWaSOLPzOFgRm4CaxJcvh9lBbBGB
	CInmGbOAGjg4mAV8JDbP0oTotZW4s/gfC4jNKWAn0fhhN1i5sICzxImlF8HmswioShycB1HD
	C1S/e98SRghbUOLH5HtgcWYBLYn1O48zQdjyEpvXvAVbJSGgLvHory7EBUYS21d3sUOUiEjs
	e/GOEWK8gMS3yYdYIMplJTYdYAb5REJgHrvE/E33mSHelZQ4uOIGywRGiVlINs9CsnkWks2z
	kKxYwMiyilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyMkrqR2MK5ssDjEKMDBqMTDu2japQAh
	1sSy4srcQ4wSHMxKIrwLb10MEOJNSaysSi3Kjy8qzUktPsToA3T5RGYp0eR8YMznlcQbGhub
	mJmYmphbmpqb4hBWEudt9kgJEBJITyxJzU5NLUgtghnHxMEp1cBYPzlUzrvGec4r2a9H1hny
	exxlffjnzkWVkGDHriT5SZW3ONMqjIWvaGTHnCp81vWbl5/tpTVDX/OrBn732yuy/md5Nem/
	a2mYoc+9xYnh9+ofepcObVqt3amtmR5usuWCWph+UZrj1zP2ZtfCf66K3Srod4xB6rBE7Zpt
	FQu7VUyWShRFaCmxFGckGmoxFxUnAgBajgH/2AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsVy+t9jAd1FGy8FGLQ22Fpc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjDUf1jEXtHBV/Dk9gbmB
	cSZHFyMnh4SAicS7i2+ZIWwxiQv31rOB2EICixglfvzS7mLkArJnM0mc2XmcFSTBJqAm8eXL
	YXYQW0QgQqJ5xiygZg4OZgEfic2zNCF6bSXuLP7HAmJzCthJNH7YDVYuLOAscWLpRbBdLAKq
	EgfnQdTwAtXv3reEEcIWlPgx+R5YnFlAS2L9zuNMELa8xOY1b8FWSQioSzz6qwtxgZHE9tVd
	7BAlIhL7XrxjnMAoNAvJpFlIJs1CMmkWkpYFjCyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3
	MYKj9pnUDsaVDRaHGAU4GJV4eBdNuxQgxJpYVlyZe4hRgoNZSYR34a2LAUK8KYmVValF+fFF
	pTmpxYcYfYAencgsJZqcD0woeSXxhsYmZkaWRmYWRibm5jiElcR5mz1SAoQE0hNLUrNTUwtS
	i2DGMXFwSjUwai3WX7bEd5pruEE440mbl93JruxhTicydnF+/WrtXruuaw2Xuq7/iR322xhM
	92b8rojviJ6+s+8vS9wWtupbmxaf5Znz3eEwb3EGwwoL+32fvt2UduycLSGyLJXTOkfNOO4E
	e67GPS/VO12ezZFVoTtjL2t+kdrJP1W9TP74DvcTB75lCFQpsRRnJBpqMRcVJwIAA4ftYwcD	AAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces EFAULT with EINVAL, because EFAULT tends to be
for the invalid memory addresses.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/s6e63m0.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/video/backlight/s6e63m0.c b/drivers/video/backlight/s6e63m0.c
index 633f0d3..87831bb 100644
--- a/drivers/video/backlight/s6e63m0.c
+++ b/drivers/video/backlight/s6e63m0.c
@@ -515,7 +515,7 @@ static int s6e63m0_power_on(struct s6e63m0 *lcd)
 
 	if (!pd->power_on) {
 		dev_err(lcd->dev, "power_on is NULL.\n");
-		return -EFAULT;
+		return -EINVAL;
 	} else {
 		pd->power_on(lcd->ld, 1);
 		msleep(pd->power_on_delay);
@@ -523,7 +523,7 @@ static int s6e63m0_power_on(struct s6e63m0 *lcd)
 
 	if (!pd->reset) {
 		dev_err(lcd->dev, "reset is NULL.\n");
-		return -EFAULT;
+		return -EINVAL;
 	} else {
 		pd->reset(lcd->ld);
 		msleep(pd->reset_delay);
@@ -747,7 +747,7 @@ static int s6e63m0_probe(struct spi_device *spi)
 	lcd->lcd_pd = spi->dev.platform_data;
 	if (!lcd->lcd_pd) {
 		dev_err(&spi->dev, "platform data is NULL.\n");
-		return -EFAULT;
+		return -EINVAL;
 	}
 
 	ld = lcd_device_register("s6e63m0", &spi->dev, lcd, &s6e63m0_lcd_ops);
-- 
1.7.2.5


