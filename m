Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450Ab2K0NCG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 08:02:06 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:51241 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164Ab2K0NCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 08:02:02 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-10-50b4b9c8513f
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-i2c@vger.kernel.org
Cc: naveenkrishna.ch@gmail.com, kgene.kim@samsung.com,
        grant.likely@secretlab.ca, w.sang@pengutronix.de,
        linux-kernel@vger.kernel.org, taeggyun.ko@samsung.com
Subject: [PATCH 0/3] i2c: Add High speed I2C controller driver for Exynos5
Date: Tue, 27 Nov 2012 18:30:33 +0530
Message-id: <1354021236-28596-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHLMWRmVeSWpSXmKPExsWyRsSkVvfEzi0BBgsvW1l0/P3CaHF51xw2
	ixnn9zE5MHt83iQXwBjFZZOSmpNZllqkb5fAlfHj2XPmgm3sFavOnGZuYLzL2sXIySEhYCLx
	rmUSI4QtJnHh3nq2LkYuDiGBpYwS+9beYocpWt79mx0isYhRYt2SA0wQTg+TxIfLx8Gq2ATM
	JA4uWg1WJSLQyyixcNNWZhCHGaTlzMWjQA4Hh7CAl8TujdwgDSwCqhLzJq1mAbF5BVwlWj81
	sICUSAgoSMyZZANRIiDxbfIhqLCsxKYDYBMlBE6wSRzpmQj1gqTEwRU3WCYwCi5gZFjFKJpa
	kFxQnJSea6hXnJhbXJqXrpecn7uJERhop/89k9rBuLLB4hCjAAejEg+vwrrNAUKsiWXFlbmH
	GCU4mJVEeBeu2hIgxJuSWFmVWpQfX1Sak1p8iNEH6JKJzFKiyfnAKMgriTc0NjE3NTa1NDIy
	MzXFIawkztvskRIgJJCeWJKanZpakFoEM46Jg1OqgbFO+7+/nwJTXvmLiCXPjG4Vun3eV2Ww
	S96+12PO9rrdten3Aw+e0/zNGPn/1y+hjR+kC1c/mJVydadF152y29s+/vsnUPnDbafj5KSp
	Epb1UWL/5wgs/fu28NMVn8f9l5UeZymKRqi6Tji4JU2G6eTppOLQot9Tzm1buaXFMaRnwqPN
	oksc3ncpsRRnJBpqMRcVJwIAb7SgpGECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsVy+t9jAd0TO7cEGNxeqmvR8fcLo8XlXXPY
	LGac38fkwOzxeZNcAGNUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJu
	qq2Si0+ArltmDtB8JYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhDWPGj2fP
	mQu2sVesOnOauYHxLmsXIyeHhICJxPLu3+wQtpjEhXvr2boYuTiEBBYxSqxbcoAJwulhkvhw
	+ThYFZuAmcTBRavZQRIiAr2MEgs3bWUGcZhBWs5cPArkcHAIC3hJ7N7IDdLAIqAqMW/SahYQ
	m1fAVaL1UwMLSImEgILEnEk2Exi5FzAyrGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQIDuNn
	UjsYVzZYHGIU4GBU4uFVWLc5QIg1say4MvcQowQHs5II78JVWwKEeFMSK6tSi/Lji0pzUosP
	MfoALZ/ILCWanA+MsbySeENjE3NTY1NLEwsTM0scwkrivM0eKQFCAumJJanZqakFqUUw45g4
	OKUaGIvu7hf4ctwlQrjXu/j0ilcNuRxcacJnC0+fr2xVvBTjHqhUeem/3tS7S7f6vHX04v9X
	JfHxgPntUg52o2L2LBHHRPlH7p4737la6j74IbvI8cJq0cqd3Yda6lXPWt6WD8/f8lFZut+w
	cvFtCXGlZdxVHelNplm1dx8dTvgYLrUh/65RxqlFSizFGYmGWsxFxYkAkNm6U5ACAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exynos5 and latter SoCs from Samsung supports High Speed I2C controller.
This patch set adds the controller driver, device tree information for Exynos5
platform and defines gating clocks.

Naveen Krishna Chatradhi (3):
  i2c: exynos5: add High Speed I2C controller driver
  ARM: exynos5: Add gate clocks for HS-I2C
  arm: exynos5: Add HS-I2C device tree platform information

 arch/arm/boot/dts/exynos5250-smdk5250.dts |   16 +
 arch/arm/boot/dts/exynos5250.dtsi         |   32 ++
 arch/arm/mach-exynos/clock-exynos5.c      |   20 +
 drivers/i2c/busses/Kconfig                |    6 +
 drivers/i2c/busses/Makefile               |    1 +
 drivers/i2c/busses/i2c-exynos5.c          |  758 +++++++++++++++++++++++++++++
 drivers/i2c/busses/i2c-exynos5.h          |   80 +++
 7 files changed, 913 insertions(+)
 create mode 100644 drivers/i2c/busses/i2c-exynos5.c
 create mode 100644 drivers/i2c/busses/i2c-exynos5.h

-- 
1.7.9.5

