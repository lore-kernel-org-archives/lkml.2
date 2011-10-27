Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309Ab1J0MJT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 08:09:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49994 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754248Ab1J0MJS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 08:09:18 -0400
Date: Thu, 27 Oct 2011 14:08:40 +0200
From: Greg KH <gregkh@suse.de>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net
Subject: Re: Linux 3.0.8
Message-ID: <20111027120840.GA6863@suse.de>
References: <20111025051928.GA7997@kroah.com>
 <1319716969.20488.14.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319716969.20488.14.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 27, 2011 at 02:02:49PM +0200, Paul Bolle wrote:
> On Tue, 2011-10-25 at 07:19 +0200, Greg KH wrote:
> > The updated 3.0.y git tree can be found at (NOTE THE ADDRESS CHANGE):
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.0.y
> > and can be browsed at the normal kernel.org git web browser:
> >         http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary
> 
> Somehow I seem to be able to generate perfect copies of patch-3.0.4.bz2
> (and earlier), by simply doing a command like:
>     git diff v3.0 v3.04 | bzip2 -9 > patch-3.0.4-git.bz2 
> 
> But for patch-3.0.5 (and above) trivial commands like
>      git diff v3.0 v3.0.8 > patch-3.0.8-git
> 
> do not generate perfect copies anymore. Have you perhaps changed the way
> you generate the patches since v3.0.5?  Not that this matters much,
> since tags v3.0.5 (and up) are signed by your "Linux kernel stable
> release signing key", but I still wonder what could cause this
> difference. Maybe it's just a git upgrade on your side.

We have found out that different versions of git will generate different
patches.  The end result of the patch when you apply it will always be
the same, but this is a non-trivial problem to solve.

That's why we generate the patches on our local machine and upload them,
instead of just generating the signature and having the server create
it.

Can you verify that the end result from your patch, and my patch,
produces the same tree?  If not, we need to resolve that.

thanks,

greg k-h
