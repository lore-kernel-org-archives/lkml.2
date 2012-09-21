Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379Ab2IURYf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 13:24:35 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:29453 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756892Ab2IURYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 13:24:34 -0400
Date: Fri, 21 Sep 2012 13:13:05 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: Oliver Chick <oliver.chick@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jan Beulich <JBeulich@suse.com>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>
Subject: Re: [Xen-devel] [PATCH] Persistent grant maps for xen blk drivers
Message-ID: <20120921171304.GB9201@phenom.dumpdata.com>
References: <1348051887-21885-1-git-send-email-oliver.chick@citrix.com>
 <505AF126.2050806@citrix.com>
 <1348140637.24539.32.camel@oliverchick-Precision-WorkStation-T3400>
 <505B1EB9020000780009CA6E@nat28.tlf.novell.com>
 <505C5C54.4060100@citrix.com>
 <20120921142733.GB3389@phenom.dumpdata.com>
 <505C9320.8030905@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <505C9320.8030905@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 05:17:36PM +0100, David Vrabel wrote:
> On 21/09/12 15:27, Konrad Rzeszutek Wilk wrote:
> > On Fri, Sep 21, 2012 at 01:23:48PM +0100, David Vrabel wrote:
> >>
> >> It's not just virtual space.  blkback in pvops kernels allocates its
> >> pages from the balloon and if there aren't enough ballooned out pages it
> >> has to allocate real pages (releasing the MFN back to Xen).
> >>
> >> Classic kernels didn't need to do this as there was an API for allocate
> >> new "empty" struct page's that get mapped into kernel space.
> > 
> > Can we ressurect/implement that in the new pvops? We could use the memory
> > hotplug mechanism to allocate "non-existent" memory. 
> 
> I don't see why not.  Provided the limitations are documented I wouldn't
> make merging the persistent grant stuff dependent on it.

I was thinking about this in the future and not delay this [persistent grants].
> 
> David
