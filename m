Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332Ab1CHKmw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 05:42:52 -0500
Received: from www.tglx.de ([62.245.132.106]:35737 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751683Ab1CHKmt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 05:42:49 -0500
Date: Tue, 8 Mar 2011 11:41:42 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sam Ravnborg <sam@ravnborg.org>
cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        David Howells <dhowells@redhat.com>
Subject: Re: [patch 31/37] mn10300: Use generic irq Kconfig
In-Reply-To: <20110305220127.GA21728@merkur.ravnborg.org>
Message-ID: <alpine.LFD.2.00.1103081140580.2787@localhost6.localdomain6>
References: <20110119205258.462759212@linutronix.de> <20110119210840.381111598@linutronix.de> <AANLkTi=nLFx7Z7UfiXZrBQoGgC1Fh_dh9--5T=Di9qhc@mail.gmail.com> <20110305220127.GA21728@merkur.ravnborg.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463795968-1698934581-1299580906=:2787"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463795968-1698934581-1299580906=:2787
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Sat, 5 Mar 2011, Sam Ravnborg wrote:

> On Sat, Mar 05, 2011 at 10:02:33PM +0100, Geert Uytterhoeven wrote:
> > On Wed, Jan 19, 2011 at 22:49, Thomas Gleixner <tglx@linutronix.de> wrote:
> > > No functional change.
> > >
> > > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > > Cc: David Howells <dhowells@redhat.com>
> > > ---
> > >  arch/mn10300/Kconfig |    5 +----
> > >  1 file changed, 1 insertion(+), 4 deletions(-)
> > >
> > > Index: linux-2.6/arch/mn10300/Kconfig
> > > ===================================================================
> > > --- linux-2.6.orig/arch/mn10300/Kconfig
> > > +++ linux-2.6/arch/mn10300/Kconfig
> > > @@ -1,6 +1,7 @@
> > >  config MN10300
> > >        def_bool y
> > >        select HAVE_OPROFILE
> > > +       select GENERIC_HARDIRQS
> > 
> > Wasn't this supposed to be "select HAVE_GENERIC_HARDIRQS"?

Crap, yes.

> > /me studying generic hardirqs...
> 
> One could hope this was nicely documented in kernel/irq/Kconfig.
> But that file contains only 9 lines of comments for 10 config symbols.
> 
> Maybe it is just me but I was struggeling understanding the purpose
> of these config symbols.
> 
> I found the individual bits of genirq nicely documented in most cases.
> But the overall picture was/is hard to get.
> 
> And I never got enough understanding to write up something myself :-(

Point taken. /me goes and adds comments :)

      tglx
---1463795968-1698934581-1299580906=:2787--
