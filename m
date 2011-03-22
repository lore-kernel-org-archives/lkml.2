Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653Ab1CVDjG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 23:39:06 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47397
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751104Ab1CVDjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 23:39:04 -0400
Date: Mon, 21 Mar 2011 20:39:41 -0700 (PDT)
Message-Id: <20110321.203941.68142922.davem@davemloft.net>
To: horms@verge.net.au
Cc: eric.dumazet@gmail.com, mingo@elte.hu, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, arnd@arndb.de, penberg@cs.helsinki.fi, ja@ssi.bg
Subject: Re: [slab poison overwritten] Re: [GIT] Networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110321221357.GF22625@verge.net.au>
References: <1300730838.2884.578.camel@edumazet-laptop>
	<1300738540.2837.5.camel@edumazet-laptop>
	<20110321221357.GF22625@verge.net.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Simon Horman <horms@verge.net.au>
Date: Tue, 22 Mar 2011 07:13:58 +0900

> On Mon, Mar 21, 2011 at 09:15:40PM +0100, Eric Dumazet wrote:
>> [PATCH] ipvs: fix a typo in __ip_vs_control_init()
>> 
>> Reported-by: Ingo Molnar <mingo@elte.hu>
>> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
>> Cc: Simon Horman <horms@verge.net.au>
>> Cc: Julian Anastasov <ja@ssi.bg>
> 
> Acked-by: Simon Horman <horms@verge.net.au>

Applied.
