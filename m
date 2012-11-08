Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011Ab2KHE0i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 23:26:38 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:44677 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138Ab2KHE0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 23:26:36 -0500
From: Amit Daniel Kachhap <amit.kachhap@linaro.org>
To: linux-pm@lists.linux-foundation.org
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        durgadoss.r@intel.com, lenb@kernel.org, rui.zhang@intel.com,
        linux-acpi@vger.kernel.org, amit.kachhap@linaro.org,
        jonghwa3.lee@samsung.com
Subject: [PATCH 0/4] thermal: Add support for interrupt based notification to thermal layer
Date: Thu,  8 Nov 2012 09:56:23 +0530
Message-Id: <1352348786-24255-1-git-send-email-amit.kachhap@linaro.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch submitted by Jonghwa Lee (https://patchwork.kernel.org/patch/1683441/)
adds support for interrupt based notification to thermal layer. This is a good
feature but the current thermal framework needs polling/regular notification for
invoking suitable cooling action. So adding 2 new thermal trend type to implement
this feature.

All these patches are based on thermal maintainer next tree.
git://git.kernel.org/pub/scm/linux/kernel/git/rzhang/linux.git next

Amit Daniel Kachhap (3):
  thermal: Add new thermal trend type to support quick cooling
  thermal: exynos: Miscellaneous fixes to support falling threshold
    interrupt
  thermal: exynos: Use the new thermal trend type for quick cooling
    action.

Jonghwa Lee (1):
  Thermal: exynos: Add support for temperature falling interrupt.

 drivers/thermal/exynos_thermal.c             |  105 +++++++++++++++-----------
 drivers/thermal/step_wise.c                  |   19 ++++-
 include/linux/platform_data/exynos_thermal.h |    3 +
 include/linux/thermal.h                      |    2 +
 4 files changed, 80 insertions(+), 49 deletions(-)

