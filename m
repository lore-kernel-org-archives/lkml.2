Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487Ab2GKMIa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 08:08:30 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:59699 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757454Ab2GKMIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 08:08:22 -0400
X-AuditID: cbfee61b-b7f566d000005c8a-a1-4ffd6cb50c53
From: Sangbeom Kim <sbkim73@samsung.com>
To: sameo@linux.intel.com,
        "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>
Cc: "'Liam Girdwood'" <lrg@ti.com>, linux-kernel@vger.kernel.org,
        sbkim01@gmail.com
Subject: [PATCH V3 7/7] MAINTAINRES: Add maintainer for samsung mfd driver
Date: Wed, 11 Jul 2012 21:08:22 +0900
Message-id: <012f01cd5f5d$dde804e0$99b80ea0$@com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1fXd3YrpRspxi6SySC03nVgU7fyA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrELMWRmVeSWpSXmKPExsVy+t9jQd2tOX/9Dd4/Era4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZd89kFtxir3jYFtvAuJuti5GTQ0LAROL0zJ9MELaYxIV764Hi
	XBxCAtMZJabPPs0K4cxlkri5ezUzSBWbgIbEyt1vwbpFBHwlfk/bDNTNwcEsECyx9bQeSFhY
	wEvi95FVjCA2i4CqxPNJP1lBbF4BQ4kN116yQdiCEj8m32MBsZkFtCTW7zzOBGHLS2xe85YZ
	ZKSEgLrEo7+6EJv0JH4fXAhVIiKx78U7xgmMArOQTJqFZNIsJJNmIWlZwMiyilE0tSC5oDgp
	PddIrzgxt7g0L10vOT93EyM4JJ9J72Bc1WBxiFGAg1GJh/dA1l9/IdbEsuLK3EOMEhzMSiK8
	NT5AId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rwm3l/9hQTSE0tSs1NTC1KLYLJMHJxSDYwpXeWP
	JN9dXrREe84lrvvhB3SDe+Zqh58JfMArHR7I+n+TzpcnbcKWS8scJ1c88ZKSP7QipfXil+b7
	XvaX/23lfvI46YfpKZcjopYtHnxTHQwjo1lcOMrk3M/FHbl3YcLbik3ZS24wLJ0/V/d71A1Z
	4SMvgjSeJUS3LzA5x8uo+2UHk3zRshYlluKMREMt5qLiRADzViSPRQIAAA==
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
index 03df1d1..bfdfc21 100644
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
1.7.1


