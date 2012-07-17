Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572Ab2GQEhE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 00:37:04 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:2446 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab2GQEhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 00:37:01 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 16 Jul 2012 21:37:00 -0700
Message-ID: <5004E9FD.4030302@nvidia.com>
Date: Tue, 17 Jul 2012 09:58:45 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH V2 3/6] mfd: tps6586x: cache register through regmap
References: <1342421510-10638-1-git-send-email-ldewangan@nvidia.com> <1342421510-10638-4-git-send-email-ldewangan@nvidia.com> <20120716200302.GF10774@opensource.wolfsonmicro.com>
In-Reply-To: <20120716200302.GF10774@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 July 2012 01:33 AM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
> On Mon, Jul 16, 2012 at 12:21:47PM +0530, Laxman Dewangan wrote:
>> To cache the interrupt mask register, use the regmap RB_TREE
>> cache-ing mechanism in place of implementing it locally.
> Reviewed-by: Mark Brown<broonie@opensource.wolfsonmicro.com>
>
> Can you use regmap-irq?
>
Sure, I will convert it to regmap_irq and will send new patch after this 
series in linux-next.
Thanks,
Laxman
