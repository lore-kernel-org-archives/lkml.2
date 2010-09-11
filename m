Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248Ab0IKIVD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 04:21:03 -0400
Received: from bld-mail18.adl2.internode.on.net ([150.101.137.103]:43710 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753289Ab0IKIVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 04:21:00 -0400
Date: Sat, 11 Sep 2010 18:20:54 +1000
From: Dave Chinner <david@fromorbit.com>
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-ide <linux-ide@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        dm-devel@redhat.com, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Combined storage tree
Message-ID: <20100911082054.GF705@dastard>
References: <1284143247.6551.23.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284143247.6551.23.camel@mulgrave.site>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 10, 2010 at 01:27:27PM -0500, James Bottomley wrote:
> One of the requests from LSF10 in August was the production of a
> combined storage tree.  This is now ready at
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/storage-tree
> 
> It's actually a nightly built merge tree consisting of
> 
> scsi-misc; scsi-rc-fixes
> libata#upstream-fixes, libata#upstream
> block#for-linus, block#for-next
> and the dm quilt (which is empty at the moment).
> 
> I haven't yet added vfs or any of the fs trees, but if necessary, I can.
> 
> Note, because it's built nightly, like linux-next, it's hard (but not
> impossible) to use it as a basis for git trees (it is much easier to use
> it as a basis for quilts).

Hmmm. I was kind of hoping for an upstream maintainer tree, kind of
like the netdev tree.  I really don't see a tree like this getting
wide use - if I enjoyed the pain of rebasing against throw-away
merge trees every day, then I'd already be using linux-next....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
