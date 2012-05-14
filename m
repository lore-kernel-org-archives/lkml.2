Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756398Ab2ENQku (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 12:40:50 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19777 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755466Ab2ENQks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 12:40:48 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 14 May 2012 09:40:42 -0700
Message-ID: <4FB13486.8020303@nvidia.com>
Date: Mon, 14 May 2012 22:06:22 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH RFT 1/2] regulator: rc5t583: Convert to regulator_list_voltage_linear()
References: <1336964086.24732.7.camel@phoenix>
In-Reply-To: <1336964086.24732.7.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 May 2012 08:24 AM, Axel Lin wrote:
> Signed-off-by: Axel Lin<axel.lin@gmail.com>
> ---
>   drivers/regulator/rc5t583-regulator.c |   28 +++++++++-------------------
>   1 files changed, 9 insertions(+), 19 deletions(-)
>
Acked-by: Laxman Dewangan <ldewangan@nvidia.com>

Looks fine to me.

Thanks,
Laxman
