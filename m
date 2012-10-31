Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781Ab2JaFjk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 01:39:40 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:38356 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297Ab2JaFji convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 01:39:38 -0400
From: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
To: Joel A Fernandes <agnel.joel@gmail.com>
CC: "Porter, Matt" <mporter@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Tony Lindgren <tony@atomide.com>,
        "Hiremath, Vaibhav" <hvaibhav@ti.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: RE: [PATCH] ARM: OMAP2+: AM33XX: clock data: fix mcasp entries
Thread-Topic: [PATCH] ARM: OMAP2+: AM33XX: clock data: fix mcasp entries
Thread-Index: AQHNpvQIuOsYud0XskqrLRNTKR4CVJfQieKQgAGGRACAAPMN0A==
Date: Wed, 31 Oct 2012 05:39:27 +0000
Message-ID: <1BAFE6F6C881BF42822005164F1491C33EAB973D@DBDE01.ent.ti.com>
References: <1349879449-22657-1-git-send-email-mporter@ti.com>
	<1BAFE6F6C881BF42822005164F1491C33EAB8596@DBDE01.ent.ti.com>
 <CAD=GYpZ9w=D55G9DOiMqZ4BCGGdGszsgG3fumHUGZ12xx+TKjw@mail.gmail.com>
In-Reply-To: <CAD=GYpZ9w=D55G9DOiMqZ4BCGGdGszsgG3fumHUGZ12xx+TKjw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 01:58:32, Joel A Fernandes wrote:
> Hi Gururaja,
> 
> On Mon, Oct 29, 2012 at 10:45 AM, Hebbar, Gururaja
> <gururaja.hebbar@ti.com> wrote:
> > Matt,
> >
> > On Wed, Oct 10, 2012 at 20:00:49, Porter, Matt wrote:
> >> 6ea74cb ARM: OMAP2+: hwmod: get rid of all omap_clk_get_by_name usage
> >> exposes a bug in the AM33XX clock data for mcasp. After moving to
> >> clk_get() usage, the _init() of all registered hwmods fails on mcasp0
> >> due to incorrect clock data causing clk_get() to fail. This causes all
> >> successive hwmods to fail to _init() leaving them in a bad state.
> >>
> >> This patch updates the mcasp clock entries so clk_get() will succeed.
> >> It is tested on BeagleBone and is needed for 3.7-rc1 to fix AM33xx
> >> boot.
> >
> >
> > I want to test Audio on AM335x Evm with your EDMA patches. I have few
> > patches for AM335x.
> > Can you share the link to the repo & branch on which I need to rebase?
> > The patches are related to mcasp dt node, mcasp pinmux in dt, etc...
> >
> 
> I was wondering about the status of following patches you wrote, not
> added to mainline yet:
> 
> (1)
>  ASoC: Davinci: machine: Add device tree binding
> https://patchwork.kernel.org/patch/1380511/  - will this be resubmitted?

There was no review comments for V3 I submitted. 

> 
> (2)
> ASoC: AM33XX: Add support for AM33xx SoC Audio
> https://github.com/joelagnel/linux-kernel/commit/973cfb48bdb70018b3869a21595bde8630efb29d

I want to re-submit both the patches along with 2 more patch-set [1]. I am
waiting for Matt Porters to reply with his recent branch, so that I can do
a final test and re-submit.

[1].
arm/dts: Add tlv320aic3x codec DT data to am335x-evm.dts
arm/dts: add mcasp1 dt node to am335x-evm.dt
ASoC: davinci-mcasp: Add pinctrl support
arm/dts: AM33XX: setup pinctrl for mcasp1 on am335x-evm

I need Mark Brown's Ack for the 3rd patch. There was some discussion
about adding pinctrl support for Audio drivers. I couldn't get the final
decision taken on it. I will rebase on to brownie-asoc/for-next and submit
it today.

> 
> Are you planning on sending/resending these patches again? I could do this too.
> 
> I guess all other audio patches except for audio dts stuff is already in.
> 
> Thanks,
> Joel
> 


Regards, 
Gururaja
