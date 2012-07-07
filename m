Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751593Ab2GGJnr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 05:43:47 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:65470 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab2GGJno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 05:43:44 -0400
X-AuditID: cbfee61a-b7f616d000004b7e-fd-4ff804cebc0e
From: Sangbeom Kim <sbkim73@samsung.com>
To: "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org, sbkim01@gmail.com,
        "'Liam Girdwood'" <lrg@ti.com>
Subject: [PATCH V2 7/7] MAINTAINRES: Add maintainer for samsung mfd driver
Date: Sat, 07 Jul 2012 18:43:43 +0900
Message-id: <0ff401cd5c24$ff39ab80$fdad0280$@com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1cJP8ady1/78SpQk6mVgE/2LKK0g==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMLMWRmVeSWpSXmKPExsVy+t9jAd1zLD/8De5c0LG4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZdyfcZym4w16x9doXpgbGvWxdjJwcEgImEi/3rmaEsMUkLtxb
	DxTn4hASWMQoMXvOFXYIZy6TxMmFZ5hBqtgENCRW7n4L1i0i4Ctx6eV/VhCbWSBYovlSExOI
	LSzgJbG0ews7iM0ioCrxZOVLoHoODl4BQ4lJBwJBwrwCghI/Jt9jgWjVkli/8zgThC0vsXnN
	W2aQcgkBdYlHf3VBTBEBPYnTh/wgKkQk9r14xziBUWAWkkGzkAyahWTQLCQtCxhZVjGKphYk
	FxQnpeca6hUn5haX5qXrJefnbmIEB+UzqR2MKxssDjEKcDAq8fB+2PHdX4g1say4MvcQowQH
	s5II7497QCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8xt5f/YUE0hNLUrNTUwtSi2CyTBycUg2M
	4gpaX1YGlZs+V1lQ9XBKyUKXzT9WnJnRE6G7SYlB+nSJr+Nc50vLl+5Yfu1JDv//q/+iQte5
	9yxin9mT75gZ3/Z1d/gPxvyEX5ryF3YtkZdZw/l88racHU7cVcYmJ2efDrqb9ff5wUuWkoxG
	jtdYX24+q65j/UpMvVvy6J/uj9YVJqwddU90lFiKMxINtZiLihMB93u4+EYCAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are many samsung multifunction devices which are
s2mps11, s5m8767, s5m8763 etc.
This devices can support regulator, rtc, charger.
I will be supporting the Samsung mfd drivers, that are currently
in development and will be upstreamed shortly.

Signed-off-by: Sangbeom Kim <sbkim73@samsung.com>
---
 MAINTAINERS |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index eb22272..398f9d4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5866,6 +5866,16 @@ L:	linux-fbdev@vger.kernel.org
 S:	Maintained
 F:	drivers/video/s3c-fb.c
 
+SAMSUNG MULTIFUNCTION DEVICE DRIVERS
+M:	Sangbeom Kim <sbkim73@samsung.com>
+L:	linux-kernel@vger.kernel.org
+S:	Supported
+F:	drivers/mfd/sec*.c
+F:	drivers/regulator/s2m*.c
+F:	drivers/regulator/s5m*.c
+F:	drivers/rtc/rtc-sec.c
+F:	include/linux/mfd/samsung/
+
 SERIAL DRIVERS
 M:	Alan Cox <alan@linux.intel.com>
 L:	linux-serial@vger.kernel.org
-- 
1.7.5.4


