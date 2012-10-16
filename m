Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060Ab2JPHca (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 03:32:30 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:25795 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754723Ab2JPHc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 03:32:29 -0400
X-AuditID: cbfee61a-b7f976d000001eb9-cc-507d0d8c94e3
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <007101cdab6f$6c8bc030$45a34090$%han@samsung.com>
In-reply-to: <007101cdab6f$6c8bc030$45a34090$%han@samsung.com>
Subject: [PATCH 13/17] backlight: pcf50633: fix checkpatch warning
Date: Tue, 16 Oct 2012 16:32:28 +0900
Message-id: <007e01cdab70$65049b60$2f0dd220$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2rb2x3b+BtYCwlRU+aka06gjxy+QAAOUDQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJLMWRmVeSWpSXmKPExsVy+t9jQd0e3toAg9b38haXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugStj8mb9gvXcFVsbt7A0MB7k7GLk5JAQMJGYOOkFE4QtJnHh3nq2
	LkYuDiGB6YwSe5/uYQRJCAnMZpI4cokHxGYTUJP48uUwO4gtIhAh0TxjFnMXIwcHs4CPxOZZ
	mhDlthKrZ7wFK+EUsJPY+PogC4gtLOAk8aLvHFg5i4CqxK0ZLiBhXqDy99vPskPYghI/Jt8D
	K2cW0JJYv/M4E4QtL7F5zVuwVgkBdYlHf3UhDjCSeN0xCapcRGLfi3eMExiFZiGZNAvJpFlI
	Js1C0rKAkWUVo2hqQXJBcVJ6rqFecWJucWleul5yfu4mRnAAP5PawbiyweIQowAHoxIPb4Zz
	TYAQa2JZcWXuIUYJDmYlEV6PiUAh3pTEyqrUovz4otKc1OJDjNIcLErivM0eKQFCAumJJanZ
	qakFqUUwWSYOTqkGxvMyVf4hV1+ETAq6ezpp7UmhJV/TH/x59vzx1A53dW8zjSsll/Zd7tSo
	emqxeMsni+qybUlfd9hUrnnzs2Z1Jd/5913dgn+t2S/m+PyyPzRN80XKJbU8X8+mO/VVtjsV
	z7UHOX4I0vksdMXx84ZX15ac2jZnw3qe45x6oaEslvNfu3tniqz7eVqJpTgj0VCLuag4EQCo
	piLlXAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the checkpatch warning as below:

WARNING: please, no spaces at the start of a line

Also, long comments are fixed for the preferred style.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 drivers/video/backlight/pcf50633-backlight.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/video/backlight/pcf50633-backlight.c b/drivers/video/backlight/pcf50633-backlight.c
index c092159..930fc2a 100644
--- a/drivers/video/backlight/pcf50633-backlight.c
+++ b/drivers/video/backlight/pcf50633-backlight.c
@@ -52,7 +52,7 @@ int pcf50633_bl_set_brightness_limit(struct pcf50633 *pcf, unsigned int limit)
 	pcf_bl->brightness_limit = limit & 0x3f;
 	backlight_update_status(pcf_bl->bl);
 
-    return 0;
+	return 0;
 }
 
 static int pcf50633_bl_update_status(struct backlight_device *bl)
@@ -136,8 +136,10 @@ static int __devinit pcf50633_bl_probe(struct platform_device *pdev)
 
 	pcf50633_reg_write(pcf_bl->pcf, PCF50633_REG_LEDDIM, pdata->ramp_time);
 
-	/* Should be different from bl_props.brightness, so we do not exit
-	 * update_status early the first time it's called */
+	/*
+	 * Should be different from bl_props.brightness, so we do not exit
+	 * update_status early the first time it's called
+	 */
 	pcf_bl->brightness = pcf_bl->bl->props.brightness + 1;
 
 	backlight_update_status(pcf_bl->bl);
-- 
1.7.1


