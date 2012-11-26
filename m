Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330Ab2KZNri (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 08:47:38 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:58370 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018Ab2KZNrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 08:47:37 -0500
From: Amit Daniel Kachhap <amit.kachhap@linaro.org>
To: linux-pm@lists.linux-foundation.org, Zhang Rui <rui.zhang@intel.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        amit.kachhap@linaro.org, jonghwa3.lee@samsung.com
Subject: [PATCH V2 0/3] thermal: Add support for interrupt based notification to thermal layer
Date: Mon, 26 Nov 2012 19:17:17 +0530
Message-Id: <1353937640-9939-1-git-send-email-amit.kachhap@linaro.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since V1: Used the new thermal trend type macro

The patch submitted by Jonghwa Lee (https://patchwork.kernel.org/patch/1683441/)
adds support for interrupt based notification to thermal layer. This is a good
feature but the current code need more fixes to support that feature so using 2 new thermal
trend type to implement this feature and some falling interrupt fixes.

All these patches are based on thermal maintainer thermal branch.
git://git.kernel.org/pub/scm/linux/kernel/git/rzhang/linux.git thermal

Amit Daniel Kachhap (2):
  thermal: exynos: Miscellaneous fixes to support falling threshold
    interrupt
  thermal: exynos: Use the new thermal trend type for quick cooling
    action.

Jonghwa Lee (1):
  Thermal: exynos: Add support for temperature falling interrupt.

 drivers/thermal/exynos_thermal.c             |  108 +++++++++++++++-----------
 include/linux/platform_data/exynos_thermal.h |    3 +
 2 files changed, 67 insertions(+), 44 deletions(-)

