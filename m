Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab2DCNdi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 09:33:38 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:26112 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872Ab2DCNdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 09:33:36 -0400
Date: Tue, 3 Apr 2012 09:28:50 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, stable@vger.kernel.org
Subject: Re: Don't apply 9f022e54b8ea82d1ecdf3bd78d9ab9f44d6b0655 to stable
 please.
Message-ID: <20120403132850.GE12464@phenom.dumpdata.com>
References: <20120402224701.GA6961@phenom.dumpdata.com>
 <20120402232750.GB17821@kroah.com>
 <1333410186.1270.92.camel@sbsiddha-desk.sc.intel.com>
 <20120402234904.GA18316@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120402234904.GA18316@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090205.4F7AFC2A.0031,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

I see it in v3.2.x as:
273fb19 x86/ioapic: Add register level checks to detect bogus io-apic entries

And in 3.0.x:
c2ec63e x86/ioapic: Add register level checks to detect bogus io-apic entries

But I don't see it in 3.1.x tree?

> 
> You need to tell me what I need to revert here, SPECIFICALLY, and in
> what tree, if needed, otherwise I have no idea what is going on, sorry,
> I can't read minds.
