Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab0JKO0V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 10:26:21 -0400
Received: from cantor.suse.de ([195.135.220.2]:55093 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754846Ab0JKO0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 10:26:20 -0400
Date: Mon, 11 Oct 2010 07:11:14 -0700
From: Greg KH <gregkh@suse.de>
To: Bob Beers <bob.beers@gmail.com>
Cc: Zimny Lech <napohybelskurwysynom2010@gmail.com>, akpm@linux-foundation.org,
        mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: mmotm 2010-10-07-14-08 uploaded
Message-ID: <20101011141114.GA4231@suse.de>
References: <201010072140.o97Le69i025659@imap1.linux-foundation.org> <AANLkTi=UgODY9REO-f9hxRBT4iZqsFB2spdBTCqeUTk4@mail.gmail.com> <20101008002244.GA6523@suse.de> <AANLkTi=Fmp_J5exsJReMoAVSaadFUDYjPUPUgd_qOCv0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=Fmp_J5exsJReMoAVSaadFUDYjPUPUgd_qOCv0@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 11, 2010 at 09:57:38AM -0400, Bob Beers wrote:
> Sorry, resend without html (gee, thanks gmail >:\)
> 
> On Thu, Oct 7, 2010 at 8:22 PM, Greg KH <gregkh@suse.de> wrote:
> >
> > On Fri, Oct 08, 2010 at 02:17:54AM +0200, Zimny Lech wrote:
> > > Hi,
> > >
> > > 2010/10/7 ?<akpm@linux-foundation.org>:
> > > > The mm-of-the-moment snapshot 2010-10-07-14-08 has been uploaded to
> > >
> > > ? LD ? ? ?drivers/built-in.o
> > > drivers/staging/built-in.o:(.data+0x2490): multiple definition of `max_mtu'
> > > drivers/infiniband/built-in.o:(.data+0x6b30): first defined here
> > > make[2]: *** [drivers/built-in.o] Error 1
> > > make[1]: *** [drivers] Error 2
> > > make: *** [sub-make] Error 2
> >
> > This is a cxt1e1 driver issue.
> >
> > Bob, care to fix this up?
> >
> > thanks,
> >
> > greg k-h
> 
> Hi Greg,
> 
> Yes, I will.
> 
> It appears in 4 files, a total of 12 occurances.
> I guess it is enough to rename it, perhaps simply add a cxt1e1 unique prefix?

Yes, that would be good to do and would solve the problems.

thanks,

greg k-h
