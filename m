Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932340Ab2IQPyT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 11:54:19 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:56370 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932093Ab2IQPyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 11:54:16 -0400
Date: Mon, 17 Sep 2012 08:54:08 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Jason Wessel <jason.wessel@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>, Alan Cox <alan@linux.intel.com>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Colin Cross <ccross@android.com>, Brian Swetland <swetland@google.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com,
        kgdb-bugreport@lists.sourceforge.net, linux-serial@vger.kernel.org
Subject: Re: [PATCH v7 0/11] KGDB/KDB FIQ (NMI) debugger
Message-ID: <20120917155408.GA302@kroah.com>
References: <20120913150133.GA16238@lizard>
 <20120917113750.GA28838@kroah.com>
 <50571ADF.3000406@windriver.com>
 <20120917125427.GA23516@kroah.com>
 <20120917153943.GA7510@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120917153943.GA7510@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 08:39:43AM -0700, Anton Vorontsov wrote:
> On Mon, Sep 17, 2012 at 05:54:27AM -0700, Greg Kroah-Hartman wrote:
> [...]
> > > > To make it easier, can I just take the tty driver patches now?  Will
> > > > that break anything?
> > > 
> > > I have not made my way through the entire series yet, so I am not sure
> > > if you need the kdb header changes or not, but so far it looks like
> > > the tty pieces are separate.  If you add your ack Greg, I'll take the
> > > whole series and merge it into kgdb-next, or after I finish the review
> > > we could do it the other way around.
> > 
> > Your tree is fine:
> > 
> > Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > Let me know if you have problems merging this due to any tty patches,
> > and if so, I'll be glad to take them through my tree.
> 
> Guys, thanks for taking a look into this!
> 
> The patch that adds nmi console driver (i.e. tty/serial/kgdb_nmi.c)
> depends on the first KDB patches in these series, and it depends on
> amba-pl1011 and tty_port work, which is in tty-next.
> 
> So, the series have to go via tty-next; I believe Jason won't able
> to take it via his tree.

Ok, I'll wait for Jason to review them.  Jason, let me know how it
goes...

greg k-h
