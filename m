Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257Ab0GAXJO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 19:09:14 -0400
Received: from xenotime.net ([72.52.115.56]:53470 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751858Ab0GAXJM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 19:09:12 -0400
Date: Thu, 1 Jul 2010 16:09:01 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Greg KH <greg@kroah.com>
Cc: Florian Fainelli <florian@openwrt.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: 4 -stable kernel review cycles starting
Message-Id: <20100701160901.887709e8.rdunlap@xenotime.net>
In-Reply-To: <20100701225129.GA12760@kroah.com>
References: <20100701175100.GA2078@kroah.com>
	<201007012355.05531.florian@openwrt.org>
	<20100701221059.GA11663@kroah.com>
	<20100701153600.a0fc684e.rdunlap@xenotime.net>
	<20100701225129.GA12760@kroah.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Jul 2010 15:51:29 -0700 Greg KH wrote:

> On Thu, Jul 01, 2010 at 03:36:00PM -0700, Randy Dunlap wrote:
> > On Thu, 1 Jul 2010 15:10:59 -0700 Greg KH wrote:
> > 
> > > On Thu, Jul 01, 2010 at 11:55:02PM +0200, Florian Fainelli wrote:
> > > > Hi,
> > > > 
> > > > Le Thursday 1 July 2010 19:51:00, Greg KH a écrit :
> > > > > First off, sorry for the long delay in the -stable kernel releases, they
> > > > > got pushed to the back-burner for other things recently ("Hey look, is
> > > > > that the sun finally here in the Pacific Northwest?")
> > > > > 
> > > > > Please note that there are still a large number of patches that have
> > > > > been submitted to the -stable trees for inclusion, that I have not
> > > > > included yet.  Do not worry, they are still in my queue, but due to the
> > > > > large number of patches that I already have queued up, I figured it was
> > > > > better to get what I have applied already out for a release and then
> > > > > work on catching up after this.
> > > > > 
> > > > > If anyone has any questions about this, please let me know.
> > > > 
> > > > Looks like this cpmac patch was not included in this -stable series: 
> > > > http://www.spinics.net/lists/netdev/msg133317.html
> > > > 
> > > > Can you queue it for future -stable releases or this one?
> > > 
> > > {sigh}
> > > 
> > > Did you see the second paragraph above as to why it isn't in this
> > > release?
> > 
> > I did. :)
> > and I saw the third paragraph above.
> > ["If anyone has any questions about this, please let me know."]
> 
> Well, if the question could be answered by reading the second
> paragraph... :)
> 
> > > And yes, it will be in future ones.
> > 
> > Unfortunately, I don't find it feasible to review several hundred patches
> > in the next 3 days.  I think that I understand how your stable & staging
> > cycles (workloads) work, but I also think that it would help if you
> > wouldn't batch all stable reviews together like this.
> 
> If you look closely, almost all of the patches in all of the trees are
> in other trees, so the number of unique patches is much less than the
> whole total of all of the different patches in 4 trees.

Yes, that's a good point.

> If you don't like this type of review cycle, what would you prefer?

I don't see a magic bullet answer here.  I think that it would help
somewhat for the stable maintainer(s) to have only one -stable review
cycle (new posting) per day, but someone may not like that either,
since it would have the effect of delaying some stable kernel releases
(not to mention muck up your workload).

thanks,
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
