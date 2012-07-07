Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751131Ab2GGJjP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 05:39:15 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:34280 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905Ab2GGJjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 05:39:13 -0400
X-AuditID: cbfee61b-b7f566d000005c8a-78-4ff803bf68db
From: Sangbeom Kim <sbkim73@samsung.com>
To: "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org, "'Liam Girdwood'" <lrg@ti.com>,
        sbkim01@gmail.com
Subject: [PATCH V2 0/7] Initial release of Samsung S2MPS11 pmic driver
Date: Sat, 07 Jul 2012 18:39:12 +0900
Message-id: <0fed01cd5c24$5dd3ebc0$197bc340$@com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1NRXPY3hj2z6DKTvmyl1TVKKzlsgO1dOgw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMLMWRmVeSWpSXmKPExsVy+t9jAd39zD/8Da70WVlc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MU3umsRbMYquYfYCrgbGNtYuRk0NCwERi28FeFghbTOLCvfVs
	XYxcHEICixglJv05yw7hzGWS+P5gCRNIFZuAhsTK3W/ZQGwRAV+JSy//g01iFgiWOPx4LiOI
	LSzgJnFm6ROwGhYBVYlD7z4DbeDg4BUwlPh71x4kzCsgKPFj8j0WiFYtifU7jzNB2PISm9e8
	ZQYplxBQl3j0Vxdik5HEic4eqBIRiX0v3jFOYBSYhWTSLCSTZiGZNAtJywJGllWMoqkFyQXF
	Sem5RnrFibnFpXnpesn5uZsYwUH5THoH46oGi0OMAhyMSjy8E3599xdiTSwrrsw9xCjBwawk
	wvvjHlCINyWxsiq1KD++qDQntfgQozQHi5I4r4n3V38hgfTEktTs1NSC1CKYLBMHp1QDY8nc
	45s/r87h+O33//mx3h2cO1vOX8tdun6ZUf6/5A15BWp3+Y0TRGc8WdiRU+K63/+d5TGtQ9vd
	E7cvflP0xFnH2k+2n2Xnh9gJgnnfC8Or7+Xfrz9vz+Rz+ady8fpT+2fJKK2OFbqZ0sUbK1Z9
	4cGpdHGe6nWbYnr3Lzquuyrn5Qan7GnPDZVYijMSDbWYi4oTAVpubUdGAgAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The S2MPS11 is comprised of high efficient Buck converters,
various LDOs, and an RTC and tightly coupled with Multi Core Samsung 
Application Processors, which is used in a wide variety of mobile applications
such as smart phones and tablet PCs.
S2MPS11 provide 10 high efficiency buck converters and 38 LDO regulators.
Especially, Buck2 can support 7.0A current capacity for high performance
samsung application processor.
Most of S2MPS11 feature are similar to S5M series.
and Instead of using s5m prefix, Samsung decide to use s2m prefix.
So, I try to make common mfd driver for S2M and S5M series.
Most of s5m prefix is changed into sec prefix.

Changes since V1:
1. Replace list_voltage with standard framework
2. Apply regmap_irq
3. Minor changes.

Thanks,
Sangbeom.

