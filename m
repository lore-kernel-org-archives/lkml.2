Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628Ab2LTGaH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 01:30:07 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:20199 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab2LTG37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 01:29:59 -0500
X-AuditID: cbfee61b-b7f616d00000319b-7d-50d2b06637e2
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000401cdde7b$2b0194c0$8104be40$%han@samsung.com>
In-reply-to: <000401cdde7b$2b0194c0$8104be40$%han@samsung.com>
Subject: [PATCH 3/5] backlight: ams369fg06: replace EFAULT with EINVAL
Date: Thu, 20 Dec 2012 15:29:58 +0900
Message-id: <000601cdde7b$6e9f9bf0$4bded3d0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3eeyqi7zfdOO97SfGBrHQPr76IuAAACjKw
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKIsWRmVeSWpSXmKPExsVy+t8zI920DZcCDC4+k7G4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZz89sYSmYyFXx9P4/xgbG5RxdjJwcEgImEq82z2KCsMUkLtxb
	z9bFyMUhJLCMUWLF9Z9sMEXvjvxmh0gsYpR4f+4mC4Qzm0ni8KIHYO1sAmoSX74cZgexRQQi
	JJpnzGLuYuTgYBbwkdg8SxMkLCRgK9E+9zBYOaeAnUTzh6Ng5cICbhJd+04zg9gsAqoSLzYs
	AlvMC1T/efNvZghbUOLH5HssIDazgJbE+p3HmSBseYnNa96CrZIQUJd49FcX4gIjiWWPpkOV
	iEjse/GOEWK8gMS3yYdYIMplJTYdYIZ4cRG7xJIGTghbUuLgihssExglZiFZPAvJ4llIFs9C
	smEBI8sqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjJC4kt7BuKrB4hCjAAejEg/vommXAoRY
	E8uKK3MPMUpwMCuJ8C68dTFAiDclsbIqtSg/vqg0J7X4EKMP0OETmaVEk/OBMZ9XEm9obGxi
	ZmJqYm5pam6KQ1hJnLfZIyVASCA9sSQ1OzW1ILUIZhwTB6dUA6Nlw5Ifbzw3VL7LtcxNN1P9
	ou32/enBjsMJ83a0m/067ezeMG35ZoF7JrXJ66Ll/ps1qPP90j2xUFydy+D5T7cYya/vc24U
	zcpb8fxrcvST855L+ZU0jWsmzwrVkV/QN3chV1HetcjG23eaj1x+vvb8b/ncLgOO7kePn1f/
	lr+xgCW+TCZI7qcSS3FGoqEWc1FxIgAhlDIA2AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsVy+t9jAd20DZcCDOatlrC4vGsOmwOjx+dN
	cgGMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlA
	U5UUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGc/PbGEpmMhV8fT+P8YG
	xuUcXYycHBICJhLvjvxmh7DFJC7cW8/WxcjFISSwiFHi/bmbLBDObCaJw4seMIFUsQmoSXz5
	chisQ0QgQqJ5xizmLkYODmYBH4nNszRBwkICthLtcw+DlXMK2Ek0fzgKVi4s4CbRte80M4jN
	IqAq8WLDIjYQmxeo/vPm38wQtqDEj8n3WEBsZgEtifU7jzNB2PISm9e8BVslIaAu8eivLsQF
	RhLLHk2HKhGR2PfiHeMERqFZSCbNQjJpFpJJs5C0LGBkWcUomlqQXFCclJ5rpFecmFtcmpeu
	l5yfu4kRHLfPpHcwrmqwOMQowMGoxMO7aNqlACHWxLLiytxDjBIczEoivAtvXQwQ4k1JrKxK
	LcqPLyrNSS0+xOgD9OhEZinR5HxgSskriTc0NjEzsjQyszAyMTfHIawkztvskRIgJJCeWJKa
	nZpakFoEM46Jg1OqgTHF+2eIW4Rz05KbK7MNTHdN1DzSEGYS02nfeI5/edrmoN4DWRGpqlsr
	Xh9d8yHcaLflQQVT/Q0Rh/1TTy7OeH7Ju7DnmsffpO+9jUGXX2xcwqLK9+S4/iyDtk1XVzpb
	WjL9+G+jmfRHnOG25tb5c14GPDHVnebfvu59qHvlan4GzhansudLfJRYijMSDbWYi4oTAfyp
	taoIAwAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces EFAULT with EINVAL, because EFAULT tends to be
for the invalid memory addresses.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/ams369fg06.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/video/backlight/ams369fg06.c b/drivers/video/backlight/ams369fg06.c
index b4bf130..22756dd 100644
--- a/drivers/video/backlight/ams369fg06.c
+++ b/drivers/video/backlight/ams369fg06.c
@@ -328,7 +328,7 @@ static int ams369fg06_power_on(struct ams369fg06 *lcd)
 
 	if (!pd->power_on) {
 		dev_err(lcd->dev, "power_on is NULL.\n");
-		return -EFAULT;
+		return -EINVAL;
 	} else {
 		pd->power_on(lcd->ld, 1);
 		msleep(pd->power_on_delay);
@@ -336,7 +336,7 @@ static int ams369fg06_power_on(struct ams369fg06 *lcd)
 
 	if (!pd->reset) {
 		dev_err(lcd->dev, "reset is NULL.\n");
-		return -EFAULT;
+		return -EINVAL;
 	} else {
 		pd->reset(lcd->ld);
 		msleep(pd->reset_delay);
@@ -485,7 +485,7 @@ static int ams369fg06_probe(struct spi_device *spi)
 	lcd->lcd_pd = spi->dev.platform_data;
 	if (!lcd->lcd_pd) {
 		dev_err(&spi->dev, "platform data is NULL\n");
-		return -EFAULT;
+		return -EINVAL;
 	}
 
 	ld = lcd_device_register("ams369fg06", &spi->dev, lcd,
-- 
1.7.2.5


