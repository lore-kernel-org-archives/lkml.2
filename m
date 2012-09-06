Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757577Ab2IFPQt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 11:16:49 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:54941 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757162Ab2IFPQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 11:16:48 -0400
Message-ID: <5048BE4A.1000603@ti.com>
Date: Thu, 6 Sep 2012 17:16:26 +0200
From: Benoit Cousson <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Omar Ramirez Luna <omar.luna@linaro.org>
CC: Paul Walmsley <paul@pwsan.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, Kevin Hilman <khilman@ti.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Omar Ramirez Luna <omar.ramirez@ti.com>
Subject: Re: [PATCH 0/2] OMAP: hwmod: fix hardreset handling
References: <1345614150-25723-1-git-send-email-omar.luna@linaro.org> <CALLhW=4GNagMQgn+W8muLz__sSRv6ZOt_FvzXHLcaQzw3N_3yg@mail.gmail.com>
In-Reply-To: <CALLhW=4GNagMQgn+W8muLz__sSRv6ZOt_FvzXHLcaQzw3N_3yg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Omar,

On 09/03/2012 04:29 PM, Omar Ramirez Luna wrote:
> On 22 August 2012 00:42, Omar Ramirez Luna <omar.luna@linaro.org> wrote:
>> From: Omar Ramirez Luna <omar.ramirez@ti.com>
>>
>> The patch to expose hwmod assert/deassert functions through omap_device
>> has been accepted and queued for 3.7[1], however these two patches are
>> needed to make the API functional. Hence a revised version is being sent
>> according to previous comments:
>>
>> - ARM: OMAP: hwmod: revise deassert sequence
>> Now it uses enable|disable_module to handle the configuration of the
>> modulemode inside CLKCTRL. As part of the cleanup of leaf clocks, the
>> one associated with ipu_mmu will be removed along with the iommu hwmod
>> migration[2].
>>
>> - ARM: OMAP: hwmod: partially un-reset hwmods might not be properly
>>   enabled
>> More infomation added in the patch description[3].
>>
>> [1] http://patchwork.kernel.org/patch/1266731/
>> [2] http://patchwork.kernel.org/patch/1201791/
>> [3] http://patchwork.kernel.org/patch/1201801/
>>
>> Omar Ramirez Luna (2):
>>   ARM: OMAP: hwmod: partially un-reset hwmods might not be properly
>>     enabled
>>   ARM: OMAP: hwmod: revise deassert sequence
>>
>>  arch/arm/mach-omap2/omap_hwmod.c |   74 ++++++++++++++++++++++++++++++--------
>>  1 file changed, 59 insertions(+), 15 deletions(-)
> 
> Ping.

Oops, sorry, I forgot your series.

Beside the concern about the duplication of code, that looks good to me.

I'll sync with Paul to see who will push that series.

Regards,
Benoit

