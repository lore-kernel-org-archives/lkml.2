Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007Ab2KZERm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 23:17:42 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:14513 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753891Ab2KZERk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 23:17:40 -0500
X-AuditID: cbfee61b-b7f616d00000319b-5b-50b2ed63878e
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
        Zhang Rui <rui.zhang@intel.com>, Durgadoss R <durgadoss.r@intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Amit Dinel Kachhap <amit.kachhap@linaro.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [PATCH] MAINTAINERS: Add maintainers for exynos thermal driver
Date: Mon, 26 Nov 2012 13:17:32 +0900
Message-id: <1353903452-20536-1-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.4.1
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJLMWRmVeSWpSXmKPExsVy+t8zXd3kt5sCDH6v47S4vGsOm8Xn3iOM
	DkwenzfJBTBGcdmkpOZklqUW6dslcGVc2drHXvCBtWL//eWsDYzfWLoYOTgkBEwkjkyR6mLk
	BDLFJC7cW8/WxcjFISSwjFFiyZ3HTBAJE4lZH5qZIRKLGCW+L74K5bQwSTz/+o0RpIpNQEfi
	/76b7CC2iICMxNQr+1lBipgF2pgllqy4ApYQFnCX2Pt8ATOIzSKgKtHY8YQVxOYV8JD41T+B
	DWKdgsSCe2/ZIGoEJL5NPgR1qqzEpgNgiyUEDrBJNO2eyQpRLylxcMUNlgmMggsYGVYxiqYW
	JBcUJ6XnGukVJ+YWl+al6yXn525ihISX9A7GVQ0WhxgFOBiVeHglj20KEGJNLCuuzD3EKMHB
	rCTCO5EJKMSbklhZlVqUH19UmpNafIjRB+iSicxSosn5wNDPK4k3NDYwNjS0NDQztTQ1wCGs
	JM7b7JESICSQnliSmp2aWpBaBDOOiYNTqoEx8P8lw6rJXBVON+dOMbaun7dDi+FBF/9cJ4ls
	9aludQGvX2skdLt6/DrQ46UV/Jm7oKnn6J0M56MTqivszNX8l4afi65K3sPc8rd04ZGiRxcm
	HXGXeOeXfeVr30XGmXbBvCcUfI/M1xPQXt/Lyp3FECf+KfDI85BIqYWJxbNerw+9WG5cOV+J
	pTgj0VCLuag4EQDndjJIXAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJLMWRmVeSWpSXmKPExsVy+t9jAd3kt5sCDBavZrS4vGsOm8Xn3iOM
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmXNnax17wgbVi
	//3lrA2M31i6GDk5JARMJGZ9aGaGsMUkLtxbz9bFyMUhJLCIUeL74qvMEE4Lk8Tzr98YQarY
	BHQk/u+7yQ5iiwjISEy9sp8VpIhZoI1ZYsmKK2AJYQF3ib3PF4CNZRFQlWjseMIKYvMKeEj8
	6p/ABrFOQWLBvbdsExi5FzAyrGIUTS1ILihOSs810itOzC0uzUvXS87P3cQIDt9n0jsYVzVY
	HGIU4GBU4uGVPLYpQIg1say4MvcQowQHs5II70QmoBBvSmJlVWpRfnxRaU5q8SFGH6DtE5ml
	RJPzgbGVVxJvaGxiZmRpZGZsYm5sjENYSZy32SMlQEggPbEkNTs1tSC1CGYcEwenVAPjxBsz
	rF1fTzwYyJR21o7zffuNlgMKkWz7syKVEowt9ryfffJN89HQy0kbS3tSf9uf+M8ws/Onr/Ya
	k38iFT8Kzh+SOXFeuF37xKmS9rcpy0Ts5QzKd6k+Ltv0L/Bx3i19VVP+zl5d+R9Wy5m3nUu/
	Hf07bvWR+X9vmU4Ke3VEv8tZ9l5ZecUhJZbijERDLeai4kQAUQLSk4wCAAA=
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
index 59203e7..cceedca 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2960,6 +2960,13 @@ S:	Maintained
 F:	drivers/video/exynos/exynos_mipi*
 F:	include/video/exynos_mipi*
 
+EXYNOS THREMAL DRIVER
+M:	Amit Daniel Kachhap <amit.kachhap@linaro.org>
+M:	Jonghwa Lee <jonghwa3.lee@samsung.com>
+L:	linux-pm@vger.kernel.org
+S:	Maintained
+F:	drivers/thermal/exynos_thermal.c
+
 F71805F HARDWARE MONITORING DRIVER
 M:	Jean Delvare <khali@linux-fr.org>
 L:	lm-sensors@lm-sensors.org
-- 
1.7.4.1

