Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562Ab2LTG2Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 01:28:16 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:19812 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab2LTG2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 01:28:08 -0500
X-AuditID: cbfee61b-b7f616d00000319b-fe-50d2aff5eedf
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 1/5] backlight: ams369fg06: use sleep instead of delay
Date: Thu, 20 Dec 2012 15:28:04 +0900
Message-id: <000401cdde7b$2b0194c0$8104be40$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3eeyqi7zfdOO97SfGBrHQPr76IuA==
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsVy+t8zA92v6y8FGHz6y2xxedccNgdGj8+b
	5AIYo7hsUlJzMstSi/TtErgy9rxYzlKwkLvi6473LA2M7ZxdjBwcEgImEp/vVHcxcgKZYhIX
	7q1n62Lk4hASWMYosWbeVjaIhInEueaJjBCJ6YwSP44eZ4JwZjNJ/L9wlwmkik1ATeLLl8Ps
	ILaIQIRE84xZzCAbmAV8JDbP0gQJCwu4Sdx8Mh2shEVAVaJr1WZWEJtXwFbi8YkbzBC2oMSP
	yfdYQGxmAS2J9TuPM0HY8hKb17xlhjhaXeLRX12ITXoSx7bdZ4YoEZHY9+IdI8R4AYlvkw+x
	QJTLSmw6wAxysYRAN7vEvCWLWCD+kpQ4uOIGywRGsVlINs9CsnkWks2zkKxYwMiyilE0tSC5
	oDgpPddIrzgxt7g0L10vOT93EyMkTqR3MK5qsDjEKMDBqMTDu2japQAh1sSy4srcQ4wSHMxK
	IrwLb10MEOJNSaysSi3Kjy8qzUktPsToA3T5RGYp0eR8YAznlcQbGhubmJmYmphbmpqb4hBW
	Eudt9kgJEBJITyxJzU5NLUgtghnHxMEp1cBYkHy/WHt/bfHiym/vtqULiHcInNtVN+9/ytSa
	fb9WfDJp3n80L0X0leCblCntTZv+he2e+U0i86T5Tv+9h341fGReVc40VWfD65s7VsjsPGCc
	ftJg29HZLrX3dzW/3vRgZ+vJ0sxTJbPn3vSaKthrfOZm4qLqx/y3H5X+mD/32/aDWtfKdHd3
	+SixFGckGmoxFxUnAgA7GqFzwAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLIsWRmVeSWpSXmKPExsVy+t9jQd0v6y8FGHRet7a4vGsOmwOjx+dN
	cgGMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlA
	U5UUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGXteLGcpWMhd8XXHe5YG
	xnbOLkZODgkBE4lzzRMZIWwxiQv31rN1MXJxCAlMZ5T4cfQ4E4Qzm0ni/4W7TCBVbAJqEl++
	HGYHsUUEIiSaZ8xi7mLk4GAW8JHYPEsTJCws4CZx88l0sBIWAVWJrlWbWUFsXgFbiccnbjBD
	2IISPybfYwGxmQW0JNbvPM4EYctLbF7zFmykhIC6xKO/uhCb9CSObbvPDFEiIrHvxTvGCYwC
	s5BMmoVk0iwkk2YhaVnAyLKKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzgOn0nvYFzVYHGI
	UYCDUYmHd9G0SwFCrIllxZW5hxglOJiVRHgX3roYIMSbklhZlVqUH19UmpNafIjRB+jRicxS
	osn5wBSRVxJvaGxiZmRpZGZhZGJujkNYSZy32SMlQEggPbEkNTs1tSC1CGYcEwenVAOj+/UH
	3Zysy1STAt4nrnpmNC3efoH+RBmNqptbVzJ8bG0+31PytoutPvbGkcnxx4RYJScy/Eq5slDG
	w3bltqOTahoMJNvPv711JcDRP1OlaOGiX6ZtZ7J6pda/OqF26+FBfS+l+PrJwpJrcgs3iT0L
	evIl92WL5v0JE9Wf5xlaipdlXf3/xv68EktxRqKhFnNRcSIAiJMoh/ACAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces mdelay with msleep to remove the busy loop
waiting.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/ams369fg06.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/video/backlight/ams369fg06.c b/drivers/video/backlight/ams369fg06.c
index f57e190..55b2792 100644
--- a/drivers/video/backlight/ams369fg06.c
+++ b/drivers/video/backlight/ams369fg06.c
@@ -210,8 +210,9 @@ static int ams369fg06_panel_send_sequence(struct ams369fg06 *lcd,
 			ret = ams369fg06_spi_write(lcd, wbuf[i], wbuf[i+1]);
 			if (ret)
 				break;
-		} else
-			mdelay(wbuf[i+1]);
+		} else {
+			msleep(wbuf[i+1]);
+		}
 		i += 2;
 	}
 
@@ -339,7 +340,7 @@ static int ams369fg06_power_on(struct ams369fg06 *lcd)
 		return -EFAULT;
 	} else {
 		pd->power_on(lcd->ld, 1);
-		mdelay(pd->power_on_delay);
+		msleep(pd->power_on_delay);
 	}
 
 	if (!pd->reset) {
@@ -347,7 +348,7 @@ static int ams369fg06_power_on(struct ams369fg06 *lcd)
 		return -EFAULT;
 	} else {
 		pd->reset(lcd->ld);
-		mdelay(pd->reset_delay);
+		msleep(pd->reset_delay);
 	}
 
 	ret = ams369fg06_ldi_init(lcd);
@@ -389,7 +390,7 @@ static int ams369fg06_power_off(struct ams369fg06 *lcd)
 		return -EIO;
 	}
 
-	mdelay(pd->power_off_delay);
+	msleep(pd->power_off_delay);
 
 	if (!pd->power_on) {
 		dev_err(lcd->dev, "power_on is NULL.\n");
-- 
1.7.2.5


