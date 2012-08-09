Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031205Ab2HIP70 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 11:59:26 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:41649 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758556Ab2HIP7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 11:59:11 -0400
MIME-Version: 1.0
X-Originating-IP: [76.119.162.148]
In-Reply-To: <1344526608.28967.1092.camel@edumazet-glaptop>
References: <50215A7E.8000701@linaro.org>
	<1695034.0lrQgQPOMT@sifl>
	<1344523833.28967.996.camel@edumazet-glaptop>
	<5799181.tjlnF0gIh2@sifl>
	<1344526608.28967.1092.camel@edumazet-glaptop>
Date: Thu, 9 Aug 2012 11:59:09 -0400
Message-ID: <CAHC9VhRpYdN3tFhik-9v7BQvr+wer2ocZuXGi0x0-pV+fA-mDw@mail.gmail.com>
Subject: Re: [PATCH] ipv4: tcp: security_sk_alloc() needed for unicast_sock
From: Paul Moore <paul@paul-moore.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Miller <davem@davemloft.net>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Eric Paris <eparis@parisplace.org>, John Stultz <johnstul@us.ibm.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        lkml <linux-kernel@vger.kernel.org>,
        James Morris <james.l.morris@oracle.com>, selinux@tycho.nsa.gov,
        john.johansen@canonical.com,
        LSM <linux-security-module@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 9, 2012 at 11:36 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> On Thu, 2012-08-09 at 11:07 -0400, Paul Moore wrote:
>
>> Is is possible to do the call to security_sk_alloc() in the ip_init() function
>> or does the per-cpu nature of the socket make this a pain?
>>
>
> Its a pain, if we want NUMA affinity.
>
> Here, each cpu should get memory from its closest node.

Okay, makes sense.

Acked-by: Paul Moore <paul@paul-moore.com>

-- 
paul moore
www.paul-moore.com
