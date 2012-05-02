Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758417Ab2EBCMs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 22:12:48 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:63527 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757528Ab2EBCMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 22:12:47 -0400
From: Robert Lee <rob.lee@linaro.org>
To: kernel@pengutronix.de
Cc: shawn.guo@linaro.org, amit.kucheria@linaro.org, daniel.lezcano@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org, jj@chaosbits.net
Subject: [PATCH v2 0/3] Add imx cpuidle
Date: Tue,  1 May 2012 21:12:37 -0500
Message-Id: <1335924760-796-1-git-send-email-rob.lee@linaro.org>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add common imx cpuidle initialization functionality and add a i.MX5 and i.MX6Q
platform cpuidle implementation.

Based on v3.4-rc5 plus recently submitted device tree late_initcall patch:
 http://www.spinics.net/lists/arm-kernel/msg171620.html

Changes since v1:
 * Removed some unnecessary  spaces
 * Added return value for an error message
 * Reworked init scheme to use device tree late_initcall.
 * Moved imx6q and imx5 cpuidle functionality to existing files.

Robert Lee (3):
  ARM: imx: Add common imx cpuidle init functionality.
  ARM: imx: Add imx5 cpuidle driver
  ARM: imx: Add imx6q cpuidle driver

 arch/arm/mach-imx/cpuidle-imx6q.c        |   33 ++++++++++++
 arch/arm/mach-imx/mach-imx6q.c           |   18 +++++++
 arch/arm/mach-imx/mm-imx5.c              |   42 ++++++++++++++--
 arch/arm/plat-mxc/Makefile               |    1 +
 arch/arm/plat-mxc/cpuidle.c              |   80 ++++++++++++++++++++++++++++++
 arch/arm/plat-mxc/include/mach/cpuidle.h |   22 ++++++++
 6 files changed, 193 insertions(+), 3 deletions(-)
 create mode 100644 arch/arm/mach-imx/cpuidle-imx6q.c
 create mode 100644 arch/arm/plat-mxc/cpuidle.c
 create mode 100644 arch/arm/plat-mxc/include/mach/cpuidle.h

-- 
1.7.10

