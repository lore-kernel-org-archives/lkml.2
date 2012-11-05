Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109Ab2KEKBe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 05:01:34 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:46805 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027Ab2KEKBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 05:01:30 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-5d-50978e79c28c
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: djbw@fb.com, dwmw2@infradead.org, hskinnemoen@gmail.com,
        iws@ovro.caltech.edu, vinod.koul@intel.com, vipin.kumar@st.com,
        t.figa@samsung.com, kyungmin.park@samsung.com,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH 09/20] async_tx: fix build for async_memset
Date: Mon, 05 Nov 2012 11:00:20 +0100
Message-id: <1352109631-3385-10-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1352109631-3385-1-git-send-email-b.zolnierkie@samsung.com>
References: <1352109631-3385-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEJMWRmVeSWpSXmKPExsVy+t9jAd3KvukBBj/uyFpc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mh4czC06zVtzbvJ65gfElSxcjJ4eEgInEnYOfGCFsMYkL99az
	dTFycQgJLGKUONa+hAnCWc0kMfnbNrAqNgEriYntq8BsEQEFic29z1hBipgFnjFKzLjdzQyS
	EBawlti0axobiM0ioCqx8thsdhCbV8BDYuvcG+wQ6+Qlnt7vA6vhBIo3NkxhBbGFBNwlLnce
	Z57AyLuAkWEVo2hqQXJBcVJ6rqFecWJucWleul5yfu4mRrDPn0ntYFzZYHGIUYCDUYmHd6bY
	9AAh1sSy4srcQ4wSHMxKIrwcDEAh3pTEyqrUovz4otKc1OJDjNIcLErivM0eKQFCAumJJanZ
	qakFqUUwWSYOTqkGRqknNzvPbfJsq3N9beN8VFC/7J1T+KaYqQyrI2JmZ1s+dNuhverTnSfr
	q+23Ws/YanSTWfBT3nGTsvBtJebXzr67t+vON/3PMa5NsjZqN498bmUX/XrlP68h+7Ef+yZL
	z9mcFl5Q7b41WGmn1q5HkTPDFyuJrihlcnP8d/3nhwK/E88OB/83PK3EUpyRaKjFXFScCACJ
	mVKa9QEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing <linux/module.h> include.

Cc: Dan Williams <djbw@fb.com>
Cc: Tomasz Figa <t.figa@samsung.com>
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

