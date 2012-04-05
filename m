Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441Ab2DEHH7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 03:07:59 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16785 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458Ab2DEHHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 03:07:46 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 05 Apr 2012 00:07:40 -0700
Message-ID: <4F7D4279.4090906@nvidia.com>
Date: Thu, 5 Apr 2012 12:28:01 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 1/2] regulator: rc5t583: Remove nsteps from struct rc5t583_regulator_info
References: <1333605888.18055.1.camel@phoenix>
In-Reply-To: <1333605888.18055.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 April 2012 11:34 AM, Axel Lin wrote:
> The nsteps can be calculated by (_max_mv - _min_mv) * 1000 / _step_uV + 1,
> thus we can remove _nsteps from RC5T583_REG macro, and then remove
> nsteps from struct rc5t583_regulator_info.
>
> Signed-off-by: Axel Lin<axel.lin@gmail.com>
> ---

Acked-by: Laxman Dewangan <ldewangan@nvidia.com>
