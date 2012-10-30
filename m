Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934483Ab2J3U2f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 16:28:35 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:61901 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932221Ab2J3U2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 16:28:33 -0400
MIME-Version: 1.0
In-Reply-To: <1BAFE6F6C881BF42822005164F1491C33EAB8596@DBDE01.ent.ti.com>
References: <1349879449-22657-1-git-send-email-mporter@ti.com>
	<1BAFE6F6C881BF42822005164F1491C33EAB8596@DBDE01.ent.ti.com>
Date: Tue, 30 Oct 2012 15:28:32 -0500
Message-ID: <CAD=GYpZ9w=D55G9DOiMqZ4BCGGdGszsgG3fumHUGZ12xx+TKjw@mail.gmail.com>
Subject: Re: [PATCH] ARM: OMAP2+: AM33XX: clock data: fix mcasp entries
From: Joel A Fernandes <agnel.joel@gmail.com>
To: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
Cc: "Porter, Matt" <mporter@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Tony Lindgren <tony@atomide.com>,
        "Hiremath, Vaibhav" <hvaibhav@ti.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gururaja,

On Mon, Oct 29, 2012 at 10:45 AM, Hebbar, Gururaja
<gururaja.hebbar@ti.com> wrote:
> Matt,
>
> On Wed, Oct 10, 2012 at 20:00:49, Porter, Matt wrote:
>> 6ea74cb ARM: OMAP2+: hwmod: get rid of all omap_clk_get_by_name usage
>> exposes a bug in the AM33XX clock data for mcasp. After moving to
>> clk_get() usage, the _init() of all registered hwmods fails on mcasp0
>> due to incorrect clock data causing clk_get() to fail. This causes all
>> successive hwmods to fail to _init() leaving them in a bad state.
>>
>> This patch updates the mcasp clock entries so clk_get() will succeed.
>> It is tested on BeagleBone and is needed for 3.7-rc1 to fix AM33xx
>> boot.
>
>
> I want to test Audio on AM335x Evm with your EDMA patches. I have few
> patches for AM335x.
> Can you share the link to the repo & branch on which I need to rebase?
> The patches are related to mcasp dt node, mcasp pinmux in dt, etc...
>

I was wondering about the status of following patches you wrote, not
added to mainline yet:

(1)
 ASoC: Davinci: machine: Add device tree binding
https://patchwork.kernel.org/patch/1380511/  - will this be resubmitted?

(2)
ASoC: AM33XX: Add support for AM33xx SoC Audio
https://github.com/joelagnel/linux-kernel/commit/973cfb48bdb70018b3869a21595bde8630efb29d

Are you planning on sending/resending these patches again? I could do this too.

I guess all other audio patches except for audio dts stuff is already in.

Thanks,
Joel
