Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727Ab1FIDwA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 23:52:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53551 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756365Ab1FIDv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 23:51:58 -0400
Date: Wed, 8 Jun 2011 20:52:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: NeilBrown <neilb@suse.de>
Cc: Miklos Szeredi <miklos@szeredi.hu>, viro@ZenIV.linux.org.uk,
        torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, apw@canonical.com, nbd@openwrt.org,
        hramrach@centrum.cz, jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu,
        mszeredi@suse.cz
Subject: Re: [PATCH 0/7] overlay filesystem: request for inclusion
Message-Id: <20110608205233.ebfedc4d.akpm@linux-foundation.org>
In-Reply-To: <20110609115934.3c53f78f@notabene.brown>
References: <1306932380-10280-1-git-send-email-miklos@szeredi.hu>
	<20110608153208.dc705cda.akpm@linux-foundation.org>
	<20110609115934.3c53f78f@notabene.brown>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Jun 2011 11:59:34 +1000 NeilBrown <neilb@suse.de> wrote:

> On Wed, 8 Jun 2011 15:32:08 -0700 Andrew Morton <akpm@linux-foundation.org>
> wrote:
> 
> > On Wed,  1 Jun 2011 14:46:13 +0200
> > Miklos Szeredi <miklos@szeredi.hu> wrote:
> > 
> > > I'd like to ask for overlayfs to be merged into 3.1.
> > 
> > Dumb questions:
> > 
> > I've never really understood the need for fs overlaying.  Who wants it?
> > What are the use-cases?
> 
> https://lwn.net/Articles/324291/
> 
> I think the strongest use case is that LIVE-DVD's want it to have a write-able
> root filesystem which is stored on the DVD.

Well, these things have been around for over 20 years.  What motivated
the developers of other OS's to develop these things and how are their
users using them?

> > 
> > This sort of thing could be implemented in userspace and wired up via
> > fuse, I assume.  Has that been attempted and why is it inadequate?
> 
> I think that would be a valid question if the proposal was large and
> complex.  But overlayfs is really quite small and self-contained.

Not merging it would be even smaller and simpler.  If there is a
userspace alternative then that option should be evaluated and compared
in a rational manner.



Another issue: there have been numerous attempts at Linux overlay
filesystems from numerous parties.  Does (or will) this implementation
satisfy all their requirements?

Because if not, we're in a situation where the in-kernel code is
unfixably inadequate so we end up merging another similar-looking
thing, or the presence of this driver makes it harder for them to get
other drivers merged and the other parties' requirements remain
unsatisfied.

