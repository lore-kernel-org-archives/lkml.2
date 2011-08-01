Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249Ab1HAMBs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 08:01:48 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:15651 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab1HAMBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 08:01:43 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6424"; a="107040728"
Date: Mon, 1 Aug 2011 05:01:42 -0700
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-msm@lists.infradead.org, linux-arm-kernel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL corrected] msm gpio move to drivers/gpio
Message-ID: <20110801120141.GA29990@huya.qualcomm.com>
References: <20110801112244.GA24384@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110801112244.GA24384@huya.qualcomm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(corrected version of the versions approved on list)

The following changes since commit 02f8c6aee8df3cdc935e9bdd4f2d020306035dbe:

  Linux 3.0 (2011-07-21 19:17:23 -0700)

are available in the git repository at:
  git://codeaurora.org/quic/kernel/davidb/linux-msm.git msm-move-gpio

David Brown (8):
      msm: gpio: Remove unsupported devices
      msm: Remove chip-ifdefs for GPIO io mappings
      msm: gpio: Remove chip-specific register definitions
      msm: gpio: Remove ifdefs on gpio chip registers
      msm: gpiomux: Move public API to public header
      msm: gpio: Fold register defs into C file
      gpio_msm: Move Qualcomm v6 MSM driver into drivers
      gpio_msm: Move Qualcomm MSM v2 gpio driver into drivers

 arch/arm/mach-msm/Kconfig                          |    4 +
 arch/arm/mach-msm/Makefile                         |    8 -
 arch/arm/mach-msm/gpio.c                           |  376 ------------
 arch/arm/mach-msm/gpio_hw.h                        |  278 ---------
 arch/arm/mach-msm/gpiomux.h                        |   17 +-
 arch/arm/mach-msm/include/mach/msm_gpiomux.h       |   38 ++
 arch/arm/mach-msm/include/mach/msm_iomap-7x00.h    |   10 +-
 arch/arm/mach-msm/include/mach/msm_iomap-7x30.h    |   10 +-
 arch/arm/mach-msm/include/mach/msm_iomap-8x50.h    |   10 +-
 arch/arm/mach-msm/include/mach/msm_iomap.h         |    2 +
 arch/arm/mach-msm/io.c                             |   12 +-
 drivers/gpio/Kconfig                               |   16 +
 drivers/gpio/Makefile                              |    2 +
 drivers/gpio/gpio-msm-v1.c                         |  636 ++++++++++++++++++++
 .../gpio-v2.c => drivers/gpio/gpio-msm-v2.c        |    4 +-
 15 files changed, 719 insertions(+), 704 deletions(-)
 delete mode 100644 arch/arm/mach-msm/gpio.c
 delete mode 100644 arch/arm/mach-msm/gpio_hw.h
 create mode 100644 arch/arm/mach-msm/include/mach/msm_gpiomux.h
 create mode 100644 drivers/gpio/gpio-msm-v1.c
 rename arch/arm/mach-msm/gpio-v2.c => drivers/gpio/gpio-msm-v2.c (99%)
