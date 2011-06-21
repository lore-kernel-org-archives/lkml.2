Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756415Ab1FUCHS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 22:07:18 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:13016 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296Ab1FUCHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 22:07:16 -0400
X-AuditID: cbfee61a-b7c59ae000003b70-bc-4dfffcd27ef3
Date: Tue, 21 Jun 2011 11:07:09 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH v2 0/4] ARM: Exynos4: NURI Board Configuration Udpate
In-reply-to: <20110620103124.GD31864@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        myungjoo.ham@gmail.com, dg77.kim@samsung.com
Message-id: <1308622033-2521-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
Content-transfer-encoding: 7BIT
References: <20110620103124.GD31864@opensource.wolfsonmicro.com>
X-OriginalArrivalTime: 21 Jun 2011 02:06:38.0162 (UTC)
 FILETIME=[DAB38320:01CC2FB7]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1/4: Add configuration for MAX8997 PMIC and regulators
2/4: Add configuration for MAX17042 fuel gauge.
3/4: Add configuration for ADC
	depends on the recently submitted ADC for Samsung SoC patch series:
	[PATCH v2 0/5] Update Samsung-SoC ADC (regulator / recent CPU support)
4/4: Add configuration for NTC themistor.
	depends on the recently submitted NTC-thermistor patch:
	[PATCH v10] drivers/hwmon NTC Thermistor Initial Support v10 (applied to next)

MyungJoo Ham (4):
  Exynos4 NURI: configure regulators and PMIC
  Exynos4 NURI: configure MAX17042 fuel gauge
  Exynos4 NURI: configure ADC.
  Exynos4 NURI: support for NTC thermistor

 arch/arm/mach-exynos4/mach-nuri.c |  703 ++++++++++++++++++++++++++++++++++++-
 1 files changed, 702 insertions(+), 1 deletions(-)

-- 
1.7.4.1

