Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932461Ab0LCLUd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 06:20:33 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:64362 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932435Ab0LCLUc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 06:20:32 -0500
MIME-Version: 1.0
In-Reply-To: <1291373531.3271.8.camel@odin>
References: <AANLkTinA-rNzSjGZQSmGUdOt8j0RWddfNo5m=fP2oQx8@mail.gmail.com>
	<1291373531.3271.8.camel@odin>
Date: Fri, 3 Dec 2010 19:20:31 +0800
Message-ID: <AANLkTinVZ3uM8S38Ug-pa1-1wCbem-ddsHmdOMLvtPhi@mail.gmail.com>
Subject: Re: [PATCH 1/2] Change the register name definitions for mc13783
From: Yong Shen <yong.shen@linaro.org>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
        Samuel Ortiz <sameo@linux.intel.com>,
        List Linux Arm Kernel <linux-arm-kernel@lists.infradead.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Liam,

If it is you take these two patches, please help add "Acked-by: Mark
Brown <broonie@opensource.wolfsonmicro.com>" in the commit, or you
prefer I send out updated ones for this.

Thanks
Yong

On Fri, Dec 3, 2010 at 6:52 PM, Liam Girdwood <lrg@slimlogic.co.uk> wrote:
> On Thu, 2010-12-02 at 19:18 +0800, Yong Shen wrote:
>> Hi there,
>>
>> Please comment inline and use attached file for patch or test.
>>
>> Thanks
>> Yong
>>
>> >From e112153c6f03b49c229a8e3913a0c0459245df20 Mon Sep 17 00:00:00 2001
>> From: Yong Shen <yong.shen@linaro.org>
>> Date: Thu, 2 Dec 2010 14:17:02 +0800
>> Subject: [PATCH 1/2] Change the register name definitions for mc13783
>>
>> To make mc13783 and mc13892 share code, the register names should be
>> changed to fit the new macro definitions in the comming patch.
>>
>> Signed-off-by: Yong Shen <yong.shen@linaro.org>
>> ---
>>  arch/arm/mach-imx/mach-pcm038.c       |    4 +-
>>  arch/arm/mach-mx3/mach-mx31_3ds.c     |    4 +-
>>  arch/arm/mach-mx3/mach-mx31moboard.c  |    4 +-
>>  drivers/regulator/mc13783-regulator.c |   30 +++++++-------
>>  include/linux/mfd/mc13783.h           |   67 +++++++++++++++++----------------
>>  5 files changed, 55 insertions(+), 54 deletions(-)
>
> Sascha, Samuel, this series touches some of mach-imx and mfd. I can take
> via regulator if that's OK with you guys ?
>
> Thanks
>
> Liam
>
> --
> Freelance Developer, SlimLogic Ltd
> ASoC and Voltage Regulator Maintainer.
> http://www.slimlogic.co.uk
>
>
