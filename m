Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921Ab1FNCax (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 22:30:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:47259 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751959Ab1FNCav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 22:30:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,361,1304319600"; 
   d="scan'208";a="15871734"
Date: Tue, 14 Jun 2011 10:30:42 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] NFS: return -EAGAIN when skipped commit in
 nfs_commit_unstable_pages()
Message-ID: <20110614023042.GA5174@localhost>
References: <20110610140459.GA8021@localhost>
 <1307993886.5569.3.camel@lade.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307993886.5569.3.camel@lade.trondhjem.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > @@ -1521,7 +1521,7 @@ static int nfs_commit_unstable_pages(str
> >  {
> >  	struct nfs_inode *nfsi = NFS_I(inode);
> >  	int flags = FLUSH_SYNC;
> > -	int ret = 0;
> > +	int ret = -EAGAIN;
> >  
> >  	if (wbc->sync_mode == WB_SYNC_NONE) {
> >  		/* Don't commit yet if this is a non-blocking flush and there
> 
> Looks good, but since this is a cleanup, I'm queueing it for 3.1 rather
> than pushing it in the regression-fixing window.

OK, thanks!

Thanks,
Fengguang
