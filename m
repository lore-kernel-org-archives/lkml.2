Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183Ab2KZGbJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 01:31:09 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:56333 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134Ab2KZGbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 01:31:07 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-ed-50b30caaf795
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Len Brown <len.brown@intel.com>, Zhang Rui <rui.zhang@intel.com>,
        Durgadoss R <durgadoss.r@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Amit Dinel Kachhap <amit.kachhap@linaro.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [PATCH] MAINTAINERS: Add maintainers for exynos thermal driver
Date: Mon, 26 Nov 2012 15:30:59 +0900
Message-id: <1353911459-18305-1-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.4.1
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFLMWRmVeSWpSXmKPExsVy+t8zPd1VPJsDDI6/Y7G4vGsOm8Xn3iOM
	DkwenzfJBTBGcdmkpOZklqUW6dslcGWs7OxmK/jAWnH01yXGBsZvLF2MnBwSAiYSzetusEHY
	YhIX7q0Hsrk4hASWMUqsWriCHaZow67v7BCJ6YwSza9uskI4LUwS+/6dZQapYhPQkfi/7yZY
	h4iAkcTnF1fAipgFFjBLNF46DFYkLOAusff5AjCbRUBVYt2l62C7eQU8JFobzjFDrFOQWHDv
	LRtEjYDEt8mHgG7lAIrLSmw6wAwyU0JgD5vE93PHoM6TlDi44gbLBEbBBYwMqxhFUwuSC4qT
	0nMN9YoTc4tL89L1kvNzNzFCAkxqB+PKBotDjAIcjEo8vIUnNgUIsSaWFVfmHmKU4GBWEuGd
	yAQU4k1JrKxKLcqPLyrNSS0+xOgDdMlEZinR5Hxg8OeVxBsaGxgbGloamplamhrgEFYS5232
	SAkQEkhPLEnNTk0tSC2CGcfEwSnVwFjN8OP1a8+Xm7MlEpk/bl+Q8dO4xZa/QKpl2sX3oRwv
	5J5tV9Z6sell8Orn75+mr3/lsu9W0H1P79BjK6d4SU7JsnH5rBoWPcnz3fQdlY9/P5P59Wh2
	YmZ3q0fy42ebHVM43MyyQ1+sWXZ9xvk+R5bwptLZB/ijeBmEJ4SkPXpspTCHZ92h8j1KLMUZ
	iYZazEXFiQB1uJLUXQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJLMWRmVeSWpSXmKPExsVy+t9jQd2VPJsDDD6us7G4vGsOm8Xn3iOM
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmrOzsZiv4wFpx
	9NclxgbGbyxdjJwcEgImEht2fWeHsMUkLtxbz9bFyMUhJDCdUaL51U1WCKeFSWLfv7PMIFVs
	AjoS//fdBOsQETCS+PziClgRs8ACZonGS4fBioQF3CX2Pl8AZrMIqEqsu3SdDcTmFfCQaG04
	xwyxTkFiwb23bBMYuRcwMqxiFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECA7fZ1I7GFc2WBxi
	FOBgVOLhLTyxKUCINbGsuDL3EKMEB7OSCO9EJqAQb0piZVVqUX58UWlOavEhRh+g7ROZpUST
	84GxlVcSb2hsYmZkaWRmbGJubIxDWEmct9kjJUBIID2xJDU7NbUgtQhmHBMHp1QD48Hbjuue
	zLUP8nzxSPHkfruWrCs3lrA8tL4isLct6MKm7mvrpaw6iooUfitu3CInPL8ltJpVXXW1TNWX
	ZC/l2B5trWqmSfde+PgHc5k8uciQayneU2viIcf7uen+l9PvlNrTvzpqTDyXGsH4mv1NmZ6n
	GtsTZZZICdbzn2Ss93K83vp0ou43JZbijERDLeai4kQAGxKhOowCAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Amit and I as maintainers for exynos thermal driver.

Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
---
 MAINTAINERS |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 59203e7..e839fb8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2960,6 +2960,13 @@ S:	Maintained
 F:	drivers/video/exynos/exynos_mipi*
 F:	include/video/exynos_mipi*
 
+EXYNOS THERMAL DRIVER
+M:	Jonghwa Lee <jonghwa3.lee@samsung.com>
+M:	Amit Daniel Kachhap <amit.kachhap@linaro.org>
+L:	linux-pm@vger.kernel.org
+S:	Maintained
+F:	drivers/thermal/exynos_thermal.c
+
 F71805F HARDWARE MONITORING DRIVER
 M:	Jean Delvare <khali@linux-fr.org>
 L:	lm-sensors@lm-sensors.org
-- 
1.7.4.1

