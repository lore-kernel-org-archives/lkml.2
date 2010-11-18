Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760920Ab0KRXsG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 18:48:06 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40479 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755398Ab0KRXsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 18:48:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=cIIXnp8NMGKZ2kDDfh/OdkKtu7tanVRPw22tdtq64U965uDhYvdothcF0GGVt+V3A2
         7C4wsKd5h8WXDwhM8AdjjZNXe1ZKENiNW3ij7ZGkxrVoM4VGpw/QXHYH774fcUFPks9y
         LtTRHuttuR7v7SonG4wgHElOP6Tt3Iz+T5+Ss=
Message-ID: <4CE5BB30.5080209@gmail.com>
Date: Thu, 18 Nov 2010 15:48:00 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Patrick McHardy <kaber@trash.net>
CC: David Miller <davem@davemloft.net>, randy.dunlap@oracle.com,
        eric.dumazet@gmail.com, linux-net@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        horms@verge.net.au, netfilter-devel@vger.kernel.org
Subject: Re: error while building the kernel Mainline
References: <20101118.125451.98885354.davem@davemloft.net>	<20101118130318.073f6beb.randy.dunlap@oracle.com>	<20101118.131004.58430322.davem@davemloft.net> <20101118.131527.45904827.davem@davemloft.net> <4CE59F3F.3080407@trash.net>
In-Reply-To: <4CE59F3F.3080407@trash.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2010 01:48 PM, Patrick McHardy wrote:
> Am 18.11.2010 22:15, schrieb David Miller:
>> From: David Miller<davem@davemloft.net>
>> Date: Thu, 18 Nov 2010 13:10:04 -0800 (PST)
>>
>>> From: Randy Dunlap<randy.dunlap@oracle.com>
>>> Date: Thu, 18 Nov 2010 13:03:18 -0800
>>>
>>>> On Thu, 18 Nov 2010 12:54:51 -0800 (PST) David Miller wrote:
>>>>
>>>>> From: Patrick McHardy<kaber@trash.net>
>>>>> Date: Thu, 18 Nov 2010 21:32:11 +0100
>>>>>
>>>>>> Thanks for testing. Dave, please apply directly, thanks!
>>>>
>>>> Dave,
>>>>
>>>> This patch does not fix the config/build error that I posted for linux-next.
>>>
>>> And it has bugs, now when NF_CONNTRACT is set to "m" IPVS isn't offered
>>> at all.
>>>
>>> So I'm reverting.
>>
>> Ignore this, I was looking for "*_IPVS" in the config instead of
>> "*_IP_VS" for some stupid reason.
>
> I always make the same mistake :)
>
>> Patch is sane and I'll look into Randy's problem when I get a chance.
>> :-)
>
> I've already asked the tproxy guys to look into this, it's a
> different problem that requires more tproxy knowledge than
> have.
>


go outside to clean the garage, and put up the christmas lights up, come 
back and am freaking for a second that the problems not fixed...

tripping me out man!!

Justin P. Mattock
