Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537Ab2HPHZ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 03:25:29 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:3275 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606Ab2HPHZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 03:25:26 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 16 Aug 2012 00:25:24 -0700
Message-ID: <502C9C4F.8090300@nvidia.com>
Date: Thu, 16 Aug 2012 12:37:59 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>,
        "w.sang@pengutronix.de" <w.sang@pengutronix.de>
CC: "khali@linux-fr.org" <khali@linux-fr.org>,
        Stephen Warren <swarren@nvidia.com>, "olof@lixom.net" <olof@lixom.net>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH] i2c: tegra: I2_M_NOSTART functionality not supported
 in Tegra20
References: <1344935949-26709-1-git-send-email-ldewangan@nvidia.com> <502A817C.4000601@wwwdotorg.org>
In-Reply-To: <502A817C.4000601@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 August 2012 10:19 PM, Stephen Warren wrote:
> On 08/14/2012 03:19 AM, Laxman Dewangan wrote:
>> Tegra20 i2c controller does not support the continue transfer
>> which implements the I2C_M_NOSTART functionality of i2c
>> protocol mangling.
>> Removing the I2C_M_NOSTART functionality for Tegra20.
>>
>> Signed-off-by: Laxman Dewangan<ldewangan@nvidia.com>
>> Reported-by: Stephen Warren<swarren@nvidia.com>
> Tested-by: Stephen Warren<swarren@wwwdotorg.org>
>
> Note that if I take Laxman's I2C driver clock patches through the Tegra
> tree, and Wolfram takes this patch through the I2C tree, there will be a
> very slight conflict, since adjacent lines are touched. However, the
> resolution is simple and obvious, so I think that's fine.

Stephen/Wolfram,
I have 2 more change to implement runtime PM and dynamic clock control 
for fast clock which I have planned for 3.7.
I think it will be better if this also goes on same tree where the clock 
related change are available to avoid the merge conflict.

