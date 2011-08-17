Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751320Ab1HQFAH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 01:00:07 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:54821 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750813Ab1HQFAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 01:00:03 -0400
X-Sasl-enc: 7E5lLP9vZyaXN4zWC9TlySRyDqstkI0PJazmToFED4x8 1313557200
Date: Tue, 16 Aug 2011 21:58:56 -0700
From: Greg KH <greg@kroah.com>
To: Tim Bird <tbird20d@gmail.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        stable-review@kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: Re: Future of the -longterm kernel releases (i.e. how we pick them).
Message-ID: <20110817045856.GB4936@kroah.com>
References: <20110815041524.GA7578@kroah.com>
 <CA+bK7J7_EKdQACnoJGWkd4asH+096SJ-gjEvsnjmRX6Dmc6dpA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+bK7J7_EKdQACnoJGWkd4asH+096SJ-gjEvsnjmRX6Dmc6dpA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 16, 2011 at 04:01:57PM -0700, Tim Bird wrote:
> >Greg KH wrote:
> > To keep this all out in the open, let's figure out what to do here.
> > Consumer devices have a 1-2 year lifespan, and want and need the
> > experience of the kernel community maintaining their "base" kernel for
> > them.  There is no real "enterprise" embedded distro out there from what
> > I can see.  montaVista and WindRiver have some offerings in this area, but
> > they are not that widely used and are usually more "deep embedded".
> > There's also talk that the CELF group and Linaro are wanting to do
> > something on a "longterm" basis, and are fishing around for how to
> > properly handle this with the community to share the workload.  Android
> > also is another huge player here, upgrading their kernel every major
> > release, and they could use the support of a longterm kernel as well.
> 
> Well I certainly hope that there's more participation on sharing the
> workload by embedded companies than there has historically been.
> I'm not at LinuxCon this week, but I want to follow up with you
> (maybe at KS?) on good ways that CE companies can help with
> this effort.

There is a BOF this week at LinuxCon with the CE companies about this
topic, and I've been talking with them about this as well, so if anyone
is there and interested, we can talk about it then.

And yes, ELC/KS/LinuxCon Europe is also a good place to discuss it as
well.

> That said, I echo the concerns about version selection.  It would be
> good to have a "settle" period longer than 1 stable release for selecting
> a kernel (but then again, we don't want to wait too long to pick each
> longterm release).

I understand, and will be working on this.  I'm trying to talk to
everyone I can about their plans for support and products to try to
determine this, and will see how it goes.

> Also, the more people using a particular LTS kernel, the better. In the past
> the embedded guys didn't coordinate well enough with other parties.  If
> we could get enterprise, desktop and embedded on a single LT release, that
> would be really nice.  I'm not sure how you're keeping track of interested
> parties, but if there's a mailing list (besides 'stable') let me know so I can
> sign up.

stable is the best place for this.  Or emails/phone calls/hallway
discussions with me as well.  Note, I also have the ability to sign NDAs
if needed.

> One specific issue I have is support for PREEMPT_RT, so that's a big
> factor in selecting Sony kernel versions.  Thus, coordinating with the
> RT patchset kernel versions is important to me.  Currently
> that would mean 3.0 is a good candidate.

3.0 is looking like a good candidate, but we haven't seen 3.1 yet :)

> The other major out-of-tree patches we usually integrate are
> 1) Android

I would love to get some feedback/contacts with the Android teams to
talk about this with them.  If anyone knows anyone I should talk to
here, please let me know.

thanks,

greg k-h
