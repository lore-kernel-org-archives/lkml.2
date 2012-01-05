Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964887Ab2AEQqK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 11:46:10 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47260 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964832Ab2AEQqH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 11:46:07 -0500
MIME-Version: 1.0
In-Reply-To: <20120105162013.GA19440@electric-eye.fr.zoreil.com>
References: <20111230215024.GA5513@electric-eye.fr.zoreil.com>
	<CACPM=kUxSRhDc2EqgceBRTFgBei7dh3_n7bPyoH=8aNC_uq4FA@mail.gmail.com>
	<20111230221938.GA6197@electric-eye.fr.zoreil.com>
	<CACPM=kXAr46BXAc3t8puRB37NeFy_ZEOWZa0H=DnSioagSLpxA@mail.gmail.com>
	<CACPM=kWn41S85eLgj4G+c6cN0WBgqF=6MigSwa9QBOxD1Uh64A@mail.gmail.com>
	<20111231121710.GB9842@electric-eye.fr.zoreil.com>
	<CACPM=kX2B6p6CSs+s-5WUbQCLa0WZW5K9Rr+hnB5VCxkEmh=8w@mail.gmail.com>
	<20120103223243.GB8563@electric-eye.fr.zoreil.com>
	<CACPM=kUhBydaVDQaxs7BaB_ZkFRa2p6cVme-77Gbsk+QDk=MFA@mail.gmail.com>
	<CACPM=kWL+Z6PH268qg=i0Nafrouq4O25+uFf8WLcE08azqpqpA@mail.gmail.com>
	<20120105162013.GA19440@electric-eye.fr.zoreil.com>
Date: Thu, 5 Jan 2012 17:46:06 +0100
X-Google-Sender-Auth: plIZtQsQbooPWKGL2UPxqSL1Kz8
Message-ID: <CACPM=kVeqfxc3SkMPghLOTHFiiVCkPmdRBtVKA_RDfVS3iZOsg@mail.gmail.com>
Subject: Re: [PATCH 1/1] via-rhine: Fix hanging with high CPU load on low-end broads.
From: Bjarke Istrup Pedersen <gurligebis@gentoo.org>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: David Miller <davem@davemloft.net>, shemminger@vyatta.com,
        bhutchings@solarflare.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, rl@hellgate.ch
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/1/5 Francois Romieu <romieu@fr.zoreil.com>:
> Bjarke Istrup Pedersen <gurligebis@gentoo.org> :
> [...]
>> Sorry for repeating myself David, but would it be possible to get this
>> into net-next for 3.4 inclusion ?
>
> You should not expect #net-next for 3.4 to open before the merge window
> for 3.3 is closed.

Okay, I'm still pretty new to how the kernel development model works,
and what opens when and for how long, but hey, you learn something
everyday :)

> With due consideration for his freedom of will and action, David can not
> take the current patchkit because he needs a formal submission of a complete
> set where #3 is fixed. Our last friday's exchange does not count as one.

Sure, it wasn't meant like that (Sorry if it was written that way, can
be difficult from time to time to get it across on paper) :)

> I understand it is important for you, it will be sent, ok ?

Yep :)

/Bjarke

> For future reference, you can see what is going on here :
>
> http://patchwork.ozlabs.org/project/netdev/list/?state=*&q=via-rhine
>
> /me returns to paperwork...
>
> --
> Ueimor
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
