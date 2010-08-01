Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751514Ab0HATpc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 15:45:32 -0400
Received: from netrider.rowland.org ([192.131.102.5]:59828 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751423Ab0HATpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 15:45:30 -0400
Date: Sun, 1 Aug 2010 15:45:29 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Arjan van de Ven <arjan@infradead.org>,
        <linux-pm@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <arve@android.com>, <mjg59@srcf.ucam.org>, <pavel@ucw.cz>,
        <florian@mickler.org>, <rjw@sisk.pl>, <swetland@google.com>,
        <peterz@infradead.org>, <tglx@linutronix.de>,
        <alan@lxorguk.ukuu.org.uk>
Subject: Re: Attempted summary of suspend-blockers LKML thread
In-Reply-To: <20100801054816.GI2470@linux.vnet.ibm.com>
Message-ID: <Pine.LNX.4.44L0.1008011542100.20420-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Jul 2010, Paul E. McKenney wrote:

> > > o	"Power-aware application" are applications that are permitted
> > > 	to acquire suspend blockers on Android.  Verion 8 of the
> > > 	suspend-blocker patch seems to use group permissions to
> > > determine which applications are classified as power aware.
> > > 
> > > 	More generally, power-aware applications seem to be those that
> > > 	have permission to exert some control over the system's
> > > 	power state.
> > 
> > I don't like the term "Power aware application". An application is well
> > behaved or it isn't. "aware" has nothing to do with it.
> 
> Applications are often complex enough to be aware of some things, naive
> about others, well behaved in some ways, and ill-behaved in others.
> This has been the case for some decades now, so it should not come as
> a surprise.
> 
> I am of course open to suggestions for alternatives to the term "power
> aware application", but most definitely not to obfuscating the difference
> between power awareness (or whatever name one wishes to call it) and
> the overall quality of the application, whatever "quality" might mean
> in a given context.

This is a false dichotomy.  The two of you have fallen into a logical 
trap.  I forget the word used to describe an argument based on a 
fundamental misunderstanding, but it applies here.

The term "power-aware" has _nothing_ to do with how well behaved an
application is, or its quality (in any sense).  Go back and re-read the
definition; you'll see what I mean.

Alan Stern

