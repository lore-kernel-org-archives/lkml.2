Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759447Ab2EJMYS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 08:24:18 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:16843 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755267Ab2EJMYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 08:24:17 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 10 May 2012 05:24:15 -0700
Message-ID: <4FABB290.40609@nvidia.com>
Date: Thu, 10 May 2012 17:50:32 +0530
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
Subject: Re: [PATCH V1 2/2] i2c: tegra: support for I2C_M_NOSTART protocol
  mangling
References: <1335251976-31925-1-git-send-email-ldewangan@nvidia.com>	<1335251976-31925-3-git-send-email-ldewangan@nvidia.com>	<4FABA585.7090600@nvidia.com> <20120510135411.3ba5bb6d@endymion.delvare>
In-Reply-To: <20120510135411.3ba5bb6d@endymion.delvare>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 May 2012 05:24 PM, Jean Delvare wrote:
> Hi Laxman,
>
> On Thu, 10 May 2012 16:54:53 +0530, Laxman Dewangan wrote:
>> Jean,
>> On Tuesday 24 April 2012 12:49 PM, Laxman Dewangan wrote:
>>> Adding support for protocol mangling I2C_M_NOSTART.
>>> When multiple message transfer request made through i2c
>>> and if any message is flagged with I2C_M_NOSTART then
>>> it will not send the start/repeat start/address of that
>>> message i.e. send the data directly.
>> Now the framework/core changes for making M_NOSTART as a separate flag
>> is already part of your tree.
>> So do I need to re-send the patch for having that change?
>> 1/1 is already part of Wolfram's tree and so not sure that how do I go
>> i.e. from where I take the base i2c-tegra driver.
>> It may create the problem in integration on main if they are not sync.
>> Also I have some couple of changes which will be on top of this.
> I'm not sure I read you correctly so, for clarity: the patch
> introducing I2C_FUNC_NOSTART finally landed in my tree [1], not
> Wolfram's. It will be merged in kernel 3.5.
>
> [1] http://khali.linux-fr.org/devel/linux-3/jdelvare-i2c/
>
> If you don't want to depend on that, then just use
> I2C_FUNC_PROTOCOL_MANGLING for now and you can switch to
> I2C_FUNC_NOSTART later.
>
It is fine. So this change can go in to Wolfram's tree as it is and 
after k3.5, I will post another change which will use I2C_FUNC_NOSTART.

Thanks,
Laxman

