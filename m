Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab2LQRya (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 12:54:30 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:11787 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917Ab2LQRy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 12:54:29 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 17 Dec 2012 09:52:10 -0800
Message-ID: <50CF5C4F.5090609@nvidia.com>
Date: Mon, 17 Dec 2012 23:24:23 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Jonas Gorski <jonas.gorski@gmail.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH] spi: make sure all transfer has bits_per_word set
References: <1352452005-13789-1-git-send-email-ldewangan@nvidia.com> <CAOiHx=nEmd9dQ297Oho=gmZTYfYgJ3o_+J2OFK=sRuRYNqzPxg@mail.gmail.com> <20121206141507.86DCF3E0948@localhost>
In-Reply-To: <20121206141507.86DCF3E0948@localhost>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 December 2012 07:45 PM, Grant Likely wrote:
> On Mon, 12 Nov 2012 11:03:56 +0100, Jonas Gorski<jonas.gorski@gmail.com>  wrote:
>> Hi,
>>
>> On 9 November 2012 10:06, Laxman Dewangan<ldewangan@nvidia.com>  wrote:
>>> When spi client does the spi transfer and does not sets
>>> the bits_per_word for each transfer then set it as default
>>> of spi device in spi core before calling low level transfer.
>> I like that (not that it counts ... )!
>>
>>> Removing the similar code from spi-tegra20-slink driver as
>>> it is not required.
>> Not sure if this should be part of *this* patch.
>> Also spi-tegra20-slink isn't the only one fixing up the bits_per_word
>> for transfers, so it would be nice if you could remove it from the
>> other drivers, too.


Just sent the patch to remove the similar code from most of driver.
Tested only tegra driver.


>> In a future patch, maybe even do the same with speed_hz?
> That sounds reasonable. Could you craft one up and see how it looks?
>
>


Ok, I will prepare change and send the patch.

Thanks,
Laxman
