Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538Ab2LFFeV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 00:34:21 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:15745 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980Ab2LFFeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 00:34:20 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 05 Dec 2012 21:34:20 -0800
Message-ID: <50C02E5A.8030700@nvidia.com>
Date: Thu, 6 Dec 2012 11:04:18 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
CC: Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mfd: tps80031: MFD_TPS80031 needs to select REGMAP_IRQ
References: <1354713588.14255.1.camel@phoenix>
In-Reply-To: <1354713588.14255.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 December 2012 06:49 PM, Axel Lin wrote:
> This driver uses regmap_irq APIs, thus need to select REGMAP_IRQ.
> IRQ_DOMAIN will be selected if select REGMAP_IRQ, thus remove it here.
>
> This fixes below build errors:
>
> drivers/built-in.o: In function `tps80031_remove':
> drivers/mfd/tps80031.c:534: undefined reference to `regmap_del_irq_chip'
> drivers/built-in.o: In function `tps80031_irq_init':
> drivers/mfd/tps80031.c:305: undefined reference to `regmap_add_irq_chip'
> drivers/built-in.o: In function `tps80031_probe':
> drivers/mfd/tps80031.c:496: undefined reference to `regmap_irq_get_domain'
> drivers/mfd/tps80031.c:512: undefined reference to `regmap_del_irq_chip'
> make: *** [vmlinux] Error 1
>
> Signed-off-by: Axel Lin<axel.lin@ingics.com>

Acked-by: Laxman Dewangan <ldewangan@nvidia.com>
