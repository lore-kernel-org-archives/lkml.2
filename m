Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757742Ab2BXQBt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 11:01:49 -0500
Received: from relay3.sgi.com ([192.48.152.1]:42740 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757696Ab2BXQBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 11:01:47 -0500
Date: Fri, 24 Feb 2012 10:01:47 -0600
From: Ben Myers <bpm@sgi.com>
To: santosh nayak <santoshprasadnayak@gmail.com>
Cc: elder@kernel.org, xfs-masters@oss.sgi.com, xfs@oss.sgi.com,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
Message-ID: <20120224160147.GD28391@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bcc: 
Subject: Re: [PATCH] xfs: Use memset to initialize structure member.
Reply-To: 
In-Reply-To: <20120224075354.GA3649@mwanda>

On Fri, Feb 24, 2012 at 10:53:54AM +0300, Dan Carpenter wrote:
> On Fri, Feb 24, 2012 at 12:38:42PM +0530, santosh nayak wrote:
> > From: Santosh Nayak <santoshprasadnayak@gmail.com>
> > 
> > Sparse is giving following warning:
> > fs/xfs/xfs_bmap.c:4826:41: warning: Using plain integer as NULL pointer.
> > 
> 
> You could just do:
> 	struct xfs_bmalloca     bma = {};

Santosh, this aggregate initializer seems cleaner than memset.  Do you
mind resending the patch with Dan's suggestion?

Thanks for your contribution.  ;)

-Ben
