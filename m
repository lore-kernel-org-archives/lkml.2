Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750Ab2JWESm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 00:18:42 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:23561 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986Ab2JWESl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 00:18:41 -0400
X-AuditID: cbfee61a-b7fa66d0000004cf-df-50861a9f217e
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Ashish Jangam'" <ashish.jangam@kpitcummins.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 1/4] backlight: da9052: add missing const
Date: Tue, 23 Oct 2012 13:18:39 +0900
Message-id: <000901cdb0d5$7aa097c0$6fe1c740$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2w1XpVbfPt/OpOQ+KIRjYTosJjAA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGLMWRmVeSWpSXmKPExsVy+t9jQd35Um0BBp1ndC0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGyqutjAUfWSt27b/C2MD4g6WLkZNDQsBEYtmWX6wQtpjEhXvr
	2boYuTiEBKYzSny48RTKmc0k0bZ1HSNIFZuAmsSXL4fZQWwRgQiJ5hmzmEGKmAUaGSVWXtzD
	DJIQFrCUOHh1I9gKFgFViUtHXoA18ArYSlx61MwMYQtK/Jh8D6yGWUBLYv3O40wQtrzE5jVv
	gWo4gE5Sl3j0Vxdil57ElH9NUCUiEvtevGOcwCgwC8mkWUgmzUIyaRaSlgWMLKsYRVMLkguK
	k9JzDfWKE3OLS/PS9ZLzczcxgkPzmdQOxpUNFocYBTgYlXh4LY60BgixJpYVV+YeYpTgYFYS
	4VUOAArxpiRWVqUW5ccXleakFh9ilOZgURLnbfZICRASSE8sSc1OTS1ILYLJMnFwSjUw7g5+
	ar72xZcHuVvuGTK2ZM5fFK3BMf/gb6WVUWbXnQQ+vbNu2cd/NGf6GdkJOVP3ead2KF0yKNff
	L5kjLS1dP73qFbvqF7vQWYZmije7215eXhPwaF+7qsZ0nYDfN6vnyd09HlwX66QhHpTR6bnk
	rkbwum1Tz1xla1y8P/NKXtX8qN3uFqEOSizFGYmGWsxFxYkAHQhHd0kCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add 'const' to static array that was missing it in its
definition.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 drivers/video/backlight/da9052_bl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/backlight/da9052_bl.c b/drivers/video/backlight/da9052_bl.c
index ac19618..842da5a 100644
--- a/drivers/video/backlight/da9052_bl.c
+++ b/drivers/video/backlight/da9052_bl.c
@@ -34,7 +34,7 @@ enum {
 	DA9052_TYPE_WLED3,
 };
 
-static unsigned char wled_bank[] = {
+static const unsigned char wled_bank[] = {
 	DA9052_LED1_CONF_REG,
 	DA9052_LED2_CONF_REG,
 	DA9052_LED3_CONF_REG,
-- 
1.7.1


