Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832Ab2LTGjG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 01:39:06 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:22042 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808Ab2LTGjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 01:39:02 -0500
X-AuditID: cbfee61b-b7f616d00000319b-4f-50d2b284fea9
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000f01cdde7c$5d4e83b0$17eb8b10$%han@samsung.com>
In-reply-to: <000f01cdde7c$5d4e83b0$17eb8b10$%han@samsung.com>
Subject: [PATCH 5/5] backlight: ld9040: reorder inclusions of <linux/xxx.h>
Date: Thu, 20 Dec 2012 15:39:00 +0900
Message-id: <001301cdde7c$b1f7a400$15e6ec00$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3efF04bK/W++SuRFi0yIAkd2rsTAAAEh7g
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCIsWRmVeSWpSXmKPExsVy+t8zQ92WTZcCDKYttrS4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZT18+ZS04xltx6/lDtgbGedxdjJwcEgImEmvO32eHsMUkLtxb
	z9bFyMUhJLCMUWJh+2tWmKL1J8+yQCSmM0rcfv2UGcKZzSTx9v9hsHY2ATWJL18gbBGBCInm
	GbOAijg4mAV8JDbP0gQJCwnYSizYMAGshFPATmL27WmsICXCAt4St7YzgpgsAqoSe48agVTw
	AlUvmXGTBcIWlPgx+R6YzSygJbF+53EmCFteYvOat2CLJATUJR791YXYbyTx+PNcZogSEYl9
	L94xgtgsAgIS3yYfYoEol5XYdADsDwmBRewSb79NYoP4VlLi4IobLBMYJWYh2TwLyeZZSDbP
	QrJiASPLKkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYyQqJLewbiqweIQowAHoxIP76JplwKE
	WBPLiitzDzFKcDArifAuvHUxQIg3JbGyKrUoP76oNCe1+BCjD9DlE5mlRJPzgRGfVxJvaGxs
	YmZiamJuaWpuikNYSZy32SMlQEggPbEkNTs1tSC1CGYcEwenVAPjas9p2gGHNdWEsjYxtInc
	K94X+GiG/dwX9yT+b/ruv7v3vUXgum3HO4Lz9+7KU5h5fd+9B5lqLLr3X6wxYds2SUM6gM/i
	hUgr51vOTI5F/dv+m+qfymtfJdYR/HhR34wHutb+JlwmL2Q5gx5ZLqmx9dsaFpu5OnaZyXPb
	bTYcBzQudczbK3BHiaU4I9FQi7moOBEAUACb0NcCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsVy+t9jQd2WTZcCDPb0m1pc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjKcvn7IWHOOtuPX8IVsD
	4zzuLkZODgkBE4n1J8+yQNhiEhfurWfrYuTiEBKYzihx+/VTZghnNpPE2/+H2UGq2ATUJL58
	gbBFBCIkmmfMAiri4GAW8JHYPEsTJCwkYCuxYMMEsBJOATuJ2bensYKUCAt4S9zazghisgio
	Suw9agRSwQtUvWTGTRYIW1Dix+R7YDazgJbE+p3HmSBseYnNa96CLZIQUJd49FcXYr+RxOPP
	c5khSkQk9r14xziBUWgWkkmzkEyahWTSLCQtCxhZVjGKphYkFxQnpeca6RUn5haX5qXrJefn
	bmIEx+wz6R2MqxosDjEKcDAq8fAumnYpQIg1say4MvcQowQHs5II78JbFwOEeFMSK6tSi/Lj
	i0pzUosPMfoA/TmRWUo0OR+YTvJK4g2NTcyMLI3MLIxMzM1xCCuJ8zZ7pAQICaQnlqRmp6YW
	pBbBjGPi4JRqYBTZqiNbGZP781tTeV9167c7Sop6bc9frZ358MobmaVblZYl+Hz5srkxN6si
	cabo/MZ17K332Pd63FWf1XwvzeDf7pm31oirNJ6XMDp8XHFpYP/15RM36+2UPpCpcuXEd+u/
	U3T++x8o/yW4lt1o85udcumGU6c+E93SdfIhM8v0xKe7mopKNYWVWIozEg21mIuKEwEzx3VZ
	BgMAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch reorders inclusions of <linux/xxx.h> for redability,
according to alphabetical ordering. Also, unnecessary header
comments are removed.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/ld9040.c |   19 +++++--------------
 1 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/video/backlight/ld9040.c b/drivers/video/backlight/ld9040.c
index bdc1a7e..12b5c01 100644
--- a/drivers/video/backlight/ld9040.c
+++ b/drivers/video/backlight/ld9040.c
@@ -9,29 +9,20 @@
  * under the terms of the GNU General Public License as published by the
  * Free Software Foundation; either version 2 of the License, or (at your
  * option) any later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License along
- * with this program; if not, write to the Free Software Foundation, Inc.,
- * 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
  */
 
-#include <linux/wait.h>
-#include <linux/fb.h>
+#include <linux/backlight.h>
 #include <linux/delay.h>
+#include <linux/fb.h>
 #include <linux/gpio.h>
-#include <linux/spi/spi.h>
-#include <linux/irq.h>
 #include <linux/interrupt.h>
+#include <linux/irq.h>
 #include <linux/kernel.h>
 #include <linux/lcd.h>
-#include <linux/backlight.h>
 #include <linux/module.h>
 #include <linux/regulator/consumer.h>
+#include <linux/spi/spi.h>
+#include <linux/wait.h>
 
 #include "ld9040_gamma.h"
 
-- 
1.7.2.5


