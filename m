Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759010Ab2J3Ktl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 06:49:41 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3514 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758147Ab2J3Ktk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 06:49:40 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 30 Oct 2012 03:49:38 -0700
Message-ID: <508FB063.70206@nvidia.com>
Date: Tue, 30 Oct 2012 16:18:03 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>
CC: "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] mfd: Convert tps6586x to irq_domain
References: <1349712805-10014-1-git-send-email-ldewangan@nvidia.com> <1349712805-10014-2-git-send-email-ldewangan@nvidia.com> <20121009060641.GE8237@opensource.wolfsonmicro.com> <5073BAA8.4060404@nvidia.com> <20121009062355.GJ8237@opensource.wolfsonmicro.com> <5073BE7F.5060107@nvidia.com> <20121009064011.GQ8237@opensource.wolfsonmicro.com>
In-Reply-To: <20121009064011.GQ8237@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark/Samuel,
There is one more change for doing cleanups in regulator parsing where I 
moved the regulator parsing from mfd to regulator driver:
[PATCH] mfd: tps6586x: move regulator dt parsing to regulator driver

Although this series and above change is independent but I like to go 
these in same branch to avoid the merge conflict.

If this is fine to go in same branch theb I can create a new series of 
these 3 changes and above change.
These series is already reviewed by Mark.

Please let me know your opinion.


Thanks,
Laxman

On Tuesday 09 October 2012 12:10 PM, Mark Brown wrote:
> On Tue, Oct 09, 2012 at 11:34:47AM +0530, Laxman Dewangan wrote:
>
>> The bit definitions are also different in status and mask register
>> and yes, this will be again problem as we do in isr thread
>>   data->status_buf[i]&= ~data->mask_buf[i];
>> So given the constraint, generic will not work here.
> OK, that's a good reason not to use the generic code.

