Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286Ab2K2TZA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 14:25:00 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:6192 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab2K2TY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 14:24:59 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 29 Nov 2012 11:24:55 -0800
Message-ID: <50B7B686.4010700@nvidia.com>
Date: Fri, 30 Nov 2012 00:54:54 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: "Kim, Milo" <Milo.Kim@ti.com>
CC: Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] mfd: tps65910: fix wrong ack_base register
References: <A874F61F95741C4A9BA573A70FE3998F6418F154@DQHE02.ent.ti.com>
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F6418F154@DQHE02.ent.ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 November 2012 12:12 PM, Kim, Milo wrote:
>   The interrupt status registers of TPS65910/1 should be cleared
>   when the associated interrupt event occurs.
>   This work is done in the regmap irq thread - using 'ack_base' register.
>   The ACK registers should be fixed as status register, not mask registers.
>
>   This patch fixes the infinite interrupt event problem by clearing
>   interrupt status registers.
>
>   Tested on the AM3517 Craneboard.
>
> Signed-off-by: Milo(Woogyom) Kim<milo.kim@ti.com>
> ---

Aah,  I was debugging the onkey and I am also seeing continuous 
interrupt. This fix the issue.
Thanks,
Acked-by: Laxman Dewangan <ldewangan@nvidia.com>

