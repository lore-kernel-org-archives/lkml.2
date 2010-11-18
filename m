Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760701Ab0KRVtE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 16:49:04 -0500
Received: from stinky.trash.net ([213.144.137.162]:42664 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757427Ab0KRVtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 16:49:00 -0500
Message-ID: <4CE59F3F.3080407@trash.net>
Date: Thu, 18 Nov 2010 22:48:47 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Thunderbird/3.1.6
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: randy.dunlap@oracle.com, justinmattock@gmail.com, eric.dumazet@gmail.com,
        linux-net@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, horms@verge.net.au,
        netfilter-devel@vger.kernel.org
Subject: Re: error while building the kernel Mainline
References: <20101118.125451.98885354.davem@davemloft.net>	<20101118130318.073f6beb.randy.dunlap@oracle.com>	<20101118.131004.58430322.davem@davemloft.net> <20101118.131527.45904827.davem@davemloft.net>
In-Reply-To: <20101118.131527.45904827.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 18.11.2010 22:15, schrieb David Miller:
> From: David Miller <davem@davemloft.net>
> Date: Thu, 18 Nov 2010 13:10:04 -0800 (PST)
> 
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>> Date: Thu, 18 Nov 2010 13:03:18 -0800
>>
>>> On Thu, 18 Nov 2010 12:54:51 -0800 (PST) David Miller wrote:
>>>
>>>> From: Patrick McHardy <kaber@trash.net>
>>>> Date: Thu, 18 Nov 2010 21:32:11 +0100
>>>>
>>>>> Thanks for testing. Dave, please apply directly, thanks!
>>>
>>> Dave,
>>>
>>> This patch does not fix the config/build error that I posted for linux-next.
>>
>> And it has bugs, now when NF_CONNTRACT is set to "m" IPVS isn't offered
>> at all.
>>
>> So I'm reverting.
> 
> Ignore this, I was looking for "*_IPVS" in the config instead of
> "*_IP_VS" for some stupid reason.

I always make the same mistake :)

> Patch is sane and I'll look into Randy's problem when I get a chance.
> :-)

I've already asked the tproxy guys to look into this, it's a
different problem that requires more tproxy knowledge than
have.
