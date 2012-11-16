Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751249Ab2KPHPa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 02:15:30 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4677 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765Ab2KPHP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 02:15:29 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 15 Nov 2012 23:15:23 -0800
Message-ID: <50A5E805.7060509@nvidia.com>
Date: Fri, 16 Nov 2012 15:15:17 +0800
From: Mark Zhang <markz@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: "airlied@redhat.com" <airlied@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH] drm: Add NVIDIA Tegra30 support
References: <1353041889-3114-1-git-send-email-markz@nvidia.com> <20121116064331.GA21671@avionic-0098.mockup.avionic-design.de> <50A5E1D7.7020902@nvidia.com> <20121116071129.GB21837@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20121116071129.GB21837@avionic-0098.mockup.avionic-design.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2012 03:11 PM, Thierry Reding wrote:
> * PGP Signed by an unknown key
> 
> On Fri, Nov 16, 2012 at 02:48:55PM +0800, Mark Zhang wrote:
>> On 11/16/2012 02:43 PM, Thierry Reding wrote:
>>>> Old Signed by an unknown key
>>>
>>> On Fri, Nov 16, 2012 at 12:58:09PM +0800, Mark Zhang wrote:
>>>> This patch is based on Thierry's drm patch for Tegra20:
>>>> - [PATCH v2 0/6] Device tree updates for host1x support
>>>> - [PATCH v3 0/2] NVIDIA Tegra DRM driver
>>>>
>>>> It adds the support for NVIDIA Tegra30.
>>>>
>>>> Signed-off-by: Mark Zhang <markz@nvidia.com>
>>>
>>> Hi Mark,
>>>
>>> I already carry a similar patch in my tegra/next branch and was going to
>>> post that once I get word back that tegra-drm actually works on Tegra30.
>>>
>>
>> Sorry for that. Actually I didn't sync your tree yet.
>>
>>> You do have the hardware available, right? Did you test this patch on
>>> top of the latest (v3) tegra-drm patches and arch/arm/mach-tegra (v2)
>>> patches I sent a few hours ago?
>>>
>>
>> Yes, I have a cardhu here. Yes, I made this patch on top of your v3 & v2
>> patches and it worked on my cardhu.
> 
> Okay, that's great! The reason I wanted this to be tested again
> explicitly is that I've made some minor modifications to bring the
> Tegra30 code more in line with the Tegra20 code where clock setup is
> concerned.
> 
> Since everything works for you on Tegra30, I'll push the Tegra30 related
> patches into the branch that David will pull from.
> 

Great. Thanks! Hope to see the display of Tegra 2 and Tegra 3 works in
kernel 3.8.

> Thierry
> 
> * Unknown Key
> * 0x7F3EB3A1
> 
