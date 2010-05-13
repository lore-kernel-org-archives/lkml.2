Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897Ab0EMNVY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 09:21:24 -0400
Received: from stinky.trash.net ([213.144.137.162]:55350 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756810Ab0EMNVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 09:21:21 -0400
Message-ID: <4BEBFCD0.80200@trash.net>
Date: Thu, 13 May 2010 15:21:20 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       eric.dumazet@gmail.com, Arnd Bergmann <arnd@relay.de.ibm.com>,
       Arnd Bergmann <arnd@arndb.de>, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH RFC tip/core/rcu 18/23] net/netfilter: __rcu annotations
References: <20100512213317.GA15085@linux.vnet.ibm.com> <1273700022-16523-18-git-send-email-paulmck@linux.vnet.ibm.com>
In-Reply-To: <1273700022-16523-18-git-send-email-paulmck@linux.vnet.ibm.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> From: Arnd Bergmann <arnd@relay.de.ibm.com>
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Patrick McHardy <kaber@trash.net>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <eric.dumazet@gmail.com>
> ---
>  include/net/netfilter/nf_conntrack.h |    2 +-
>  net/ipv4/netfilter/nf_nat_core.c     |    2 +-
>  net/netfilter/core.c                 |    2 +-
>  net/netfilter/nf_conntrack_ecache.c  |    4 ++--
>  net/netfilter/nf_conntrack_extend.c  |    2 +-
>  net/netfilter/nf_conntrack_proto.c   |    4 ++--
>  net/netfilter/nf_log.c               |    2 +-
>  net/netfilter/nf_queue.c             |    2 +-
>  8 files changed, 10 insertions(+), 10 deletions(-)

Acked-by: Patrick McHardy <kaber@trash.net>
