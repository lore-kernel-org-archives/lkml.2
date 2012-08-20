Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159Ab2HTR3Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 13:29:16 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19233 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259Ab2HTR3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 13:29:12 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 20 Aug 2012 10:29:11 -0700
Message-ID: <50326F82.3050503@nvidia.com>
Date: Mon, 20 Aug 2012 22:40:26 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "khali@linux-fr.org" <khali@linux-fr.org>,
        "w.sang@pengutronix.de" <w.sang@pengutronix.de>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH V2 1/2] i2c: tegra: I2_M_NOSTART functionality not supported
 in Tegra20
References: <1345317467-22258-1-git-send-email-ldewangan@nvidia.com> <503270B3.7000007@wwwdotorg.org>
In-Reply-To: <503270B3.7000007@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 20 August 2012 10:45 PM, Stephen Warren wrote:
> On 08/18/2012 01:17 PM, Laxman Dewangan wrote:
>> Tegra20 i2c controller does not support the continue transfer
>> which implements the I2C_M_NOSTART functionality of i2c
>> protocol mangling.
>> Removing the I2C_M_NOSTART functionality support for Tegra20.
> Thanks, applied the series to Tegra's for-3.7/drivers-i2c branch.
>
> Note that I had to fix up patch 1 to remove const on the tegra*_i2c_hw
> variable declarations to avoid compiler warnings when assigning pointers
> into tegra_i2c_of_match[].data.
Thanks for correction but
I did not get this warning and when saw the structure, it is declared as 
const type only..
struct of_device_id
{
         char    name[32];
         char    type[32];
         char    compatible[128];
#ifdef __KERNEL__
         const void *data;
#else
         kernel_ulong_t data;
#endif
};


