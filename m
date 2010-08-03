Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250Ab0HCFoI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 01:44:08 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:45997 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755184Ab0HCFoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 01:44:05 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAH9JV0x5LcpI/2dsb2JhbACDFZxycrFskhCBJoMgcwQ
Date: Tue, 3 Aug 2010 15:44:00 +1000
From: Nick Piggin <npiggin@suse.de>
To: john stultz <johnstul@us.ibm.com>
Cc: Nick Piggin <npiggin@suse.de>, Nick Piggin <npiggin@kernel.dk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Frank Mayhar <fmayhar@google.com>
Subject: Re: VFS scalability git tree
Message-ID: <20100803054400.GA7398@amd>
References: <20100722190100.GA22269@amd>
 <20100730091226.GA10437@amd>
 <1280795279.3966.47.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1280795279.3966.47.camel@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 02, 2010 at 05:27:59PM -0700, John Stultz wrote:
> On Fri, 2010-07-30 at 19:12 +1000, Nick Piggin wrote:
> > On Fri, Jul 23, 2010 at 05:01:00AM +1000, Nick Piggin wrote:
> > > I'm pleased to announce I have a git tree up of my vfs scalability work.
> > > 
> > > git://git.kernel.org/pub/scm/linux/kernel/git/npiggin/linux-npiggin.git
> > > http://git.kernel.org/?p=linux/kernel/git/npiggin/linux-npiggin.git
> > > 
> > > Branch vfs-scale-working
> > > 
> > > The really interesting new item is the store-free path walk, (43fe2b)
> > > which I've re-introduced. It has had a complete redesign, it has much
> > > better performance and scalability in more cases, and is actually sane
> > > code now.
> > 
> > Things are progressing well here with fixes and improvements to the
> > branch.
> 
> Hey Nick,
> 	Just another minor compile issue with today's vfs-scale-working branch.
> 
> fs/fuse/dir.c:231: error: ‘fuse_dentry_revalidate_rcu’ undeclared here
> (not in a function)
> 
> >From looking at the vfat and ecryptfs changes in
> 582c56f032983e9a8e4b4bd6fac58d18811f7d41 it looks like you intended to
> add the following? 

Thanks John, you're right.

I thought I actually linked and ran this, but I must not have had fuse
compiled in.

