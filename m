Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778Ab2IFLy5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 07:54:57 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:18216 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792Ab2IFLy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 07:54:56 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 06 Sep 2012 04:47:43 -0700
Message-ID: <50488975.2000009@nvidia.com>
Date: Thu, 6 Sep 2012 17:01:01 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "lrg@ti.com" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] regulator: tps6586x: register regulator even if no
 init data
References: <1346252473-30068-1-git-send-email-ldewangan@nvidia.com> <504668E3.1060907@wwwdotorg.org> <5047072F.5030702@nvidia.com> <504770AD.8060103@wwwdotorg.org>
In-Reply-To: <504770AD.8060103@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 September 2012 09:03 PM, Stephen Warren wrote:
> On 09/05/2012 02:02 AM, Laxman Dewangan wrote:
>> On Wednesday 05 September 2012 02:17 AM, Stephen Warren wrote:
>>> On 08/29/2012 09:01 AM, Laxman Dewangan wrote:
>>>> Register all TPS6586x regulators even if there is no regulator
>>>> init data for platform i.e. without any user-supplied constraints.
>>>>
>>>> Signed-off-by: Laxman Dewangan<ldewangan@nvidia.com>
>>> Tested-by: Stephen Warren<swarren@nvidia.com>
>>>
>>> Note that this patch depends on the patch I just posted titled
>>> "regulator: tps6586x: add support for SYS rail". I also believe Laxman
>>> will be posting another patch based on these 2 soon (it will move the
>>> regulator DT parsing out of the MFD driver into the regulator driver),
>>> so I guess it makes sense to take them all through the same TPS6586x
>>> topic branch in the regulator tree.
>> About next patch (moving regulator dt parsing out of mfd), do you want
>> to support the Harmony also?
>> If yes then same change should also contain the board-harmony-power.c
>> changes.
> Yes, Harmony needs to continue working.
>
> We can either:
>
> a) Add your third patch to the TPS6586x topic branch in the regulator
> tree, and I'll merge all 3 into the Tegra tree in order to build on it
> and switch the regulators to DT.
>
> b) You can wait to submit your third patch until after the 3.7 merge
> window (i.e. send if for 3.8) since then all the dependencies will have
> appeared in Linus's tree as a baseline. This is probably the simplest.

I will go with option (b) as this is just enhancement and not any 
critical bug fixes.

