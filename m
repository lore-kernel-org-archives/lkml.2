Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291Ab2B0JHK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 04:07:10 -0500
Received: from smtprelay-b11.telenor.se ([62.127.194.20]:33556 "EHLO
	smtprelay-b11.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704Ab2B0JHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 04:07:05 -0500
X-SENDER-IP: [85.230.168.211]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuV5AN5GS09V5qjTPGdsb2JhbABCiWyoUwOBBRkBAQEBNzSBcwEBBAE6HCMFCwgDRhQlCoguCbZ9E4pXgiwCDgEDBw0NAgoBBgsCBgcMFAkChEMIATwKCRIKU4I7YwSVPIVtjQM
X-IronPort-AV: E=Sophos;i="4.73,490,1325458800"; 
   d="scan'208";a="50836919"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Mon, 27 Feb 2012 10:07:17 +0100
To: david@lang.hm
Cc: Bobby Powers <bobbypowers@gmail.com>, "Ted Ts'o" <tytso@mit.edu>,
        Greg KH <gregkh@linuxfoundation.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Jidong Xiao <jidong.xiao@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Can we move device drivers into user-space?
Message-ID: <20120227090717.GA3516@polaris.bitmath.org>
References: <20120224203715.GA4995@polaris.bitmath.org>
 <20120224205651.GA13333@kroah.com>
 <20120224212238.GA5178@polaris.bitmath.org>
 <20120224213027.GB15735@thunk.org>
 <20120224221459.GA5254@polaris.bitmath.org>
 <CAArOQ2WCXDf2ymxihFdjKhBFMVhtoupVRB97_LsEky4HAGq0hA@mail.gmail.com>
 <20120226104701.GA18152@polaris.bitmath.org>
 <alpine.DEB.2.02.1202261503320.4108@asgard.lang.hm>
 <20120227000129.GA2265@polaris.bitmath.org>
 <alpine.DEB.2.02.1202261646480.4108@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1202261646480.4108@asgard.lang.hm>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >The argument was based on the idea that they would stabilize over
> >time. However, I realize this may not be true, which was also touched
> >upon in a later reply. The heavy-tailed nature of large changes in
> >open-source projects seems to put some hard numbers behind that claim [1].
> 
> What you are hearing from the long-time kernel developers is that
> they expect the interfaces to change over time.

That is coming through clearly.  What I find interesting is that in
addition to the authorative voice of Linux experience, there is
physical evidence that the well-known phenomenon of self-organized
criticality governs open-source code development at large. The
collective stream of patches coming from individual decisions and
real-world adaption shows the same behavior as avalanches, solar
flares and earthquakes; there is always a bigger change around the
corner. This critical phenomenon manifests itself through heavy-tailed
distributions, as reported in reference [1].  To a physicist, this is
a big deal.

Coming back to interfaces, the conclusion is that a large code tree
which exhibits these qualities is susceptible to large changes, and
can therefore adapt better.  This puts extra weight behind the notion
that Linux is doing the Right Thing.

The measurement by Wu and Holt in 2006 [1] has probably been succeeded
many times over, perhaps someone else has pointers to more recent
studies.

> Remember, the linux kernel has been around for a long time, and as a
> result, the interfaces have gone through many iterations. There is
> no reason to believe that the current version is the final one, and
> the kernel developers now expect that the current interfaces are
> _not_ going to remain the same forever, they expect that new
> technology will drive changes in these interfaces. This is
> especially true for the types of things that device drivers need.

Theory, experiment and experience seems to say the same thing, so one
simply has to agree with this point.
 
> Take for example locking. That is an implicit part of the interface
> to the device drivers, and is are area with a fairly high rate of
> change today. Anyone who claims that the current locking is
> 'correct' and can be depended on by an out-of-tree driver for even a
> couple of kernel releases is going to be either laughed at or
> ignored as being too ignorant to matter.
> 
> Yes, you can look around and find interfaces in the kernel that have
> not changed for a long time, but I'll bet that for every example you
> find, someone else could find an example of an interface that had
> remained unchanged for just about as long, but has changed fairly
> recently.

Obviously there is no disagreement here anymore.  And I wouldn't bet
without first computing the probability of such a change. :-)

Thanks.
Henrik
