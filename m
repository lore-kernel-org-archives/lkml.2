Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367Ab1AMWBB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 17:01:01 -0500
Received: from thunk.org ([69.25.196.29]:47411 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752022Ab1AMWAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 17:00:55 -0500
Date: Thu, 13 Jan 2011 17:00:39 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Christoph Hellwig <hch@infradead.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: clearcache (Was: Re: [git pull] vfs pile 1)
Message-ID: <20110113220039.GF31800@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Christoph Hellwig <hch@infradead.org>,
	Dan Magenheimer <dan.magenheimer@oracle.com>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20110113053554.GQ19804@ZenIV.linux.org.uk>
 <20110113172557.c016ec51.sfr@canb.auug.org.au>
 <20110113085547.GA7414@infradead.org>
 <20110113214239.1b23b523.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110113214239.1b23b523.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 09:42:39PM +1100, Stephen Rothwell wrote:
> 
> "I didn't really follow the discussion at Kernel Summit, but there seemed
> to be some question as to whether the cleancache stuff will be merged or
> not.  It missed 2.6.37 (obviously), but my question now is do I keep in
> in linux-next in the hope that it will be merged in 2.6.38?  Or is that
> not going to happen?"

The real problem is I don't think anyone is really paying attention to
cleancache.

Dan, something that might be useful to drive interest would be a
demonstration of this improves performance on, say, a netbook using
cleancache and zram, and how it is better than just using zram
directly as a swap device.  With maybe some numbers?  That might get
some interest from the community desktop distributions...

     	      	       		 	 - Ted
