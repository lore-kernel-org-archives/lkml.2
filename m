Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232Ab2JPHeV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 03:34:21 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:34740 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754949Ab2JPHeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 03:34:19 -0400
X-AuditID: cbfee61a-b7f976d000001eb9-6e-507d0df9efca
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <007101cdab6f$6c8bc030$45a34090$%han@samsung.com>
In-reply-to: <007101cdab6f$6c8bc030$45a34090$%han@samsung.com>
Subject: [PATCH 17/17] backlight: vgg2432a4: fix checkpatch warning
Date: Tue, 16 Oct 2012 16:34:17 +0900
Message-id: <008201cdab70$a62a0170$f27e0450$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2rb2x3b+BtYCwlRU+aka06gjxy+QAASgcQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsVy+t9jAd2fvLUBBltmGFhc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MLQffsxd8Za3YevUtUwPjX5YuRk4OCQETiY7FyxkhbDGJC/fW
	s3UxcnEICSxilDjVepkRwpnNJHGiZylYB5uAmsSXL4fZQWwRgQiJ5hmzmLsYOTiYBXwkNs/S
	BAkLCdhKrJ7xFqyEU8BOYuPrg2CtwgLOEt8bloDZLAKqEgfvbmQFsXmB6tfe28UIYQtK/Jh8
	D6yGWUBLYv3O40wQtrzE5jVvwVZJCKhLPPqrC3GBkcSLuV+hSkQk9r14xziBUWgWkkmzkEya
	hWTSLCQtCxhZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIEh/EzqR2MKxssDjEKcDAq8fBm
	ONcECLEmlhVX5h5ilOBgVhLh9ZgIFOJNSaysSi3Kjy8qzUktPsQozcGiJM7b7JESICSQnliS
	mp2aWpBaBJNl4uCUamBMXMIdFyK5+va2w/Y7npZF8zw6qPfeoYvbZ+H6gwum8GnvamSUXncw
	+uzb1ctCwjnnWz0VlVPdN8eCj1Hx9J3Xv7qbuhS9efex5KgFf9zus+wa/8ZTh+sX+4V8X3XK
	4lShFu/zm7MLpRl3Rv3a7mNvb9e+PH+DYsCVfQaTCjrjlvGJ71wccK5MiaU4I9FQi7moOBEA
	SQnggV8CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the checkpatch warning as below:

WARNING: please, no space before tabs

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 drivers/video/backlight/vgg2432a4.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/backlight/vgg2432a4.c b/drivers/video/backlight/vgg2432a4.c
index b617fae..b1ead3d 100644
--- a/drivers/video/backlight/vgg2432a4.c
+++ b/drivers/video/backlight/vgg2432a4.c
@@ -217,7 +217,7 @@ static int vgg2432a4_resume(struct spi_device *spi)
 }
 #else
 #define vgg2432a4_suspend	NULL
-#define vgg2432a4_resume 	NULL
+#define vgg2432a4_resume	NULL
 #endif
 
 static struct ili9320_client vgg2432a4_client = {
-- 
1.7.1


