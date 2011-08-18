Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844Ab1HRPb4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 11:31:56 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44184 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755057Ab1HRPby convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 11:31:54 -0400
From: "Gadiyar, Anand" <gadiyar@ti.com>
To: Greg KH <greg@kroah.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "Balbi, Felipe" <balbi@ti.com>, Tony Lindgren <tony@atomide.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Date: Thu, 18 Aug 2011 21:00:55 +0530
Subject: RE: [PATCH] MAINTAINERS: add myself as co-maintainer for OMAP USB
Thread-Topic: [PATCH] MAINTAINERS: add myself as co-maintainer for OMAP USB
Thread-Index: AcxduHdr3g0vJ5MRTCWoBjThxc3AmQAAksXQ
Message-ID: <ADF30F4D7BDE934D9B632CE7D5C7ACA4047C4D3ADEE8@dbde03.ent.ti.com>
References: <1313664504-956-1-git-send-email-gadiyar@ti.com>
 <20110818145507.GA7012@kroah.com>
In-Reply-To: <20110818145507.GA7012@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Thu, Aug 18, 2011 at 04:18:24PM +0530, Anand Gadiyar wrote:
> > I'd like to help co-maintain OMAP USB support. I've helped
> > out in the past when Felipe was away and would like make
> > it official.
> 
> Traditionally people are asked to be a maintainer, or they volunteer to
> take over unmaintained projects.  The only time I've see co-maintainers,
> is for larger projects, and then, it was a group decision.
> 

I was asked, by Felipe among others, to help maintain OMAP USB
support. The reason was to take some load off Felipe - I did not
take this up at that time due to other product pressures. I do
have more time on my hands now and would like to get back to
being more active in the community - I felt helping maintain
a driver was a good start.

Within TI, I've worked on debugging the EHCI, OHCI and
MUSB hardware for close to three years now and know more about
the controllers on OMAP than anyone else. I've acquired boards which
stress the several possible combinations of configurations possible
and usually help out with testing those corner cases.

> For something as "small" as musb, what is the benefit to anyone to have
> more than one maintainer?
>
> It seems to me that things are finally settling down with the recent
> musb mess, and I've been extremely happy with how Felipe has been
> handling things, and I honestly don't want to see that change at the
> moment.

It's less of MUSB, and more of the EHCI/OHCI - I don't believe
Felipe's familiar enough with the hardware to look after that.
Most contributions to the wrappers for those controllers have come
from Ajay Gupta, Keshava and me.


> So I'd stick with what we have now, unless you feel there are issues
> with how Felipe is handling things, and if so, you should take that up
> directly with him and only if that doesn't work out, me.

Nope - I'm happy with the way things are currently. So if Felipe no
longer feels the need to offload some of his maintainership work,
that's okay with me.

- Anand
