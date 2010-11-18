Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760056Ab0KRSMJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 13:12:09 -0500
Received: from stinky.trash.net ([213.144.137.162]:39194 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755721Ab0KRSMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 13:12:07 -0500
Message-ID: <4CE56C70.8090404@trash.net>
Date: Thu, 18 Nov 2010 19:12:00 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Thunderbird/3.1.6
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: eric.dumazet@gmail.com, justinmattock@gmail.com, linux-net@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        horms@verge.net.au, netfilter-devel@vger.kernel.org
Subject: Re: error while building the kernel Mainline
References: <1290093135.2781.167.camel@edumazet-laptop>	<4CE561A2.2020600@gmail.com>	<1290102497.2781.242.camel@edumazet-laptop> <20101118.095046.28818361.davem@davemloft.net>
In-Reply-To: <20101118.095046.28818361.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 18.11.2010 18:50, schrieb David Miller:
> From: Eric Dumazet <eric.dumazet@gmail.com>
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

Thanks, I'll take care of this.
