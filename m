Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297Ab2DFFng (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 01:43:36 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5163 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742Ab2DFFnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 01:43:35 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 05 Apr 2012 22:43:31 -0700
Message-ID: <4F7E8030.80000@nvidia.com>
Date: Fri, 6 Apr 2012 11:03:36 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] regulator: rc5t583: Simplify RC5T583_REG macro
References: <1333670496.2777.0.camel@phoenix>
In-Reply-To: <1333670496.2777.0.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 April 2012 05:31 AM, Axel Lin wrote:
> Simplify RC5T583_REG macro by removing _vout_reg and _ds_reg parameters.
>
> The naming for vout_reg and deepsleep_reg can be replaced by:
> .vout_reg       = RC5T583_REG_##_id##DAC,
> .deepsleep_reg  = RC5T583_REG_##_id##DAC_DS,
>
> Signed-off-by: Axel Lin<axel.lin@gmail.com>
> ---

Acked-by: Laxman Dewangan <ldewangan@nvidia.com>

I thought of doing this on my first patch and then thought that table 
should have all configuration picture rather than deriving  from few 
parameters.
If this is a good way then I will take care for my next PMIC driver 
development.

Thanks,
Laxman
