Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab1HAOZ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 10:25:27 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:46288 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959Ab1HAOZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 10:25:22 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 1 Aug 2011 15:25:00 +0100
X-Google-Sender-Auth: dVPAazd_bZYradvJm7bJfWv2SFM
Message-ID: <CACxGe6tV4VUtdEzcMi1zkXJ1Ro2vrFgksHP52dzSNASB0-aSwA@mail.gmail.com>
Subject: [GIT PULL] last gpio patches for v3.1 merge window
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: David Brown <davidb@codeaurora.org>, Axel Lin <axel.lin@gmail.com>,
        Jamie Iles <jamie@jamieiles.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are some more gpio changes that should get into v3.1

Thanks,
g.

The following changes since commit 3da3f872aa175f59e20766ed30aaea67fd4fa7d1:

  Merge branch 'for-next' of
git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-2.6
(2011-07-31 14:31:44 -1000)

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 gpio/next

Axel Lin (1):
      gpio: ab8500: fix MODULE_ALIAS for ab8500

David Brown (8):
      msm: gpio: Remove unsupported devices
      msm: Remove chip-ifdefs for GPIO io mappings
      msm: gpio: Remove chip-specific register definitions
      msm: gpio: Remove ifdefs on gpio chip registers
      msm: gpiomux: Move public API to public header
      msm: gpio: Fold register defs into C file
      gpio_msm: Move Qualcomm v6 MSM driver into drivers
      gpio_msm: Move Qualcomm MSM v2 gpio driver into drivers

Grant Likely (1):
      Merge branch 'msm-move-gpio' of
git://codeaurora.org/quic/kernel/davidb/linux-msm into gpio/next

Jamie Iles (1):
      of/gpio: export of_gpio_simple_xlate

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
 drivers/gpio/gpio-ab8500.c                         |    2 +-
 drivers/gpio/gpio-msm-v1.c                         |  636 ++++++++++++++++++++
 .../gpio-v2.c => drivers/gpio/gpio-msm-v2.c        |    4 +-
 drivers/of/gpio.c                                  |    5 +-
 include/linux/of_gpio.h                            |    9 +
 18 files changed, 732 insertions(+), 707 deletions(-)
 delete mode 100644 arch/arm/mach-msm/gpio.c
 delete mode 100644 arch/arm/mach-msm/gpio_hw.h
 create mode 100644 arch/arm/mach-msm/include/mach/msm_gpiomux.h
 create mode 100644 drivers/gpio/gpio-msm-v1.c
 rename arch/arm/mach-msm/gpio-v2.c => drivers/gpio/gpio-msm-v2.c (99%)


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
