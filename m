Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649Ab2LTGbR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 01:31:17 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:15274 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab2LTGbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 01:31:12 -0500
X-AuditID: cbfee61b-b7f616d00000319b-79-50d2b0af7b6e
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000401cdde7b$2b0194c0$8104be40$%han@samsung.com>
In-reply-to: <000401cdde7b$2b0194c0$8104be40$%han@samsung.com>
Subject: [PATCH 5/5] backlight: ams369fg06: reorder inclusions of <linux/xxx.h>
Date: Thu, 20 Dec 2012 15:31:10 +0900
Message-id: <000801cdde7b$99f38730$cdda9590$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3eeyqi7zfdOO97SfGBrHQPr76IuAAAF+jA
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEIsWRmVeSWpSXmKPExsVy+t8zfd31Gy4FGHTs5LO4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZh57vZS34xVNxY712A+Mdri5GTg4JAROJm1OXskDYYhIX7q1n
	62Lk4hASWMYosXPHaRaYop1N/YwQiemMEhsblzFDOLOZJHrmL2IDqWITUJP48uUwO4gtIhAh
	0TxjFlARBwezgI/E5lmaIGEhAVuJ9rmHmUBsTgE7ieYPR8HKhQX8JeZc+cUIYrMIqEqcvnST
	DaSVF6h+wQETkDCvgKDEj8n3wO5hFtCSWL/zOBOELS+xec1bsE0SAuoSj/7qgpgiAkYS25p9
	ISpEJPa9eAc1XEDi2+RDLBDVshKbDjBDPLiMXeLTBR8IW1Li4IobLBMYJWYh2TsLyd5ZSPbO
	QrJhASPLKkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYyQiJLewbiqweIQowAHoxIP76JplwKE
	WBPLiitzDzFKcDArifAuvHUxQIg3JbGyKrUoP76oNCe1+BCjD9DhE5mlRJPzgdGeVxJvaGxs
	YmZiamJuaWpuikNYSZy32SMlQEggPbEkNTs1tSC1CGYcEwenVANj4eRXs7eW+l08+JGzU0o7
	vHn99BnLIu89vBMY72P/yF86Xu/zszLpc+YXWq10Kvl+Xr+ZLfzUS8l+1hT+ZdOcOqTEtE3b
	WW8/rFDas6d/XtiZxzaKiS/Pc5TKd153W12o2f5S4EOOeYvHnjMsZ1iFF8Y6Xwpx6zIOn789
	91zC2VmbJnhIXd+txFKckWioxVxUnAgAO4ez19UCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEIsWRmVeSWpSXmKPExsVy+t9jQd31Gy4FGKz9yWVxedccNgdGj8+b
	5AIYoxoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOA
	pioplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCesYMw4938ta8Iun4sZ67QbG
	O1xdjJwcEgImEjub+hkhbDGJC/fWs3UxcnEICUxnlNjYuIwZwpnNJNEzfxEbSBWbgJrEly+H
	2UFsEYEIieYZs4CKODiYBXwkNs/SBAkLCdhKtM89zARicwrYSTR/OApWLizgLzHnyi+wZSwC
	qhKnL91kA2nlBapfcMAEJMwrICjxY/I9FhCbWUBLYv3O40wQtrzE5jVvwTZJCKhLPPqrC2KK
	CBhJbGv2hagQkdj34h3jBEahWUgGzUIyaBaSQbOQtCxgZFnFKJpakFxQnJSea6RXnJhbXJqX
	rpecn7uJERyxz6R3MK5qsDjEKMDBqMTDu2japQAh1sSy4srcQ4wSHMxKIrwLb10MEOJNSays
	Si3Kjy8qzUktPsToA/TmRGYp0eR8YDLJK4k3NDYxM7I0MrMwMjE3xyGsJM7b7JESICSQnliS
	mp2aWpBaBDOOiYNTqoExdu3NO4XbnpgsYOAv2FKd2qvjtcWSbWr/w22GPdO99NfvFvi/Nmnl
	tw3RwUkapR8n/BO6Vv3cNmarSBjnx8Y3axMDavkrhN7d26hs3dcV1SO1eabRvJUL2z7NPDA/
	db7eyaCrLys93HiN35ot8OwxzUnZp/F9VnPJPttNazT4ovY5nGFnag1WYinOSDTUYi4qTgQA
	g+bkFwUDAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch reorders inclusions of <linux/xxx.h> for redability,
according to alphabetical ordering. Also, unnecessary header
comments are removed.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/ams369fg06.c |   19 +++++--------------
 1 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/video/backlight/ams369fg06.c b/drivers/video/backlight/ams369fg06.c
index 4794a9a..72d71e0 100644
--- a/drivers/video/backlight/ams369fg06.c
+++ b/drivers/video/backlight/ams369fg06.c
@@ -10,25 +10,16 @@
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
-#include <linux/module.h>
-#include <linux/fb.h>
+#include <linux/backlight.h>
 #include <linux/delay.h>
+#include <linux/fb.h>
 #include <linux/gpio.h>
-#include <linux/spi/spi.h>
 #include <linux/lcd.h>
-#include <linux/backlight.h>
+#include <linux/module.h>
+#include <linux/spi/spi.h>
+#include <linux/wait.h>
 
 #define SLEEPMSEC		0x1000
 #define ENDDEF			0x2000
-- 
1.7.2.5


