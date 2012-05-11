Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759791Ab2EKNWT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 09:22:19 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:19072 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758847Ab2EKNV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 09:21:56 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 11 May 2012 06:21:04 -0700
Message-ID: <4FAD1188.7000706@nvidia.com>
Date: Fri, 11 May 2012 18:48:00 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
CC: "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "jedu@slimlogic.co.uk" <jedu@slimlogic.co.uk>,
        "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] mfd:tps65910: use devm_* and register gpio as platform
 driver
References: <1336569057-3890-1-git-send-email-ldewangan@nvidia.com> <20120511131454.GI1214@sortiz-mobl>
In-Reply-To: <20120511131454.GI1214@sortiz-mobl>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 May 2012 06:44 PM, Samuel Ortiz wrote:
> Hi Laxman,
>
> On Wed, May 09, 2012 at 06:40:53PM +0530, Laxman Dewangan wrote:
>> This series does cleanup in the mfd/tps65910 as follows:
>> - Do not cache the register when initailizing regmap. Cache when
>>    actually when we need it.
>> - Convert the allocation to use devm_* apis.
>> - Move the gpio as platform driver and register it as mfd sub devices.
>>
>> Laxman Dewangan (4):
>>    mfd: tps65910: cache register when we need it
>> 	Remove the chaching of register in regmap initialization.
>>
>>    mfd: tps65910: convert all allocation to devm_*
>> 	Convert the allocation to use devm_* apis.
>>
>>    mfd: tps65910: register gpio as mfd device
>>    gpio: tps65910: move this as platform driver
>> 	Above two patch to make gpio driver as platform driver and register
>> 	as mfd sub device from core driver.
>> 	
> I applied patches 1, 2 and 3. Patch #4 does not apply cleanly to my for-next
> branch, could you please rebase it ?
> Also, having Grant's ACK for it would be nice.
Thanks for taking care.
I will create a new patch based on your tree if Grant is OK with this.
