Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815Ab0DAPf6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 11:35:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46366 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756696Ab0DAPfe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 11:35:34 -0400
Date: Thu, 1 Apr 2010 08:35:47 -0700
From: Greg KH <gregkh@suse.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: David Miller <davem@davemloft.net>, w@1wt.eu, david@fromorbit.com,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] 4 stable kernel review cycles starting
Message-ID: <20100401153547.GB12944@suse.de>
References: <20100331215332.GH7671@dastard> <20100331224755.GA23284@suse.de> <20100401044048.GD16238@1wt.eu> <20100401.002622.179174704.davem@davemloft.net> <4BB4823F.7040408@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BB4823F.7040408@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 01, 2010 at 01:23:43PM +0200, Stefan Richter wrote:
> David Miller wrote:
> > From: Willy Tarreau <w@1wt.eu>
> > Date: Thu, 1 Apr 2010 06:40:48 +0200
> > 
> >> For this reason, IMHO it helps when submitters can indicate in each
> >> patch the mainline equivalent ID, or alternatively that it's pointless
> >> to look for it because the fix is much different.
> > 
> > I put this at the top of every networking/ide/sparc commit message
> > for -stable submissions I make.
> > 
> > In fact I thought that was a requirement for -stable submissions?
> 
> It is a documented requirement, perhaps not very clearly worded in The
> Submitter's Guide To Stable...
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=46cdf871d9970b9252469531f9efd4a17243bb0b

Patches always welcome to make that file easier to understand.

thanks,

greg k-h
