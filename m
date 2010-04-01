Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517Ab0DAEla (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 00:41:30 -0400
Received: from 1wt.eu ([62.212.114.60]:61245 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752423Ab0DAElY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 00:41:24 -0400
Date: Thu, 1 Apr 2010 06:40:48 +0200
From: Willy Tarreau <w@1wt.eu>
To: Greg KH <gregkh@suse.de>
Cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable-review@kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] 4 stable kernel review cycles starting
Message-ID: <20100401044048.GD16238@1wt.eu>
References: <20100330230338.GA28642@kroah.com> <20100331044445.GU3335@dastard> <20100331173831.GA9180@suse.de> <20100331215332.GH7671@dastard> <20100331224755.GA23284@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100331224755.GA23284@suse.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 31, 2010 at 03:47:55PM -0700, Greg KH wrote:
> On Thu, Apr 01, 2010 at 08:53:32AM +1100, Dave Chinner wrote:
> > On Wed, Mar 31, 2010 at 10:38:31AM -0700, Greg KH wrote:
> > > The issue is that applying individual patches like this is more
> > > "difficult" than just handling patches that are already marked in
> > > Linus's kernel tree as to be added to the stable queues.  So it
> > > takes a bit more time and effort to get to those patches, while
> > > still keeping up with the series like you, and other developers,
> > > sent.
> > 
> > Understood. Would providing a git tree to pull from for large series
> > like the XFS one make this easier for you in future? I can do that
> > bit of extra work if that makes things easier for you...
> 
> No, patches are still easier, I would have to convert the git tree to
> patches anyway, so for now, this is fine.

I don't know for you, Greg, but one thing that I find time consuming
when merging fixes that I'm not backporting is to try to find the
commit ID of the equivalent mainline fix. And it's not specific to
the kernel, I also have the same issue with other projects.

For this reason, IMHO it helps when submitters can indicate in each
patch the mainline equivalent ID, or alternatively that it's pointless
to look for it because the fix is much different.

Just my 2 cents,
Willy

