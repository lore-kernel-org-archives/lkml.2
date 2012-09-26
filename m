Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112Ab2IZSyO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 14:54:14 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:35715 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756979Ab2IZSyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 14:54:11 -0400
MIME-Version: 1.0
In-Reply-To: <506346ED.3020900@codeaurora.org>
References: <1348194419-11486-1-git-send-email-sboyd@codeaurora.org>
	<1348194419-11486-8-git-send-email-sboyd@codeaurora.org>
	<CADTbHxqrPmnOHqqYyskC32bN269k-_pgk-+czwf7zLCs70ESzA@mail.gmail.com>
	<506346ED.3020900@codeaurora.org>
Date: Thu, 27 Sep 2012 00:24:11 +0530
Message-ID: <CADTbHxrRBg8GnciN2SyzBrQrc2Y3aXmJKbT7SZq8-QMfw4vgoA@mail.gmail.com>
Subject: Re: [PATCH 07/10] ARM: msm: Remove clock-7x30.h include file
From: Pankaj Jangra <jangra.pankaj9@gmail.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Saravana Kannan <skannan@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Sep 26, 2012 at 11:48 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> On 09/26/12 10:51, Pankaj Jangra wrote:
>> On Fri, Sep 21, 2012 at 7:56 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>>> diff --git a/arch/arm/mach-msm/devices-msm7x30.c b/arch/arm/mach-msm/devices-msm7x30.c
>>> index 09b4f14..1597d43 100644
>>> --- a/arch/arm/mach-msm/devices-msm7x30.c
>>> +++ b/arch/arm/mach-msm/devices-msm7x30.c
>>> @@ -146,7 +146,6 @@ struct clk_lookup msm_clocks_7x30[] = {
>>>         CLK_PCOM("grp_2d_pclk", GRP_2D_P_CLK,   NULL, 0),
>>>         CLK_PCOM("grp_clk",     GRP_3D_CLK,     NULL, 0),
>>>         CLK_PCOM("grp_pclk",    GRP_3D_P_CLK,   NULL, 0),
>>> -       CLK_7X30S("grp_src_clk", GRP_3D_SRC_CLK, GRP_3D_CLK,    NULL, 0),
>>>         CLK_PCOM("hdmi_clk",    HDMI_CLK,       NULL, 0),
>>>         CLK_PCOM("imem_clk",    IMEM_CLK,       NULL, OFF),
>> I suppose you forget to remove the include header clock-7x30.h from
>> this file. :)
>
> Thanks, fixed. BTW, you could have trimmed this mail down so I didn't
> have to scroll to the bottom.
>
ah, i think mistakenly i forgot. Next time will keep in mind..:)

--
Pankaj Jangra
