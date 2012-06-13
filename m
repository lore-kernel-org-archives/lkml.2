Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678Ab2FMI0k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 04:26:40 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:10603 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607Ab2FMI0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 04:26:37 -0400
X-AuditID: cbfee61b-b7fcc6d000003a7a-d5-4fd84ea7e459
From: Sangbeom Kim <sbkim73@samsung.com>
To: "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        "'Liam Girdwood'" <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org, sbkim01@gmail.com
Subject: [PATCH 1/5] regulator: Remove s5m8767a buck initialization
Date: Wed, 13 Jun 2012 17:26:15 +0900
Message-id: <041f01cd493e$32e99020$98bcb060$@com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1JPjJcCpnOlrPySpmvn/G/eeYrcg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCLMWRmVeSWpSXmKPExsVy+t9jQd3lfjf8DTa8MLO4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZl7uPsRc8Zau4PfU7WwPjE9YuRk4OCQETiRvHPjFB2GISF+6t
	Z+ti5OIQEpjOKNG69hoLhDOXSaJ542R2kCo2AQ2JlbvfsoHYIgJhEjNnrWQBsZkFjCVOLHwP
	VMPBISzgLPF5kRVImEVAVeJv2wZmEJtXwFDiau8uJghbUOLH5HtQrVoS63ceZ4Kw5SU2r3nL
	DDJGQkBd4tFfXYhNehJLOzugykUk9r14xziBUWAWkkmzkEyahWTSLCQtCxhZVjGKphYkFxQn
	peca6RUn5haX5qXrJefnbmIEh+Uz6R2MqxosDjEKcDAq8fAGud3wF2JNLCuuzD3EKMHBrCTC
	W7z1ur8Qb0piZVVqUX58UWlOavEhRmkOFiVx3ibrC/5CAumJJanZqakFqUUwWSYOTqkGRres
	GbyHV0vK8S01m2M4UVHIrWPeOZW3d6Mur738/4bB/w9vUypityqyZ5fuqPkvzdIllMrR9ej1
	RfXXEf2tLnqswj9L7kzmyO239vN42OB76+1E2e1x077smRTjtHSyaUvtBU6v+6qWrYfmJTos
	qfq+zbDsmXtN607NDVZ1/rLiFxL/vjmQo8RSnJFoqMVcVJwIAA1ubaRHAgAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As s5m8767a is revisioned, remove unnecessary buck 2,3,4 initialization routine.

Signed-off-by: Sangbeom Kim <sbkim73@samsung.com>
---
 drivers/regulator/s5m8767.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index 290d6fc..4edf344 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -668,9 +668,6 @@ static __devinit int s5m8767_pmic_probe(struct platform_device *pdev)
 					   s5m8767->buck4_vol[i]);
 		}
 	}
-	s5m_reg_update(s5m8767->iodev, S5M8767_REG_BUCK2CTRL, 0x78, 0xff);
-	s5m_reg_update(s5m8767->iodev, S5M8767_REG_BUCK3CTRL, 0x58, 0xff);
-	s5m_reg_update(s5m8767->iodev, S5M8767_REG_BUCK4CTRL, 0x78, 0xff);
 
 	if (s5m8767->buck2_ramp)
 		s5m_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP, 0x08, 0x08);
-- 
1.7.1


