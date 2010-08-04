Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759454Ab0HDXYt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 19:24:49 -0400
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:38090 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759372Ab0HDXYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 19:24:48 -0400
X-Greylist: delayed 1377 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Aug 2010 19:24:47 EDT
Date: Wed, 4 Aug 2010 16:01:48 -0700
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: stefani@seibold.net
Cc: Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, tytso@mit.edu
Subject: Re: new gerneric kfifo API
Message-ID: <20100804230147.GI23951@ovro.caltech.edu>
References: <201005132135.o4DLZ9WI021613@imap1.linux-foundation.org>
 <1280905854.8441.3.camel@wall-e.seibold.net>
 <20100804194617.GA30773@suse.de>
 <1280952551.8594.0.camel@wall-e.seibold.net>
 <20100804201724.GA32100@suse.de>
 <20100804145205.524c1c03.akpm@linux-foundation.org>
 <20100805000246.57246lmy2qeimft2@mail.your-server.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100805000246.57246lmy2qeimft2@mail.your-server.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Wed, 04 Aug 2010 16:01:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 05, 2010 at 12:02:46AM +0200, stefani@seibold.net wrote:
> 
> Zitat von Andrew Morton <akpm@linux-foundation.org>:
> 
> > On Wed, 4 Aug 2010 13:17:24 -0700
> > Greg KH <gregkh@suse.de> wrote:
> >
> >> On Wed, Aug 04, 2010 at 10:09:11PM +0200, Stefani Seibold wrote:
> >> > Am Mittwoch, den 04.08.2010, 12:46 -0700 schrieb Greg KH:
> >> > > On Wed, Aug 04, 2010 at 09:10:54AM +0200, Stefani Seibold wrote:
> >> > > > Hi,
> >> > > >
> >> > > > once again. Kernel 2.6.35 is out and i want to know if there  
> >> is play plan to
> >> > > > merge the generic kfifo API. All complains was fixed, so there is no
> >> > > > reason to shift the merge again. Please gibe me a short answer.
> >> > >
> >> > > These have been in the -mm tree for a few major kernel releases now,
> >> > > right?  And they are API safe, and only change the internals, right?
> >> > >
> >> > > If so, I see no objection to merging them now, especially as you will be
> >> > > around to fix up any problems that people have, right?  :)
> >> > >
> >> >
> >> > right!
> >>
> >> Great.  As Andrew doesn't have the time to send them on, want me to?  If
> >> so, care to point me at them in his tree, or resend them to me?
> >>
> >
> > One does a little more than "send things on"...
> >
> > I have a little pile of kfifo changes queud for 2.6.36.  The "generic
> > kfifo" patches are a large rotorooting of the whole facility, based on
> > that work (I hope).
> >
> > There's also the abandoned
> > kfifo-replace-the-old-non-generic-api-kfifo-fix-scatterlist-usage.patch
> > which never got resolved with the originator.
> >
> >
> 
> This patch was included in the latest version i had posted last week.
> 

Hello Stefani, Andrew,

I've reviewed the updated patch from Stefani which has incorporated the
fixes I suggested into the DMA routines. The DMA routines have my ack,
though I have not ported any code to them yet.

Thanks,
Ira
