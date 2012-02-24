Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758149Ab2BXVWm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 16:22:42 -0500
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:36790 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756160Ab2BXVWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 16:22:41 -0500
X-SENDER-IP: [85.230.168.211]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aip4AEv/R09V5qjTPGdsb2JhbABDiX+oG4EGGQEBAQE3NIFzAQEEATocERIQCANGFCUKGogUCbcqE4pKgi4CBg0fCwMPDQIPFQUDAoUtDgMMgw9jBJU6hW2NBA
X-IronPort-AV: E=Sophos;i="4.73,478,1325458800"; 
   d="scan'208";a="274144032"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Fri, 24 Feb 2012 22:22:38 +0100
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>,
        Jidong Xiao <jidong.xiao@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Can we move device drivers into user-space?
Message-ID: <20120224212238.GA5178@polaris.bitmath.org>
References: <20120224153811.GA16535@kroah.com>
 <1330103229.23014.130.camel@groeck-laptop>
 <20120224171752.GB9485@kroah.com>
 <20120224183423.GA23284@kroah.com>
 <20120224191535.GA4505@polaris.bitmath.org>
 <20120224192643.GB24120@kroah.com>
 <20120224201027.GA4859@polaris.bitmath.org>
 <20120224201655.GA5994@kroah.com>
 <20120224203715.GA4995@polaris.bitmath.org>
 <20120224205651.GA13333@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120224205651.GA13333@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > How long can one grow and still claim to _be_ a kernel?
> 
> You tell me.  I know of lots of "kernels" that are far bigger than
> Linux, and people still consider them a kernel.

I would love to be enligthened.

> > The current
> > (arbitrary) split between kernel and userland was made a long time
> > ago. For a number of reasons, of course, but not least out of
> > convenience. Projecting the current kernel growth ten years into the
> > future, will there still not be another (arbitrary) convenient split?
> 
> Why?  What problems are we having with our existing user/kernel split
> that would drive such a change?

Maintenance. Sure, as soon as an area grows too large for a single
person, the current structure will ensure it divides so that the patch
stream becomes manageable. We have already seen ample examples of
that. But the overall structure of the kernel will become less and
less manageable, and the likelihood of duplicates and maintenance
problems will increase. At some point, intra-system interfaces will be
introduced, such that several areas may coexist and expand
individually. At that point, the convenience split will already have
been made, and the subsystems may well reside in different places.


> > Even so, the main point was not whether a secondary split may or may
> > not happen, but what will happen to the quality of the total system
> > when/if that happens. I doubt the fate of userland drivers would be so
> > heatedly discussed if everyone believed that work would be carried out
> > with the same quality currently found in the kernel.
> 
> Quality is not the only reason we don't want userspace drivers for some
> types of devices.  Realize what drivers provide to userspace today and
> you will understand that.

I think I do understand how software interfaces and streamlining
works, so I fail to get the point here.

Thanks,
Henrik
