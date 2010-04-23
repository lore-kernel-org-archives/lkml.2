Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998Ab0DWLNw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 07:13:52 -0400
Received: from cantor.suse.de ([195.135.220.2]:53676 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751662Ab0DWLNu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 07:13:50 -0400
Date: Fri, 23 Apr 2010 21:13:40 +1000
From: Neil Brown <neilb@suse.de>
To: Greg KH <gregkh@suse.de>
Cc: Stefan Lippers-Hollmann <s.L-H@gmx.de>, linux-kernel@vger.kernel.org,
       king.br@gmail.com, stable@kernel.org
Subject: Re: patch md-raid5-allow-for-more-than-2-31-chunks.patch added to
 2.6.33-stable tree
Message-ID: <20100423211340.5049ec16@notabene.brown>
In-Reply-To: <20100423031100.GA1637@suse.de>
References: <12718801381479@kroah.org>
	<201004220408.33822.s.L-H@gmx.de>
	<20100422124022.1320e49c@notabene.brown>
	<201004221336.28530.s.L-H@gmx.de>
	<20100423031100.GA1637@suse.de>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.7; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Apr 2010 20:11:00 -0700
Greg KH <gregkh@suse.de> wrote:

> On Thu, Apr 22, 2010 at 01:36:26PM +0200, Stefan Lippers-Hollmann wrote:
> > Hi
> > 
> > On Thursday 22 April 2010, Neil Brown wrote:
> > > On Thu, 22 Apr 2010 04:08:30 +0200
> > > "Stefan Lippers-Hollmann" <s.L-H@gmx.de> wrote:
> > > > On Thursday 22 April 2010, gregkh@suse.de wrote:
> > [...]
> > > > > From 35f2a591192d0a5d9f7fc696869c76f0b8e49c3d Mon Sep 17 00:00:00 2001
> > > > > From: NeilBrown <neilb@suse.de>
> > > > > Date: Tue, 20 Apr 2010 14:13:34 +1000
> > > > > Subject: md/raid5: allow for more than 2^31 chunks.
> > > > > 
> > > > > From: NeilBrown <neilb@suse.de>
> > > > > 
> > > > > commit 35f2a591192d0a5d9f7fc696869c76f0b8e49c3d upstream.
> > > > > 
> > > > > With many large drives and small chunk sizes it is possible
> > > > > to create a RAID5 with more than 2^31 chunks.  Make sure this
> > > > > works.
> > > > > 
> > > > > Reported-by: Brett King <king.br@gmail.com>
> > > > > Signed-off-by: NeilBrown <neilb@suse.de>
> > > > > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > > > 
> > > > This patch, as part of the current 2.6.33 stable queue, breaks compiling
> > > > on i386 (CONFIG_LBDAF=y) for me (amd64 builds fine):
> > > > 
> > > > [...]
> > > >   BUILD   arch/x86/boot/bzImage
> > > > Root device is (254, 6)
> > > > Setup is 12700 bytes (padded to 12800 bytes).
> > > > System is 2415 kB
> > > > CRC db6fa5fa
> > > > Kernel: arch/x86/boot/bzImage is ready  (#1)
> > > > ERROR: "__umoddi3" [drivers/md/raid456.ko] undefined!
> > > > 
> > > > reverting just this patch fixes the problem for me.
> > > 
> > > Thanks for testing and reporting.
> > > 
> > > If you could verify that this additional patch fixes the compile error I
> > > would really appreciate it.
> > 
> > I can confirm that this patch on top of the original 
> > md-raid5-allow-for-more-than-2-31-chunks.patch fixes the build problem on 
> > i386 for me (amd64 continues to build fine as well).
> > 
> > Tested-by: Stefan Lippers-Hollmann <s.l-h@gmx.de>
> 
> Neil, care to push this to Linus?

I've sent him a request to pull it from  git://neil.brown.name/md for-linus

Thanks.
NeilBrown
