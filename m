Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130Ab1JGT1z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 15:27:55 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55145 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969Ab1JGT1x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 15:27:53 -0400
MIME-Version: 1.0
In-Reply-To: <6.2.5.6.2.20111007143050.039bd578@binnacle.cx>
References: <6.2.5.6.2.20111006231958.039bb570@binnacle.cx>
	<1317966007.3457.47.camel@edumazet-laptop>
	<6.2.5.6.2.20111007020308.039be248@binnacle.cx>
	<CAAsGZS4s1wTWW1j7FRUWW9jqpPUVF3Q46AMa7+njvE1ckX0Snw@mail.gmail.com>
	<6.2.5.6.2.20111007143050.039bd578@binnacle.cx>
Date: Fri, 7 Oct 2011 15:27:52 -0400
Message-ID: <CAAsGZS4b2F9N3nV3TNu5xG+=2d0L0ncste4xv2vqoVFb1pOxEw@mail.gmail.com>
Subject: Re: big picture UDP/IP performance question re 2.6.18 -> 2.6.32
From: chetan loke <loke.chetan@gmail.com>
To: starlight@binnacle.cx
Cc: Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        netdev <netdev@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Christoph Lameter <cl@gentwo.org>, Willy Tarreau <w@1wt.eu>,
        Ingo Molnar <mingo@elte.hu>,
        Stephen Hemminger <stephen.hemminger@vyatta.com>,
        Benjamin LaHaise <bcrl@kvack.org>, Joe Perches <joe@perches.com>,
        lokechetan@gmail.com, Con Kolivas <conman@kolivas.org>,
        Serge Belyshev <belyshev@depni.sinp.msu.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 7, 2011 at 2:37 PM,  <starlight@binnacle.cx> wrote:
> At 02:09 PM 10/7/2011 -0400, chetan loke wrote:
>>You got it. In case of tilera there are two modes:
>>tile-cpu in device mode: beats most of the
>>non-COTS NICs. It runs linux on the adapter
>>side. Imagine having the flexibility/power to
>>program the ASIC using your favorite OS. Its
>>orgasmic. So go for it!  tile-cpu in host-mode:
>>Yes, it could be a game changer.
>
> We almost went for the 1st gen Tile64 outboard
> NIC approach, but were concerned about whether
> they would survive--still are.  Intel has
> crushed more than a few competitors along
> the way.  If Google or Facebook buys into the
> Tile-Gx it becomes a safe choice overnight.
>
>

If at all, tile-cpu may not be able to survive the heat in host-mode,
but there's no competition in device-mode. ASIC design is an expensive
science project. All adapter vendors know this. Not to mention all the
chicken-games they then have to play to incorporate multi-core ARMs(or
whatever CPUs) to support big(40/100 G) pipes. Slowly their firmware
needs to evolve as an OS and they start shopping for RT linux
shops/consulting firms.Been there. Done that. There's a lot of bad
blood and too much pain involved when you ask clunky firmware guys to
abandon the big fat while loop in their beloved firmware and stop
hacking the chip ;). Offload it to a tile-CPU and just sell what you
are good at - a darn protocol stack...
