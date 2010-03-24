Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323Ab0CXVyr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 17:54:47 -0400
Received: from bld-mail18.adl2.internode.on.net ([150.101.137.103]:43649 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751208Ab0CXVyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 17:54:45 -0400
Date: Thu, 25 Mar 2010 08:54:36 +1100
From: Dave Chinner <david@fromorbit.com>
To: wzt.wzt@gmail.com
Cc: linux-kernel@vger.kernel.org, xfs-masters@oss.sgi.com, aelder@sgi.com
Subject: Re: [PATCH] xfs: Fix integer overflow in
 fs/xfs/linux-2.6/xfs_ioctl*.c
Message-ID: <20100324215436.GC7671@dastard>
References: <20100317031947.GB2796@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100317031947.GB2796@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 17, 2010 at 11:19:47AM +0800, wzt.wzt@gmail.com wrote:
> The am_hreq.opcount field in the xfs_attrmulti_by_handle() interface
> is not bounded correctly. The opcount is used to determine the size
> of the buffer required. The size is bounded, but can overflow and so
> the size checks may not be sufficient to catch invalid opcounts.
> Fix it by catching opcount values that would cause overflows before
> calculating the size.
> 
> Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>

Looks good now. I'll queue it up with all the other pending changes
I have.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
