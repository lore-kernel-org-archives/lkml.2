Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993139Ab2K3UAz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 15:00:55 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:18016 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933615Ab2K3UAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 15:00:53 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 30 Nov 2012 12:00:24 -0800
Message-ID: <50B91070.9080708@nvidia.com>
Date: Sat, 1 Dec 2012 01:30:48 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: tps51632: Ensure [base|max]_voltage_uV pdata
 settings are valid
References: <1354265569.3859.1.camel@phoenix>
In-Reply-To: <1354265569.3859.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 30 November 2012 02:22 PM, Axel Lin wrote:
> If pdata->base_voltage_uV is missing or the settings of pdata->base_voltage_uV
> and pdata->max_voltage_uV are out of range, TPS51632_VOLT_VSEL macro
> returns wrong vsel.
>
> Thus add checking [base|max]_voltage_uV pdata settings in probe.
>

Looks good.

Acked-by: Laxman Dewangan <ldewangan@nvidia.com>


