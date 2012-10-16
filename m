Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104Ab2JPHaf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 03:30:35 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:33961 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755063Ab2JPHac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 03:30:32 -0400
X-AuditID: cbfee61b-b7fd46d0000046e0-8d-507d0d1762cc
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <007101cdab6f$6c8bc030$45a34090$%han@samsung.com>
In-reply-to: <007101cdab6f$6c8bc030$45a34090$%han@samsung.com>
Subject: [PATCH 09/17] backlight: l4f00242t03: fix checkpatch warning
Date: Tue, 16 Oct 2012 16:30:30 +0900
Message-id: <007a01cdab70$1f35aa70$5da0ff50$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2rb2x3b+BtYCwlRU+aka06gjxy+QAAKGVw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsVy+t9jQV1x3toAg2mPxC0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfG3RmNjAXdnBXvrn5kamDczd7FyMkhIWAisez3ZjYIW0ziwr31
	YLaQwHRGiR/LbLoYuYDs2UwSjY1LGUESbAJqEl++HAZrFhGIkGieMYu5i5GDg1nAR2LzLE2I
	XluJ1TPegpVwCthJbHx9kAXEFhZwlbh8pocZxGYRUJWY9msL2EheoPpn5x+xQdiCEj8m3wOr
	ZxbQkli/8zgThC0vsXnNW7BVEgLqEo/+6kJcYCTR/mg1O0SJiMS+F+8YJzAKzUIyaRaSSbOQ
	TJqFpGUBI8sqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjOAgfia9g3FVg8UhRgEORiUe3gzn
	mgAh1sSy4srcQ4wSHMxKIrweE4FCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeZs9UgKEBNITS1Kz
	U1MLUotgskwcnFINjA3/bk34dqi5uNde+2KkKTfLBkeem5LP/9+618f01Xv3XjOVyHlVttn/
	udIOMMdusA8Q6vJMZiiasnjSojc1a/clTnhplRcmGqmz+V3i3MlyLXGZryY2SqqcdTDm1jrz
	Ij1zjpuX2te/O4/eFz3Ht6zup+fF4zwtmj7P9tdWzf11NVtDOFelR4mlOCPRUIu5qDgRAPaH
	Lj5eAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the checkpatch warning as below:

WARNING: please, no space before tabs

Also, unnecessary line is removed.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 drivers/video/backlight/l4f00242t03.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/video/backlight/l4f00242t03.c b/drivers/video/backlight/l4f00242t03.c
index 2d90c06..472c7dc 100644
--- a/drivers/video/backlight/l4f00242t03.c
+++ b/drivers/video/backlight/l4f00242t03.c
@@ -4,7 +4,7 @@
  * Copyright 2007-2009 Freescale Semiconductor, Inc. All Rights Reserved.
  *
  * Copyright (c) 2009 Alberto Panizzo <maramaopercheseimorto@gmail.com>
- * 	Inspired by Marek Vasut work in l4f00242t03.c
+ *	Inspired by Marek Vasut work in l4f00242t03.c
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -33,7 +33,6 @@ struct l4f00242t03_priv {
 	struct regulator *core_reg;
 };
 
-
 static void l4f00242t03_reset(unsigned int gpio)
 {
 	pr_debug("l4f00242t03_reset.\n");
-- 
1.7.1


