Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900Ab0HAGA6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 02:00:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:45173 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab0HAGA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 02:00:57 -0400
Date: Sat, 31 Jul 2010 23:01:01 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, rjw@sisk.pl, stern@rowland.harvard.edu,
        swetland@google.com, peterz@infradead.org, tglx@linutronix.de,
        alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
Message-ID: <20100731230101.7cc1d8c7@infradead.org>
In-Reply-To: <20100801054816.GI2470@linux.vnet.ibm.com>
References: <20100731175841.GA9367@linux.vnet.ibm.com>
	<20100731215214.2543c07e@infradead.org>
	<20100801054816.GI2470@linux.vnet.ibm.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Jul 2010 22:48:16 -0700
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

> On Sat, Jul 31, 2010 at 09:52:14PM -0700, Arjan van de Ven wrote:
> > On Sat, 31 Jul 2010 10:58:42 -0700
> > "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> > 
> > > o	"Power-aware application" are applications that are
> > > permitted to acquire suspend blockers on Android.  Verion 8 of the
> > > 	suspend-blocker patch seems to use group permissions to
> > > determine which applications are classified as power aware.
> > > 
> > > 	More generally, power-aware applications seem to be those
> > > that have permission to exert some control over the system's
> > > 	power state.
> > 
> > I don't like the term "Power aware application". An application is
> > well behaved or it isn't. "aware" has nothing to do with it.
> 
> Applications are often complex enough to be aware of some things,
> naive about others, well behaved in some ways, and ill-behaved in
> others. This has been the case for some decades now, so it should not
> come as a surprise.

I do not like the term "aware". At all.
It implies "awareness", and implies it does things based on the power
circumstances.

It's about *behaving well*. (not polling, not having activity when
there is nothing to do etc etc). Not about being aware that power
matters.

I can write a very shitty application that polls all the time and
otherwise keeps the CPU and system busy, but it'll be aware that power
matters.. it just doesn't behave accordingly.



> 
> The choice between power-aware and power-naive will depend on who is
> available to do the programming and how valuable power-awareness is
> for the application in question.  Given that people who program
> PC-class applications are much more common than are people who
> program with energy efficiency in mind, the power-naive choice will
> be attractive in many cases.

I'm not sure I buy that.
4 years ago.. yes.
Today.. with PowerTOP and co out there for a long time?
I don't believe that anymore. Most of our open source PC apps are
actually very well behaving in the power sense.
Yes an occasional bug slips in, and then gets fixed quickly.
(speaking as someone who does this sort of work for a Linux
distribution... yes bugs happen on a whole distro level, but they're
also not all that common, and get fixed quickly)




-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
