Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227Ab0LDR2E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Dec 2010 12:28:04 -0500
Received: from kroah.org ([198.145.64.141]:44565 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752396Ab0LDR2C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Dec 2010 12:28:02 -0500
Date: Sat, 4 Dec 2010 09:27:18 -0800
From: Greg KH <greg@kroah.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org,
        jason.wessel@windriver.com, Andi Kleen <andi@firstfloor.org>,
        lwn@lwn.net
Subject: Re: Announcement: Plans for v2.6.34-longterm
Message-ID: <20101204172718.GB10282@kroah.com>
References: <20101203210719.GB21223@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101203210719.GB21223@windriver.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 03, 2010 at 04:07:19PM -0500, Paul Gortmaker wrote:
> Firstly, I'd like to thank Greg for all the past work he's done on
> juggling all these different stable releases - many people have
> reaped the benefits of them for quite some time, and it only makes
> sense to spread the loading around as it has grown significantly.
> 
> With that in mind, it is our intention to also maintain a 2.6.34
> longterm tree.  Jason and I work at Wind River, which already has
> released products based on v2.6.34, and as such it only makes sense
> to have a public long-term tree that others who are also based on
> 2.6.34 can make use of.
> 
> I've already done an end-to-end audit of the current 2.6.32 longterm
> stable release, and used the list of these already "approved for stable"
> patches on v2.6.32 to identify 260 upstream commits that are applicable,
> but not yet present in the last 2.6.34.7 stable release.
> 
> A candidate tree for 2.6.34.8 with the above 260 commits applied to
> it is available now for review/testing at:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/paulg/linux-2.6.34.y.git

That's great, but you really don't want to keep the patches in a
"combined" git tree like this for development and review.  What happens
if someone says "patch 121 needs to be removed"?

I recommend using quilt like we have been for the stable tree for the
past 5+ years as it handles situations like this very well.

Other than that, good luck with this, it's a lot of work :)

greg k-h
