Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933035Ab1C3WQO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 18:16:14 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:9833 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932342Ab1C3WQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 18:16:11 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6301"; a="82841765"
From: David Collins <collinsd@codeaurora.org>
To: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm-owner@vger.kernel.org,
        David Collins <collinsd@codeaurora.org>
Subject: [PATCH 0/2] regulator: msm: Add PM8921 regulator driver
Date: Wed, 30 Mar 2011 15:16:01 -0700
Message-Id: <1301523361-5982-1-git-send-email-collinsd@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set adds a new regulator driver to control the regulators in
Qualcomm PM8921 PMIC chips.  It also introduces board file changes to use
this new driver with the Qualcomm MSM 8960 platform.

This patch set depends upon the following outstanding PM8XXX and PM8921
patches:

https://patchwork.kernel.org/patch/643231/
https://patchwork.kernel.org/patch/643221/
https://patchwork.kernel.org/patch/643201/
https://patchwork.kernel.org/patch/643211/
https://patchwork.kernel.org/patch/643241/

David Collins (2):
  regulator: pm8921-regulator: Add regulator driver for PM8921
  msm: board-8960: Add support for pm8921-regulator

 arch/arm/mach-msm/Makefile                  |    1 +
 arch/arm/mach-msm/board-msm8960-regulator.c |  303 ++++
 arch/arm/mach-msm/board-msm8960.c           |    6 +
 arch/arm/mach-msm/board-msm8960.h           |   23 +
 drivers/mfd/pm8921-core.c                   |   32 +-
 drivers/regulator/Kconfig                   |   10 +
 drivers/regulator/Makefile                  |    1 +
 drivers/regulator/pm8921-regulator.c        | 2211 +++++++++++++++++++++++++++
 include/linux/mfd/pm8xxx/pm8921.h           |    3 +
 include/linux/regulator/pm8921-regulator.h  |   97 ++
 10 files changed, 2686 insertions(+), 1 deletions(-)
 create mode 100644 arch/arm/mach-msm/board-msm8960-regulator.c
 create mode 100644 arch/arm/mach-msm/board-msm8960.h
 create mode 100644 drivers/regulator/pm8921-regulator.c
 create mode 100644 include/linux/regulator/pm8921-regulator.h

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

