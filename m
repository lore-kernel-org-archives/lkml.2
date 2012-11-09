Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751176Ab2KIHyb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 02:54:31 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:53623 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab2KIHy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 02:54:29 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-42-509cb6b32952
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Rob Herring'" <rob.herring@calxeda.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] of/fdt: add const to char *pathp in of_scan_flat_dt()
Date: Fri, 09 Nov 2012 16:54:27 +0900
Message-id: <000201cdbe4f$71202bc0$53608340$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2+T3EGhXJ3wzFqRrWLALZ/nn+oXg==
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t8zA93N2+YEGGy9pmJxedccNgdGj8+b
	5AIYo7hsUlJzMstSi/TtErgy/qw9z1jwg7Vi87tLTA2Mj1m6GDk5JARMJJa/+sEEYYtJXLi3
	nq2LkYtDSGAZo8TVyRvYYYqWTP4KlVjEKHF0dwMLhDObSWJhy1qwKjYBNYkvXw6D2SICvhLf
	F28AG8ssUCtxcF4rmC0s4CbxdsNcVhCbRUBV4sWFA8wgNq+ArcSTvUfYIWxBiR+T77FA9GpJ
	rN95HGqOvMTmNW+B6jmALlKXePRXF8QUEdCT6P9RBVEhIrHvxTtGiOkCEt8mH2KBqJaV2ASy
	iAvIbGeX+HvoA9TDkhIHV9xgmcAoNgvJ4llIFs9CsngWkhULGFlWMYqmFiQXFCel5xrqFSfm
	Fpfmpesl5+duYoREitQOxpUNFocYBTgYlXh4Ex/MDhBiTSwrrsw9xCjBwawkwjs3c06AEG9K
	YmVValF+fFFpTmrxIUYfoMsnMkuJJucDozivJN7Q2NjEzMTUxNzS1NwUh7CSOG+zR0qAkEB6
	YklqdmpqQWoRzDgmDk6pBkbexZ6KrzKrXJwt3x83E/l7rTSyd9aXvtiWvN0ml8vcpPtPd5ge
	12h1uLfI3OWJvsnvz/Z6kTP/SPBtW/FykUrXa5f7HKJPSkrMgtf4qtxWVWq19Dh5POebm2zq
	ftGELd8ZDt+6Jldr6vRq7nzboxsfzj8is9qOyWhSK7P9xR7Hafklpvf3tCixFGckGmoxFxUn
	AgCbmI6MwQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLIsWRmVeSWpSXmKPExsVy+t9jAd3N2+YEGBx9oGBxedccNgdGj8+b
	5AIYoxoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOA
	pioplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCesYM/6sPc9Y8IO1YvO7S0wN
	jI9Zuhg5OSQETCSWTP7KBmGLSVy4tx7I5uIQEljEKHF0dwMLhDObSWJhy1p2kCo2ATWJL18O
	g9kiAr4S3xdvYAKxmQVqJQ7OawWzhQXcJN5umMsKYrMIqEq8uHCAGcTmFbCVeLL3CDuELSjx
	Y/I9FoheLYn1O49DzZGX2LzmLVA9B9BF6hKP/uqCmCICehL9P6ogKkQk9r14xziBUWAWkkGz
	kAyahWTQLCQtCxhZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIEx+EzqR2MKxssDjEKcDAq
	8fAmPpgdIMSaWFZcmXuIUYKDWUmEd27mnAAh3pTEyqrUovz4otKc1OJDjD5Af05klhJNzgem
	iLySeENjEzMjSyMzCyMTc3McwkrivM0eKQFCAumJJanZqakFqUUw45g4OKUaGOcuuxf5+VxM
	x9U3i+Zz/lTafCIzMKl/iSXPotebjBlP/tL86CTJrpFxWvPHq5q1Lyd8Es++wVu74fkp7vac
	fV9TJvPI7nY14t6q37WTnVXyW/5m3xivCSrXt8mWv2tz9b02beUKRqNJX0oMYmJuv+f1nvYt
	ovLk1e7++oQLCl+N+z1PSgVFr1RiKc5INNRiLipOBAB4uOsd8AIAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed build warning as below:

drivers/of/fdt.c: In function 'of_scan_flat_dt':
drivers/of/fdt.c:490:10: warning: assignment discards 'const' qualifier from pointer target type [enabled by default]

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
This patch is based on linux-next-20121109 code tree.

 drivers/of/fdt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index 0ca0f9e..738228f 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -459,7 +459,7 @@ int __init of_scan_flat_dt(int (*it)(unsigned long node,
 
 	do {
 		u32 tag = be32_to_cpup((__be32 *)p);
-		char *pathp;
+		const char *pathp;
 
 		p += 4;
 		if (tag == OF_DT_END_NODE) {
-- 
1.7.1


