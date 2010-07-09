Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757683Ab0GIQSu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 12:18:50 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:39101 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755883Ab0GIQSt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 12:18:49 -0400
Date: Fri, 9 Jul 2010 09:18:38 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Don Zickus <dzickus@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Jerome Marchand <jmarchan@redhat.com>,
       Mandeep Singh Baines <msb@google.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: while_each_thread() under rcu_read_lock() is broken?
Message-ID: <20100709161838.GS2426@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100618190251.GA17297@redhat.com>
 <20100618193403.GA17314@redhat.com>
 <20100618223354.GL2365@linux.vnet.ibm.com>
 <20100621170919.GA13826@redhat.com>
 <20100621174455.GA14886@redhat.com>
 <20100621190212.C8630400C5@magilla.sf.frob.com>
 <20100621200633.GA21099@redhat.com>
 <20100708235925.A71DA4A967@magilla.sf.frob.com>
 <20100709004107.GQ2426@linux.vnet.ibm.com>
 <20100709010137.B06704A968@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100709010137.B06704A968@magilla.sf.frob.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 08, 2010 at 06:01:37PM -0700, Roland McGrath wrote:
> > Hmmm...  The kerneldoc for rcu_read_lock() looks like it says this
> > pretty unambiguously.  Then again, that is easy for me to say, given
> > that I was the one who made most of this stuff up.   ;-)
> 
> Yeah, well, I thought I knew what rcu_read_lock did and the only new thing
> I had in mind was using call_rcu, so that's the only place I looked.  It
> wasn't entirely unreasonable to have to read through Documentation/RCU/ a
> bit for a subtlety of this kind, and I did find it quickly enough once
> Oleg's attentiveness alerted me to be freshly afraid of the subtleties.
> 
> > But it has been awhile since I looked after the kerneldoc.  Please see
> > below for the changes I would make if left to myself.
> 
> Those look good to me!

Very good, I have them queued.  I have some messy dependencies in my
tree, so it will take some time for them to appear.

> > Any other suggestions for improvement to the kerneldoc?
> 
> Oh, I don't know, send over someone to read it to me in a sultry voice
> so I get appropriately motivated to cast about for all of it I can find
> and listen closely to every word?  It already looks like if I'd actually
> read all of it twice that day, I would have had the information I needed.

Hmmm...  Despite being happily married for well over two decades, I do
feel the need to advise you to be careful what you wish for.  ;-)

							Thanx, Paul
