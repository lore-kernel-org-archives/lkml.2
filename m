Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513Ab2LMLWY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 06:22:24 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:18261 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab2LMLWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 06:22:23 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-b6-50c9ba56eb35
From: Thomas Abraham <thomas.abraham@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linus.walleij@linaro.org, kgene.kim@samsung.com, t.figa@samsung.com,
        patches@linaro.org
Subject: [PATCH 0/3] pinctrl: exynos: add support for Samsung's Exynos5250
Date: Thu, 13 Dec 2012 17:24:01 +0530
Message-id: <1355399644-29417-1-git-send-email-thomas.abraham@linaro.org>
X-Mailer: git-send-email 1.6.6.rc2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAJMWRmVeSWpSXmKPExsVy+t9jAd2wXScDDI5ct7K4vGsOm8WM8/uY
	HJg8Pm+SC2CM4rJJSc3JLEst0rdL4Mr4ufwjS8EK9opDH9+zNTD+Ye1i5OSQEDCRuHJmB5Qt
	JnHh3nq2LkYuDiGBRYwSM1ta2CGcNiaJ9/+3sIFUsQkYSDxa+I4dxBYRUJDY3PuMFaSIWWAF
	o8SJrq9gCWEBL4mX5w+DNbAIqEocu9EHZvMKeEpcfD2DCWKdksSG3qNMExi5FzAyrGIUTS1I
	LihOSs811CtOzC0uzUvXS87P3cQI9uczqR2MKxssDjEKcDAq8fAWhJ8MEGJNLCuuzD3EKMHB
	rCTC678cKMSbklhZlVqUH19UmpNafIhRmoNFSZy32SMlQEggPbEkNTs1tSC1CCbLxMEp1cA4
	/34r/7mOA+IMLk1at7skpdRT191p3zhvWlxL1595znVOrZyNU04eD8vqFShcW/9MimPPufvV
	R8p+NxUI5rHO+2XK7Gr4X3a2k77phgcXVr2bz6hs/GfbTom933/ViGpGfP9veefSzevX5qm3
	hCVeOn5/29s5k6uiXV+m5rEfKmzzM1iySmaCEktxRqKhFnNRcSIA8QUvP+MBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds pinctrl driver support for Samsung's Exynos5250 SoC.
The first patch adds the required Exynos5250 SoC specific data which is
used by the Samsung pinctrl driver to setup the pinctrl/pinmux/eint
controllers. The second and third patches skips the wakeup interrupt and
gpiolib registration if the pinctrl support is enabled for Exynos5250.

Thomas Abraham (3):
  pinctrl: exynos: add exynos5250 SoC specific data
  gpio: samsung: skip gpiolib registration if pinctrl support is enabled for exynos5250
  arm: exynos: skip wakeup interrupt registration for exynos5250 if pinctrl is enabled

 arch/arm/mach-exynos/common.c     |    1 +
 drivers/gpio/gpio-samsung.c       |    1 +
 drivers/pinctrl/pinctrl-exynos.c  |  108 +++++++++++++++++++++++++++++++++++++
 drivers/pinctrl/pinctrl-samsung.c |    2 +
 drivers/pinctrl/pinctrl-samsung.h |    1 +
 5 files changed, 113 insertions(+), 0 deletions(-)

