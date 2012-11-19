Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818Ab2KSBi5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 20:38:57 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:48392 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780Ab2KSBiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 20:38:55 -0500
X-AuditID: cbfee61b-b7f616d00000319b-0a-50a98dae2240
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>, "'Joe Perches'" <joe@perches.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] backlight: 88pm860x_bl: remove an unnecessary line continuation
Date: Mon, 19 Nov 2012 10:38:53 +0900
Message-id: <004a01cdc5f6$a247bed0$e6d73c70$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3F9qItnFesOl8jR0iHpU3utwzoHg==
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t8zY911vSsDDKZ/5bS4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZx19uYy9YyVGxb/tJ5gbGTvYuRk4OCQETiQ+n9rFC2GISF+6t
	Z+ti5OIQEljGKPGj8wwTTNGRL79ZIBLTgRJ/r0M5s5kk/p04BdbOJqAm8eXLYbCxIgIREs0z
	ZjGD2MwC+RILlr4Hs4UFAiQO/HwINpVFQFVi7+kvYL28ArYSa6bPZIawBSV+TL7HAtGrJbF5
	WxMrhC0vsXnNW6AaDqCL1CUe/dWFWKUn0XFlP1S5iMS+F+8YIcYLSHybfIgFolxWYtMBZpCT
	JQSa2SWeLj8K9b2kxMEVN1gmMIrNQrJ5FpLNs5BsnoVkxQJGllWMoqkFyQXFSem5RnrFibnF
	pXnpesn5uZsYIbEivYNxVYPFIUYBDkYlHt6dBisChFgTy4orcw8xSnAwK4nwalquDBDiTUms
	rEotyo8vKs1JLT7E6AN0+URmKdHkfGAc55XEGxobm5iZmJqYW5qam+IQVhLnbfZICRASSE8s
	Sc1OTS1ILYIZx8TBKdXAmJ6Z3vKs7V6xS0mIjmdu3ZJ5VY8vWAS79teY/DNYucNs5d3kH0Wf
	dksqLuB5wZ2UVXZsW9ikKZti50ab1Jh5qovyR3f6fWl1vT4z47J1vRVvuMj5ayXqfbPO3qi6
	d7nsCyNj0SNbPgMBgaVKs7MLJ/3UEj8f/vvO/jQN58y+z+dsWZ+Za01SYinOSDTUYi4qTgQA
	5XEPcMICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHIsWRmVeSWpSXmKPExsVy+t9jQd11vSsDDDYtZrG4vGsOmwOjx+dN
	cgGMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlA
	U5UUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGcdfbmMvWMlRsW/7SeYG
	xk72LkZODgkBE4kjX36zQNhiEhfurWfrYuTiEBKYzijx4+91FghnNpPEvxOnWEGq2ATUJL58
	OQzWLSIQIdE8YxYziM0skC+xYOl7MFtYIEDiwM+HTCA2i4CqxN7TX8B6eQVsJdZMn8kMYQtK
	/Jh8jwWiV0ti87YmVghbXmLzmrdANRxAF6lLPPqrC7FKT6Ljyn6ochGJfS/eMU5gFJiFZNIs
	JJNmIZk0C0nLAkaWVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjBkfhMegfjqgaLQ4wCHIxK
	PLw7DVYECLEmlhVX5h5ilOBgVhLh1bRcGSDEm5JYWZValB9fVJqTWnyI0Qfo0YnMUqLJ+cAk
	kVcSb2hsYmZkaWRmYWRibo5DWEmct9kjJUBIID2xJDU7NbUgtQhmHBMHp1QDo9TGjNNMz2en
	GO91zJv08py5pGm+Rv7VRYE5wvV517s1Ns1W460V/jBr/7KdTMtSf29ri/DNuv0iQLRZ6n3z
	tE1Tr/FXGi4uW3H6O9cboZqvsrLtb8xOW79fYprXWLm0Xke4a69V+sXu7Ny8rMM3amZGTFsn
	uNY5eV1i2BKv+q91r/7seym/WYmlOCPRUIu5qDgRACqZfQbxAgAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes remove an unnecessary line continuation in
pm860x_backlight_probe(). Also, a checkpatch warning is fixed
as below:

WARNING: Avoid unnecessary line continuations

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Joe Perches <joe@perches.com>
---
 drivers/video/backlight/88pm860x_bl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/backlight/88pm860x_bl.c b/drivers/video/backlight/88pm860x_bl.c
index bb21412..6e1bbf8 100644
--- a/drivers/video/backlight/88pm860x_bl.c
+++ b/drivers/video/backlight/88pm860x_bl.c
@@ -228,7 +228,7 @@ static int pm860x_backlight_probe(struct platform_device *pdev)
 	sprintf(name, "backlight-%d", pdev->id);
 	data->port = pdev->id;
 	data->chip = chip;
-	data->i2c = (chip->id == CHIP_PM8606) ? chip->client	\
+	data->i2c = (chip->id == CHIP_PM8606) ? chip->client
 			: chip->companion;
 	data->current_brightness = MAX_BRIGHTNESS;
 	if (pm860x_backlight_dt_init(pdev, data, name)) {
-- 
1.7.2.5


