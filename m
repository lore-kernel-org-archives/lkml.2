Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758549Ab0FVAke (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 20:40:34 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:51098 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967Ab0FVAkd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 20:40:33 -0400
Date: Mon, 21 Jun 2010 17:40:30 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Subject: Re: linux-next: manual merge of the tip tree with the block tree
Message-ID: <20100622004030.GN2354@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100621161623.3dfedc32.sfr@canb.auug.org.au>
 <20100621171300.GF2354@linux.vnet.ibm.com>
 <20100622094033.3becf09f.sfr@canb.auug.org.au>
 <20100622100423.205ae0a4.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100622100423.205ae0a4.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 22, 2010 at 10:04:23AM +1000, Stephen Rothwell wrote:
> Hi Paul,
> 
> On Tue, 22 Jun 2010 09:40:33 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > On Mon, 21 Jun 2010 10:13:00 -0700 "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> > >
> > > I took a look, and all of the changes from "fs: remove all rcu head
> > > initializations, except on_stack initializations" are reflected in -next.
> > 
> > Thanks for checking.
> 
> Is there some way that this commit can be merged via the block tree?  Or
> does later work in your tree depend on it?  There is considerable and
> ongoing work in the block tree on the same areas as your commit changes.
> Even today, this conflict is going to be much worse.

I have no problem with this patch being applied via the block tree, as
long as it doesn't take too many minor releases for it to hit mainline.  ;-)

How would everyone like to proceed?

							Thanx, Paul
