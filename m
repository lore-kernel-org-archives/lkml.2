Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759570Ab0ECWyI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 18:54:08 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46779
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759431Ab0ECWyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 18:54:06 -0400
Date: Mon, 03 May 2010 15:54:11 -0700 (PDT)
Message-Id: <20100503.155411.112816416.davem@davemloft.net>
To: paulmck@linux.vnet.ibm.com
Cc: eric.dumazet@gmail.com, shemminger@vyatta.com, Valdis.Kletnieks@vt.edu,
       akpm@linux-foundation.org, peterz@infradead.org, kaber@trash.net,
       linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH net-next-2.6] net: if6_get_next() fix
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100503225229.GO2597@linux.vnet.ibm.com>
References: <20100503.132442.200112018.davem@davemloft.net>
	<1272919814.2407.149.camel@edumazet-laptop>
	<20100503225229.GO2597@linux.vnet.ibm.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Mon, 3 May 2010 15:52:29 -0700

> On Mon, May 03, 2010 at 10:50:14PM +0200, Eric Dumazet wrote:
>> Paul, David, here the patch I was thinking about :
>> 
>> Feel free to split it in two parts if you like, I am too tired and must
>> sleep now ;)
>> 
>> Thanks
>> 
>> [PATCH net-next-2.6] net: rcu fixes
>> 
>> Add hlist_for_each_entry_rcu_bh() and
>> hlist_for_each_entry_continue_rcu_bh() macros, and use them in
>> ipv6_get_ifaddr(), if6_get_first() and if6_get_next() to fix lockdeps
>> warnings.
> 
> Looks good!!!
> 
> It will collide with Arnd's sparse-based changes, but that will be
> easy to fix, so no problem.
> 
> Reviewed-by: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Applied, thanks!
