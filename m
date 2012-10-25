Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161208Ab2JYLEx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 07:04:53 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:27854 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161055Ab2JYLEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 07:04:51 -0400
X-AuditID: cbfee61b-b7f616d00000319b-0d-50891cd16375
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <001001cdb2a0$58c17f80$0a447e80$%han@samsung.com>
In-reply-to: <001001cdb2a0$58c17f80$0a447e80$%han@samsung.com>
Subject: [PATCH 3/3] backlight: ili9320: add missing __devexit macros for remove
Date: Thu, 25 Oct 2012 20:04:49 +0900
Message-id: <001201cdb2a0$8d319200$a794b600$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2yoFiqa8gwXpqqSuWkk7J8877xPgAACOqw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFLMWRmVeSWpSXmKPExsVy+t9jQd2LMp0BBif69S0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAldG153NTAWT2ComzPjA3MA4h7WLkYNDQsBEYsdZni5GTiBTTOLC
	vfVsILaQwHRGiVf/LLsYuYDs2UwSG7/9YAJJsAmoSXz5cpgdxBYRiJBonjGLGWQOs4CPxOZZ
	mhC9thL7bh4EK+EUsJPY3PmGGcQWFgiQ6J54DGwMi4CqxLE/+xhBbF6g+qPbt7JA2IISPybf
	A7OZBbQk1u88zgRhy0tsXvOWGeJkdYlHf3UhLjCSuHzpElSJiMS+F+8YJzAKzUIyaRaSSbOQ
	TJqFpGUBI8sqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjOAQfia9g3FVg8UhRgEORiUe3oMe
	HQFCrIllxZW5hxglOJiVRHi3vwcK8aYkVlalFuXHF5XmpBYfYpTmYFES5232SAkQEkhPLEnN
	Tk0tSC2CyTJxcEo1MDbYWhsIzXrHqGfgnruT+bxwncSuUvkqprVbTr391p4eeb7thNRM1rPn
	59TukhK8lhZky773wNUGQYv+F0ITZuzJ/Xu10nl7RvRR7T0KRxj0uIMLrwmdFMmX+1pRwaNl
	VBgXerNu6bvclQmVW87E7nmdcrDxS93xmctybsebfC+elhk+g+VaghJLcUaioRZzUXEiABGR
	IVBdAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The __devexit macros is added to remove function. The macros
moves the remove function to devexit sections.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 drivers/video/backlight/ili9320.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/backlight/ili9320.c b/drivers/video/backlight/ili9320.c
index 09ec735..a0a369d 100644
--- a/drivers/video/backlight/ili9320.c
+++ b/drivers/video/backlight/ili9320.c
@@ -260,7 +260,7 @@ int __devinit ili9320_probe_spi(struct spi_device *spi,
 }
 EXPORT_SYMBOL_GPL(ili9320_probe_spi);
 
-int ili9320_remove(struct ili9320 *ili)
+int __devexit ili9320_remove(struct ili9320 *ili)
 {
 	ili9320_power(ili, FB_BLANK_POWERDOWN);
 
-- 
1.7.1


