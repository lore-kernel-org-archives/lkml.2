Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751Ab2BGJIR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 04:08:17 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:2353 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756725Ab2BGJIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 04:08:14 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 07 Feb 2012 01:08:08 -0800
Message-ID: <4F30E99E.9080503@nvidia.com>
Date: Tue, 7 Feb 2012 14:36:38 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] regulator: tps62360: Remove pointless test for unsigned
 less than zero
References: <1328583980.5528.1.camel@phoenix>
In-Reply-To: <1328583980.5528.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 February 2012 08:36 AM, Axel Lin wrote:
> The variable 'selector' is a 'unsigned int', so it can never be less than zero.
>
> Signed-off-by: Axel Lin<axel.lin@gmail.com>
> ---
>

Looks good, Thanks
Acked-by: Laxman Dewangan <ldewangan@nvidia.com>

Laxman
