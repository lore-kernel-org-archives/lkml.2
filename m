Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579Ab0ESRuY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 13:50:24 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:55176 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753720Ab0ESRuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 13:50:22 -0400
Date: Wed, 19 May 2010 19:50:18 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for May 19 (mm/page-writeback)
Message-ID: <20100519175018.GW25951@kernel.dk>
References: <20100519163554.80c7fcd3.sfr@canb.auug.org.au> <20100519104800.5a43346f.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100519104800.5a43346f.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19 2010, Randy Dunlap wrote:
> On Wed, 19 May 2010 16:35:54 +1000 Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > We are in the merge window again.  I remind you all not to add stuff for
> > 2.6.36 to your linux-next trees until after 2.6.35-rc1.
> > 
> > Changes since 20100518:
> 
> 
> When CONFIG_BLOCK is not enabled:
> 
> mm/page-writeback.c: In function 'laptop_mode_timer_fn':
> mm/page-writeback.c:708: error: dereferencing pointer to incomplete type
> mm/page-writeback.c:709: error: dereferencing pointer to incomplete type

Thanks Randy, I'll fix that up.

-- 
Jens Axboe

