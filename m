Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761297Ab2FVF6E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 01:58:04 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6561 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761246Ab2FVF6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 01:58:02 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 21 Jun 2012 22:57:56 -0700
Message-ID: <4FE4093D.4070704@nvidia.com>
Date: Fri, 22 Jun 2012 11:27:17 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 1/2] regulator: tps65910: Remove unused min_uV and max_uV
 from struct tps_info
References: <1340275546.2922.1.camel@phoenix>
In-Reply-To: <1340275546.2922.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 June 2012 04:15 PM, Axel Lin wrote:
> The min_uV and max_uV fields of struct tps_info are not used in the code.
> For the case voltage_table is provided, the min_uV and max_uV are the same
> values as volt_table[0] and volt_table[n_voltages -1].
> For the case voltage_table is not available, having the min_uV and max_uV seems
> misleading. Current code uses equations to get the voltage value in this case,
> but these equations do not use the min_uV and max_uV fields of struct tps_info.
>
> Thus this patch removes the min_uV and max_uV fields from struct tps_info.
>
> Signed-off-by: Axel Lin<axel.lin@gmail.com>
> ---
Acked-by: Laxman Dewangan <ldewangan@nvidia.com>

