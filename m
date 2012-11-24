Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876Ab2KXCNh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 21:13:37 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:59610 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756816Ab2KXCNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 21:13:35 -0500
X-AuditID: cbfee61b-b7f616d00000319b-cf-50b02d4de01d
From: Sangbeom Kim <sbkim73@samsung.com>
To: "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>, lrg@ti.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] regulator: s2mps11: Fix ramp delay value shift operation
Date: Sat, 24 Nov 2012 11:13:28 +0900
Message-id: <000001cdc9e9$4e417cd0$eac47670$@com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3J6EY5fSr2LcPeQ2GVDsPSb5Av/Q==
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t8zI11f3Q0BBl+O21hc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MDd1b2Qqmcle0bZrB3MC4j7OLkZNDQsBE4v3WB0wQtpjEhXvr
	2boYuTiEBJYxSszbe5YVpmj15V1MEInpjBJHzn6EqprLJNG89jU7SBWbgIbEyt1v2UBsEQEn
	ib+Ne1lAbGYBBYlf9zaBTRIW8JRo6L7OCGKzCKhK7Fj6BGw1r4ChxPQ9+9kgbEGJH5PvQfVq
	SazfeZwJwpaX2LzmLXMXIwfQReoSj/7qQqzSk7i04hozRImIxL4X76DGC0h8m3yIBaJcVmLT
	AWaQkyUEmtklfq18wQjxmKTEwRU3WCYwis1CsnkWks2zkGyehWTFAkaWVYyiqQXJBcVJ6blG
	esWJucWleel6yfm5mxghsSK9g3FVg8UhRgEORiUe3gNX1wcIsSaWFVfmHmKU4GBWEuH9WgEU
	4k1JrKxKLcqPLyrNSS0+xOgDdPlEZinR5HxgHOeVxBsaG5uYmZiamFuampviEFYS5232SAkQ
	EkhPLEnNTk0tSC2CGcfEwSnVwMi/+paHQG/+SevobpOjszW35L50e7h92cIHyxTZLOaEXejc
	NYu5jldtV4d2rnN4wh/Bsz3RnAF6Qe+3NyaVm6h8vnP3gPYlO7H5gZMDOaT+3TmRHzrX/K7c
	OcVssdnT+F8+PVD3OHZWrAzX77xX3x8/W79Ap0O3VYZ1L+sD3sQ3ilo8xraC95RYijMSDbWY
	i4oTASu45XbCAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHIsWRmVeSWpSXmKPExsVy+t9jQV1f3Q0BBvP7LCwu75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxoburWwFU7kr2jbNYG5g
	3MfZxcjJISFgIrH68i4mCFtM4sK99WxdjFwcQgLTGSWOnP0I5cxlkmhe+5odpIpNQENi5e63
	bCC2iICTxN/GvSwgNrOAgsSve5tYQWxhAU+Jhu7rjCA2i4CqxI6lT8A28AoYSkzfs58NwhaU
	+DH5HlSvlsT6nceZIGx5ic1r3jJ3MXIAXaQu8eivLsQqPYlLK64xQ5SISOx78Y5xAqPALCST
	ZiGZNAvJpFlIWhYwsqxiFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECI7EZ9I7GFc1WBxiFOBg
	VOLhPXB1fYAQa2JZcWXuIUYJDmYlEd6vFUAh3pTEyqrUovz4otKc1OJDjD5Aj05klhJNzgcm
	ibySeENjEzMjSyMzCyMTc3McwkrivM0eKQFCAumJJanZqakFqUUw45g4OKUaGAVvsHb8Xt7/
	qDvwP++FtT26JSZLq+f2mgvvjP0jsUFSs49pv8bevR/WfpCLe729TS9iUzPPB92a0hIN3Q9n
	1Z7ZiDTsOiq91kQ5zEnISzDy/yfHFC13SYa4EsNFXW+tvtZtCzzE9WLBHmf39xe3lzG7/9hf
	J/qwKi7tyvvWlb6bb15gMHGrVmIpzkg01GIuKk4EAK9iA6HxAgAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix the abnormal ramp delay setting.
The shift operation was wrong.

Signed-off-by: Sangbeom Kim <sbkim73@samsung.com>
---
 drivers/regulator/s2mps11.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/regulator/s2mps11.c b/drivers/regulator/s2mps11.c
index 85fc086..bd062a2 100644
--- a/drivers/regulator/s2mps11.c
+++ b/drivers/regulator/s2mps11.c
@@ -269,16 +269,16 @@ static int s2mps11_pmic_probe(struct platform_device *pdev)
 
 	if (ramp_enable) {
 		if (s2mps11->buck2_ramp)
-			ramp_reg |= get_ramp_delay(s2mps11->ramp_delay2) >> 6;
+			ramp_reg |= get_ramp_delay(s2mps11->ramp_delay2) << 6;
 		if (s2mps11->buck3_ramp || s2mps11->buck4_ramp)
-			ramp_reg |= get_ramp_delay(s2mps11->ramp_delay34) >> 4;
+			ramp_reg |= get_ramp_delay(s2mps11->ramp_delay34) << 4;
 		sec_reg_write(iodev, S2MPS11_REG_RAMP, ramp_reg | ramp_enable);
 	}
 
 	ramp_reg &= 0x00;
-	ramp_reg |= get_ramp_delay(s2mps11->ramp_delay5) >> 6;
-	ramp_reg |= get_ramp_delay(s2mps11->ramp_delay16) >> 4;
-	ramp_reg |= get_ramp_delay(s2mps11->ramp_delay7810) >> 2;
+	ramp_reg |= get_ramp_delay(s2mps11->ramp_delay5) << 6;
+	ramp_reg |= get_ramp_delay(s2mps11->ramp_delay16) << 4;
+	ramp_reg |= get_ramp_delay(s2mps11->ramp_delay7810) << 2;
 	ramp_reg |= get_ramp_delay(s2mps11->ramp_delay9);
 	sec_reg_write(iodev, S2MPS11_REG_RAMP_BUCK, ramp_reg);
 
-- 
1.7.4.1


