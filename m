Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283Ab2ENFez (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 01:34:55 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:19942 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607Ab2ENFey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 01:34:54 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sun, 13 May 2012 22:34:49 -0700
Message-ID: <4FB09879.5010906@nvidia.com>
Date: Mon, 14 May 2012 11:00:33 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH RFT 1/2] regulator: tps62360: Convert to regulator_list_voltage_linear()
References: <1336965942.24732.14.camel@phoenix>
In-Reply-To: <1336965942.24732.14.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 May 2012 08:55 AM, Axel Lin wrote:
> Signed-off-by: Axel Lin<axel.lin@gmail.com>
> ---
>   drivers/regulator/tps62360-regulator.c |   20 ++++++--------------
>   1 files changed, 6 insertions(+), 14 deletions(-)

Acked-by: Laxman Dewangan <ldewangan@nvidia.com>
