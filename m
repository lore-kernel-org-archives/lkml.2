Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932301Ab2BXQFG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 11:05:06 -0500
Received: from relay1.sgi.com ([192.48.179.29]:48814 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932208Ab2BXQFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 11:05:04 -0500
Date: Fri, 24 Feb 2012 10:05:05 -0600
From: Ben Myers <bpm@sgi.com>
To: Dan Carpenter <dan.carpenter@oracle.com>,
        santosh nayak <santoshprasadnayak@gmail.com>
Cc: elder@kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, xfs@oss.sgi.com, xfs-masters@oss.sgi.com
Subject: Re: [PATCH] xfs: Use memset to initialize structure member.
Message-ID: <20120224160505.GF7762@sgi.com>
References: <1330067322-17011-1-git-send-email-santoshprasadnayak@gmail.com> <20120224075354.GA3649@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120224075354.GA3649@mwanda>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Santosh,

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

This aggregate initializer seems cleaner than memset.  Do you
mind resending the patch with Dan's suggestion?                                 
                                                                                
Thanks for your contribution.  ;)    

-Ben
