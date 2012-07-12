Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933614Ab2GLJ5Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 05:57:25 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13048 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030225Ab2GLJ5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 05:57:00 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 12 Jul 2012 02:56:58 -0700
Message-ID: <4FFE9DD2.9070404@nvidia.com>
Date: Thu, 12 Jul 2012 15:20:10 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Graeme Gregory <gg@slimlogic.co.uk>, Liam Girdwood <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        SamuelOrtiz <sameo@linux.intel.com>,
        Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: Re: [PATCH RFT] regulator: tps65910: Remvoe tps65910_reg_[read|modify_bits|read_locked|write_locked]
 functions
References: <1342007053.4362.2.camel@phoenix>
In-Reply-To: <1342007053.4362.2.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 July 2012 05:14 PM, Axel Lin wrote:
> The tps65910 mfd driver has been converted to regmap APIs.
> This patch adds tps65910_reg_update_bits() in include/linux/mfd/tps65910.h.
> Thus we can use tps65910_reg_read/tps65910_reg_write/tps65910_reg_update_bits
> directly and remove tps65910_reg_[read|modify_bits|read_locked|write_locked]
> functions. With this change, we can also remove the mutex in struct tps65910_reg.
>
> Signed-off-by: Axel Lin<axel.lin@gmail.com>
> ---

Tested-by: Laxman Dewangan <ldewangan@nvidia.com>

Venu,
I think your RTC driver development may need some of change from here.

Thanks,
Laxman

