Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758844Ab0ECWRV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 18:17:21 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46490
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758419Ab0ECWRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 18:17:19 -0400
Date: Mon, 03 May 2010 15:17:25 -0700 (PDT)
Message-Id: <20100503.151725.94856059.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: paulmck@linux.vnet.ibm.com, shemminger@vyatta.com, Valdis.Kletnieks@vt.edu,
       akpm@linux-foundation.org, peterz@infradead.org, kaber@trash.net,
       linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH net-next-2.6] net: if6_get_next() fix
From: David Miller <davem@davemloft.net>
In-Reply-To: <1272919814.2407.149.camel@edumazet-laptop>
References: <1272917635.2407.106.camel@edumazet-laptop>
	<20100503.132442.200112018.davem@davemloft.net>
	<1272919814.2407.149.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Mon, 03 May 2010 22:50:14 +0200

> Paul, David, here the patch I was thinking about :
> 
> Feel free to split it in two parts if you like, I am too tired and must
> sleep now ;)
 ...
> [PATCH net-next-2.6] net: rcu fixes
> 
> Add hlist_for_each_entry_rcu_bh() and
> hlist_for_each_entry_continue_rcu_bh() macros, and use them in
> ipv6_get_ifaddr(), if6_get_first() and if6_get_next() to fix lockdeps
> warnings.
> 
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

Paul, let me know if you want to handle these seperately (one commit
in your tree for the rculist.h bit and one for the ipv6 change) or to
put it all at once into net-next-2.6, I'm happy either way.
