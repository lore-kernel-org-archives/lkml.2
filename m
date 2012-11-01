Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936130Ab2KAWFs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 18:05:48 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:32873 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761979Ab2KAWFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 18:05:45 -0400
Date: Thu, 1 Nov 2012 18:05:20 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jan Beulich <jbeulich@suse.com>
Cc: rientjes@google.com, jeremy@goop.org, x86@kernel.org, tglx@linutronix.de,
        torvalds@linux-foundation.org, xen-devel@lists.xensource.com,
        mingo@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [patch] x86, xen: fix build dependency when USB_SUPPORT is not
 enabled
Message-ID: <20121101220520.GC18854@localhost.localdomain>
References: <alpine.DEB.2.00.1210312239120.31758@chino.kir.corp.google.com>
 <20121101124912.GA10743@localhost.localdomain>
 <5092D5EA020000780008EB85@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5092D5EA020000780008EB85@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 01, 2012 at 08:04:58PM +0000, Jan Beulich wrote:
> >>> Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> 11/01/12 1:49 PM >>>
> >On Wed, Oct 31, 2012 at 10:42:30PM -0700, David Rientjes wrote:
> >> CONFIG_XEN_DOM0 must depend on CONFIG_USB_SUPPORT, otherwise there is no 
> >> definition of xen_dbgp_reset_prep() and xen_dbgp_external_startup() 
> >> resulting in the following link error:
> >> 
> >> drivers/built-in.o: In function `dbgp_reset_prep':
> >> (.text+0x1e03c5): undefined reference to `xen_dbgp_reset_prep'
> >> drivers/built-in.o: In function `dbgp_external_startup':
> >> (.text+0x1e0d55): undefined reference to `xen_dbgp_external_startup'
> >
> >There is another patch that needs to be Acked and picked up by
> >Greg KH that fixes this.
> >
> >Let me poke Jan Beulich to repost it with the appropiate Acks.
> 
> It's been picked up already, but another dependency problem was found with
> it (due to not having used CONFIG_USB_SUPPORT as dependency, as I had
> first submitted).

Oh. I missed that part - so do you think that this patch should also
be used? Or do you think there is another way to fix this?

I am in transit right now so I can't prep a patch (and the laptop I've
is extremely slow to even do a test compile).
> 
> Jan
> 
