Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023Ab1CEWBa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 17:01:30 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:39603 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055Ab1CEWB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 17:01:29 -0500
Date: Sat, 5 Mar 2011 23:01:27 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        David Howells <dhowells@redhat.com>
Subject: Re: [patch 31/37] mn10300: Use generic irq Kconfig
Message-ID: <20110305220127.GA21728@merkur.ravnborg.org>
References: <20110119205258.462759212@linutronix.de> <20110119210840.381111598@linutronix.de> <AANLkTi=nLFx7Z7UfiXZrBQoGgC1Fh_dh9--5T=Di9qhc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=nLFx7Z7UfiXZrBQoGgC1Fh_dh9--5T=Di9qhc@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 05, 2011 at 10:02:33PM +0100, Geert Uytterhoeven wrote:
> On Wed, Jan 19, 2011 at 22:49, Thomas Gleixner <tglx@linutronix.de> wrote:
> > No functional change.
> >
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > Cc: David Howells <dhowells@redhat.com>
> > ---
> >  arch/mn10300/Kconfig |    5 +----
> >  1 file changed, 1 insertion(+), 4 deletions(-)
> >
> > Index: linux-2.6/arch/mn10300/Kconfig
> > ===================================================================
> > --- linux-2.6.orig/arch/mn10300/Kconfig
> > +++ linux-2.6/arch/mn10300/Kconfig
> > @@ -1,6 +1,7 @@
> >  config MN10300
> >        def_bool y
> >        select HAVE_OPROFILE
> > +       select GENERIC_HARDIRQS
> 
> Wasn't this supposed to be "select HAVE_GENERIC_HARDIRQS"?
> 
> /me studying generic hardirqs...

One could hope this was nicely documented in kernel/irq/Kconfig.
But that file contains only 9 lines of comments for 10 config symbols.

Maybe it is just me but I was struggeling understanding the purpose
of these config symbols.

I found the individual bits of genirq nicely documented in most cases.
But the overall picture was/is hard to get.

And I never got enough understanding to write up something myself :-(

	Sam
