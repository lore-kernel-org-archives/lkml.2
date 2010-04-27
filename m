Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683Ab0D0DoE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 23:44:04 -0400
Received: from kroah.org ([198.145.64.141]:59576 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753027Ab0D0DoB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 23:44:01 -0400
Date: Mon, 26 Apr 2010 20:37:42 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: Can you include a new git tree in linux-next, the staging-next
	tree?
Message-ID: <20100427033742.GA4759@kroah.com>
References: <20100427000104.GA31358@kroah.com> <20100427131935.9d48a17b.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100427131935.9d48a17b.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 27, 2010 at 01:19:35PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> On Mon, 26 Apr 2010 17:01:04 -0700 Greg KH <greg@kroah.com> wrote:
> >
> > Welcome back from your break :)
> 
> Thanks - I was nice and refreshed until about 9am this morning :-)
> 
> > Could you include a new git tree in linux-next, the staging-next tree
> > at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging-next-2.6.git
> > 
> > the branch is "staging-next" to pull from.
> 
> OK, I will add it at the end today.  I assume that this will be based off
> Linus' tree?

Yes.

> > I'm trying to do the -next work for staging in a git tree to keep my
> > development quilt trees smaller, and make it a bit easier for others to
> > work off of if they want to.
> 
> Should I drop the "staging" quilt tree?

Yes, but not the staging.current tree, I'll still use that for now in
quilt.

thanks,

greg k-h
