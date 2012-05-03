Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab2ECGP4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 02:15:56 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:18723 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804Ab2ECGPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 02:15:54 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 02 May 2012 23:15:53 -0700
Message-ID: <4FA221FA.2030305@nvidia.com>
Date: Thu, 3 May 2012 11:43:14 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: "w.sang@pengutronix.de" <w.sang@pengutronix.de>,
        "ben-linux@fluff.org" <ben-linux@fluff.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "olof@lixom.net" <olof@lixom.net>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V1 1/2] i2c: tegra: fix 10bit address configuration
References: <1335251976-31925-1-git-send-email-ldewangan@nvidia.com>	<1335251976-31925-2-git-send-email-ldewangan@nvidia.com> <20120424105815.1d9e7d95@endymion.delvare>
In-Reply-To: <20120424105815.1d9e7d95@endymion.delvare>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 April 2012 02:28 PM, Jean Delvare wrote:
> On Tue, 24 Apr 2012 12:49:35 +0530, Laxman Dewangan wrote:
>> The slave address of device to be configured in packet
>> header as follows:
>>      7 bit address: PacketHeader3[7:1]
>>      10 bit address: PacketHeader3[9:0]
>>
>> Fixing the code to make packet header3 properly.
>>
>> Signed-off-by: Laxman Dewangan<ldewangan@nvidia.com>
>> ---
>>
>>   
> Looks good.
>
> Acked-by: Jean Delvare<khali@linux-fr.org>
>
Hi Wolfram Sang,
Can it be apply? This is independent of other change in this series 
which is under discussion/review.
