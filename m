Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab0LAIWQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 03:22:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27345 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753973Ab0LAIWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 03:22:14 -0500
Message-ID: <4CF606C7.6020606@redhat.com>
Date: Wed, 01 Dec 2010 16:26:47 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Shredder/3.0.4
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: linux-kernel@vger.kernel.org, Jiri Pirko <jpirko@redhat.com>,
        Neil Horman <nhorman@redhat.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        bonding-devel@lists.sourceforge.net, Jay Vosburgh <fubar@us.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: [Patch] bonding: clean up netpoll code
References: <20101201075043.5741.29172.sendpatchset@localhost.localdomain> <1291190612.2856.481.camel@edumazet-laptop>
In-Reply-To: <1291190612.2856.481.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/10 16:03, Eric Dumazet wrote:
> Le mercredi 01 décembre 2010 à 02:45 -0500, Amerigo Wang a écrit :
>> Against net-next-2.6.
>>
>> This patch unifies the netpoll code in bonding with netpoll code in bridge,
>> thanks to Herbert that code is much cleaner now.
>>
>> It also removes the flag IFF_IN_NETPOLL, we don't need it any more since
>> we have netpoll_tx_running() now.
>>
>> It passes my basic testings.
>
> Sorry this NETPOLL patch is frightening...
>
> Could you split it in several parts ?
>
> The removal of IFF_IN_NETPOLL deserves a patch on its own, its not a
> cleanup at all, if you ask me.
>

Is this necessary?
It is just replacing checking IFF_IN_NETPOLL with netpoll_tx_running(),
you might need to take a look at the bridge code.
