Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757257Ab0IBXoX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 19:44:23 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:58676 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212Ab0IBXoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 19:44:22 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6093"; a="53079919"
From: Kenneth Heitke <kheitke@codeaurora.org>
To: khali@linux-fr.org, ben-linux@fluff.org, srinidhi.kasagar@stericsson.com,
        tsoni@codeaurora.org
Cc: linux-arm-msm@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kenneth Heitke <kheitke@codeaurora.org>
Subject: [PATCH v2 0/2] i2c: QUP based bus driver for Qualcomm MSM chipsets
Date: Thu,  2 Sep 2010 17:44:18 -0600
Message-Id: <1283471059-22262-1-git-send-email-kheitke@codeaurora.org>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

These patches incorporated requested changes from the v1 revision.

[PATCH 1/2] is for the header file that defines the platform data used
by the driver.  This patch can be picked up by the i2c maintainers but
also needs to be acked by the msm maintainers (linux-arm-msm).

[PATCH 2/2] contains the QUP I2C driver.

Revision history:
v2: incorporated feedback from the following people:
	ben-linux@fluff.org
	srinidhi.kasagar@stericsson.com
	tsoni@codeaurora.org

Kenneth Heitke (2):
  msm: i2c: Add msm_qup_i2c.h
  i2c: QUP based bus driver for Qualcomm MSM chipsets

 arch/arm/mach-msm/include/mach/msm_qup_i2c.h |   28 +
 drivers/i2c/busses/Kconfig                   |   12 +
 drivers/i2c/busses/Makefile                  |    1 +
 drivers/i2c/busses/i2c-qup.c                 | 1105 ++++++++++++++++++++++++++
 4 files changed, 1146 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-msm/include/mach/msm_qup_i2c.h
 create mode 100644 drivers/i2c/busses/i2c-qup.c

--
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
