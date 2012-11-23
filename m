Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751424Ab2KWFZB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 00:25:01 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1873 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778Ab2KWFZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 00:25:00 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 22 Nov 2012 21:24:57 -0800
Message-ID: <50AF08A7.8060308@nvidia.com>
Date: Fri, 23 Nov 2012 10:54:55 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: tps80031: Implement list_voltage and set n_voltages
 = 1 for fixed regulators
References: <1353633954.7586.1.camel@phoenix>
In-Reply-To: <1353633954.7586.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 23 November 2012 06:55 AM, Axel Lin wrote:
> Implement list_voltage for fixed regulators, otherwise
> regulator_is_supported_voltage() returns 0.
>

This rail is used for vbus only which is 5V or 0. I don't see any use 
for using this rail for other purpose. It just need enable/disable.

But this change does not hurt anything on my usage.

Acked-by: Laxman Dewangan <ldewangan@nvidia.com>

