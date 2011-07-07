Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012Ab1GGIcl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 04:32:41 -0400
Received: from bar.sig21.net ([80.81.252.164]:36348 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753306Ab1GGIcj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 04:32:39 -0400
Date: Thu, 7 Jul 2011 10:32:29 +0200
From: Johannes Stezenbach <js@sig21.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Jens Axboe <axboe@kernel.dk>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] compat_ioctl: fix make headers_check regression
Message-ID: <20110707083229.GA23261@sig21.net>
References: <20110704134842.7ab89126.sfr@canb.auug.org.au>
 <20110704100316.GA15894@sig21.net>
 <20110706225140.GA21510@sig21.net>
 <20110706161132.c393b685.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110706161132.c393b685.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-21-Score: -3.7 (---)
X-Spam-21-Report: No, score=-3.7 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.718,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 06, 2011 at 04:11:32PM -0700, Andrew Morton wrote:
> On Thu, 7 Jul 2011 00:51:40 +0200
> Johannes Stezenbach <js@sig21.net> wrote:
> 
> > On Mon, Jul 04, 2011 at 12:03:16PM +0200, Johannes Stezenbach wrote:
> > > Fix headers_check error introduced by 390192b30057:
> > > 
> > > include/linux/fd.h:6: included file 'linux/compat.h' is not exported
> > > 
> > > Signed-off-by: Johannes Stezenbach <js@sig21.net>
> > > ---
> > > I used the same style as in linux/usbdevice_fs.h, hope
> > > that's OK.
> > 
> > 
> > I just got an "added to -mm tree" mail for the original patch, so I
> > wonder what's with this fix?
> 
> What does the "original patch" refer to.

"compat_ioctl: fix warning caused by qemu"

> Also, there's no commit 390192b30057.  Commit ID's can change.  This is
> why we ask people to also include the patch title when describing
> patches by SHA ID's

I see, will do in the future

> Please let's just start again.  Tell us what is going on here.

Well, I'm confused by the -mm workflow.  The "original" patch
390192b30057 is in
git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git for-3.1/core

http://git.kernel.org/?p=linux/kernel/git/axboe/linux-block.git;a=commit;h=390192b300570b2bc721d77067ca133f58015ae8

And this fix now, too:

http://git.kernel.org/?p=linux/kernel/git/axboe/linux-block.git;a=commit;h=719c0c590609809365c6f3da2f923cd84dc99113


Johannes
