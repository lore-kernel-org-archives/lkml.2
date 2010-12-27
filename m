Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab0L0OOJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 09:14:09 -0500
Received: from bld-mail14.adl6.internode.on.net ([150.101.137.99]:44349 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753885Ab0L0OOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 09:14:07 -0500
Date: Tue, 28 Dec 2010 01:13:57 +1100
From: Dave Chinner <david@fromorbit.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: xfs@oss.sgi.com, xfs-masters@oss.sgi.com, linux-kernel@vger.kernel.org,
        Alex Elder <aelder@sgi.com>
Subject: Re: [PATCH] XFS: Compare, don't assign in ASSERT() in
 xfs_trans_unreserve_and_mod_sb()
Message-ID: <20101227141357.GC24828@dastard>
References: <alpine.LNX.2.00.1012252110490.10759@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1012252110490.10759@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 25, 2010 at 09:14:53PM +0100, Jesper Juhl wrote:
> Hi,
> 
> In fs/xfs/xfs_trans.c::xfs_trans_unreserve_and_mod_sb() at the out: label 
> we have this:
> 	ASSERT(error = 0);
> I believe a comparison was intended, not an assignment. If I'm right, the 
> patch below fixes that up.

Already fixed in this patch pending for 2.6.38:

http://git.kernel.org/?p=linux/kernel/git/dgc/xfsdev.git;a=commitdiff;h=831ef3cf682a1f9d8fc7c16dace55137751c0410

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
