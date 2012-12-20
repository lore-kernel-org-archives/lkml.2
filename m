Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715Ab2LTGgP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 01:36:15 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:16335 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441Ab2LTGgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 01:36:07 -0500
X-AuditID: cbfee61b-b7f616d00000319b-b1-50d2b1d609c5
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000901cdde7b$db4f6690$91ee33b0$%han@samsung.com>
In-reply-to: <000901cdde7b$db4f6690$91ee33b0$%han@samsung.com>
Subject: [PATCH 6/6] backlight: s6e63m0: reorder inclusions of <linux/xxx.h>
Date: Thu, 20 Dec 2012 15:36:06 +0900
Message-id: <000e01cdde7c$49f0ef10$ddd2cd30$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3ee9s5WLGjeuuhRceS0Ez4r5xE9AAAF6iw
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCIsWRmVeSWpSXmKPExsVy+t8zA91rGy8FGLQ9krS4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZ2x7kFizjrTi05gVLA2MTdxcjJ4eEgIlEY+91NghbTOLCvfVA
	NheHkMAyRolzO7awwxRN/P0FKjGdUaLtSiczhDObSeLQjAmsIFVsAmoSX74cBusQEYiQaJ4x
	C6iIg4NZwEdi8yxNkLCQgK3EncX/WEBsTgE7icYPu8HKhYFKtp88yQRiswioStw/cQ3M5gWq
	P7BsCwuELSjxY/I9MJtZQEti/c7jTBC2vMTmNW/BVkkIqEs8+qsLYooIGEl8Pa0CUSEise/F
	O0aI6QIS3yYfYoGolpXYdADsEQmBeewSHxYugHpXUuLgihssExglZiFZPAvJ4llIFs9CsmIB
	I8sqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjJCokt7BuKrB4hCjAAejEg/vommXAoRYE8uK
	K3MPMUpwMCuJ8C68dTFAiDclsbIqtSg/vqg0J7X4EKMP0OUTmaVEk/OBEZ9XEm9obGxiZmJq
	Ym5pam6KQ1hJnLfZIyVASCA9sSQ1OzW1ILUIZhwTB6dUA6PcOsVJqfU7uP6sPjEpZZ7L3GdX
	3x9jF/62bam0utif+4qrDiTmbAn6M+2h2E5VI+XN4s1feFdsi1o8wfvdzGyHyt+/J18Lrd37
	6d95Ic+PXzO+7skLiPcWcjmWtGBmSlhZtugp/56ULV+8NldtUVvExHWsbLMPT/GTrXxzmORV
	ja5s9PZsX5SkxFKckWioxVxUnAgA9gVigtcCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsVy+t9jQd1rGy8FGOybIWpxedccNgdGj8+b
	5AIYoxoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOA
	pioplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCesYM7Y9yC1YxltxaM0LlgbG
	Ju4uRk4OCQETiYm/v7BB2GISF+6tB7K5OIQEpjNKtF3pZIZwZjNJHJoxgRWkik1ATeLLl8Ps
	ILaIQIRE84xZQEUcHMwCPhKbZ2mChIUEbCXuLP7HAmJzCthJNH7YDVYuDFSy/eRJJhCbRUBV
	4v6Ja2A2L1D9gWVbWCBsQYkfk++B2cwCWhLrdx5ngrDlJTaveQu2SkJAXeLRX10QU0TASOLr
	aRWIChGJfS/eMU5gFJqFZNAsJINmIRk0C0nLAkaWVYyiqQXJBcVJ6blGesWJucWleel6yfm5
	mxjBMftMegfjqgaLQ4wCHIxKPLyLpl0KEGJNLCuuzD3EKMHBrCTCu/DWxQAh3pTEyqrUovz4
	otKc1OJDjD5Af05klhJNzgemk7ySeENjEzMjSyMzCyMTc3McwkrivM0eKQFCAumJJanZqakF
	qUUw45g4OKUaGG1zt/7zVQl6/fC2a5OWXfS+uU0SqSY76j0ZBC01lOW1Ls73WZ6xhOFCBUPb
	x38tGgpvkz0PPWi06bFPdhf9d/aby80nvb91j12abOQyZX/tzanPnpy80Vr61MPwhXd30qmT
	J9bvVl5RXN1/Qe5A1+1fBS/5BFV5Ha/GMG1eqeZqwZ7pvs/RSomlOCPRUIu5qDgRAFX1IEYG	AwAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch reorders inclusions of <linux/xxx.h> for redability,
according to alphabetical ordering. Also, unnecessary header
comments are removed.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/s6e63m0.c |   19 +++++--------------
 1 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/video/backlight/s6e63m0.c b/drivers/video/backlight/s6e63m0.c
index 92e53e2..0969a4048 100644
--- a/drivers/video/backlight/s6e63m0.c
+++ b/drivers/video/backlight/s6e63m0.c
@@ -9,28 +9,19 @@
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
+#include <linux/spi/spi.h>
+#include <linux/wait.h>
 
 #include "s6e63m0_gamma.h"
 
-- 
1.7.2.5


