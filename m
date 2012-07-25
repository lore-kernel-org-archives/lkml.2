Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751123Ab2GYSwV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 14:52:21 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:22280 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789Ab2GYSwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 14:52:20 -0400
Date: Wed, 25 Jul 2012 14:43:19 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "Tim (Xen.org)" <tim@xen.org>, Ian Campbell <Ian.Campbell@citrix.com>
Subject: Re: [Xen-devel] [PATCH WIP 6/6] xen/arm: enable evtchn irqs
Message-ID: <20120725184319.GB16360@phenom.dumpdata.com>
References: <1340381685-22529-1-git-send-email-stefano.stabellini@eu.citrix.com>
 <1340381685-22529-6-git-send-email-stefano.stabellini@eu.citrix.com>
 <20120709144005.GA12102@phenom.dumpdata.com>
 <alpine.DEB.2.02.1207131749470.23783@kaball.uk.xensource.com>
 <20120716145709.GB552@phenom.dumpdata.com>
 <alpine.DEB.2.02.1207181750500.23783@kaball.uk.xensource.com>
 <20120719233045.GA944@phenom.dumpdata.com>
 <alpine.DEB.2.02.1207201208230.23783@kaball.uk.xensource.com>
 <20120720143609.GA21870@phenom.dumpdata.com>
 <alpine.DEB.2.02.1207201608100.26163@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1207201608100.26163@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2012 at 04:23:07PM +0100, Stefano Stabellini wrote:
> On Fri, 20 Jul 2012, Konrad Rzeszutek Wilk wrote:
> > On Fri, Jul 20, 2012 at 12:09:56PM +0100, Stefano Stabellini wrote:
> > > On Fri, 20 Jul 2012, Konrad Rzeszutek Wilk wrote:
> > > > > > OK, please include those questions/answers in the git commit and
> > > > > > repost.
> > > > 
> > > > I seem to be missing the rest of the patches. I see the drivers/xen/events also
> > > > has the  xen_init_IRQ_arm... is there a git tree with the base patches?
> > > 
> > > Yes, the latest git tree, based on
> > > 55b02d2f4445ad625213817a1736bf2884d32547, is available here:
> > > 
> > > git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git xenarmv7-3
> > 
> > Uh there is a bit of stuff there.
> 
> Actually, aside from many backports and hacks, there are just three
> interesting patch series from my point of view:
> 
> http://marc.info/?l=xen-devel&m=133001901013674&w=2 xen/arm: receive Xen events and initialize xenbus
> http://marc.info/?l=xen-devel&m=134038186610813&w=2 xen/arm: PV console support
> http://marc.info/?l=xen-devel&m=134140081408627&w=2 xen/arm: grant_table, blkfront and blkback
> 
> The last two are recent and I have received feedback from you on the second
> one.
> 
> 
> > Can you just repost those you want me to
> > review and Ack that touch common code?
> 
> Good idea, but fortunately there aren't that many of them.
> In fact if we exclude the ones that just add more #include, these are the ones
> that remains:
> 
> d122a6b075e582af17dd2b3ddd8ee4ded3f85300 xen/arm: receive xen events on arm
> 1902bd5574447c03c1e6081cce98d8bf6e1f35e7 xen/arm: compile and run xenbus
> 5bbda4a165284aceee19b54954f10344b724b506 xen/arm: enable evtchn irqs
> d4fda31cf5411e8ada3f1163c68595b7474d7c1d xen/arm: initialize grant_table on ARM
> 
> it would be nice if you could take a look at them and tell me what you think.
> 
> 
> > Or are you posting them to collect feedback/Acks and then want to post them
> > as a bigger set?

I am going to be lazy and wait for you to git-send-email the right patches. If
you like, you can just email them privately to me and I can look at them.

> 
> Yes, the idea is to post them in a single set.
> Now that I have support for the basic functionalities (guests booting, PV
> console, disk and network), I can start working on a single patch
> series for a recent kernel.
