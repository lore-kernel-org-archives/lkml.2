Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335Ab1CWEzr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 00:55:47 -0400
Received: from kroah.org ([198.145.64.141]:33097 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752978Ab1CWEzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 00:55:46 -0400
Date: Tue, 22 Mar 2011 21:56:52 -0700
From: Greg KH <greg@kroah.com>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, andy.green@linaro.org,
        Jaswinder Singh <jaswinder.singh@linaro.org>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, arnd@arndb.de,
        broonie@opensource.wolfsonmicro.com, roger.quadros@nokia.com,
        grant.likely@secretlab.ca
Subject: Re: RFC: Platform data for onboard USB assets
Message-ID: <20110323045652.GA13694@kroah.com>
References: <4D79F068.2080009@linaro.org>
 <AANLkTim=ezye=1fQP_1a2SWbPnbENP9B+k27Z3AkS=zf@mail.gmail.com>
 <1300828125.2402.300.camel@pasglop>
 <4D8924B6.8040403@linaro.org>
 <1300842219.2402.309.camel@pasglop>
 <alpine.LFD.2.00.1103222138320.11889@xanadu.home>
 <1300850595.2402.320.camel@pasglop>
 <alpine.LFD.2.00.1103222336030.11889@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1103222336030.11889@xanadu.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 12:21:41AM -0400, Nicolas Pitre wrote:
> On Wed, 23 Mar 2011, Benjamin Herrenschmidt wrote:
> > The argument boils down to should we encourage adding an additional
> > in-kernel platform_data based hooks for dynamically probed busses such
> > as USB as well ? or go for a udev based solution for the time being
> > which would probably work as well in practice and focus on getting the
> > device-tree based solution for the long term instead.
> 
> The udev solution has its set of drawbacks.  Using udev is perfect for 
> arbitrary user policies.  But here we're talking about a particular 
> device which happens to be soldered on a particular board, and adding 
> that knowledge to udev which is a separately maintained piece of 
> software from the kernel is rather redundant while the kernel already 
> knows perfectly well on which hardware it is running.  And as Andy 
> pointed out, the kernel's job is to abstract hardware peculiarities, not 
> to force them to user space.

{sigh}

This is the _exact_ same argument that the server manufacturers tried to
do for the naming of the ethernet pci devices and naming of them to
match up with the physical label that is on the back of the machine.

Because of that, please use the same tools that they created to solve
this problem.  It's done in userspace, in a way that works for everyone
and on all distros, even your embedded one.

I do not understand why everyone is so resistant to this solution?  Have
you all tried it out and found problems with it?

thanks,

greg k-h
