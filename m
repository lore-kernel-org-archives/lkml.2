Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139Ab2HOFmf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 01:42:35 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:14923 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006Ab2HOFmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 01:42:33 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 14 Aug 2012 22:40:11 -0700
Date: Wed, 15 Aug 2012 08:40:08 +0300
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] debugfs: Allow debugfs_create_dir() to take data
Message-ID: <20120815084008.3d8f4ac20af5dc3372cd7681@nvidia.com>
In-Reply-To: <20120809155624.b781edae9efa7c51faf6c31c@nvidia.com>
References: <1344407073-12030-1-git-send-email-hdoyu@nvidia.com>
	<1344407073-12030-2-git-send-email-hdoyu@nvidia.com>
	<20120808133427.GA14417@kroah.com>
	<20120809155624.b781edae9efa7c51faf6c31c@nvidia.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Aug 2012 14:56:24 +0200
Hiroshi Doyu <hdoyu@nvidia.com> wrote:

> Hi Greg, Felipe,
> 
> On Wed, 8 Aug 2012 15:34:27 +0200
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> 
> > On Wed, Aug 08, 2012 at 09:24:32AM +0300, Hiroshi Doyu wrote:
> > > Add __debugfs_create_dir(), which takes data passed from caller.
> > 
> > Why?
> > 
> > > Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
> > > ---
> > >  fs/debugfs/inode.c      |    7 ++++---
> > >  include/linux/debugfs.h |    9 ++++++++-
> > >  2 files changed, 12 insertions(+), 4 deletions(-)
> .....
> > What are you trying to do here?  This patch doesn't look right at all.
> 
> I missed to send the cover letter of this patch series to LKML, which
> explained the background. I attached that cover letter below. Please
> read the following explanation too.

Any chance to get some feedback on this?

I'm also sending another version of patch, which just uses
debgufs_create_dir() as Felipe suggested, in-reply-to this mail.
