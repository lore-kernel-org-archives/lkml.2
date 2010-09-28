Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760553Ab0I1BpM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 21:45:12 -0400
Received: from www.telegraphics.com.au ([204.15.192.19]:60613 "EHLO
	mail.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757688Ab0I1BpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 21:45:10 -0400
X-Greylist: delayed 413 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Sep 2010 21:45:10 EDT
Date: Tue, 28 Sep 2010 11:37:57 +1000 (EST)
From: Finn Thain <fthain@telegraphics.com.au>
To: "Justin P. Mattock" <justinmattock@gmail.com>
cc: Joe Perches <joe@perches.com>, "John W. Linville" <linville@tuxdriver.com>,
        trivial@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org,
        alsa-devel@alsa-project.org, dri-devel@lists.freedesktop.org,
        linux-ide@vger.kernel.org, "Maciej W. Rozycki" <macro@linux-mips.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Randy Dunlap <rdunlap@xenotime.net>, Matt Turner <mattst88@gmail.com>,
        Dimitry Torokhov <dmitry.torokhov@gmail.com>,
        Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [RFC v4]update broken web addresses in the kernel.
In-Reply-To: <4CA0CB0F.3060303@gmail.com>
Message-ID: <alpine.OSX.2.00.1009281119570.276@localhost>
References: <1285525875-9920-1-git-send-email-justinmattock@gmail.com>  <20100927151005.GC11086@tuxdriver.com> <1285603383.1732.106.camel@Joe-Laptop> <4CA0CB0F.3060303@gmail.com>
User-Agent: Alpine 2.00 (OSX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 27 Sep 2010, Justin P. Mattock wrote:

> On 09/27/2010 09:03 AM, Joe Perches wrote:
> > On Mon, 2010-09-27 at 11:10 -0400, John W. Linville wrote:
> > > On Sun, Sep 26, 2010 at 11:31:15AM -0700, Justin P. Mattock wrote:
> > > > Below is an updated patch from the original fixing broken web 
> > > > addresses in the kernel. Thanks for all the help and info on this 
> > > > to everybody.. Hopefully I didnt miss any of them(if so let me 
> > > > know, and I'll resend).
> > > Changing a URL for a relocated page is one thing, but removing links 
> > > isn't necessarily a great idea.  Even if the site is technically 
> > > gone, it may be possible to find information e.g through the 
> > > Internet Archive Wayback Machine.
> > 
> > Perhaps it'd be better to scrape the contents of the various web 
> > pages, collect them somewhere like wiki.kernel.org and encourage 
> > others to put new contributions in that site.

The copyright problem aside, this might be a good idea for material not 
already archived but I don't think it makes sense to start a new 
archive when archive.org (or other) has the information.

And which version(s) do you scrape? I discussed some problems with 
changing URLs in another thread: http://lkml.org/lkml/2010/9/22/22

Anyway, without knowing what future archive(s) would be available or 
relevant to any given URL in the future, I think the best we might do is a 
"Retrieved on YYYY-MM-DD" qualification for new URLs.

> 
> 
> yeah I think somebody was saying something about having a separate file, 
> with all the web addresses in them or something...In any case, up to you 
> guys..

I don't see how moving the addresses would help.
And would it not make the information harder to find?

Finn

> 
> Justin P. Mattock
> 
