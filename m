Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab2DCOgG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 10:36:06 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:34117 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894Ab2DCOgE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 10:36:04 -0400
Date: Tue, 3 Apr 2012 10:31:14 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Teck Choon Giam <giamteckchoon@gmail.com>, gregkh@linuxfoundation.org
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, stable@vger.kernel.org
Subject: Re: Don't apply 9f022e54b8ea82d1ecdf3bd78d9ab9f44d6b0655 to stable
 please.
Message-ID: <20120403143114.GA27326@phenom.dumpdata.com>
References: <20120402224701.GA6961@phenom.dumpdata.com>
 <20120402232750.GB17821@kroah.com>
 <1333410186.1270.92.camel@sbsiddha-desk.sc.intel.com>
 <20120402234904.GA18316@kroah.com>
 <20120403132850.GE12464@phenom.dumpdata.com>
 <CAEwRVpNMZaQq0vaoS0aLk2rv3ysyhtOpXKub9HWR0bosgku6_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <CAEwRVpNMZaQq0vaoS0aLk2rv3ysyhtOpXKub9HWR0bosgku6_Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-CT-RefId: str=0001.0A090202.4F7B0AC8.0094,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 03, 2012 at 10:26:42PM +0800, Teck Choon Giam wrote:
> On Tue, Apr 3, 2012 at 9:28 PM, Konrad Rzeszutek Wilk
> <konrad.wilk@oracle.com> wrote:
> >> > Author: Suresh Siddha <suresh.b.siddha@intel.com>
> >> > Date:   Mon Mar 12 11:36:33 2012 -0700
> >> >
> >> >     x86/ioapic: Add register level checks to detect bogus io-apic entries
> >> >
> >> > With out this commit, if the bios lists bogus io-apic's, then we will
> >> > see some error messages ("Unable to reset IRR for apic")during linux
> >> > boot which are benign. But as this patch breaks Xen, I am ok if these
> >> > don't get applied to 'stable'. Also I think it is Ingo who added the
> >> > 'stable' tag. Ingo, are you ok with this?
> >>
> >> What stable trees did this already go into in the releases today?
> >
> > I see it in v3.2.x as:
> > 273fb19 x86/ioapic: Add register level checks to detect bogus io-apic entries
> >
> > And in 3.0.x:
> > c2ec63e x86/ioapic: Add register level checks to detect bogus io-apic entries
> 
> And does this also affect 3.3.x?  I haven't test but guess it will?

Yup!
> 
> # git log | grep -B 5 'x86/ioapic: Add register level checks to detect
> bogus io-apic entries'
> 
> commit a998dc2fa76f496d2944f0602b920d1d10d7467d
> Author: Suresh Siddha <suresh.b.siddha@intel.com>
> Date:   Mon Mar 12 11:36:33 2012 -0700
> 
>     x86/ioapic: Add register level checks to detect bogus io-apic entries
> 

Greg, please also revert this one.
