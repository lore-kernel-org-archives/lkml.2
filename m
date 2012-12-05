Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917Ab2LELLv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 06:11:51 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:9563 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753622Ab2LELLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 06:11:43 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-a6-50bf2beede02
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: vinod.koul@intel.com
Cc: linux-kernel@vger.kernel.org, djbw@fb.com, dwmw2@infradead.org,
        hskinnemoen@gmail.com, iws@ovro.caltech.edu, vipin.kumar@st.com,
        t.figa@samsung.com, kyungmin.park@samsung.com,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH resend 6/7] async_tx: fix build for async_memset
Date: Wed, 05 Dec 2012 12:10:44 +0100
Message-id: <1354705845-29439-7-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1354705845-29439-1-git-send-email-b.zolnierkie@samsung.com>
References: <1354705845-29439-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEJMWRmVeSWpSXmKPExsVy+t9jAd132vsDDKbuFrS4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZ+9uXMhXcYq3Y8OcfSwPjD5YuRk4OCQETiVuTr7BD2GISF+6t
	Z+ti5OIQEljEKLFq2QooZzWTxIOFi9lAqtgErCQmtq9iBLFFBCQktj/rYwcpYhZ4xyjRtO4v
	E0hCWMBB4sGDd2BFLAKqEq+XzGMGsXkFPCRW3nzKCLFOXuLp/T6woZwCnhIPps4EOokDaJuH
	xKwDIRMYeRcwMqxiFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECPb5M6kdjCsbLA4xCnAwKvHw
	ZuntCxBiTSwrrsw9xCjBwawkwjtPZn+AEG9KYmVValF+fFFpTmrxIUZpDhYlcd5mj5QAIYH0
	xJLU7NTUgtQimCwTB6dUA2Py6r9/u1+Kx6+zONbaXnyOr+3VFm6xx5u/S5Yl3Q6wV2aafPBb
	Rdr7peu7DNgnqp+8EpJwjFVMTsX7np3MvKNT3sw1Tc6t8yl4fU7OvNc/N2VZyaT3u2f0fz52
	6VNmFe/8cD31nLh3Fg83tM5RErpedCy2k/2b/xuOry/lV8wqdi2+evmHQo0SS3FGoqEWc1Fx
	IgD99sBP9QEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing <linux/module.h> include.

Acked-by: Dan Williams <djbw@fb.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 crypto/async_tx/async_memset.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/async_tx/async_memset.c b/crypto/async_tx/async_memset.c
index 58e4a87..05a4d1e 100644
--- a/crypto/async_tx/async_memset.c
+++ b/crypto/async_tx/async_memset.c
@@ -25,6 +25,7 @@
  */
 #include <linux/kernel.h>
 #include <linux/interrupt.h>
+#include <linux/module.h>
 #include <linux/mm.h>
 #include <linux/dma-mapping.h>
 #include <linux/async_tx.h>
-- 
1.8.0

