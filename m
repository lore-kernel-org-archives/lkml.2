Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932403Ab1CVVw5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 17:52:57 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:45301 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932353Ab1CVVwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 17:52:54 -0400
Date: Wed, 23 Mar 2011 06:52:50 +0900
From: Simon Horman <horms@verge.net.au>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Arnd Bergmann <arnd@arndb.de>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Julian Anastasov <ja@ssi.bg>
Subject: Re: [slab poison overwritten] Re: [GIT] Networking
Message-ID: <20110322215249.GD2423@verge.net.au>
References: <20110320.195156.226769634.davem@davemloft.net>
 <20110321125320.GA23490@elte.hu>
 <1300714346.2884.284.camel@edumazet-laptop>
 <20110321161528.GA28580@elte.hu>
 <20110321164238.GA5303@elte.hu>
 <20110321173941.GB3892@elte.hu>
 <1300730838.2884.578.camel@edumazet-laptop>
 <1300738540.2837.5.camel@edumazet-laptop>
 <20110322095638.GA26130@elte.hu>
 <1300788039.3084.0.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1300788039.3084.0.camel@edumazet-laptop>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 11:00:39AM +0100, Eric Dumazet wrote:
> Le mardi 22 mars 2011 à 10:56 +0100, Ingo Molnar a écrit :
> > * Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > 
> > > [PATCH] ipvs: fix a typo in __ip_vs_control_init()
> > 
> > This fix and Simon's:
> > 
> >   IPVS: Use global mutex in ip_vs_app.c
> > 
> > Did the trick here, the IPVS related SLAB corruptions are now gone.
> > 
> > Thanks guys!
> 
> Thanks for testing Ingo ;)

Yes, thanks Ingo.
