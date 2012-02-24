Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757009Ab2BXTPj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 14:15:39 -0500
Received: from smtprelay-b11.telenor.se ([62.127.194.20]:59953 "EHLO
	smtprelay-b11.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873Ab2BXTPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 14:15:38 -0500
X-SENDER-IP: [85.230.168.211]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqZ+AEnhR09V5qjTPGdsb2JhbABDiX+oFoEGGQEBAQE3NIFzAQEEATocIxAIA0YUJQoaiBQJtx0TikqCJAoGDxUKCwMPDQIPFQUDAoUtDgMMgw9jBJU6hW2NBA
X-IronPort-AV: E=Sophos;i="4.73,477,1325458800"; 
   d="scan'208";a="54559073"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Fri, 24 Feb 2012 20:15:35 +0100
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>,
        Jidong Xiao <jidong.xiao@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Can we move device drivers into user-space?
Message-ID: <20120224191535.GA4505@polaris.bitmath.org>
References: <CAG4AFWb0iG_t+Ps2isC_DF=f3WfVKyL+H-=ybKCtRP=ZmAAUUA@mail.gmail.com>
 <CAG4AFWZD8LeFkidnESCMfYFVFbjekAMJ_OZCTc2NRKJsvN3Qjw@mail.gmail.com>
 <20120224153811.GA16535@kroah.com>
 <1330103229.23014.130.camel@groeck-laptop>
 <20120224171752.GB9485@kroah.com>
 <20120224183423.GA23284@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120224183423.GA23284@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Given the choice, I would be quite happy to piss off some robots. Call
> > it a prejudice if you like ;).
> 
> You can't control how people use an interface.  You will note that there
> are no stupid users of the UIO interface in the kernel today, we can't
> control what people do in the privacy of their own companies/homes,
> despite numerous governments trying to do so in the past.
> 
> So yes, people will always do stupid, foolish things.  And they were
> doing them before UIO came along, now they just have the chance to at
> least do those foolish things in a way that interfaces with the kernel
> in a semi-sane manner, not messing anything else in the kernel up.

So the question is; can the uio example be repeated in other areas, to
bring more kernel power to userspace?

No doubt, the kernel has fostered an unprecedented code-quality view,
which, IMHO, is the bottom line. As long as that quality remains
unchallenged, having all drivers in-kernel will remain the best
choice. But, suppose some entity managed to keep that quality in
userspace, would there be any reason to think of it as a bad idea? I
think not.

Henrik
