Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932670Ab1JCVfI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 17:35:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50107 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756850Ab1JCVfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 17:35:06 -0400
Date: Mon, 3 Oct 2011 14:26:26 -0700
From: Greg KH <gregkh@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net
Subject: Re: Linux 3.0.6
Message-ID: <20111003212626.GA24927@suse.de>
References: <20111003203537.GC22113@kroah.com>
 <alpine.LFD.2.02.1110032308120.1489@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1110032308120.1489@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 03, 2011 at 11:11:12PM +0200, Thomas Gleixner wrote:
> On Mon, 3 Oct 2011, Greg KH wrote:
> 
> > I'm announcing the release of the 3.0.6 kernel.
> > 
> > There was a build error in the radeon driver of the 3.0.5 kernel, so
> > this update is only needed if you have problems building that kernel.
> > 
> > The updated 3.0.y git tree can be found at (NOTE THE ADDRESS CHANGE):
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
> 
> That's missing the branch
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git 3.0.y

Oops, sorry, you are right.

> and while I can see the reason to make branches instead of separate
> trees, it's a nightmare when you want to get the 3.0.y tags because
> git insists on downloading the world and some more :(. It's just a one
> time thing, but nevertheless anoying as hell.

Yeah, but now we will not have a ton of different directories, one per
minor release, as it seemed that everyone ended up using the merged tree
anyway.

thanks,

greg k-h
