Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab0ETHVZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 03:21:25 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:35774 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146Ab0ETHVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 03:21:23 -0400
Date: Thu, 20 May 2010 09:21:21 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for May 19 (mm/page-writeback)
Message-ID: <20100520072121.GG25951@kernel.dk>
References: <20100519163554.80c7fcd3.sfr@canb.auug.org.au> <20100519104800.5a43346f.randy.dunlap@oracle.com> <20100519175018.GW25951@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100519175018.GW25951@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19 2010, Jens Axboe wrote:
> On Wed, May 19 2010, Randy Dunlap wrote:
> > On Wed, 19 May 2010 16:35:54 +1000 Stephen Rothwell wrote:
> > 
> > > Hi all,
> > > 
> > > We are in the merge window again.  I remind you all not to add stuff for
> > > 2.6.36 to your linux-next trees until after 2.6.35-rc1.
> > > 
> > > Changes since 20100518:
> > 
> > 
> > When CONFIG_BLOCK is not enabled:
> > 
> > mm/page-writeback.c: In function 'laptop_mode_timer_fn':
> > mm/page-writeback.c:708: error: dereferencing pointer to incomplete type
> > mm/page-writeback.c:709: error: dereferencing pointer to incomplete type
> 
> Thanks Randy, I'll fix that up.

Fixed up in for-2.6.35/for-next now.

-- 
Jens Axboe

