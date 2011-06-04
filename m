Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687Ab1FDAPr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 20:15:47 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:30464 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148Ab1FDAPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 20:15:46 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6366"; a="95329613"
From: David Brown <davidb@codeaurora.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 0/7] Move Qualcomm gpio drivers into drivers dir
References: <1305755453-31112-1-git-send-email-davidb@codeaurora.org>
	<1307141059-22431-1-git-send-email-davidb@codeaurora.org>
Date: Fri, 03 Jun 2011 17:15:45 -0700
In-Reply-To: <1307141059-22431-1-git-send-email-davidb@codeaurora.org> (David
	Brown's message of "Fri, 3 Jun 2011 15:44:12 -0700")
Message-ID: <8yavcwmsb7y.fsf@huya.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 03 2011, David Brown wrote:

> This patch series moves the Qualcomm MSM gpio device drivers into the
> drivers/gpio directory.

Grant, feel free to pull these changes from my git repo if you'd like.
(assuming there are no additional objections to the change).

Thanks,
David

The following changes since commit 55922c9d1b84b89cb946c777fddccb3247e7df2c:

  Linux 3.0-rc1 (2011-05-29 17:43:36 -0700)

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
