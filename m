Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262Ab2LNEUE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 23:20:04 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:63669 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755452Ab2LNEUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 23:20:02 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-6a-50caa8efeabd
From: Joonyoung Shim <jy0922.shim@samsung.com>
To: thierry.reding@avionic-design.de
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kgene.kim@samsung.com, kyungmin.park@samsung.com
Subject: [PATCH] pwm: samsung: add missing s3c->pwm_id
Date: Fri, 14 Dec 2012 13:20:09 +0900
Message-id: <1355458809-12290-1-git-send-email-jy0922.shim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOLMWRmVeSWpSXmKPExsVy+t8zXd0PK04FGCyYwWhxedccNosZ5/cx
	OTB5fN4kF8AYxWWTkpqTWZZapG+XwJWxuO8Ic0EDa8XpvhWMDYwtLF2MnBwSAiYSny/tZ4aw
	xSQu3FvP1sXIxSEksIxRYseRv6wwRf0d7WANQgLTGSUu35KCKGphklh5/D8bSIJNQE/izrbj
	TCC2iICKxLQ1D8BsZoFyifbfu8E2CAuYSSz8eogRxGYRUJXYcfEn2AJeAXeJxb8vA9kcQMsU
	JOZMsoEoEZD4NvkQC0RYVmLTAWaQtRICe9gkJmzeAnWbpMTBFTdYJjAKLmBkWMUomlqQXFCc
	lJ5rqFecmFtcmpeul5yfu4kRElpSOxhXNlgcYhTgYFTi4f0odCpAiDWxrLgy9xCjBAezkgiv
	XRNQiDclsbIqtSg/vqg0J7X4EKMP0CUTmaVEk/OBYZ9XEm9obGBsaGhpaGZqaWqAQ1hJnLfZ
	IyVASCA9sSQ1OzW1ILUIZhwTB6dUA2Peq7c/dI+bxB3eOlfW88uDR61qYTNEPNiTn1ec3TXz
	NuepbS79165OV07+PNUnc890gUvJ8mKsEf5zvt469jGEhcOK/2DSstpDq4KX33zR5CN/vfNT
	s27a+bIFx8zO8Z5gqPumPZUp1LJAOLc58emFAtn03aZ50f9NExZ+C+eessN81otzShuUWIoz
	Eg21mIuKEwG+8MT1WgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGLMWRmVeSWpSXmKPExsVy+t9jQd33K04FGMy5qWtxedccNosZ5/cx
	OTB5fN4kF8AY1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIT
	oOuWmQM0WkmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeYsbjvCHNBA2vF
	6b4VjA2MLSxdjJwcEgImEv0d7VC2mMSFe+vZQGwhgemMEpdvSXUxcgHZLUwSK4//B0uwCehJ
	3Nl2nAnEFhFQkZi25gGYzSxQLtH+ezcziC0sYCax8OshRhCbRUBVYsfFn6wgNq+Au8Ti35eB
	bA6gZQoScybZTGDkXsDIsIpRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjOHCfSe1gXNlgcYhR
	gINRiYf3o9CpACHWxLLiytxDjBIczEoivHZNQCHelMTKqtSi/Pii0pzU4kOMPkDLJzJLiSbn
	A6MqryTe0NjEzMjSyMzYxNzYGIewkjhvs0dKgJBAemJJanZqakFqEcw4Jg5OqQbG2UmLq9iy
	PjyMqbS6eOBFx6OZmZkOBlLOs49JZ24XLFq0QIfh1erqwg/f/8yZaFHpHZ1j17cgXMEmV/pl
	6j3NeUKpdWvErIT7209/9vh3edH9HXe5vj0v5NBKOdA787B5w5zA44LumkLMQq/PBubfYCs/
	pp4+ryk3aL+e4wT9JRe72fV0j91VYinOSDTUYi4qTgQA44Egy4kCAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The s3c->pwm_id is used to calculate offset of related register.

Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
---
 drivers/pwm/pwm-samsung.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pwm/pwm-samsung.c b/drivers/pwm/pwm-samsung.c
index 023a3be..b415102 100644
--- a/drivers/pwm/pwm-samsung.c
+++ b/drivers/pwm/pwm-samsung.c
@@ -220,6 +220,8 @@ static int s3c_pwm_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
+	s3c->pwm_id = id;
+
 	/* calculate base of control bits in TCON */
 	s3c->tcon_base = id == 0 ? 0 : (id * 4) + 4;
 	s3c->chip.dev = &pdev->dev;
-- 
1.7.9.5

