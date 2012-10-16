Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab2JPHZd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 03:25:33 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:24198 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244Ab2JPHZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 03:25:32 -0400
X-AuditID: cbfee61a-b7f976d000001eb9-e2-507d0bebc7c9
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 01/17] backlight: 88pm860x_bl: fix checkpatch warning
Date: Tue, 16 Oct 2012 16:25:31 +0900
Message-id: <007101cdab6f$6c8bc030$45a34090$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2rb2x3b+BtYCwlRU+aka06gjxy+Q==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCLMWRmVeSWpSXmKPExsVy+t9jQd3X3LUBBnNWqFtc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MZ1c2sxf8ZKvYMO8nWwPjC9YuRk4OCQETicNPjjBB2GISF+6t
	Z+ti5OIQEpjOKLGwbykLhDObSeLGnj2MIFVsAmoSX74cZgexRQQiJJpnzGLuYuTgYBbwkdg8
	SxMkLCzgKnHxxUawoSwCqhLb/v0FK+cVsJVY+fsQE4QtKPFj8j0WEJtZQEti/c7jTBC2vMTm
	NW/BRkoIqEs8+qsLsUlPouXFJXaIEhGJfS/eMU5gFJiFZNIsJJNmIZk0C0nLAkaWVYyiqQXJ
	BcVJ6bmGesWJucWleel6yfm5mxjBYflMagfjygaLQ4wCHIxKPLwZzjUBQqyJZcWVuYcYJTiY
	lUR4PSYChXhTEiurUovy44tKc1KLDzFKc7AoifM2e6QECAmkJ5akZqemFqQWwWSZODilGhh7
	XH5sWF66zKT4KmdeRKHVyeg0m4RnTKJb76gbT+IWSvw9/d7hc3rlJSFnpjy2E/xz+mDYBf1/
	gjJynsEJyedjy2erhgjaah4WLJ3D5pVUkC5k67JKpeuL+o4pHFOqH5mKZ/y+/2P+e9uSKumX
	/ad109/PUuQ3kZXtT/o9o0/hZOep9gWeD5RYijMSDbWYi4oTAZGz0/ZHAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the checkpatch warning as below:

WARNING: quoted string split across lines

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 drivers/video/backlight/88pm860x_bl.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/backlight/88pm860x_bl.c b/drivers/video/backlight/88pm860x_bl.c
index b7ec34c..6e509d9 100644
--- a/drivers/video/backlight/88pm860x_bl.c
+++ b/drivers/video/backlight/88pm860x_bl.c
@@ -117,8 +117,8 @@ static int pm860x_backlight_set(struct backlight_device *bl, int brightness)
 	data->current_brightness = value;
 	return 0;
 out:
-	dev_dbg(chip->dev, "set brightness %d failure with return "
-		"value:%d\n", value, ret);
+	dev_dbg(chip->dev, "set brightness %d failure with return value: %d\n",
+		value, ret);
 	return ret;
 }
 
-- 
1.7.1


