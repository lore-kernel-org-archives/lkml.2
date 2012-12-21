Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751371Ab2LUF0P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 00:26:15 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:41387 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab2LUF0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 00:26:01 -0500
X-AuditID: cbfee61b-b7f616d00000319b-af-50d3f2e749b9
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <001001cddf3b$7bb2c3b0$73184b10$%han@samsung.com>
In-reply-to: <001001cddf3b$7bb2c3b0$73184b10$%han@samsung.com>
Subject: [PATCH 3/6] backlight: ams369fg06: use bl_get_data instead of
 dev_get_drvdata
Date: Fri, 21 Dec 2012 14:25:58 +0900
Message-id: <001201cddf3b$a88c1670$f9a44350$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3fO3udRdsnHWRmS2i/6pBmiWTW1AAACFEw
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCIsWRmVeSWpSXmKPExsVy+t8zI93nny4HGDz8zWZxedccNgdGj8+b
	5AIYo7hsUlJzMstSi/TtErgyTpy7yVjQxF7xacF6lgbGr6xdjJwcEgImEqt6utggbDGJC/fW
	g9lCAssYJe7fKOxi5ACrefmao4uRCyg8nVFi8e0FjBDObCaJ0+cfM4I0sAmoSXz5cpgdxBYR
	iJBonjGLGaSZWcBHYvMsTYiZthIXJn1hBrE5BewkOnc/AmsVBiqfPecQWJxFQFWi6dsyFhCb
	F6j+xKIdbBC2oMSPyffA4swCWhLrdx5ngrDlJTavecsMcae6xKO/uhAXGElM3XYXqlxEYt+L
	d4wQ4wUkvk0+xAJRLiux6QAzyCcSAvPYJfa9nQkNEkmJgytusExglJiFZPMsJJtnIdk8C8mK
	BYwsqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzFCokp6B+OqBotDjAIcjEo8vJEWlwOEWBPL
	iitzDzFKcDArifD6fwAK8aYkVlalFuXHF5XmpBYfYvQBunwis5Rocj4w4vNK4g2NjU3MTExN
	zC1NzU1xCCuJ8zZ7pAQICaQnlqRmp6YWpBbBjGPi4JRqYHRQ8TULLufqf3jvUuCpb5IfT6qd
	unMx9OOE1o43BennldIdtEWNda9ILE5M2zhtQsSu7ccs/ao6JW5aOIpoM06ff+pz5/zwC1d7
	+gVbOr2bRCpP/Ek4vWlqctiRJZ8Zqu9FeZo32r+qurNrr/fqAI2AwhKvFSxz9u6cGdL/uZ1B
	9tLMvi/TNZVYijMSDbWYi4oTARcKDcbXAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsVy+t9jQd3nny4HGOy6ymxxedccNgdGj8+b
	5AIYoxoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOA
	pioplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCesYM06cu8lY0MRe8WnBepYG
	xq+sXYwcHBICJhIvX3N0MXICmWISF+6tZ+ti5OIQEpjOKLH49gJGCGc2k8Tp848ZQarYBNQk
	vnw5zA5iiwhESDTPmMUMMohZwEdi8yxNkLCQgK3EhUlfmEFsTgE7ic7dj8BahYHKZ885BBZn
	EVCVaPq2jAXE5gWqP7FoBxuELSjxY/I9sDizgJbE+p3HmSBseYnNa94yQ9ysLvHory7EBUYS
	U7fdhSoXkdj34h3jBEahWUgmzUIyaRaSSbOQtCxgZFnFKJpakFxQnJSea6RXnJhbXJqXrpec
	n7uJERy1z6R3MK5qsDjEKMDBqMTDG2lxOUCINbGsuDL3EKMEB7OSCK//B6AQb0piZVVqUX58
	UWlOavEhRh+gRycyS4km5wMTSl5JvKGxiZmRpZGZhZGJuTkOYSVx3maPlAAhgfTEktTs1NSC
	1CKYcUwcnFINjMIaV0S4Ij8E+G7WPx7+p2vpsh6rUg675BmlTq5uHcX8B5jW79GdsP6D3jFn
	mwk9HI0ab87dF+nfO2OTTKBm9/engovern6Yti9yr7j13BXPPbwPlKhVCM9w4kg1PKt6jp1J
	i1lZjfVEanWB49XsI3dY59d+erGt4NjetJ0Xt282dIu8yDGLQ4mlOCPRUIu5qDgRAI/3mnoH	AwAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper function for getting the driver data using
backlight_device instead of using dev_get_drvdata with &bd->dev,
so we can directly pass a struct backlight_device.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/ams369fg06.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/backlight/ams369fg06.c b/drivers/video/backlight/ams369fg06.c
index bd8a320..d29e494 100644
--- a/drivers/video/backlight/ams369fg06.c
+++ b/drivers/video/backlight/ams369fg06.c
@@ -421,7 +421,7 @@ static int ams369fg06_set_brightness(struct backlight_device *bd)
 {
 	int ret = 0;
 	int brightness = bd->props.brightness;
-	struct ams369fg06 *lcd = dev_get_drvdata(&bd->dev);
+	struct ams369fg06 *lcd = bl_get_data(bd);
 
 	if (brightness < MIN_BRIGHTNESS ||
 		brightness > bd->props.max_brightness) {
-- 
1.7.2.5


