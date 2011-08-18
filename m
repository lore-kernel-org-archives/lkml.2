Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755784Ab1HRMLX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 08:11:23 -0400
Received: from smtp.tele.fi ([192.89.123.25]:43144 "EHLO
	vulpes-int.media.sonera.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752826Ab1HRMLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 08:11:20 -0400
X-Greylist: delayed 2589 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Aug 2011 08:11:19 EDT
X-Originating-Ip: [194.89.68.22]
Date: Thu, 18 Aug 2011 14:28:06 +0300
From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Greg KH <greg@kroah.com>, Tim Bird <tbird20d@gmail.com>,
        linux-kernel@vger.kernel.org, stable-review@kernel.org,
        tim.bird@am.sony.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@kernel.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] Future of the -longterm kernel releases (i.e.
	how we pick them).
Message-ID: <20110818112806.GF32373@reaktio.net>
References: <20110815041524.GA7578@kroah.com> <CA+bK7J7_EKdQACnoJGWkd4asH+096SJ-gjEvsnjmRX6Dmc6dpA@mail.gmail.com> <20110817045856.GB4936@kroah.com> <1313627614.2799.61.camel@deadeye>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313627614.2799.61.camel@deadeye>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 18, 2011 at 01:33:34AM +0100, Ben Hutchings wrote:
> On Tue, 2011-08-16 at 21:58 -0700, Greg KH wrote:
> > On Tue, Aug 16, 2011 at 04:01:57PM -0700, Tim Bird wrote:
> [...]
> > > One specific issue I have is support for PREEMPT_RT, so that's a big
> > > factor in selecting Sony kernel versions.  Thus, coordinating with the
> > > RT patchset kernel versions is important to me.  Currently
> > > that would mean 3.0 is a good candidate.
> > 
> > 3.0 is looking like a good candidate, but we haven't seen 3.1 yet :)
> [...]
> 
> I'm quite happy with 3.0 in terms of stability and features, though it's
> early days yet.  It's not so good for Debian in terms of timing.  We're
> not going to freeze for another 10 months, then the release will likely
> be at least 6 months after that.  The earlier a kernel release we pick
> with, the more hardware support needs to be backported later.  So,
> extrapolating the likely kernel release dates, I think I would prefer to
> use something between 3.2 and 3.4.
> 

I'd *guess* Ubuntu 12.04 LTS goes for Linux 3.2 .. 

-- Pasi


> As for the RT patchset, I haven't seen any announcement that it will
> continue to be developed against 3.0 after the release of 3.1.  Of
> course, the fact that there *is* a working RT patchset for 3.0 is an
> advancement over recent upstream releases.
> 
> Ben.
> 


