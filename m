Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070Ab1HALWw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 07:22:52 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:24219 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299Ab1HALWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 07:22:46 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6424"; a="107247451"
Date: Mon, 1 Aug 2011 04:22:45 -0700
From: David Brown <davidb@codeaurora.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] msm gpio move to drivers/gpio
Message-ID: <20110801112244.GA24384@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 02f8c6aee8df3cdc935e9bdd4f2d020306035dbe:

  Linux 3.0 (2011-07-21 19:17:23 -0700)

are available in the git repository at:
  git://codeaurora.org/quic/kernel/davidb/linux-msm.git msm-move-gpio

David Brown (7):
      msm: gpio: Remove unsupported devices
      msm: Remove chip-ifdefs for GPIO io mappings
      msm: gpio: Remove chip-specific register definitions
      msm: gpio: Remove ifdefs on gpio chip registers
      msm: gpiomux: Move public API to public header
      gpio_msm: Move Qualcomm v6 MSM driver into drivers
      gpio_msm: Move Qualcomm MSM v2 gpio driver into drivers

 arch/arm/mach-msm/Kconfig                          |    4 +
 arch/arm/mach-msm/Makefile                         |    8 -
 arch/arm/mach-msm/gpio_hw.h                        |  278 --------------------
 arch/arm/mach-msm/gpiomux.h                        |   17 +--
 arch/arm/mach-msm/include/mach/msm_gpiomux.h       |   38 +++
 arch/arm/mach-msm/include/mach/msm_iomap-7x00.h    |   10 +-
 arch/arm/mach-msm/include/mach/msm_iomap-7x30.h    |   10 +-
 arch/arm/mach-msm/include/mach/msm_iomap-8x50.h    |   10 +-
 arch/arm/mach-msm/include/mach/msm_iomap.h         |    2 +
 arch/arm/mach-msm/io.c                             |   12 +-
 drivers/gpio/Kconfig                               |   16 ++
 drivers/gpio/Makefile                              |    2 +
 arch/arm/mach-msm/gpio.c => drivers/gpio/msm_v1.c  |  111 +++++----
 drivers/gpio/msm_v1.h                              |  271 +++++++++++++++++++
 .../mach-msm/gpio-v2.c => drivers/gpio/msm_v2.c    |    2 +-
 15 files changed, 414 insertions(+), 377 deletions(-)
 delete mode 100644 arch/arm/mach-msm/gpio_hw.h
 create mode 100644 arch/arm/mach-msm/include/mach/msm_gpiomux.h
 rename arch/arm/mach-msm/gpio.c => drivers/gpio/msm_v1.c (82%)
 create mode 100644 drivers/gpio/msm_v1.h
 rename arch/arm/mach-msm/gpio-v2.c => drivers/gpio/msm_v2.c (99%)

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
