Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531Ab1GYS0m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 14:26:42 -0400
Received: from mx2.netapp.com ([216.240.18.37]:2966 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751563Ab1GYS0k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 14:26:40 -0400
X-IronPort-AV: E=Sophos;i="4.67,264,1309762800"; 
   d="scan'208";a="565384666"
Subject: Re: linux-next: build failure after merge of the vfs tree
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@ZenIV.linux.org.uk>
Date: Mon, 25 Jul 2011 14:26:15 -0400
In-Reply-To: <20110725132022.9cac27e6aee69728e4de6b97@canb.auug.org.au>
References: <20110716164404.0f791c640332bbad6ab8ea34@canb.auug.org.au>
	 <20110725132022.9cac27e6aee69728e4de6b97@canb.auug.org.au>
Organization: NetApp Inc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Message-ID: <1311618375.28209.1.camel@lade.trondhjem.org>
Mime-Version: 1.0
X-OriginalArrivalTime: 25 Jul 2011 18:26:16.0664 (UTC) FILETIME=[5776A580:01CC4AF8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-25 at 13:20 +1000, Stephen Rothwell wrote: 
> Hi all,
> 
> On Sat, 16 Jul 2011 16:44:04 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > After merging the vfs tree, today's linux-next build (powerpc
> > ppc64_defconfig) failed like this:
> > 
> > fs/nfs/read.c: In function 'nfs_do_read':
> > fs/nfs/read.c:246:42: error: 'struct nfs_open_context' has no member named 'path'
> > 
> > Caused by commit 6e4efd568574 ("NFS: Clean up nfs_read_rpcsetup and
> > nfs_write_rpcsetup") from the nfs tree interacting with commit
> > b98aad31afdc ("nfs_open_context doesn't need struct path either").
> > 
> > I have applied the following merge fixup patch:
> 
> This patch (repeasted here) is now required after mergeing the nfs tree
> and Linus' tree:

Thanks Stephen!

I've merged the contents of Linus' current tree into my NFS development
branch, and applied your patch as part of the merge commit.

Cheers
  Trond

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

