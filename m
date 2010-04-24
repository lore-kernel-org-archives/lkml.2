Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab0DXPQE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Apr 2010 11:16:04 -0400
Received: from cantor.suse.de ([195.135.220.2]:34361 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753339Ab0DXPQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Apr 2010 11:16:03 -0400
Date: Sat, 24 Apr 2010 08:02:31 -0700
From: Greg KH <gregkh@suse.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: tytso@mit.edu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Documentation: -stable rules: upstream commit ID
	requirement reworded
Message-ID: <20100424150231.GA9572@suse.de>
References: <20100422222928.GA3268@kroah.com> <1271976016-3584-1-git-send-email-gregkh@suse.de> <20100424020253.GP14986@thunk.org> <4BD2B5EC.4020808@s5r6.in-berlin.de> <4BD2BA28.3000109@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BD2BA28.3000109@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 24, 2010 at 11:30:16AM +0200, Stefan Richter wrote:
> Stefan Richter wrote:
> > tytso@mit.edu wrote:
> >> I find the upstream commit ID to be highly useful when looking at
> >> commits in the stable tree.  So it would be nice IMHO if we could
> >> enforce this requirement regardless of whether the submission path is
> >> via e-mail or git.
> ...
> > Apparently Greg's scripts modify the
> > changelogs respectively when he cherry-picks from linux-2.6.git, so the
> > requirement is also always fulfilled with this alternative submission path.
> 
> Or do you mean submission directly from a developer's git tree to stable
> via git pull by Greg?  Is this been done?  If yes, I suppose this comes
> only from people who know very well how a stable patch is meant to look
> like.  Nevertheless I could send another adjustment for
> Documentation/stable_kernel_rules.txt if this is another actual
> submission path.

No, it's not a real submission patch, and yes, I always require a git
commit id in the patch.  If I don't have it, it is explained in the
patch why it is not in Linus's tree.

Don't worry, I think the current wording is fine.

thanks,

greg k-h
