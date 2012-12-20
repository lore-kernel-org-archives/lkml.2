Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743Ab2LTGgr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 01:36:47 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:23027 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab2LTGgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 01:36:40 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-cf-50d2b1f67e95
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 1/5] backlight: ld9040: use sleep instead of delay
Date: Thu, 20 Dec 2012 15:36:38 +0900
Message-id: <000f01cdde7c$5d4e83b0$17eb8b10$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3efF04bK/W++SuRFi0yIAkd2rsTA==
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsVy+t8zA91vGy8FGDy/Ym1xedccNgdGj8+b
	5AIYo7hsUlJzMstSi/TtErgyNl61K2jnrfjbuY61gXELVxcjJ4eEgInE/d0zWCBsMYkL99az
	dTFycQgJLGOUWLj5HCNM0ZN3B1ggEtMZJaZNfssO4cxmknjz7wcTSBWbgJrEly+H2UFsEYEI
	ieYZs5i7GDk4mAV8JDbP0gQJCws4SWxf0Ac2lEVAVWLLxV1grbwCthIXF/1jg7AFJX5Mvgd2
	EbOAlsT6nceZIGx5ic1r3oKNlBBQl3j0Vxdik57E9N8trBAlIhL7XryDGi8g8W3yIRaIclmJ
	TQeYQS6WEGhnl9i94jgrxF+SEgdX3GCZwCg2C8nmWUg2z0KyeRaSFQsYWVYxiqYWJBcUJ6Xn
	GuoVJ+YWl+al6yXn525ihMSJ1A7GlQ0WhxgFOBiVeHgXTbsUIMSaWFZcmXuIUYKDWUmEd+Gt
	iwFCvCmJlVWpRfnxRaU5qcWHGH2ALp/ILCWanA+M4bySeENjYxMzE1MTc0tTc1McwkrivM0e
	KQFCAumJJanZqakFqUUw45g4OKUaGBkrFhXayllmbxeJm8adVxfdeuk3I5N+8K7XpnxLLLue
	V1pf5i6v21zy6Kv0ee/9M132Fba9sI7cWynVMHFjdvTHxom69dNrev8/ZX6wlm2yppPx+yDB
	6Io5XN/9/rtMV4wLY/i9+UjUhGrVJJvqG4dvzci4U+bc85P1w91uO16NVwX1pS9/KrEUZyQa
	ajEXFScCAPDKKWnAAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsVy+t9jQd1vGy8FGFx6YWZxedccNgdGj8+b
	5AIYoxoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOA
	pioplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCesYMzZetSto563427mOtYFx
	C1cXIyeHhICJxJN3B1ggbDGJC/fWs3UxcnEICUxnlJg2+S07hDObSeLNvx9MIFVsAmoSX74c
	ZgexRQQiJJpnzGLuYuTgYBbwkdg8SxMkLCzgJLF9QR8jiM0ioCqx5eIusFZeAVuJi4v+sUHY
	ghI/Jt8DW8wsoCWxfudxJghbXmLzmrdgIyUE1CUe/dWF2KQnMf13CytEiYjEvhfvGCcwCsxC
	MmkWkkmzkEyahaRlASPLKkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYzgKHwmtYNxZYPFIUYB
	DkYlHt5F0y4FCLEmlhVX5h5ilOBgVhLhXXjrYoAQb0piZVVqUX58UWlOavEhRh+gRycyS4km
	5wMTRF5JvKGxiZmRpZGZhZGJuTkOYSVx3maPlAAhgfTEktTs1NSC1CKYcUwcnFINjGb70q5p
	75OObJ1g6dmQumD7m9IZgjdE3Zp+86/55f+gb16T1LGJVwXLSlz28UYVGHdt66tcbCtYUeDR
	vuzU9iscLWUzD/jfXZ19rf7l/U6hu8ZWcx+v9I71ffx3Pu9ryxu837i+zRE6efNE/lsegwqX
	v1ZL1/ztXam2Jrf+9/zWYpF/gjmN2UosxRmJhlrMRcWJAAJfkVzvAgAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces mdelay with msleep to remove the busy loop
waiting.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/ld9040.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/video/backlight/ld9040.c b/drivers/video/backlight/ld9040.c
index 1cb3524..a52a6a7 100644
--- a/drivers/video/backlight/ld9040.c
+++ b/drivers/video/backlight/ld9040.c
@@ -78,7 +78,7 @@ static void ld9040_regulator_enable(struct ld9040 *lcd)
 
 		lcd->enabled = true;
 	}
-	mdelay(pd->power_on_delay);
+	msleep(pd->power_on_delay);
 out:
 	mutex_unlock(&lcd->lock);
 }
@@ -474,8 +474,9 @@ static int ld9040_panel_send_sequence(struct ld9040 *lcd,
 			ret = ld9040_spi_write(lcd, wbuf[i], wbuf[i+1]);
 			if (ret)
 				break;
-		} else
-			udelay(wbuf[i+1]*1000);
+		} else {
+			msleep(wbuf[i+1]);
+		}
 		i += 2;
 	}
 
@@ -539,7 +540,7 @@ static int ld9040_ldi_init(struct ld9040 *lcd)
 	for (i = 0; i < ARRAY_SIZE(init_seq); i++) {
 		ret = ld9040_panel_send_sequence(lcd, init_seq[i]);
 		/* workaround: minimum delay time for transferring CMD */
-		udelay(300);
+		usleep_range(300, 310);
 		if (ret)
 			break;
 	}
@@ -584,7 +585,7 @@ static int ld9040_power_on(struct ld9040 *lcd)
 		return -EFAULT;
 	} else {
 		pd->reset(lcd->ld);
-		mdelay(pd->reset_delay);
+		msleep(pd->reset_delay);
 	}
 
 	ret = ld9040_ldi_init(lcd);
@@ -619,7 +620,7 @@ static int ld9040_power_off(struct ld9040 *lcd)
 		return -EIO;
 	}
 
-	mdelay(pd->power_off_delay);
+	msleep(pd->power_off_delay);
 
 	/* lcd power off */
 	ld9040_regulator_disable(lcd);
-- 
1.7.2.5


