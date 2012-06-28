Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612Ab2F1Bs3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 21:48:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40297 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753686Ab2F1Bs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 21:48:28 -0400
Date: Wed, 27 Jun 2012 18:48:23 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Kay Sievers <kay@vrfy.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Wu Fengguang <fengguang.wu@intel.com>, Joe Perches <joe@perches.com>,
        "Paul E. McKenney" <paulmck@us.ibm.com>
Subject: Re: [PATCH v3] printk: Have printk() never buffer its data
Message-ID: <20120628014823.GA2025@kroah.com>
References: <CA+55aFwczZTA=JUahoj_Sw1fQssDwoM2LGJ6g5nPvehTLxnSpg@mail.gmail.com>
 <20120626002307.GA4389@kroah.com>
 <CA+55aFxhYRqcU2EUmcsuLrhgo4FEO6-b+mB57wB3JRiXEp3ZrA@mail.gmail.com>
 <CAPXgP10cPFSmZ5yr6Z4wVtDa+x2J1yQDF57NJXtxjUuxMHm=Lw@mail.gmail.com>
 <CA+55aFzkX=jCC1O6+2oz8meswOqZQ+Q8Ao60q8eAS1G3AuEStQ@mail.gmail.com>
 <1340726856.977.6.camel@mop>
 <1340810038.16702.16.camel@gandalf.stny.rr.com>
 <1340810283.16702.19.camel@gandalf.stny.rr.com>
 <CAPXgP121+zA_p4x9VdSMWtu-SqqqiNC51CKkYKY4YkAL+QsQ4g@mail.gmail.com>
 <1340869133.876.10.camel@mop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340869133.876.10.camel@mop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2012 at 09:38:53AM +0200, Kay Sievers wrote:
> On Wed, 2012-06-27 at 11:26 -0400, Kay Sievers wrote:
> > On Wed, Jun 27, 2012 at 11:18 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > > On Wed, 2012-06-27 at 11:13 -0400, Steven Rostedt wrote:
> > >
> > >> I just tested this patch and it boots fine for me.
> > >
> > > Of course after sending this, I rebooted to the same kernel and it
> > > locked up :-p
> > 
> > Thanks for testing it. Greg had some issues too, which I can't
> > reproduce it on any of my boxes. I'll have a look ...
> 
> Here is an updated version, that should be look a bit cleaner.
> 
> It passes all my tests here, including the fake kernel module that has
> threads racing against each other. With that, the console output gets a
> bit disturbed now without the buffering, but the recorded log still
> looks all fine.

And this solves the boot problem I was seeing, thanks a lot for fixing
that issue.

Steven, any objections to me taking this patch?

thanks,

greg k-h
