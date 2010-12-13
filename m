Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728Ab0LMDtA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 22:49:00 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:61829 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753204Ab0LMDs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 22:48:58 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAJskBU15LdLl/2dsb2JhbACjf3nBCoVKBA
Date: Mon, 13 Dec 2010 14:48:54 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Nick Piggin <npiggin@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: rcu-walk and dcache scaling tree update and status
Message-ID: <20101213034854.GA8018@amd>
References: <20101213023733.GB6522@amd>
 <20101213144049.fa3b14d9.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101213144049.fa3b14d9.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 13, 2010 at 02:40:49PM +1100, Stephen Rothwell wrote:
> Hi Nick,
> 
> On Mon, 13 Dec 2010 13:37:33 +1100 Nick Piggin <npiggin@kernel.dk> wrote:
> >
> > Linus has suggested pretty strongly that he wants to pull this in the
> > next merge window (recently, that "inodes will be RCU freed in 2.6.38"
> > in an urelated discussion). As far as I know, that's what he's going to
> > do. I'd like to get this some time in linux-next to improve test
> > coverage (many filesystems I can't even test, so there are bound to be a
> > few silly crashes). Stephen, how do I arrange that?
> 
> Well, you ask me :-) (letting me know where the git tree is).
> 
> I this case I would like an email from Al and/or Linus (and/or maybe
> Christoph?) before I add this to linux-next as you say below that
> (despite being as well tested as you can do) it does require more review
> and buyin from others.  Of course, if Linus is going to merge this during
> the next merge window, then it really should be in linux-next as soon as
> it is ready enough.

Yes I would like an ack from Al to have it in linux-next. Note that
wouldn't have to be an ack on the patches or agreement to merge it next
window, just an "ok to get wider review and testing" type of thing.

If Linus's is intending *not* to pull it, then it's not so urgent, and I
might instead ask Andrew to host it in -mm for a while. I just don't
want to get caught with my pants down here, because there are a good
number of untested filesystems and things.

