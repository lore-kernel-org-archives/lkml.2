Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab2KZEqD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 23:46:03 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:41207 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330Ab2KZEqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 23:46:01 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-13-50b2f4070017
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
Subject: [RESEND PATCH] MAINTAINERS: Add maintainers for exynos thermal driver
Date: Mon, 26 Nov 2012 13:45:51 +0900
Message-id: <1353905151-20735-1-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.4.1
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJLMWRmVeSWpSXmKPExsVy+t8zPV32L5sCDC5ck7W4vGsOm8Xn3iOM
	DkwenzfJBTBGcdmkpOZklqUW6dslcGWs7OxmK/jAWnH01yXGBsZvLF2MnBwSAiYSW2c9ZYWw
	xSQu3FvP1sXIxSEksIxRYuKbR2wwRZ+ezAIrEhKYzihx4UkMRFELk8TMFbfBJrEJ6Ej833eT
	HcQWEZCRmHplPytIEbNAG7PEkhVXwBLCAn4Sq89eYwaxWQRUJc7uPAjWzCvgIbHqwx6oMxQk
	Ftx7ywZRIyDxbfIhoBoOoLisxKYDzCAzJQT2sEl0tV2DqpeUOLjiBssERsEFjAyrGEVTC5IL
	ipPScw31ihNzi0vz0vWS83M3MULCS2oH48oGi0OMAhyMSjy8hSc2BQixJpYVV+YeYpTgYFYS
	4Z3IBBTiTUmsrEotyo8vKs1JLT7E6AN0yURmKdHkfGDo55XEGxobGBsaWhqamVqaGuAQVhLn
	bfZICRASSE8sSc1OTS1ILYIZx8TBKdXAKHij9baL76HetVcLvW9Wv5d3iStWiuhU1pp0LTll
	bkHp7rbiNIZH78XDXz6XeM2xf2W35pfbmxOm92yK2v8oq6XXMrwm70k6U1lD8+SLq92KNYVW
	NeoWKrGkaf+ucHV3f3PAJfLqt5/CNxpkZ93+/cJz/9WVveWfW+6lLWx7+OZiu5H7guTzSizF
	GYmGWsxFxYkAsITpcFwCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBLMWRmVeSWpSXmKPExsVy+t9jQV32L5sCDKZcELK4vGsOm8Xn3iOM
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmrOzsZiv4wFpx
	9NclxgbGbyxdjJwcEgImEp+ezGKFsMUkLtxbzwZiCwlMZ5S48CSmi5ELyG5hkpi54jZYA5uA
	jsT/fTfZQWwRARmJqVf2s4IUMQu0MUssWXEFLCEs4Cex+uw1ZhCbRUBV4uzOg2DNvAIeEqs+
	7IHapiCx4N5btgmM3AsYGVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBAfvM6kdjCsbLA4x
	CnAwKvHwFp7YFCDEmlhWXJl7iFGCg1lJhHciE1CINyWxsiq1KD++qDQntfgQow/Q9onMUqLJ
	+cDIyiuJNzQ2MTOyNDIzNjE3NsYhrCTO2+yREiAkkJ5YkpqdmlqQWgQzjomDU6qBcY/9vCe3
	T/66FHTusIbiz0URGyfyK8zb93d2e6TYdDlGVhmL6y/WX3VMk3L4ekH9i9lDvYxbRqHmx7au
	TFuh51eeFBdZcfGZpeFf49NK1vXpEx5e+bRY4p2/eKTZIyfNZVUJEafzWCW+82/oWnQi1r7q
	zZlfUtNC9TqdHpadiO7i0/rlJbDkpxJLcUaioRZzUXEiAF+JiF2LAgAA
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

