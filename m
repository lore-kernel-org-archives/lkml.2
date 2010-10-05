Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244Ab0JETM0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 15:12:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57465 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753802Ab0JETMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 15:12:24 -0400
Date: Tue, 5 Oct 2010 12:11:52 -0700
From: Greg KH <gregkh@suse.de>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Zimny Lech <napohybelskurwysynom2010@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for October 4
Message-ID: <20101005191152.GA14151@suse.de>
References: <20101004113638.a7f8517b.sfr@canb.auug.org.au>
 <AANLkTi=5k=29G+xLrN_1F-ho+90k_KAwcb++eKzHA+Ai@mail.gmail.com>
 <49602.216.212.242.109.1286305155.squirrel@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49602.216.212.242.109.1286305155.squirrel@xenotime.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 05, 2010 at 11:59:15AM -0700, Randy Dunlap wrote:
> 
> On Mon, October 4, 2010 10:48 pm, Zimny Lech wrote:
> > Hi,
> >
> >
> > 2010/10/4 Stephen Rothwell <sfr@canb.auug.org.au>:
> >
> >> Hi all,
> >>
> >>
> >> This tree is not as well tested as others since it was only built after
> >>  all the merges had been done.
> >
> > Randy said that he had already sent a patch for this
> >
> >
> > /home/test/linux-2.6/drivers/base/core.c: In function
> > 'get_device_parent':
> > /home/test/linux-2.6/drivers/base/core.c:634:3: error: 'block_class'
> > undeclared (first use in this function)
> > /home/test/linux-2.6/drivers/base/core.c:634:3: note: each undeclared
> > identifier is reported only once for each function it appears in
> > /home/test/linux-2.6/drivers/base/core.c: In function
> > 'device_add_class_symlinks':
> > /home/test/linux-2.6/drivers/base/core.c:723:2: error: 'block_class'
> > undeclared (first use in this function)
> > /home/test/linux-2.6/drivers/base/core.c: In function
> > 'device_remove_class_symlinks':
> > /home/test/linux-2.6/drivers/base/core.c:751:2: error: 'block_class'
> > undeclared (first use in this function) make[3]: *** [drivers/base/core.o]
> > Error 1
> > make[2]: *** [drivers/base] Error 2
> > make[1]: *** [drivers] Error 2
> > make: *** [sub-make] Error 2
> 
> 
> I sure did, but Greg may be backlogged or just ignoring it.

backlogged, I was in Tokyo last week, catching up now...

thanks,

greg k-h
