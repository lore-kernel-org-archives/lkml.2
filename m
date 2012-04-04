Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238Ab2DDMQt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 08:16:49 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13150 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756047Ab2DDMQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 08:16:48 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 04 Apr 2012 05:16:43 -0700
Message-ID: <4F7C3972.2040509@nvidia.com>
Date: Wed, 4 Apr 2012 17:37:14 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] regulator: Fix rc5t583_regulator_probe error handling
References: <1333540355.5672.1.camel@phoenix>
In-Reply-To: <1333540355.5672.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 April 2012 05:22 PM, Axel Lin wrote:
> 1. regulator_register returns ERR_PTR on error, thus use IS_ERR to check the
>     return value.
> 2. Fix off-by-one for unregistering the registered regulator.
>     Current code does not unregister regs[0].rdev in clean_exit.
>
> Signed-off-by: Axel Lin<axel.lin@gmail.com>
> ---

Acked-by: Laxman  Dewangan <ldewangan@nvidia.com>
