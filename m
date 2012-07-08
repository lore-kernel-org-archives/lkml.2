Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592Ab2GHJSp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 05:18:45 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:7019 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab2GHJSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 05:18:43 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Sun, 08 Jul 2012 02:18:41 -0700
Message-ID: <4FF94F24.5050106@nvidia.com>
Date: Sun, 8 Jul 2012 14:43:08 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: tps62360: Convert to devm_gpio_request_one
References: <1341620913.3153.1.camel@phoenix>
In-Reply-To: <1341620913.3153.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 07 July 2012 05:58 AM, Axel Lin wrote:
> Use devm_gpio_request_one to save a few error handling code.
> Also remove trivial comment for tps62360_remove.
>
> Signed-off-by: Axel Lin<axel.lin@gmail.com>
> ---

Acked-by: Laxman Dewangan <ldewangan@nvidia.com>

This same as earlier patch.
[PATCH] regulator: tps62360: use devm_* for gpio request
