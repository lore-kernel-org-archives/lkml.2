Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704Ab0JTCPG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 22:15:06 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:11497 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751375Ab0JTCPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 22:15:04 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEALPqvUx5LdoF/2dsb2JhbAChVXLDPIVKBI9L
Date: Wed, 20 Oct 2010 13:14:57 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: npiggin@kernel.dk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [patch 08/35] fs: icache lock i_count
Message-ID: <20101020021457.GA3740@amd>
References: <20101019034216.319085068@kernel.dk>
 <20101019034656.303425354@kernel.dk>
 <4CBD7013.1030709@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CBD7013.1030709@panasas.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 12:16:51PM +0200, Boaz Harrosh wrote:
> On 10/19/2010 05:42 AM, npiggin@kernel.dk wrote:
> > Protect inode->i_count with i_lock, rather than having it atomic.
> > 
> > Signed-off-by: Nick Piggin <npiggin@kernel.dk>
> > 
> > ---
> <>
> >  fs/exofs/inode.c                         |   12 +++++++---
> >  fs/exofs/namei.c                         |    4 ++-
> <>
> > Index: linux-2.6/fs/exofs/inode.c
> > ===================================================================
> > --- linux-2.6.orig/fs/exofs/inode.c	2010-10-19 14:17:26.000000000 +1100
> > +++ linux-2.6/fs/exofs/inode.c	2010-10-19 14:19:18.000000000 +1100
> > @@ -1107,7 +1107,9 @@
> >  
> 
> Hi Nick, Please use -p option in your diff(s) it is a bit hard to follow
> and review without the proper function context. These patches are on a git
> tree. Why don't you use git to produce and send these patches?

Yes, sorry that was a big mistake. New computer, I don't know why it
doesn't do that as default option.

Thanks,
Nick


