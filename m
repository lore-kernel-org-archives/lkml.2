Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662Ab2DCNJR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 09:09:17 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:45653 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428Ab2DCNJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 09:09:15 -0400
Date: Tue, 3 Apr 2012 09:04:28 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, stable@vger.kernel.org
Subject: Re: Don't apply 9f022e54b8ea82d1ecdf3bd78d9ab9f44d6b0655 to stable
 please.
Message-ID: <20120403130428.GA12464@phenom.dumpdata.com>
References: <20120402224701.GA6961@phenom.dumpdata.com>
 <20120402232750.GB17821@kroah.com>
 <1333410186.1270.92.camel@sbsiddha-desk.sc.intel.com>
 <20120402234904.GA18316@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120402234904.GA18316@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090209.4F7AF674.0074,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2012 at 04:49:04PM -0700, Greg KH wrote:
> On Mon, Apr 02, 2012 at 04:43:05PM -0700, Suresh Siddha wrote:
> > On Mon, 2012-04-02 at 16:27 -0700, Greg KH wrote:
> > > On Mon, Apr 02, 2012 at 06:47:02PM -0400, Konrad Rzeszutek Wilk wrote:
> > > > Hey Greg,
> > > > 
> > > > The git commit 9f022e54b8ea82d1ecdf3bd78d9ab9f44d6b0655 has CC stable@kernel.org
> > > > but it breaks Xen - we are working to fix it in 3.4, but the fix for it
> > > > does some architectual changes (136d249ef7dbf0fefa292082cc40be1ea864cbd6) that
> > > > I don't know if you are comfortable putting in stable tree.
> > > > 
> > > 
> > > I have no idea what that git commit id referrs to, as it's not in
> > > Linus's tree at the moment.
> > > 
> > > Care to give me a subject?  diffstat?  Some kind of hint?
> > 
> > Greg, Konrad is referring to:
> > 
> > commit 73d63d038ee9f769f5e5b46792d227fe20e442c5
> 
> Ok, then where did the 9f022e54b8ea82d1ecdf3bd78d9ab9f44d6b0655 number
> come from?  And where was I supposed to be able to determine what it is
> pointing to?

Hm, somehow that is the git commit I saw, but it probably was b/c it got
cherrypicked in my testing tree.
> 
> Come on people...
> 
> > Author: Suresh Siddha <suresh.b.siddha@intel.com>
> > Date:   Mon Mar 12 11:36:33 2012 -0700
> > 
> >     x86/ioapic: Add register level checks to detect bogus io-apic entries
> > 
> > With out this commit, if the bios lists bogus io-apic's, then we will
> > see some error messages ("Unable to reset IRR for apic")during linux
> > boot which are benign. But as this patch breaks Xen, I am ok if these
> > don't get applied to 'stable'. Also I think it is Ingo who added the
> > 'stable' tag. Ingo, are you ok with this?
> 
> What stable trees did this already go into in the releases today?

None. That is why I am sending this advance warning so you don't
put it in.

> 
> You need to tell me what I need to revert here, SPECIFICALLY, and in
> what tree, if needed, otherwise I have no idea what is going on, sorry,
> I can't read minds.
> 
> > For the mainline, we have queued more patches to fix the Xen breakage.
> 
> And what is that supposed to mean to me?
> 
> Again, help me out here, this is making no sense at all.
> 
> How am I supposed to "not apply" a patch that I have never heard of?
> And how am I supposed to "not apply" a patch that I have already
> applied?
> 
> How about you all start over from the beginning and tell me EXACTLY what
> you want me to do here, because I sure as heck don't know what is going
> on...

Heh.

The patch titled "x86/ioapic: Add register level checks to detect bogus io-apic entries"
(git commit 73d63d038ee9f769f5e5b46792d227fe20e442c5) that is in v3.4-rc1, even
thought it has cc: stable@kernel.org, should _NOT_ be applied to the stable tree.

> 
> confused,
> 
> greg k-h
