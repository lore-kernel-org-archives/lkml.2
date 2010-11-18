Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760067Ab0KRSNc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 13:13:32 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60882 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758308Ab0KRSNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 13:13:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Dj2CkvuzvvQUlcBPZIaacL8WJ+V22BEzhe6SWloAE5v42Wk32Rdr7WIiohkv6COuCf
         2dzGmsJ2ojBDAbPcaPjnkSq9kci7BU2gHqa1Gofe1ZKT6wILA4lRLoE2ESn4YDOjqo53
         K/Hd77tAB1F66agJpjuGutmy5g95E0fMORMPs=
Message-ID: <4CE56CC4.4020107@gmail.com>
Date: Thu, 18 Nov 2010 10:13:24 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: eric.dumazet@gmail.com, linux-net@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        horms@verge.net.au, netfilter-devel@vger.kernel.org, kaber@trash.net
Subject: Re: error while building the kernel Mainline
References: <1290093135.2781.167.camel@edumazet-laptop>	<4CE561A2.2020600@gmail.com>	<1290102497.2781.242.camel@edumazet-laptop> <20101118.095046.28818361.davem@davemloft.net>
In-Reply-To: <20101118.095046.28818361.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2010 09:50 AM, David Miller wrote:
> From: Eric Dumazet<eric.dumazet@gmail.com>
> Date: Thu, 18 Nov 2010 18:48:17 +0100
>
>> Let me guess...
>>
>> net/netfilter/nf_conntrack_core is compiled as a module, and ip_vs
>> statically (in vmlinux) ?
>>
>> CONFIG_NF_CONNTRACK=m
>> CONFIG_IP_VS=y
>>
>> We probably need some Kconfig magic ;)
>
> Randy Dunlap made a similar report today with a sample .config
> that triggers the problem.
>
> I'll look into it after lunch.
>

alright..

Justin P. Mattock
