Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964793Ab2GLCYA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 22:24:00 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:9277 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932904Ab2GLCX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 22:23:58 -0400
X-AuditID: cbfee61b-b7f566d000005c8a-c0-4ffe35300770
From: Sangbeom Kim <sbkim73@samsung.com>
To: "'Axel Lin'" <axel.lin@gmail.com>,
        "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>
Cc: "'Liam Girdwood'" <lrg@ti.com>, linux-kernel@vger.kernel.org
References: <1342056950.19192.0.camel@phoenix>
In-reply-to: <1342056950.19192.0.camel@phoenix>
Subject: RE: [PATCH 1/3] regulator: s2mps11: Fixup missing commas
Date: Thu, 12 Jul 2012 11:23:43 +0900
Message-id: <016401cd5fd5$5bf443e0$13dccba0$@com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1fzrIgu/WZADMDTFm6hW8r3QwWfwABHpzQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJLMWRmVeSWpSXmKPExsVy+t9jQV0D03/+Bn+Pilpc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MJSe+sRXcZa7Yuda9gbGNuYuRk0NCwETi56zfULaYxIV769m6
	GLk4hASmM0oc+XaHBcKZyySx7vssNpAqNgENiZW734LZIgKREpdf7mIFsZkF7CTmHmhhArGF
	BPQkLi2aBTaVU0BfonsaSA0Hh7CAo8TTRiOQMIuAqsTxC4/AynkFDCUOTexjhLAFJX5MvscC
	Us4soC4xZUouxHR5ic1r3jKDhCWAwo/+6kIcYCSx9PI7qANEJPa9eMc4gVFoFpJBsxAGzUIy
	aBaSjgWMLKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxggP4mfQOxlUNFocYBTgYlXh4fxj+
	8xdiTSwrrsw9xCjBwawkwntUCSjEm5JYWZValB9fVJqTWnyIUZqDRUmc18T7q7+QQHpiSWp2
	ampBahFMlomDU6qBsV5ZQuplr44yuyH/69bapPb6cI51cr+8pbS5Xh0S2GN2+qjVZtUzxXUn
	46tu2stV1lXdMxR5VLvU4zR/7rrkre9anocULe51P567/OlOY00jZ9vG//rbE/nb00ReLOUy
	48+3Sf1wcV+uiuJ87pZNDwK+/vFdqCil+X16bct7O99zSbP7Lj9WYinOSDTUYi4qTgQAojKe
	PlwCAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
On Thursday, July 12, 2012 10:36 AM +0900, Axel Lin wrote:

> Signed-off-by: Axel Lin <axel.lin@gmail.com>

S2mps11 regulator patch is based on mfd/for-next branch.
On mfd/for-next branch, Some regulator features didn't apply 
like a set_voltage_time_sel.
So, I didn't add some feature like a set_voltage_time_sel, vsel_mask.
Before send patch, I just added that. 
Anyway, It's my mistake.

Acked-by: Sangbeom Kim <sbkim73@samsung.com>

Thanks,
Sangbeom.

