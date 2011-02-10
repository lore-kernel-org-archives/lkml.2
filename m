Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163Ab1BJSvc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 13:51:32 -0500
Received: from kroah.org ([198.145.64.141]:36843 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754903Ab1BJSva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 13:51:30 -0500
Date: Thu, 10 Feb 2011 10:50:54 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nitin Gupta <ngupta@vflare.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>
Subject: Re: linux-next: manual merge of the staging tree with the
 staging.current tree
Message-ID: <20110210185054.GA15944@kroah.com>
References: <20110210163527.3b2cc580.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110210163527.3b2cc580.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 04:35:27PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflict in
> drivers/staging/zram/zram_drv.c between commit
> 5414e557fca545614ceedc3d3496f747457e2e3b ("staging: zram: fix data
> corruption issue") from the staging.current tree and commit
> 2787f959d6c5fb258d964218ac75346019f49ee9 ("zram: Return zero'd pages on
> new reads") from the staging tree.
> 
> I fixed it up (I think - see below) and can carry the fix as necessary.

Thanks, I'll handle this when Linus takes my tree and I'll merge to
resolve the conflict.

greg k-h
