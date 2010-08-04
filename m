Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177Ab0HDVkp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 17:40:45 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:58227 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786Ab0HDVkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 17:40:39 -0400
Date: Wed, 4 Aug 2010 22:40:32 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Arve Hj?nnev?g <arve@android.com>, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, florian@mickler.org, rjw@sisk.pl,
        stern@rowland.harvard.edu, swetland@google.com, peterz@infradead.org,
        tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
Message-ID: <20100804214031.GD5864@sirena.org.uk>
References: <20100801191228.GL2470@linux.vnet.ibm.com> <20100801154708.19817b75@infradead.org> <20100802011006.GS2470@linux.vnet.ibm.com> <AANLkTi=a-1hn_oL=i-=RKK9xOur+4mQjTRut+aiXtYkE@mail.gmail.com> <20100803183447.0275c134@infradead.org> <20100804163216.GB24163@linux.vnet.ibm.com> <20100804163509.GA31523@srcf.ucam.org> <20100804204208.GA21452@elf.ucw.cz> <20100804205159.GH24163@linux.vnet.ibm.com> <20100804211513.GC21452@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100804211513.GC21452@elf.ucw.cz>
X-Cookie: Only God can make random selections.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 04, 2010 at 11:15:13PM +0200, Pavel Machek wrote:

> > > In different message, Arve said they are actually using low-power idle
> > > to emulate suspend on Android.

> > Could you please point me at this message?

> AFAICT, this tells us that idle and suspend is the same hardware state
> on current Android hardware:

This is all massively system dependant.  On some systems when the system
is in the same idle state in the lowest power idle mode as in suspend
however as a result of not doing the suspend (which causes Linux to
quiesce most of the hardware) many more things will be able to generate
wake events.  On other systems you will achieve a lower power state by
using suspend for various reasons, some fixable and some not.  I rather
suspect Arve was talking about the former case.
