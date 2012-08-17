Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758777Ab2HQSSe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 14:18:34 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:17836 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758728Ab2HQSS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 14:18:27 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Fri, 17 Aug 2012 11:18:26 -0700
Message-ID: <502E86C1.4000800@nvidia.com>
Date: Fri, 17 Aug 2012 23:30:33 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "olof@lixom.net" <olof@lixom.net>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "lrg@ti.com" <lrg@ti.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "vinod.koul@linux.intel.com" <vinod.koul@linux.intel.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Subject: Re: [PATCH 1/5] ARM: tegra: config: enable dmaengine based APB DMA
 driver
References: <1345126397-28864-1-git-send-email-ldewangan@nvidia.com> <1345126397-28864-2-git-send-email-ldewangan@nvidia.com> <502D33B6.7070103@wwwdotorg.org> <502DE6FE.8040200@nvidia.com> <502E60A3.1020405@wwwdotorg.org> <502E80BA.5020409@wwwdotorg.org>
In-Reply-To: <502E80BA.5020409@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 August 2012 11:04 PM, Stephen Warren wrote:
> On 08/17/2012 09:17 AM, Stephen Warren wrote:
>> On 08/17/2012 12:38 AM, Laxman Dewangan wrote:
>>> On Thursday 16 August 2012 11:23 PM, Stephen Warren wrote:
>>>> On 08/16/2012 08:13 AM, Laxman Dewangan wrote:
>>>>> Enable config for dmaengine based Tegra APB DMA driver and
>>>>> disable the legacy APB DMA driver (SYSTEM_DMA).
>>>> Laxman, if I apply this series to next-20120816 (plus a few patches in
>>>> my local work branch plus the CPU hotplug patches from Joseph, although
>>>> I suspect none of that matters), then audio playback on Tegra20 is
>>>> broken; the pitch is far too high. Audio playback on Tegra30 works as
>>>> expected.
>>> I run the test again on ventana and did not see any issue.
>>> I play one song and saw similar behavior with/without this series.
>> OK, I'll test some other boards. I tested Whistler, although all the
>> clocking logic is identical between all Tegra20 boards.
> I tested both 3.6-rc2 and next-20120816, and they both work fine on Ventana.
>
> I then applied this patch series to both (plus your "dma: tegra:
> enable/disable dma clock" for 3.6-rc2) and it causes (or at least
> exposes) the problem.
>
> All testing was with a full git clean, using tegra_defconfig, and with
> no other patches applied.
>
> If you're not seeing this problem, are you sure you're executing the
> kernel you think you are, and that it got correctly switched to the new
> dmaengine driver, and rebuilt after applying your patches?

I generally clean, remove .config and then generate .config , build and 
test whenever any branch change or want to remove any change. I tested 
in next-20120816.
Let me take help from other team member for test it if I am missing 
anything here.

