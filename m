Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183Ab2KAH7A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 03:59:00 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:7968 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992Ab2KAH66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 03:58:58 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 01 Nov 2012 00:58:56 -0700
Message-ID: <50922B5A.9050601@nvidia.com>
Date: Thu, 1 Nov 2012 13:27:14 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: Fix trivial typo for TPS51632 Kconfig help
 text
References: <1351749756.3695.2.camel@phoenix>
In-Reply-To: <1351749756.3695.2.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 November 2012 11:32 AM, Axel Lin wrote:
> Signed-off-by: Axel Lin<axel.lin@ingics.com>
>
>   	help
>   	  This driver supports TPS51632 voltage regulator chip.
> -	  The TPS52632 is 3-2-1 Phase D-Cap+ Step Down Driverless Controller
> +	  The TPS51632 is 3-2-1 Phase D-Cap+ Step Down Driverless Controller
Ooh no, silly typo.

Acked-by: Laxman Dewangan <ldewangan@nvidia.com>
