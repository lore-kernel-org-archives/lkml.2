Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759993Ab2FGKpU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 06:45:20 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:13964 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754730Ab2FGKpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 06:45:19 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 07 Jun 2012 03:45:13 -0700
Message-ID: <4FD0845B.7060406@nvidia.com>
Date: Thu, 7 Jun 2012 16:07:15 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] regulator: rc5t583: Simplify rc5t583_set_voltage_time_sel
 implementation
References: <1339058289.5274.0.camel@phoenix>
In-Reply-To: <1339058289.5274.0.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 June 2012 02:08 PM, Axel Lin wrote:
> For linear mappings, we can use below equation to get the voltage difference
> between new_selector and old_selector:
>
> abs(new_selector - old_selector) * rdev->desc->uV_step

Acked-by: Laxman Dewangan <ldewangan@nvidia.com>

Looks good to me.
