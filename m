Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205Ab1CVBPy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 21:15:54 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37965
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755227Ab1CVBPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 21:15:52 -0400
Date: Mon, 21 Mar 2011 18:16:30 -0700 (PDT)
Message-Id: <20110321.181630.35037636.davem@davemloft.net>
To: mingo@elte.hu
Cc: eric.dumazet@gmail.com, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, arnd@arndb.de
Subject: Re: [held lock freed] Re: [GIT] Networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110321161528.GA28580@elte.hu>
References: <20110321125320.GA23490@elte.hu>
	<1300714346.2884.284.camel@edumazet-laptop>
	<20110321161528.GA28580@elte.hu>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Mon, 21 Mar 2011 17:15:28 +0100

> 
> * Eric Dumazet <eric.dumazet@gmail.com> wrote:
> 
>> Here is a probable fix.
>> 
>> [PATCH] ipx: fix ipx_release()
> 
> This patch did the trick - thanks Eric!
> 
> Tested-by: Ingo Molnar <mingo@elte.hu>

Applied, thanks everyone.
