Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402Ab2JVENu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 00:13:50 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:31642 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970Ab2JVENs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 00:13:48 -0400
X-AuditID: cbfee61b-b7f616d00000319b-ff-5084c7fb6511
From: Yadwinder Singh Brar <yadi.brar@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>
Subject: [PATCH] regulator: max77686: Make max77686_enable() static.
Date: Mon, 22 Oct 2012 09:39:28 +0530
Message-id: <1350878968-3020-1-git-send-email-yadi.brar@samsung.com>
X-Mailer: git-send-email 1.7.0.4
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrELMWRmVeSWpSXmKPExsWyRsSkWvf38ZYAg9+3ZSwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGlAmPWQoes1bcazjO3sD4hqWLkZNDQsBE4vDMB4wQtpjEhXvr
	2boYuTiEBJYySvyctQGu6Mr9BSwQiUWMEps/7YOqWs4ksfjncdYuRg4ONgEjiVfH7EAaRAQU
	JDb3PmMFsZkFpjNKrDxWAGILC7hI9J07xwZSziKgKjG9OR8kzAsU/rComw1il4JE67JD7CA2
	i4CAxLfJh1hAyiUEZCU2HWAG2SohsIVNoqn9M9RtkhIHV9xgmcAouICRYRWjaGpBckFxUnqu
	kV5xYm5xaV66XnJ+7iZGYECd/vdMegfjqgaLQ4wCHIxKPLwWM1oChFgTy4orcw8xSnAwK4nw
	nooHCvGmJFZWpRblxxeV5qQWH2L0AbpkIrOUaHI+MNjzSuINjU3MTY1NLY2MzExNcQgrifM2
	e6QECAmkJ5akZqemFqQWwYxj4uCUamBUi6s+bZbpOZ9dT1blpADnDa7vDhcuhcX/9114cXHZ
	Y63ZCxrSTq/q4Pl3ViDxfeby4P9/927Vkbd4HldpMdW5vvSHvsCpb+yMZTqqlrv6o47L5cj6
	VF6KnT43ZHLjlx/zAlhdn90VNjpW+z5DoaNJas+yKo1c6V27tZgl+iwki927k+ecMFFiKc5I
	NNRiLipOBADcz++FVQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrILMWRmVeSWpSXmKPExsVy+t9jAd3fx1sCDHY/4rG4vGsOmwOjx+dN
	cgGMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlA
	U5UUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhDWMGVMmPGYpeMxaca/hOHsD
	4xuWLkZODgkBE4kr9xdA2WISF+6tZ+ti5OIQEljEKLH50z4oZzmTxOKfx1m7GDk42ASMJF4d
	swNpEBFQkNjc+4wVxGYWmM4osfJYAYgtLOAi0XfuHBtIOYuAqsT05nyQMC9Q+MOibjaIXQoS
	rcsOsU9g5F7AyLCKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzhcn0nvYFzVYHGIUYCDUYmH
	12JGS4AQa2JZcWXuIUYJDmYlEd5T8UAh3pTEyqrUovz4otKc1OJDjD5AyycyS4km5wNjKa8k
	3tDYxNzU2NTSxMLEzBKHsJI4b7NHSoCQQHpiSWp2ampBahHMOCYOTqkGRrdzs4se6y1QKv/w
	widv1mqJdEapJDUTezPRw4zvVxqvUK7SYGi777Dt8jaOOpZtFuI8xs8vdulO7LTLeZZUczLt
	8V2Vb99KfCef9tq4ZUnlhftXtrNOWL/qi5r/nrVvns1LnLTdn8Wae3+VrsgOhwMfby3XKNIp
	VN5YsjzpnVe3fveeMiWHlUosxRmJhlrMRcWJAOl1EL2EAgAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a sparse warning. Since max77686_enable() is a callback,so it
should be static.

Signed-off-by: Yadwinder Singh Brar <yadi.brar@samsung.com>
---
 drivers/regulator/max77686.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/max77686.c b/drivers/regulator/max77686.c
index 383eb9d..c9bec16 100644
--- a/drivers/regulator/max77686.c
+++ b/drivers/regulator/max77686.c
@@ -146,7 +146,7 @@ static int max77686_ldo_set_suspend_mode(struct regulator_dev *rdev,
 				  val);
 }
 
-int max77686_enable(struct regulator_dev *rdev)
+static int max77686_enable(struct regulator_dev *rdev)
 {
 	struct max77686_data *max77686 = rdev_get_drvdata(rdev);
 
-- 
1.7.0.4

