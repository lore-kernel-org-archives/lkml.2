Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab1JGTtL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 15:49:11 -0400
Received: from mx.binnacle.cx ([74.95.187.105]:40868 "EHLO mx.binnacle.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752843Ab1JGTtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 15:49:09 -0400
Message-Id: <6.2.5.6.2.20111007153756.039bcdc8@binnacle.cx>
X-Mailer: QUALCOMM Windows Eudora Version 6.2.5.6
Date: Fri, 07 Oct 2011 15:41:37 -0400
To: chetan loke <loke.chetan@gmail.com>
From: starlight@binnacle.cx
Subject: Re: big picture UDP/IP performance question re 2.6.18
  -> 2.6.32
Cc: Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        netdev <netdev@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Christoph Lameter <cl@gentwo.org>, Willy Tarreau <w@1wt.eu>,
        Ingo Molnar <mingo@elte.hu>,
        Stephen Hemminger <stephen.hemminger@vyatta.com>,
        Benjamin LaHaise <bcrl@kvack.org>, Joe Perches <joe@perches.com>,
        lokechetan@gmail.com, Con Kolivas <conman@kolivas.org>,
        Serge Belyshev <belyshev@depni.sinp.msu.ru>
In-Reply-To: <CAAsGZS4b2F9N3nV3TNu5xG+=2d0L0ncste4xv2vqoVFb1pOxEw
 @mail.gmail.com>
References: <6.2.5.6.2.20111006231958.039bb570@binnacle.cx>
 <1317966007.3457.47.camel@edumazet-laptop>
 <6.2.5.6.2.20111007020308.039be248@binnacle.cx>
 <CAAsGZS4s1wTWW1j7FRUWW9jqpPUVF3Q46AMa7+njvE1ckX0Snw@mail.gmail.com>
 <6.2.5.6.2.20111007143050.039bd578@binnacle.cx>
 <CAAsGZS4b2F9N3nV3TNu5xG+=2d0L0ncste4xv2vqoVFb1pOxEw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If they didn't want $20k to get started ($10k
for the card, $10k for the developer kit) would
probably have ported our application to run
outboard on a Tile64 NIC.  The cost + youth
of Tilra has been just a little to far out
on the edge.  If they survive (and lower the
price a bit) it will become an increasingly
easier sell.

If their patents hold up and their investors
can stomach the legal battles, they may
win the day.  Intel and AMD use ring
topologies between cores and this can
only scale so far.


At 03:27 PM 10/7/2011 -0400, chetan loke wrote:
>If at all, tile-cpu may not be able to survive the
>heat in host-mode, but there's no competition in
>device-mode. ASIC design is an expensive science
>project. All adapter vendors know this. Not to
>mention all the chicken-games they then have to
>play to incorporate multi-core ARMs(or whatever
>CPUs) to support big(40/100 G) pipes. Slowly their
>firmware needs to evolve as an OS and they start
>shopping for RT linux shops/consulting firms.Been
>there. Done that. There's a lot of bad blood and
>too much pain involved when you ask clunky
>firmware guys to abandon the big fat while loop in
>their beloved firmware and stop hacking the chip
>;). Offload it to a tile-CPU and just sell what
>you are good at - a darn protocol stack...

