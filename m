Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448Ab0ERNFt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 09:05:49 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:40138 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753281Ab0ERNFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 09:05:47 -0400
Date: Tue, 18 May 2010 15:05:46 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, drbd-dev@lists.linbit.com,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: manual merge of the drbd tree with the block tree
Message-ID: <20100518130545.GZ25951@kernel.dk>
References: <20100518152031.9a244971.sfr@canb.auug.org.au> <201005181345.22986.philipp.reisner@linbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201005181345.22986.philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 18 2010, Philipp Reisner wrote:
> Hi Stephen,
> 
> FYI:
> I use 
> git://git.drbd.org/linux-2.6-drbd.git for-jens
> as path of my patches to Jens.
> 
> I switched that tree to Jens' 
> git://git.kernel.dk/linux-2.6-block.git for-2.6.35
> and provided the DRBD patches on top of that.
> 
> Not that I am not willing to help, I have the feeling that this
> merge conflict has nothing to do with DRBD.

I suspect that the merge will go smoothly with the updated branches when
Stephen runs his scripts tomorrow.

-- 
Jens Axboe

