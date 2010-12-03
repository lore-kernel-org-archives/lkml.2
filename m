Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758384Ab0LCKwS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 05:52:18 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64900 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757129Ab0LCKwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 05:52:16 -0500
Subject: Re: [PATCH 1/2] Change the register name definitions for mc13783
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Yong Shen <yong.shen@linaro.org>, Sascha Hauer <s.hauer@pengutronix.de>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: List Linux Arm Kernel <linux-arm-kernel@lists.infradead.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
In-Reply-To: <AANLkTinA-rNzSjGZQSmGUdOt8j0RWddfNo5m=fP2oQx8@mail.gmail.com>
References: <AANLkTinA-rNzSjGZQSmGUdOt8j0RWddfNo5m=fP2oQx8@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 03 Dec 2010 10:52:11 +0000
Message-ID: <1291373531.3271.8.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-02 at 19:18 +0800, Yong Shen wrote:
> Hi there,
> 
> Please comment inline and use attached file for patch or test.
> 
> Thanks
> Yong
> 
> >From e112153c6f03b49c229a8e3913a0c0459245df20 Mon Sep 17 00:00:00 2001
> From: Yong Shen <yong.shen@linaro.org>
> Date: Thu, 2 Dec 2010 14:17:02 +0800
> Subject: [PATCH 1/2] Change the register name definitions for mc13783
> 
> To make mc13783 and mc13892 share code, the register names should be
> changed to fit the new macro definitions in the comming patch.
> 
> Signed-off-by: Yong Shen <yong.shen@linaro.org>
> ---
>  arch/arm/mach-imx/mach-pcm038.c       |    4 +-
>  arch/arm/mach-mx3/mach-mx31_3ds.c     |    4 +-
>  arch/arm/mach-mx3/mach-mx31moboard.c  |    4 +-
>  drivers/regulator/mc13783-regulator.c |   30 +++++++-------
>  include/linux/mfd/mc13783.h           |   67 +++++++++++++++++----------------
>  5 files changed, 55 insertions(+), 54 deletions(-)

Sascha, Samuel, this series touches some of mach-imx and mfd. I can take
via regulator if that's OK with you guys ?

Thanks

Liam

-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

