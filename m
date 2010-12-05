Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608Ab0LEAqJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Dec 2010 19:46:09 -0500
Received: from mail.windriver.com ([147.11.1.11]:65240 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755187Ab0LEAqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Dec 2010 19:46:07 -0500
Date: Sat, 4 Dec 2010 19:45:54 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org,
        jason.wessel@windriver.com, Andi Kleen <andi@firstfloor.org>,
        lwn@lwn.net
Subject: Re: Announcement: Plans for v2.6.34-longterm
Message-ID: <20101205004554.GA314@windriver.com>
References: <20101203210719.GB21223@windriver.com>
 <20101204172718.GB10282@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101204172718.GB10282@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 05 Dec 2010 00:45:55.0307 (UTC) FILETIME=[C657FBB0:01CB9415]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Re: Announcement: Plans for v2.6.34-longterm] On 04/12/2010 (Sat 09:27) Greg KH wrote:

> On Fri, Dec 03, 2010 at 04:07:19PM -0500, Paul Gortmaker wrote:
> > Firstly, I'd like to thank Greg for all the past work he's done on
> > juggling all these different stable releases - many people have
> > reaped the benefits of them for quite some time, and it only makes
> > sense to spread the loading around as it has grown significantly.
> > 
> > With that in mind, it is our intention to also maintain a 2.6.34
> > longterm tree.  Jason and I work at Wind River, which already has
> > released products based on v2.6.34, and as such it only makes sense
> > to have a public long-term tree that others who are also based on
> > 2.6.34 can make use of.
> > 
> > I've already done an end-to-end audit of the current 2.6.32 longterm
> > stable release, and used the list of these already "approved for stable"
> > patches on v2.6.32 to identify 260 upstream commits that are applicable,
> > but not yet present in the last 2.6.34.7 stable release.
> > 
> > A candidate tree for 2.6.34.8 with the above 260 commits applied to
> > it is available now for review/testing at:
> > 
> >    git://git.kernel.org/pub/scm/linux/kernel/git/paulg/linux-2.6.34.y.git
> 
> That's great, but you really don't want to keep the patches in a
> "combined" git tree like this for development and review.  What happens
> if someone says "patch 121 needs to be removed"?
> 
> I recommend using quilt like we have been for the stable tree for the
> past 5+ years as it handles situations like this very well.

It was my intention to also create a git repo of patches, but since I've
found myself using quilt less and less in favour of just using git
directly, it wasn't a natural byproduct of my work so far. 

Fortunately its easy to dump patches out into a repo of patches suitable
for quilt, so there is one now, and it makes a good place to put that
audit data relating to this that I'd sent you a couple weeks ago.

http://git.kernel.org/?p=linux/kernel/git/paulg/stable-queue.git;a=summary
 
> Other than that, good luck with this, it's a lot of work :)

Thanks!

Paul.

> 
> greg k-h
