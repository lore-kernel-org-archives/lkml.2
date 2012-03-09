Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab2CIMQN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 07:16:13 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:18566 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754796Ab2CIMQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 07:16:11 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 09 Mar 2012 04:16:01 -0800
Message-ID: <4F59F3D3.9050103@nvidia.com>
Date: Fri, 9 Mar 2012 17:43:07 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Margarita Olaya Cabrera <magi@slimlogic.co.uk>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: Re: [PATCH] regulator: Rename set_voltage_sel callback function name
 to *_sel
References: <1331259740.6239.4.camel@phoenix>
In-Reply-To: <1331259740.6239.4.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 March 2012 07:52 AM, Axel Lin wrote:
> This change improves readability.
>
> Signed-off-by: Axel Lin<axel.lin@gmail.com>
> ---
>   drivers/regulator/tps65910-regulator.c |   16 +++++++++-------
>   drivers/regulator/tps65912-regulator.c |   12 ++++++------
>   2 files changed, 15 insertions(+), 13 deletions(-)
>
Acked-by: Laxman Dewangan <ldewangan@nvidia.com>

