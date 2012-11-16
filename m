Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751001Ab2KPGta (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 01:49:30 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:8263 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817Ab2KPGt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 01:49:29 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 15 Nov 2012 22:49:22 -0800
Message-ID: <50A5E1D7.7020902@nvidia.com>
Date: Fri, 16 Nov 2012 14:48:55 +0800
From: Mark Zhang <markz@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: "airlied@redhat.com" <airlied@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH] drm: Add NVIDIA Tegra30 support
References: <1353041889-3114-1-git-send-email-markz@nvidia.com> <20121116064331.GA21671@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20121116064331.GA21671@avionic-0098.mockup.avionic-design.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2012 02:43 PM, Thierry Reding wrote:
> * PGP Signed by an unknown key
> 
> On Fri, Nov 16, 2012 at 12:58:09PM +0800, Mark Zhang wrote:
>> This patch is based on Thierry's drm patch for Tegra20:
>> - [PATCH v2 0/6] Device tree updates for host1x support
>> - [PATCH v3 0/2] NVIDIA Tegra DRM driver
>>
>> It adds the support for NVIDIA Tegra30.
>>
>> Signed-off-by: Mark Zhang <markz@nvidia.com>
> 
> Hi Mark,
> 
> I already carry a similar patch in my tegra/next branch and was going to
> post that once I get word back that tegra-drm actually works on Tegra30.
>

Sorry for that. Actually I didn't sync your tree yet.

> You do have the hardware available, right? Did you test this patch on
> top of the latest (v3) tegra-drm patches and arch/arm/mach-tegra (v2)
> patches I sent a few hours ago?
> 

Yes, I have a cardhu here. Yes, I made this patch on top of your v3 & v2
patches and it worked on my cardhu.

> Thierry
> 
> * Unknown Key
> * 0x7F3EB3A1
> 
