Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933859Ab0J1Vlp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 17:41:45 -0400
Received: from bld-mail15.adl6.internode.on.net ([150.101.137.100]:35624 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933101Ab0J1Vli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 17:41:38 -0400
Date: Fri, 29 Oct 2010 08:41:34 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] fs: remove inode_lock from iput_final and
 prune_icache
Message-ID: <20101028214134.GE2715@dastard>
References: <1288220538-21476-1-git-send-email-david@fromorbit.com>
 <1288220538-21476-5-git-send-email-david@fromorbit.com>
 <20101028120057.GB4546@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101028120057.GB4546@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 28, 2010 at 08:00:57AM -0400, Christoph Hellwig wrote:
> Looks good - although at this point you could already remove inode_lock
> from igrab, too.

Yes, it probably can go at this point - after the next three patches
it's pretty much the only place the lock is left, so it's not really
protecting anything anymore...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
