Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933840Ab2GLNlk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 09:41:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39554 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933758Ab2GLNli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 09:41:38 -0400
From: Amit Daniel Kachhap <amit.kachhap@linaro.org>
To: linux-pm@lists.linux-foundation.org, lenb@kernel.org
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, lm-sensors@lm-sensors.org,
        amit.kachhap@linaro.org, akpm@linux-foundation.org
Subject: [RESEND PATCH v4 0/5] thermal: Add kernel thermal support for exynos platform
Date: Thu, 12 Jul 2012 19:11:03 +0530
Message-Id: <1342100468-19426-1-git-send-email-amit.kachhap@linaro.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Len,

This series is a repost of the thermal support for exynos platform.
These set of patches were already accepted for 3.5 merge.
(https://lkml.org/lkml/2012/6/2/7) but somehow could not go through so,
I am resending them again with rebasing against 3.5-rc6. Please apply them
for 3.6 merge.

Thanks,
Amit Daniel


Amit Daniel Kachhap (5):
  thermal: add generic cpufreq cooling implementation
  hwmon: exynos4: move thermal sensor driver to driver/thermal
    directory
  thermal: exynos5: add exynos5 thermal sensor driver support
  thermal: exynos: register the tmu sensor with the kernel thermal
    layer
  ARM: exynos: add thermal sensor driver platform data support

 Documentation/hwmon/exynos4_tmu              |   81 ---
 Documentation/thermal/cpu-cooling-api.txt    |   60 ++
 Documentation/thermal/exynos_thermal         |   52 ++
 drivers/hwmon/Kconfig                        |   10 -
 drivers/hwmon/Makefile                       |    1 -
 drivers/hwmon/exynos4_tmu.c                  |  514 --------------
 drivers/thermal/Kconfig                      |   20 +
 drivers/thermal/Makefile                     |    4 +-
 drivers/thermal/cpu_cooling.c                |  483 +++++++++++++
 drivers/thermal/exynos_thermal.c             |  956 ++++++++++++++++++++++++++
 include/linux/cpu_cooling.h                  |   99 +++
 include/linux/platform_data/exynos4_tmu.h    |   83 ---
 include/linux/platform_data/exynos_thermal.h |  100 +++
 13 files changed, 1773 insertions(+), 690 deletions(-)
 delete mode 100644 Documentation/hwmon/exynos4_tmu
 create mode 100644 Documentation/thermal/cpu-cooling-api.txt
 create mode 100644 Documentation/thermal/exynos_thermal
 delete mode 100644 drivers/hwmon/exynos4_tmu.c
 create mode 100644 drivers/thermal/cpu_cooling.c
 create mode 100644 drivers/thermal/exynos_thermal.c
 create mode 100644 include/linux/cpu_cooling.h
 delete mode 100644 include/linux/platform_data/exynos4_tmu.h
 create mode 100644 include/linux/platform_data/exynos_thermal.h

