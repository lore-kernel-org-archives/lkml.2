Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280Ab2ADH7R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 02:59:17 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:38523 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751470Ab2ADH7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 02:59:15 -0500
MIME-Version: 1.0
In-Reply-To: <20120103223243.GB8563@electric-eye.fr.zoreil.com>
References: <CACPM=kVBxcL1_Z9zVvnEEdEgAc0rbAAbzkcocz4OYWQ2xn6VmQ@mail.gmail.com>
	<20111230180347.GA3647@electric-eye.fr.zoreil.com>
	<CACPM=kXWXUE+JcVhkz-6tGZ2YyteN9sGA80+Pnw6+LaJ-eNWBA@mail.gmail.com>
	<20111230215024.GA5513@electric-eye.fr.zoreil.com>
	<CACPM=kUxSRhDc2EqgceBRTFgBei7dh3_n7bPyoH=8aNC_uq4FA@mail.gmail.com>
	<20111230221938.GA6197@electric-eye.fr.zoreil.com>
	<CACPM=kXAr46BXAc3t8puRB37NeFy_ZEOWZa0H=DnSioagSLpxA@mail.gmail.com>
	<CACPM=kWn41S85eLgj4G+c6cN0WBgqF=6MigSwa9QBOxD1Uh64A@mail.gmail.com>
	<20111231121710.GB9842@electric-eye.fr.zoreil.com>
	<CACPM=kX2B6p6CSs+s-5WUbQCLa0WZW5K9Rr+hnB5VCxkEmh=8w@mail.gmail.com>
	<20120103223243.GB8563@electric-eye.fr.zoreil.com>
Date: Wed, 4 Jan 2012 08:59:14 +0100
X-Google-Sender-Auth: 9oKZzY1D4n3NbBoSfsL26sFVW98
Message-ID: <CACPM=kUhBydaVDQaxs7BaB_ZkFRa2p6cVme-77Gbsk+QDk=MFA@mail.gmail.com>
Subject: Re: [PATCH 1/1] via-rhine: Fix hanging with high CPU load on low-end broads.
From: Bjarke Istrup Pedersen <gurligebis@gentoo.org>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: David Miller <davem@davemloft.net>, shemminger@vyatta.com,
        bhutchings@solarflare.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, rl@hellgate.ch
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/1/3 Francois Romieu <romieu@fr.zoreil.com>:
> Bjarke Istrup Pedersen <gurligebis@gentoo.org> :
> [...]
>> Is there anything else I should try out?
>
> Your computer is supposed to be moderately underpowered. Find someone
> with an heavily overpowered one.

Hmm, thats gonna be difficult, since it's an on-board chip in the box,
so it's no possible to move it to something more powerful :)

>> Also, would it be possible to push these changes to mainline as
>
> Probably. There has not been much objection nor comments so far.

Nice, any objections David? :)

>> another CONFIG option (not sure if thats possible), so more people can
>> enable it and test it? :)
>
> I'd rather not. It would not be terribly elegant and more CONFIG options
> would not imply more testing.

I agree, but if we push these changes to mainline directly, there is
no need - it was more as a way of getting it to mainline, while still
keeping the old way around, if it was needed.

/Bjarke

> --
> Ueimor
