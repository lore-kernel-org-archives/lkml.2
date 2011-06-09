Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918Ab1FIURF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 16:17:05 -0400
Received: from cantor.suse.de ([195.135.220.2]:56480 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755887Ab1FIURC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 16:17:02 -0400
Subject: Re: [PATCH 0/7] overlay filesystem: request for inclusion
From: Miklos Szeredi <mszeredi@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>, NeilBrown <neilb@suse.de>,
        Miklos Szeredi <miklos@szeredi.hu>, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        nbd@openwrt.org, hramrach@centrum.cz, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu
In-Reply-To: <BANLkTimTyYp1P4qd8awvsq6PVZn1TQ5A-Q@mail.gmail.com>
References: <1306932380-10280-1-git-send-email-miklos@szeredi.hu>
	 <20110608153208.dc705cda.akpm@linux-foundation.org>
	 <20110609115934.3c53f78f@notabene.brown>
	 <20110608205233.ebfedc4d.akpm@linux-foundation.org>
	 <20110609134947.GD13242@shadowen.org>
	 <20110609123220.6afb9d0f.akpm@linux-foundation.org>
	 <BANLkTimTyYp1P4qd8awvsq6PVZn1TQ5A-Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Jun 2011 22:17:22 +0200
Message-ID: <1307650642.9874.10.camel@tucsk.pomaz.szeredi.hu>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-09 at 12:40 -0700, Linus Torvalds wrote:
> On Thu, Jun 9, 2011 at 12:32 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> >
> > If the implementation is slow or buggy then the appropriate action is
> > to speed it up and to fix the bugs, so these are just non-arguments,
> > IMO.
> 
> Umm.
> 
> "userspace filesystem"?
> 
> The problem is right there. Always has been. People who think that
> userspace filesystems are realistic for anything but toys are just
> misguided.
> 
> fuse works fine if the thing being exported is some random low-use
> interface to a fundamentally slow device. But for something like your
> root filesystem? Nope. Not going to happen.

It's a tradeoff between speed and ease of development.

NTFS has been doing nicely in userspace for almost half a decade.  It's
not as fast as a kernel driver _could_ be, but it's faster than _the_
kernel driver.

And there's room for improvement.  The fact is (and you know it) the
speed of filesystems mainly comes from caching not from the filesystem
itself, so whether it's in userspace or in kernelspace matters not all
that much in the end.

> So Andrew, I think that arguing that something _can_ be done with
> fuse, and thus _should_ be done with fuse is just ridiculous. That's
> like saying you should do a microkernel - it may sound nice on paper,
> but it's a damn stupid idea for people who care more about some idea
> than they care about reality.

I think it isn't ridiculous, but here the tradeoffs might be in favor of
a kernel based solution.  And I'm saying that after having done both.

Thanks,
Miklos


