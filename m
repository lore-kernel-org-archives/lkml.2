Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897Ab1JKFsX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 01:48:23 -0400
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:45585 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750918Ab1JKFsV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 01:48:21 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1110101835070.5205@utopia.booyaka.com>
References: <1317901123-2546-1-git-send-email-keshava_mgowda@ti.com>
	<alpine.DEB.2.00.1110101835070.5205@utopia.booyaka.com>
Date: Tue, 11 Oct 2011 11:18:20 +0530
Message-ID: <CAP05o4+Y3_-mFYdsta4DM7EfkYEq1-6psjvawN5pCWX++8jm8A@mail.gmail.com>
Subject: Re: [PATCH 2/5 v13] arm: omap: usb: ehci and ohci hwmod structures
 for omap3
From: "Munegowda, Keshava" <keshava_mgowda@ti.com>
To: Paul Walmsley <paul@pwsan.com>
Cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, balbi@ti.com, khilman@ti.com,
        b-cousson@ti.com, gadiyar@ti.com, sameo@linux.intel.com,
        parthab@india.ti.com, tony@atomide.com, johnstul@us.ibm.com,
        vishwanath.bs@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 11, 2011 at 6:08 AM, Paul Walmsley <paul@pwsan.com> wrote:
> Hi
>
> so I just noticed another problem with these hwmods:
>
> On Thu, 6 Oct 2011, Keshava Munegowda wrote:
>
>> Following 2 hwmod structures are added
>>     1. usb_host_hs
>>          The hwmod of usbhs with uhh, ehci and ohci base addresses
>>          functional clock and ehci, ohci irqs
>>
>>     2. usb_tll_hs
>>           hwmod of usbhs with the TLL base address and irq.
>>
>> Signed-off-by: Keshava Munegowda <keshava_mgowda@ti.com>
>> Reviewed-by: Partha Basak <parthab@india.ti.com>
>> ---
>>  arch/arm/mach-omap2/omap_hwmod_3xxx_data.c |  227 ++++++++++++++++++++++++++++
>>  1 files changed, 227 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
>> index 59fdb9f..b8ca690 100644
>> --- a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
>> +++ b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
>
> ...
>
>> +static struct omap_hwmod_ocp_if omap34xx_ick_cfg__usb_tll_hs = {
>
> This interface is missing a .master and .slave.  It must have both.  So,
> dropping this patch until it's fixed.
>
> Clearly we also need to modify the hwmod code needs to reject any
> instances where either .master or .slave is NULL.
>
>
> - Paul

Hi Paul
           I will fix it today only and I will send the updated
patches in couple of hours.
please help me to make it in this merge window.

Thanks and Regards
keshava
