Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112Ab1CCFlj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 00:41:39 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42708 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751980Ab1CCFli (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 00:41:38 -0500
Date: Wed, 2 Mar 2011 20:03:06 -0800
From: Greg KH <gregkh@suse.de>
To: dj@deadhat.com
Cc: "Ted Ts'o" <tytso@mit.edu>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Why is my copyright code in the linux kernel?
Message-ID: <20110303040306.GA26722@suse.de>
References: <ded07e5c09d72da478c6218658095f5a.squirrel@deadhat.com>
 <AANLkTimg1x56B4Yu=Zsd0VEci2i4jRKaMU+gxv3oFVr8@mail.gmail.com>
 <20110301235433.GD2959@thunk.org>
 <56a24cfecea63a4752f441056da9c813.squirrel@deadhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56a24cfecea63a4752f441056da9c813.squirrel@deadhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<resend adding lkml back on, somehow it got dropped on the thread, which
isn't good...>

On Tue, Mar 01, 2011 at 06:38:12PM -0800, dj@deadhat.com wrote:
> > On Wed, Mar 02, 2011 at 12:30:45AM +0100, richard -rw- weinberger wrote:
> 
> 
> >> the code is from ralink.
> >
> > David, you might want to contact ralink directly, since it's likely
> > they are distributing that driver with your AES code in other places
> > besides just in the mainstream kernel sources.  Even if we delete the
> > code in the staging tree, they might be distributing that driver still
> > via other means.
> >
> > Regards,
> >
> > 						- Ted
> >
> 
> Thank you. I will contact ralink after I work out who to contact.
> I'm not particularly looking for any code to be deleted, just to have my
> copyright in the header if it is to remain. I will happily GPL those parts
> that are my code if necessary. While ralink might be misrepresenting the
> copyright (and VIA - see below) it's kernel.org that's distributing it.
> 
> The code is in use in proprietary 802.11 and 802.16 products from a few
> companies. So it is reasonably important that the Linux kernel isn't
> propagating false copyright information about it. I granted permission to
> some companies to use the code when they asked, but never ralink or VIA.

What was the license that the code was originaly released under?  I see
it on your web site as "public domain" which I think means the companies
involved felt it was safe to put into their drivers, and as such, it
should be also safe to put it into the kernel under the GPL, right?

Was the code published anywhere else (i.e. in the spec itself)?

> As far as the quality of the code - I never wrote the code for production
> purposes. It's pedagogical code, which is why it is so byte oriented. In a
> standards setting body writing crypto specs, it's really easy to lose
> track of which end is which. There are more compact, more efficient ways
> to write it, not that performance matters much for 802.11i session key set
> up algorithms.
> 
> I've done a little digging and I've found my code in other places in the
> current stable kernel 2.6.37.2 that I just downloaded:
> drivers/staging/rtl8712/rtl871x_security.c - AES  & TKIP Key mixing and MIC.
> drivers/staging/rt2860/common/cmm_tkip.c - TKIP key mixing and MIC.
> drivers/staging/vt6656/tkip.c - TKIP Key mixing code
> 
> The latter being from VIA, interestingly claiming 1996 copyright on code I
> wrote in 2001/2002 for an algorithm that didn't exist in 1996.

That's not good at all.  I'll be glad to remove these files, but the
original license of this code should be determined first, right?

thanks,

greg k-h
