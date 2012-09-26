Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758105Ab2IZSSl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 14:18:41 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:27675 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757739Ab2IZSSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 14:18:39 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6847"; a="241506874"
Message-ID: <506346ED.3020900@codeaurora.org>
Date: Wed, 26 Sep 2012 11:18:21 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Pankaj Jangra <jangra.pankaj9@gmail.com>
CC: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Saravana Kannan <skannan@codeaurora.org>
Subject: Re: [PATCH 07/10] ARM: msm: Remove clock-7x30.h include file
References: <1348194419-11486-1-git-send-email-sboyd@codeaurora.org> <1348194419-11486-8-git-send-email-sboyd@codeaurora.org> <CADTbHxqrPmnOHqqYyskC32bN269k-_pgk-+czwf7zLCs70ESzA@mail.gmail.com>
In-Reply-To: <CADTbHxqrPmnOHqqYyskC32bN269k-_pgk-+czwf7zLCs70ESzA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/12 10:51, Pankaj Jangra wrote:
> On Fri, Sep 21, 2012 at 7:56 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>> diff --git a/arch/arm/mach-msm/devices-msm7x30.c b/arch/arm/mach-msm/devices-msm7x30.c
>> index 09b4f14..1597d43 100644
>> --- a/arch/arm/mach-msm/devices-msm7x30.c
>> +++ b/arch/arm/mach-msm/devices-msm7x30.c
>> @@ -146,7 +146,6 @@ struct clk_lookup msm_clocks_7x30[] = {
>>         CLK_PCOM("grp_2d_pclk", GRP_2D_P_CLK,   NULL, 0),
>>         CLK_PCOM("grp_clk",     GRP_3D_CLK,     NULL, 0),
>>         CLK_PCOM("grp_pclk",    GRP_3D_P_CLK,   NULL, 0),
>> -       CLK_7X30S("grp_src_clk", GRP_3D_SRC_CLK, GRP_3D_CLK,    NULL, 0),
>>         CLK_PCOM("hdmi_clk",    HDMI_CLK,       NULL, 0),
>>         CLK_PCOM("imem_clk",    IMEM_CLK,       NULL, OFF),
> I suppose you forget to remove the include header clock-7x30.h from
> this file. :)

Thanks, fixed. BTW, you could have trimmed this mail down so I didn't
have to scroll to the bottom.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

