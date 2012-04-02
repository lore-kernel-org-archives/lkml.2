Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278Ab2DBK3i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 06:29:38 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13899 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab2DBK3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 06:29:37 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 02 Apr 2012 03:29:32 -0700
Message-ID: <4F797D73.6060900@nvidia.com>
Date: Mon, 2 Apr 2012 15:50:35 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH RFT] regulator: Add support for tps62362 and tps62363
 in tps62360-regulator driver
References: <1333361968.2802.1.camel@phoenix>
In-Reply-To: <1333361968.2802.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 April 2012 03:49 PM, Axel Lin wrote:
> According to the datasheet[1], tps62360 is register compatible with tps62362.
> tps62361B is register compatible with tps62363.
> Thus this patch adds support for tps62362 and tps62363.
>
> [1] http://www.ti.com/litv/pdf/slvsau9b
>
> Signed-off-by: Axel Lin<axel.lin@gmail.com>
> ---


Acked-by: Laxman Dewangan <ldewangan@nvidia.com>

Thanks Axel for doing this. This was my todo list and was waiting for 
the board to be available for testing.
