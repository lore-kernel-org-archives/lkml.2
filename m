Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840Ab1GFXML (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 19:12:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54875 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752025Ab1GFXMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 19:12:09 -0400
Date: Wed, 6 Jul 2011 16:11:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Stezenbach <js@sig21.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Jens Axboe <axboe@kernel.dk>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] compat_ioctl: fix make headers_check regression
Message-Id: <20110706161132.c393b685.akpm@linux-foundation.org>
In-Reply-To: <20110706225140.GA21510@sig21.net>
References: <20110704134842.7ab89126.sfr@canb.auug.org.au>
	<20110704100316.GA15894@sig21.net>
	<20110706225140.GA21510@sig21.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jul 2011 00:51:40 +0200
Johannes Stezenbach <js@sig21.net> wrote:

> On Mon, Jul 04, 2011 at 12:03:16PM +0200, Johannes Stezenbach wrote:
> > Fix headers_check error introduced by 390192b30057:
> > 
> > include/linux/fd.h:6: included file 'linux/compat.h' is not exported
> > 
> > Signed-off-by: Johannes Stezenbach <js@sig21.net>
> > ---
> > I used the same style as in linux/usbdevice_fs.h, hope
> > that's OK.
> 
> 
> I just got an "added to -mm tree" mail for the original patch, so I
> wonder what's with this fix?

What does the "original patch" refer to.

Also, there's no commit 390192b30057.  Commit ID's can change.  This is
why we ask people to also include the patch title when describing
patches by SHA ID's



Please let's just start again.  Tell us what is going on here.
