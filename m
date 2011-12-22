Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441Ab1LVAku (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 19:40:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50000 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752462Ab1LVAkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 19:40:47 -0500
Date: Wed, 21 Dec 2011 16:40:30 -0800
From: Greg KH <gregkh@suse.de>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mempool: drop unnecessary and incorrect BUG_ON()
 from mempool_destroy()
Message-ID: <20111222004030.GA22345@suse.de>
References: <20111222001800.GL9213@google.com>
 <20111221162519.b7fc3a79.akpm@linux-foundation.org>
 <20111222003316.GN9213@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111222003316.GN9213@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 21, 2011 at 04:35:07PM -0800, Tejun Heo wrote:
> Hello,
> 
> On Wed, Dec 21, 2011 at 04:25:19PM -0800, Andrew Morton wrote:
> > > Signed-off-by: Tejun Heo <tj@kernel.org>
> > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > Cc: stable@kernel.org
> > 
> > (that's stable@vger.kernel.org)
> 
> (cc'ing Greg)
> 
> It has been stable@kernel.org for quite a while and Greg scans for
> that Cc.  Even MAINTAINERS has that as the official mail address.  I
> heard that the mailing alias is broken at the moment but wouldn't it
> be better to fix that?

I have a patch in one my trees to update the MAINTAINERS file, which
will get backported to the older kernels as well, it must be queued for
3.3, as it's not really a big deal.

And the alias is being worked on, sometimes it works, others it doesn't<
I'm not quite sure what is going on.

But either way, I will catch patches with cc: stable@vger.kernel.org or
stable@kernel.org when they hit Linus's tree, which is the important
thing, as that's the "real" path to get patches into stable releases.

thanks,

greg k-h
