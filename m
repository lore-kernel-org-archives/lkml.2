Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757156Ab0J0W0u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 18:26:50 -0400
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:26388 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751031Ab0J0W0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 18:26:47 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: V34MVJ4VM1mBLsPr2E24Wp4gUZ7p7TRP1h8zxoqWHRUYoBb
 nnQ9y3MU8RInrtN5kGZWM2IsOwIG2qAN3SA7lo4OmEORpVrLOSuLpKTsonSG
 086OSwtmkhzNf8mXDMiJtsH5BSw6YAPy5aI3ejYxBN3SD_70ZRcRN0UML_nQ
 qMTabxx45zD8w_LvyZ7ieur2EjCWa55EQQj8PNaj84rbeBI3KwODVFvx7HhS
 _
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 27 Oct 2010 17:26:44 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Martin Nybo Andersen <tweek@tweek.dk>
cc: Dragoslav Zaric <zaricdragoslav@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Tickles scheduler
In-Reply-To: <alpine.DEB.2.00.1010260959250.10975@odin.tweek.dk>
Message-ID: <alpine.DEB.2.00.1010271725260.9704@router.home>
References: <AANLkTimzEDtfUKajFPgGOhifPhyRQboZbKNbypBaKpKO@mail.gmail.com> <alpine.DEB.2.00.1010260959250.10975@odin.tweek.dk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Oct 2010, Martin Nybo Andersen wrote:

> On Tue, 26 Oct 2010, Dragoslav Zaric wrote:
>
> > [...]
> >
> > Is it at all possible to implement kernel without ticking, spin system
> > by events and periods ?
>
> You can compile with CONFIG_NO_HZ=n if you want a ticking kernel.

The kernel always ticks when a process is running CONFIG_NO_HZ does
nothing for that.

> > Maybe ticking is still best solution to have fast responding system ?

I think we need a tickless kernel.... Yes....

> My guesses are that it has already been benchmarked for speed, but you can
> still test it yourself.
> At least power usage/battery times is much better with a tickless kernel.

Well yes CONFIG_NO_HZ really should say CONFIG_NO_HZ_IDLE. You have
no ticks when a cpu is idle. Otherwise we are ticking...

