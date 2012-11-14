Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332Ab2KNPqJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 10:46:09 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:2852 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754316Ab2KNPqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 10:46:06 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 14 Nov 2012 07:46:03 -0800
Message-ID: <50A3BCB8.50000@nvidia.com>
Date: Wed, 14 Nov 2012 21:16:00 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
CC: "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND 0/3] mfd: tps6586x: Convert to irq domain
References: <1352814487-25886-1-git-send-email-ldewangan@nvidia.com> <20121113190419.GP27828@sortiz-mobl>
In-Reply-To: <20121113190419.GP27828@sortiz-mobl>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 November 2012 12:34 AM, Samuel Ortiz wrote:
> Hi Laxman,
>
> On Tue, Nov 13, 2012 at 07:18:04PM +0530, Laxman Dewangan wrote:
>> This patch series convert the irq implementation to use the
>> irq domain.
>> Accordingly, gpio driver and rtc registration is updated.
>>
>> Reposting the series and adding the reviwed by Mark and acked by Linus W
>> for the respective patches.
> Thanks for the repost and for adding the reviewers and ackers name.
> This patchset is applied to my for-next branch.
Thank you very much for taking care. This will enable us to add rtc 
support in our platform.

Thanks,
Laxman
