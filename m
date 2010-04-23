Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772Ab0DWD3o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 23:29:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52776 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753234Ab0DWD3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 23:29:43 -0400
Date: Thu, 22 Apr 2010 20:11:00 -0700
From: Greg KH <gregkh@suse.de>
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
Cc: Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org,
       king.br@gmail.com, stable@kernel.org
Subject: Re: patch md-raid5-allow-for-more-than-2-31-chunks.patch added to
	2.6.33-stable tree
Message-ID: <20100423031100.GA1637@suse.de>
References: <12718801381479@kroah.org> <201004220408.33822.s.L-H@gmx.de> <20100422124022.1320e49c@notabene.brown> <201004221336.28530.s.L-H@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201004221336.28530.s.L-H@gmx.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 22, 2010 at 01:36:26PM +0200, Stefan Lippers-Hollmann wrote:
> Hi
> 
> On Thursday 22 April 2010, Neil Brown wrote:
> > On Thu, 22 Apr 2010 04:08:30 +0200
> > "Stefan Lippers-Hollmann" <s.L-H@gmx.de> wrote:
> > > On Thursday 22 April 2010, gregkh@suse.de wrote:
> [...]
> > > > From 35f2a591192d0a5d9f7fc696869c76f0b8e49c3d Mon Sep 17 00:00:00 2001
> > > > From: NeilBrown <neilb@suse.de>
> > > > Date: Tue, 20 Apr 2010 14:13:34 +1000
> > > > Subject: md/raid5: allow for more than 2^31 chunks.
> > > > 
> > > > From: NeilBrown <neilb@suse.de>
> > > > 
> > > > commit 35f2a591192d0a5d9f7fc696869c76f0b8e49c3d upstream.
> > > > 
> > > > With many large drives and small chunk sizes it is possible
> > > > to create a RAID5 with more than 2^31 chunks.  Make sure this
> > > > works.
> > > > 
> > > > Reported-by: Brett King <king.br@gmail.com>
> > > > Signed-off-by: NeilBrown <neilb@suse.de>
> > > > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > > 
> > > This patch, as part of the current 2.6.33 stable queue, breaks compiling
> > > on i386 (CONFIG_LBDAF=y) for me (amd64 builds fine):
> > > 
> > > [...]
> > >   BUILD   arch/x86/boot/bzImage
> > > Root device is (254, 6)
> > > Setup is 12700 bytes (padded to 12800 bytes).
> > > System is 2415 kB
> > > CRC db6fa5fa
> > > Kernel: arch/x86/boot/bzImage is ready  (#1)
> > > ERROR: "__umoddi3" [drivers/md/raid456.ko] undefined!
> > > 
> > > reverting just this patch fixes the problem for me.
> > 
> > Thanks for testing and reporting.
> > 
> > If you could verify that this additional patch fixes the compile error I
> > would really appreciate it.
> 
> I can confirm that this patch on top of the original 
> md-raid5-allow-for-more-than-2-31-chunks.patch fixes the build problem on 
> i386 for me (amd64 continues to build fine as well).
> 
> Tested-by: Stefan Lippers-Hollmann <s.l-h@gmx.de>

Neil, care to push this to Linus?

thanks,

greg k-h
