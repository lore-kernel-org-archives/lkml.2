Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab2DPXuX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 19:50:23 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:52516 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381Ab2DPXuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 19:50:22 -0400
From: Robert Lee <rob.lee@linaro.org>
To: kernel@pengutronix.de
Cc: shawn.guo@linaro.org, amit.kucheria@linaro.org, daniel.lezcano@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org
Subject: [PATCH 0/3] Add imx cpuidle
Date: Mon, 16 Apr 2012 18:50:11 -0500
Message-Id: <1334620214-25803-1-git-send-email-rob.lee@linaro.org>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add common imx cpuidle initialization functionality and add a i.MX5 and i.MX6
platform cpuidle implementation.

Robert Lee (3):
  ARM: imx: Add common imx cpuidle init functionality.
  ARM: imx: Add imx5 cpuidle driver
  ARM: imx: Add imx6q cpuidle driver

 arch/arm/mach-imx/Makefile               |    4 +-
 arch/arm/mach-imx/cpuidle-imx5.c         |   55 ++++++++++++++++++
 arch/arm/mach-imx/cpuidle-imx6q.c        |   33 +++++++++++
 arch/arm/mach-imx/mach-imx6q.c           |    2 +
 arch/arm/mach-imx/mm-imx5.c              |   16 ++++--
 arch/arm/plat-mxc/Makefile               |    2 +
 arch/arm/plat-mxc/cpuidle.c              |   89 ++++++++++++++++++++++++++++++
 arch/arm/plat-mxc/include/mach/common.h  |    1 +
 arch/arm/plat-mxc/include/mach/cpuidle.h |   26 +++++++++
 9 files changed, 222 insertions(+), 6 deletions(-)
 create mode 100644 arch/arm/mach-imx/cpuidle-imx5.c
 create mode 100644 arch/arm/mach-imx/cpuidle-imx6q.c
 create mode 100644 arch/arm/plat-mxc/cpuidle.c
 create mode 100644 arch/arm/plat-mxc/include/mach/cpuidle.h

-- 
1.7.10

