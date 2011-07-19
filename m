Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751845Ab1GSB32 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 21:29:28 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:5974 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751029Ab1GSB31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 21:29:27 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0DAArdJE55LCkBgWdsb2JhbABTp0kVAQEWJiXNMg6GLgSjTg
Date: Tue, 19 Jul 2011 11:29:23 +1000
From: Dave Chinner <david@fromorbit.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: linux-next: manual merge of the vfs tree with the xfs tree
Message-ID: <20110719012923.GI30254@dastard>
References: <20110718133636.579d9002dbb56cd6408a2a7b@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110718133636.579d9002dbb56cd6408a2a7b@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 18, 2011 at 01:36:36PM +1000, Stephen Rothwell wrote:
> Hi Al,
> 
> Today's linux-next merge of the vfs tree got a conflict in
> fs/xfs/linux-2.6/xfs_super.c between commit 2bcf6e970f5a ("xfs: start
> periodic workers later") from the xfs tree and commit d86b98f73104 ("xfs:
> make use of new shrinker callout for the inode cache") from the vfs tree.
> 
> I fixed it up (I think, see below) and can carry the fix as necessary.

Looks OK to me.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
