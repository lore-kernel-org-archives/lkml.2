Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755023Ab1FITdr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 15:33:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56839 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754692Ab1FITdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 15:33:42 -0400
Date: Thu, 9 Jun 2011 12:32:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andy Whitcroft <apw@canonical.com>
Cc: NeilBrown <neilb@suse.de>, Miklos Szeredi <miklos@szeredi.hu>,
        viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        nbd@openwrt.org, hramrach@centrum.cz, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, mszeredi@suse.cz
Subject: Re: [PATCH 0/7] overlay filesystem: request for inclusion
Message-Id: <20110609123220.6afb9d0f.akpm@linux-foundation.org>
In-Reply-To: <20110609134947.GD13242@shadowen.org>
References: <1306932380-10280-1-git-send-email-miklos@szeredi.hu>
	<20110608153208.dc705cda.akpm@linux-foundation.org>
	<20110609115934.3c53f78f@notabene.brown>
	<20110608205233.ebfedc4d.akpm@linux-foundation.org>
	<20110609134947.GD13242@shadowen.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Jun 2011 14:49:47 +0100
Andy Whitcroft <apw@canonical.com> wrote:

> On Wed, Jun 08, 2011 at 08:52:33PM -0700, Andrew Morton wrote:
> 
> > > > This sort of thing could be implemented in userspace and wired up via
> > > > fuse, I assume.  Has that been attempted and why is it inadequate?
> > > 
> > > I think that would be a valid question if the proposal was large and
> > > complex.  But overlayfs is really quite small and self-contained.
> > 
> > Not merging it would be even smaller and simpler.  If there is a
> > userspace alternative then that option should be evaluated and compared
> > in a rational manner.
> 
> For the Ubuntu liveCD we have tried to use unions via fuse with a view
> to dropping aufs2 as an external module.  The performance was atrocious
> (IIRC of the order of 10x slower), to the point that most people assumed
> it was broken and reset the machine.

On Thu, 9 Jun 2011 15:57:48 +0200
Michal Suchanek <hramrach@centrum.cz> wrote:

> The problem with the userspace alternative is that it does not work. I
> tried to run my live CD on top of unionfs-fuse and the filesystem
> would fail intermittently leading to random errors during boot.


If the implementation is slow or buggy then the appropriate action is
to speed it up and to fix the bugs, so these are just non-arguments,
IMO.

If it is demonstrated that the userspace implementation simply cannot
ever have acceptable performance then OK, we have an argument for a
kernel driver.
