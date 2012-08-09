Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758186Ab2HINIP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 09:08:15 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16683 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310Ab2HINIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 09:08:14 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 09 Aug 2012 06:08:13 -0700
Message-ID: <5023B2A4.6020808@nvidia.com>
Date: Thu, 9 Aug 2012 18:22:52 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Stephen Warren <swarren@wwwdotorg.org>, Liam Girdwood <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Gyungoh Yoo <jack.yoo@maxim-ic.com>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH V2 3/3] regulator: add MAX8907 driver
References: <1344460727-6243-1-git-send-email-swarren@wwwdotorg.org> <1344460727-6243-3-git-send-email-swarren@wwwdotorg.org> <5023AAE5.90603@nvidia.com> <20120809123838.GP24328@opensource.wolfsonmicro.com> <5023AC97.60409@nvidia.com> <20120809130025.GQ24328@opensource.wolfsonmicro.com>
In-Reply-To: <20120809130025.GQ24328@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 August 2012 06:30 PM, Mark Brown wrote:
> On Thu, Aug 09, 2012 at 05:57:03PM +0530, Laxman Dewangan wrote:
>> On Thursday 09 August 2012 06:08 PM, Mark Brown wrote:
>>> The driver should just register all the regulators the chip has, it's
>>> useful for diagnostic purposes if nothing else.
>> Then probably we need to update our dts file becasue we left some of
>> regualtor entry as it is not used on design.
> Why would this impact the device tree?

If entry is not there in dts file then init_data will be null for that 
regulator.
I was thinking that if we dont provide the valid init_data at the time 
of regulator_registration, it will fail but going through the 
regulator_register() in core  it seems it is not mandatory to have valid 
init_data. So even if we call regulator_register() with init_data=NULL 
will be success.

So the checks for the init data is not require here.

I am acking it..

Acked-by: Laxman Dewangan <ldewangan@nvidia.com>



