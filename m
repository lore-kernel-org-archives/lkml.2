Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab2HONkZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 09:40:25 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:64481 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754636Ab2HONkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 09:40:20 -0400
Date: Wed, 15 Aug 2012 06:40:15 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Hiroshi Doyu <hdoyu@nvidia.com>
Cc: Felipe Balbi <balbi@ti.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] debugfs: Allow debugfs_create_dir() to take data
Message-ID: <20120815134015.GA22202@kroah.com>
References: <1344407073-12030-1-git-send-email-hdoyu@nvidia.com>
 <1344407073-12030-2-git-send-email-hdoyu@nvidia.com>
 <20120808133427.GA14417@kroah.com>
 <20120809155624.b781edae9efa7c51faf6c31c@nvidia.com>
 <20120815084008.3d8f4ac20af5dc3372cd7681@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120815084008.3d8f4ac20af5dc3372cd7681@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 08:40:08AM +0300, Hiroshi Doyu wrote:
> On Thu, 9 Aug 2012 14:56:24 +0200
> Hiroshi Doyu <hdoyu@nvidia.com> wrote:
> 
> > Hi Greg, Felipe,
> > 
> > On Wed, 8 Aug 2012 15:34:27 +0200
> > Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > 
> > > On Wed, Aug 08, 2012 at 09:24:32AM +0300, Hiroshi Doyu wrote:
> > > > Add __debugfs_create_dir(), which takes data passed from caller.
> > > 
> > > Why?
> > > 
> > > > Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
> > > > ---
> > > >  fs/debugfs/inode.c      |    7 ++++---
> > > >  include/linux/debugfs.h |    9 ++++++++-
> > > >  2 files changed, 12 insertions(+), 4 deletions(-)
> > .....
> > > What are you trying to do here?  This patch doesn't look right at all.
> > 
> > I missed to send the cover letter of this patch series to LKML, which
> > explained the background. I attached that cover letter below. Please
> > read the following explanation too.
> 
> Any chance to get some feedback on this?

I still don't like it, and then there's the basic fact that I'm pretty
sure you broke the build with the patch, but who's noticing little
things like that :)

> I'm also sending another version of patch, which just uses
> debgufs_create_dir() as Felipe suggested, in-reply-to this mail.

I'd prefer not to change debugfs for this, so if you don't do that, I
don't object to your driver-specific patch.

greg k-h
