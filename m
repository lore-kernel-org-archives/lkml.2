Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753Ab0DAPfh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 11:35:37 -0400
Received: from cantor.suse.de ([195.135.220.2]:52965 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222Ab0DAPfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 11:35:31 -0400
Date: Thu, 1 Apr 2010 08:35:23 -0700
From: Greg KH <gregkh@suse.de>
To: David Miller <davem@davemloft.net>
Cc: w@1wt.eu, david@fromorbit.com, linux-kernel@vger.kernel.org,
       stable@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable-review@kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] 4 stable kernel review cycles starting
Message-ID: <20100401153523.GA12944@suse.de>
References: <20100331215332.GH7671@dastard> <20100331224755.GA23284@suse.de> <20100401044048.GD16238@1wt.eu> <20100401.002622.179174704.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100401.002622.179174704.davem@davemloft.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 01, 2010 at 12:26:22AM -0700, David Miller wrote:
> From: Willy Tarreau <w@1wt.eu>
> Date: Thu, 1 Apr 2010 06:40:48 +0200
> 
> > For this reason, IMHO it helps when submitters can indicate in each
> > patch the mainline equivalent ID, or alternatively that it's pointless
> > to look for it because the fix is much different.
> 
> I put this at the top of every networking/ide/sparc commit message
> for -stable submissions I make.
> 
> In fact I thought that was a requirement for -stable submissions?

It is.  Unfortunatly not everyone remembers it, and I have to go dig
through the git tree to find the commit ids, which slows down the
ability for their patches to get accepted.

The patches that include the git commit ids are trivial to get added to
the tree, almost no extra work on my part.

thanks,

greg k-h
