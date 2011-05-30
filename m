Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756426Ab1E3IRb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 04:17:31 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:12737 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756303Ab1E3IR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 04:17:28 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 30 May 2011 01:17:27 -0700
From: Jin Park <jinyoungp@nvidia.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Jin Park <jinyoungp@nvidia.com>
Subject: [PATCH 0/1] Submitting aat2870 driver
Date: Mon, 30 May 2011 17:17:31 +0900
Message-Id: <1306743452-26386-1-git-send-email-jinyoungp@nvidia.com>
X-Mailer: git-send-email 1.7.1
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Samuel

I would like to contribute my driver to Linux Kernel.
The driver is for AnalogicTech AAT2870 and include backlight, regulator
and mfd driver.
It was written by me and verified on NVIDIA Tegra platform.
And following patches are based on for-next branch in your repository.
(git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-2.6.git)
Please review my driver.

Thanks,
Jin Park.

Jin Park (1):
  aat2870: Adding backlight, regulator and mfd driver

 drivers/mfd/Kconfig                   |    7 +
 drivers/mfd/Makefile                  |    1 +
 drivers/mfd/aat2870-core.c            |  532 +++++++++++++++++++++++++++++++++
 drivers/regulator/Kconfig             |    7 +
 drivers/regulator/Makefile            |    1 +
 drivers/regulator/aat2870-regulator.c |  265 ++++++++++++++++
 drivers/video/backlight/Kconfig       |    7 +
 drivers/video/backlight/Makefile      |    1 +
 drivers/video/backlight/aat2870_bl.c  |  246 +++++++++++++++
 include/linux/mfd/aat2870.h           |  182 +++++++++++
 10 files changed, 1249 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/aat2870-core.c
 create mode 100644 drivers/regulator/aat2870-regulator.c
 create mode 100644 drivers/video/backlight/aat2870_bl.c
 create mode 100644 include/linux/mfd/aat2870.h

