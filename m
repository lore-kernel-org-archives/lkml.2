Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672Ab0ECUI6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 16:08:58 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45605
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756479Ab0ECUI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 16:08:57 -0400
Date: Mon, 03 May 2010 13:09:02 -0700 (PDT)
Message-Id: <20100503.130902.172620141.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: paulmck@linux.vnet.ibm.com, shemminger@vyatta.com, Valdis.Kletnieks@vt.edu,
       akpm@linux-foundation.org, peterz@infradead.org, kaber@trash.net,
       linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH net-next-2.6] net: if6_get_next() fix
From: David Miller <davem@davemloft.net>
In-Reply-To: <1272916007.2407.75.camel@edumazet-laptop>
References: <1272903293.2226.50.camel@edumazet-laptop>
	<20100503181629.GJ2597@linux.vnet.ibm.com>
	<1272916007.2407.75.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Mon, 03 May 2010 21:46:47 +0200

> Then, net-next-2.6 doesnt yet have your commit Paul to relax
> hlist_for_each_entry_rcu(), so its a bit difficult to continue the work.

Is that in Linus's tree yet?  If it propagates there I can make it
propagate to net-next-2.6, you just have to tell me you need it.
