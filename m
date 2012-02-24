Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757885Ab2BXUKb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 15:10:31 -0500
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:44647 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755195Ab2BXUKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 15:10:30 -0500
X-SENDER-IP: [85.230.168.211]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiiIAAbuR09V5qjTPGdsb2JhbABDiW2oFwOBBBkBAQEBNzSBcwEBBAE6HCMFCwgDRhQlChqIFAm4GxOKSoIfDxUfCwMPDQIPFQUDAoUtDgMMgw9jBJU6hW2NBA
X-IronPort-AV: E=Sophos;i="4.73,477,1325458800"; 
   d="scan'208";a="54575107"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Fri, 24 Feb 2012 21:10:27 +0100
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>,
        Jidong Xiao <jidong.xiao@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Can we move device drivers into user-space?
Message-ID: <20120224201027.GA4859@polaris.bitmath.org>
References: <CAG4AFWb0iG_t+Ps2isC_DF=f3WfVKyL+H-=ybKCtRP=ZmAAUUA@mail.gmail.com>
 <CAG4AFWZD8LeFkidnESCMfYFVFbjekAMJ_OZCTc2NRKJsvN3Qjw@mail.gmail.com>
 <20120224153811.GA16535@kroah.com>
 <1330103229.23014.130.camel@groeck-laptop>
 <20120224171752.GB9485@kroah.com>
 <20120224183423.GA23284@kroah.com>
 <20120224191535.GA4505@polaris.bitmath.org>
 <20120224192643.GB24120@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120224192643.GB24120@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > So yes, people will always do stupid, foolish things.  And they were
> > > doing them before UIO came along, now they just have the chance to at
> > > least do those foolish things in a way that interfaces with the kernel
> > > in a semi-sane manner, not messing anything else in the kernel up.
> > 
> > So the question is; can the uio example be repeated in other areas, to
> > bring more kernel power to userspace?
> 
> What exactly do you mean by "more kernel power"?  You can write
> userspace char drivers, filesystems, usb drivers, usb gadget drivers,
> and lots of other things today with the interfaces we provide from the
> kernel.

This is all good, but the thread was started for some generic reason
not covered by those examples. The uio interface was pointed out
because it brings pci(e) to userland, which was not (readily)
accessible before. However, every driver that cannot be implemented in
userspace is another example.

I am not complaining about the kernel and its driver structure - on
the contrary. I do, however, see a reason why constructing lower-level
interfaces to userspace may be of benefit. The kernel is growing
tremendously fast. Sooner or later, parts of the present driver
responsibility will have to be split into smaller chunks. Why not
place those chunks outside the kernel itself?

> And even better yet, please show what you mean with patches.

Sure. This particular thread seems to transcend patches, though. It
does not hurt to vent public opinion every now and then.

Henrik
