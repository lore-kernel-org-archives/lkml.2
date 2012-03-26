Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757907Ab2CZX5w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 19:57:52 -0400
Received: from lunge.queued.net ([173.255.254.236]:51601 "EHLO
	lunge.queued.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757876Ab2CZX5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 19:57:51 -0400
Date: Mon, 26 Mar 2012 16:57:46 -0700
From: Andres Salomon <dilinger@queued.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Daniel Drake <dsd@laptop.org>, mingo@redhat.com, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        pgf@laptop.org
Subject: Re: [PATCH v4] x86, olpc: add debugfs interface for EC commands
Message-ID: <20120326165746.30588c55@debxo>
In-Reply-To: <20120326155359.e5092006.akpm@linux-foundation.org>
References: <20120326180710.8DF9C9D401E@zog.reactivated.net>
	<20120326142908.c5248aec.akpm@linux-foundation.org>
	<CAMLZHHSD8eRd17NyUb=Druj==4Eh+XtY=86vGQUGU1fiPMcMNg@mail.gmail.com>
	<20120326155359.e5092006.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Mar 2012 15:53:59 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 26 Mar 2012 16:45:10 -0600
> Daniel Drake <dsd@laptop.org> wrote:
> 
> > On Mon, Mar 26, 2012 at 3:29 PM, Andrew Morton
> > <akpm@linux-foundation.org> wrote:
> > > s/fix/break/? __"Originally-from" is not a recognised tag. __If
> > > this code is based upon an earlier version from Paul then
> > > Signed-off-by: is correct.
> > >
> > > What's going on here? __What are you trying to communicate?
> > 
> > I'm trying to take Ingo's suggestion, in the thread "[patch 1/8]
> > x86, olpc: add debugfs interface for EC commands" he wrote:
> > 
> > ====
> > This is not a valid signoff sequence - the 'From: ' author of
> > the patch must be the first SOB line.
> > 
> > The way to do this is either to have a:
> > 
> >  From: Paul Fox <pgf@laptop.org>
> > 
> > or to covert Paul Fox's SOB to a credit line, such as:
> > 
> >  Originally-from: Paul Fox <pgf@laptop.org>
> > ====
> > 
> > The original code was from Paul Fox. I changed it somewhat
> > significantly, and Paul approves of the end result.
> > Can someone suggest a way of expressing this, including tag
> > ordering, that will be accepted by all parties?  :)
> 
> From: Daniel Drake <dsd@laptop.org>
> 
> ....
> 
> The original code was from Paul Fox.  I changed it somewhat
> significantly, and Paul approves of the end result.
> 
> Signed-off-by: Paul Fox <pgf@laptop.org>
> Signed-off-by: Daniel Drake <dsd@laptop.org>


This makes a lot more sense to me (and has been used in the past by
both myself and dsd for OLPC submissions) rather than having a plethora
of machine-parsable tags that no one cares about.  Minus the "approves
of the end result" bit, though, as that's implicit in the SOB line.
There are innumerable possible variants of this (Originally-by,
Co-authored-with, Based-on-code-in-another-project-by,
Written-while-being-whipped-by, and so on).

