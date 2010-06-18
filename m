Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759743Ab0FRJ7l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 05:59:41 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:56423 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046Ab0FRJ7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 05:59:39 -0400
Date: Fri, 18 Jun 2010 12:00:42 +0200
From: Borislav Petkov <bp@amd64.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Carpenter <error27@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch] get rid of "cut here" from bug output
Message-ID: <20100618100042.GA1905@aftab>
References: <20100617122156.GK5483@bicker>
 <20100617123637.GA3492@kryptos.osrc.amd.com>
 <20100617231902.9ce1e33e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100617231902.9ce1e33e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, Jun 18, 2010 at 02:19:02AM -0400

> On Thu, 17 Jun 2010 14:36:37 +0200 Borislav Petkov <bp@amd64.org> wrote:
> 
> > From: Dan Carpenter <error27@gmail.com>
> > Date: Thu, Jun 17, 2010 at 02:21:56PM +0200
> > 
> > > It's annoying to have chunks of dmesg output instead just the whole
> > > output.  A lot of times the very interesting information is before
> > > the bug happens.
> > > 
> > > Signed-off-by: Dan Carpenter <error27@gmail.com>
> > > 
> > > diff --git a/kernel/panic.c b/kernel/panic.c
> > > index 3b16cd9..2db532a 100644
> > > --- a/kernel/panic.c
> > > +++ b/kernel/panic.c
> > > @@ -373,7 +373,7 @@ static void warn_slowpath_common(const char *file, int line, void *caller,
> > >  {
> > >  	const char *board;
> > >  
> > > -	printk(KERN_WARNING "------------[ cut here ]------------\n");
> > > +	printk(KERN_WARNING "-----[ paste whole dmesg to bugzilla ]-----\n");
> > 
> > Good idea, we end up requesting the whole dmesg most of the time anyway.
> > However not all bugs are reported through bugzilla, and, frankly
> > bugzilla is kinda sucky when it comes down to communicating with the bug
> > reporter. How about the more generic "send whole dmesg when reporting"
> > instead?
> 
> And the pestiferous thing wordwraps the dmesg output to death, making
> it amazingly hard to read.  s/paste/attach/ maybe.

Right, good point.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
