Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371Ab0LALLJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 06:11:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20663 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751117Ab0LALLG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 06:11:06 -0500
Message-ID: <4CF62E5F.2090507@redhat.com>
Date: Wed, 01 Dec 2010 19:15:43 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Shredder/3.0.4
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.hengli.com.au>
CC: Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        Jiri Pirko <jpirko@redhat.com>, Neil Horman <nhorman@redhat.com>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        bonding-devel@lists.sourceforge.net, Jay Vosburgh <fubar@us.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: [Patch] bonding: clean up netpoll code
References: <20101201075043.5741.29172.sendpatchset@localhost.localdomain> <1291190612.2856.481.camel@edumazet-laptop> <4CF606C7.6020606@redhat.com> <20101201090621.GA11366@gondor.apana.org.au>
In-Reply-To: <20101201090621.GA11366@gondor.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/10 17:06, Herbert Xu wrote:
> On Wed, Dec 01, 2010 at 04:26:47PM +0800, Cong Wang wrote:
>>
>> Is this necessary?
>> It is just replacing checking IFF_IN_NETPOLL with netpoll_tx_running(),
>> you might need to take a look at the bridge code.
>
> I agree with Eric.  The patch does look pretty scary right now.
>
> Each patch should do one thing and one thing only.
>

Ok, I will separate that part out.

Thanks!
