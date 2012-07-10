Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab2GJVFK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 17:05:10 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:63137 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919Ab2GJVFH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 17:05:07 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdYTKu8XVbnLom+VKp=2YGB+EX3Qnc5EX_ciqbaGndbROw@mail.gmail.com>
References: <CACRpkdYTKu8XVbnLom+VKp=2YGB+EX3Qnc5EX_ciqbaGndbROw@mail.gmail.com>
Date: Tue, 10 Jul 2012 23:05:06 +0200
Message-ID: <CACRpkdZ65V=Y0uxahxZ2RUQMSc514Zc=FWNbrCSFq+y_AsYFWA@mail.gmail.com>
Subject: Re: [GIT PULL] gpio fixes for v3.5
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Grant Likely <grant.likely@secretlab.ca>, Kevin Hilman <khilman@ti.com>,
        linux-kernel@vger.kernel.org, Laxman Dewangan <ldewangan@nvidia.com>,
        Alessandro Rubini <rubini@gnudd.com>,
        Christian Dietrich 
	<christian.dietrich@informatik.uni-erlangen.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Roland Stigge <stigge@antcom.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Gerard Snitselaar <dev@snitselaar.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2012 at 10:16 PM, Linus Walleij
<linus.walleij@linaro.org> wrote:

> yes, this is a *LATE* GPIO pull request with fixes for v3.5.

Grr! So typically -next washed out a bug in the bug fixes. This v2 of the
pull request fixes another OF/DT related issue caused by fixing another
OF/DT related issue, courtesy of Gerard Sintselaar.

So please pull the v2. Or pull it on top of the other one, whatever.
Sorry for the panic mode, I'm in the middle of the Swedish woods,
supposedly on vacation.

Yours,
Linus Walleij


The following changes since commit 6887a4131da3adaab011613776d865f4bcfb5678:

  Linux 3.5-rc5 (2012-06-30 16:08:57 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio.git
tags/fixes-for-v3.5-v2

Alessandro Rubini (1):
      gpio-sta2x11: don't use pdata if null

Christian Dietrich (1):
      gpio/msm_v1: CONFIG_GPIO_MSM_V1 is only available on three SoCs

Grazvydas Ignotas (1):
      gpio/omap: fix irq loss while in idle with debounce on

Jerry Snitselaar (1):
      gpio/gpio-tps65910: gpio_chip.of_node referenced without
CONFIG_OF_GPIO defined

Jon Hunter (1):
      gpio/omap: fix invalid context restore of gpio bank-0

Laxman Dewangan (2):
      gpio: fix bits conflict for gpio flags
      gpio: tps65910: initialize of_node of gpio_chip

Linus Walleij (1):
      Merge branch 'kevin' into fixes

Mark Brown (1):
      gpiolib: wm8994: Pay attention to the value set when enabling as output

Roland Stigge (1):
      mips: pci-lantiq: Fix check for valid gpio

Stephen Warren (1):
      gpio: export devm_gpio_request_one

Uwe Kleine-König (1):
      gpio/mxc: make irqs work for fsl,imx21-gpio devices

 arch/mips/pci/pci-lantiq.c   |    4 ++--
 drivers/gpio/Kconfig         |    2 +-
 drivers/gpio/devres.c        |    1 +
 drivers/gpio/gpio-mxc.c      |   10 ++++++----
 drivers/gpio/gpio-omap.c     |   14 +++++++++++++-
 drivers/gpio/gpio-sta2x11.c  |    5 +++--
 drivers/gpio/gpio-tps65910.c |    3 +++
 drivers/gpio/gpio-wm8994.c   |    5 ++++-
 include/linux/gpio.h         |    4 ++--
 9 files changed, 35 insertions(+), 13 deletions(-)
