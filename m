Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759593Ab0D3VQm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 17:16:42 -0400
Received: from 97.17.115-78.rev.gaoland.net ([78.115.17.97]:32949 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754191Ab0D3VQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 17:16:40 -0400
Date: Fri, 30 Apr 2010 23:15:56 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
       Oleg Nesterov <oleg@redhat.com>, David Miller <davem@davemloft.net>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       netdev@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: r8169 INFO: inconsistent lock state
Message-ID: <20100430211556.GA4903@electric-eye.fr.zoreil.com>
References: <20100430182012.GA3329@swordfish.minsk.epam.com>
 <1272661149.2230.11.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272661149.2230.11.camel@edumazet-laptop>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet <eric.dumazet@gmail.com> :
[...]
> So we have following illegal chain (process context, not softirq)
> 
> rtl8169_reset_task() -> tl8169_rx_interrupt() -> netif_receive_skb()
> 
> And normally, commit 630b943c tried to change this chain to :
> 
> rtl8169_reset_task() -> tl8169_rx_interrupt() -> netif_rx()
> 
> I have no idea why it doesnt work.

630b943c appears to be in net-next.

Oops ?

-- 
Ueimor
