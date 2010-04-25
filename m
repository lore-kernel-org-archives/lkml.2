Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437Ab0DYRIi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 13:08:38 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:51653 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679Ab0DYRIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 13:08:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=jIsKQ8LI++HfyNLMs5BznY+tWXC3SgmIXKy+gBmvQ8Fd4WiXm9lRNb6eKICuUQgln+
         VTfaVc61Gh9vTEWFXkfqPR/9mWexElWGWTcjtdk2cy3pr+03Td36dBkTV1+wvehq6v80
         YS4O287Iwfjw4hhxRxC4EsJ/nAvyxS1MkdyuQ=
Subject: Re: [2.6.34-rc5-git6] EIP: is at inet6_csk_bind_conflict +
 06xe/0xb7 [ipv6]
From: Eric Dumazet <eric.dumazet@gmail.com>
To: piotr@hosowicz.com
Cc: sedat.dilek@gmail.com, Sedat Dilek <sedat.dilek@googlemail.com>,
       LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       David Miller <davem@davemloft.net>, Jiri Olsa <jolsa@redhat.com>,
       Jongman Heo <jongman.heo@gmail.com>
In-Reply-To: <4BD4757E.8020503@example.com>
References: <l2z2d0a357f1004250811w6da355ebp95d1730473026c22@mail.gmail.com>
	 <4BD45E68.4080900@example.com>
	 <g2z2d0a357f1004250931pf5880c60l32fd0643e0f14bde@mail.gmail.com>
	 <4BD46F9C.5060500@example.com>	 <1272213597.2069.32.camel@edumazet-laptop>
	 <j2p2d0a357f1004250955i59969a2cp9fd9eb9f3ef22d4b@mail.gmail.com>
	 <4BD4757E.8020503@example.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 25 Apr 2010 19:08:31 +0200
Message-ID: <1272215311.2069.91.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 25 avril 2010 à 19:01 +0200, Piotr Hosowicz a écrit :
> On 25.04.2010 18:55, Sedat Dilek wrote:
> > Rebuild ipv6 kernel-modules by:
> >
> > $ make M=net/ipv6
> >
> > ...and copied net/ipv6/*.ko and net/ipv6/netfilter/*.ko files manually
> > to the right place.
> >
> > Applied your patch (seen on netdev ML) already and booted into new kernel.
> > Works, thanks.
> >
> > Tested-by: Sedat Dilek<sedat.dilek@gmail.com>
> >
> > - Sedat -
> >
> > On Sun, Apr 25, 2010 at 6:39 PM, Eric Dumazet<eric.dumazet@gmail.com>  wrote:
> >> Le dimanche 25 avril 2010 à 18:36 +0200, Piotr Hosowicz a écrit :
> >>> On 25.04.2010 18:31, Sedat Dilek wrote:
> >>>> [ CCing netdev ML ]
> >>>>
> >>>> Confirmed: The revert-patch [1] fixes the problem here.
> >>>
> >>> I confirm, I've built a git6 kernel and it works fine.
> >>>
> >>>> See also "Bug 15847 -  crash in inet6_csk_bind_conflict" [2].
> >>>>
> >>>> Feel free to add a... Tested-by: Sedat Dilek<sedat.dilek@gmail.com>
> >>>
> >>> I added created and tested phrase in my archive. ;-) Thank you a lot. I
> >>> hope there will be no this error in git7.
> >>>
> >>
> >> Did you test the proposed fix ?
> 
> Eric, but where to get the proposed fix as a patch? I looked at kernel's 
> bugzilla and there is no such thing. As for now I applied Sedat's 
> reverse patch and now I am booted fine in git6 kernel.
> 

I wont spend my Sunday time at filling bugzilla entries.

I sent a patch on netdev.

I finaly could test it (I have a very slow machine while traveling, and
compiling the thing took a *lot* of time)

Now back to family affairs ;)



