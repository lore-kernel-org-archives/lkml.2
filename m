Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751358Ab1LSFBw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 00:01:52 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:46580 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750713Ab1LSFBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 00:01:50 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EABHC7k55LOCn/2dsb2JhbABDq1qBBoFyAQEFOhwjEAgDDgouFCUDIRO+YxOLcQSUfZJD
Date: Mon, 19 Dec 2011 16:01:48 +1100
From: Dave Chinner <david@fromorbit.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>, Ben Myers <bpm@sgi.com>,
        xfs-masters@oss.sgi.com
Subject: Re: linux-next: manual merge of the pm tree with the xfs tree
Message-ID: <20111219050148.GP23662@dastard>
References: <20111219151145.dba82854f65671a877db8ed3@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111219151145.dba82854f65671a877db8ed3@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 19, 2011 at 03:11:45PM +1100, Stephen Rothwell wrote:
> Hi Rafael,
> 
> Today's linux-next merge of the pm tree got a conflict in
> fs/xfs/xfs_buf.c between commit 687d1c5e8e26 ("xfs: remove unused
> XBT_FORCE_SLEEP bit") from the xfs tree and commit a0acae0e886d
> ("freezer: unexport refrigerator() and update try_to_freeze() slightly")
> from the pm tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

Looks correct from the XFS POV, Stephen. Thanks.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
