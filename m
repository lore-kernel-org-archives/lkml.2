Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456Ab1H3WwS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 18:52:18 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:32685 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775Ab1H3WwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 18:52:15 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6454"; a="114131741"
Date: Tue, 30 Aug 2011 15:52:13 -0700
From: David Brown <davidb@codeaurora.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] msm: devboard defconfigs
Message-ID: <20110830225213.GB7093@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unless Russell objects, and prefers these to be in his tree, I'm fine
with having these in a branch for linux-next that isn't merged
upstream for now.

The following changes since commit c6a389f123b9f68d605bb7e0f9b32ec1e3e14132:

  Linux 3.1-rc4 (2011-08-28 21:16:01 -0700)

are available in the git repository at:
  git://codeaurora.org/quic/kernel/davidb/linux-msm.git msm-defconfig

David Brown (1):
      ARM: msm: defconfigs for Qualcomm dev boards

 arch/arm/configs/msm7x30_defconfig |   68 +++++++++
 arch/arm/configs/msm8660_defconfig |   96 +++++++++++++
 arch/arm/configs/msm8960_defconfig |  265 ++++++++++++++++++++++++++++++++++++
 arch/arm/configs/qsd8x50_defconfig |   82 +++++++++++
 4 files changed, 511 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/configs/msm7x30_defconfig
 create mode 100644 arch/arm/configs/msm8660_defconfig
 create mode 100644 arch/arm/configs/msm8960_defconfig
 create mode 100644 arch/arm/configs/qsd8x50_defconfig

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
