Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111Ab2JPHb4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 03:31:56 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:25697 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754966Ab2JPHbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 03:31:55 -0400
X-AuditID: cbfee61b-b7fd46d0000046e0-23-507d0d6a3d4e
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <007101cdab6f$6c8bc030$45a34090$%han@samsung.com>
In-reply-to: <007101cdab6f$6c8bc030$45a34090$%han@samsung.com>
Subject: [PATCH 12/17] backlight: omap1: fix checkpatch warning
Date: Tue, 16 Oct 2012 16:31:53 +0900
Message-id: <007d01cdab70$508ac150$f1a043f0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2rb2x3b+BtYCwlRU+aka06gjxy+QAANZrg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsVy+t9jQd0s3toAg/PvOC0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAldG+/WFzAW72Ct2v9jK1sC4lK2LkZNDQsBEYlbnYVYIW0ziwr31
	QHEuDiGB6YwSL2ZsYYVwZjNJTFjyC6yDTUBN4suXw+wgtohAhETzjFnMXYwcHMwCPhKbZ2mC
	hIUEbCVWz3gLVsIpYCex8fVBFhBbWMBe4s2HL2BjWARUJX433gar4QWqn925mg3CFpT4Mfke
	WD2zgJbE+p3HmSBseYnNa96CrZIQUJd49FcX4gIjiabZz1ghSkQk9r14xziBUWgWkkmzkEya
	hWTSLCQtCxhZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEh/Ez6R2MqxosDjEKcDAq8fBm
	ONcECLEmlhVX5h5ilOBgVhLh9ZgIFOJNSaysSi3Kjy8qzUktPsQozcGiJM7b7JESICSQnliS
	mp2aWpBaBJNl4uCUamBcbr1c1tXLvHDf3vj4/8+E1k3UvP7586O1/LJP+bUF91U4M/E/Y3rK
	sUlTfE+GZ33U2v+ayyYY9rNVRxR4HTWefKvilvfs/mZT/lm8J2vTts+LZ932QFtZIGPm3glc
	Wu5zI893OJhFND8oS4htf3Kh4ltYxeSKczKxbUI/unxKHm996+62MEaJpTgj0VCLuag4EQCM
	ko7JXwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the checkpatch warning as below:

ERROR: inline keyword should sit between storage class and type

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 drivers/video/backlight/omap1_bl.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/backlight/omap1_bl.c b/drivers/video/backlight/omap1_bl.c
index 9a046a4..af31c26 100644
--- a/drivers/video/backlight/omap1_bl.c
+++ b/drivers/video/backlight/omap1_bl.c
@@ -42,12 +42,12 @@ struct omap_backlight {
 	struct omap_backlight_config *pdata;
 };
 
-static void inline omapbl_send_intensity(int intensity)
+static inline void omapbl_send_intensity(int intensity)
 {
 	omap_writeb(intensity, OMAP_PWL_ENABLE);
 }
 
-static void inline omapbl_send_enable(int enable)
+static inline void omapbl_send_enable(int enable)
 {
 	omap_writeb(enable, OMAP_PWL_CLK_ENABLE);
 }
-- 
1.7.1


