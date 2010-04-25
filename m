Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248Ab0DYAxn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Apr 2010 20:53:43 -0400
Received: from THUNK.ORG ([69.25.196.29]:34366 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753629Ab0DYAxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Apr 2010 20:53:41 -0400
Date: Sat, 24 Apr 2010 20:53:36 -0400
From: tytso@mit.edu
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] ext4 fixes
Message-ID: <20100425005336.GB667@thunk.org>
Mail-Followup-To: tytso@mit.edu,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <E1O4LAG-0003NN-0A@closure.thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1O4LAG-0003NN-0A@closure.thunk.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping?  

I'm guessing that perhaps you didn't pull because of concerns raised
about some of the crazy dates in the ext4 tree.  I've checked to make
sure this isn't true for this set of patches, and I'll make sure the
dates are well-behaved for the future.

Best regards,

     	       	   	     		  - Ted

On Tue, Apr 20, 2010 at 05:39:28PM -0400, Theodore Ts'o wrote:
> Hi Linus,
> 
> I have some fixes for some data corruption bugs that should really get
> pulled into the 2.6.34 kernel, so I'd appreciate it if you could pull
> from:
> 
>         git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus
> 
> Thanks,
> 
> 						- Ted
> 
>  fs/ext4/extents.c |    1 +
>  fs/ext4/inode.c   |    3 ++-
>  fs/ext4/mballoc.c |   21 +++++++++++----------
>  3 files changed, 14 insertions(+), 11 deletions(-)
> 
> Curt Wohlgemuth (2):
>       ext4: Fix possible lost inode write in no journal mode
>       ext4: Fix buffer head leaks after calls to ext4_get_inode_loc()
> 
> Theodore Ts'o (1):
>       ext4: Issue the discard operation *before* releasing the blocks to be reused
> 
> 
> 
