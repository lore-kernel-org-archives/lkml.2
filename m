Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309Ab1HIDlm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 23:41:42 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:52227 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752144Ab1HIDlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 23:41:40 -0400
X-Sasl-enc: JjZGgAtZB/gljwZMiv0cqI2MihRBI7YtPgqG0FuskmZf 1312861299
Date: Mon, 8 Aug 2011 20:39:19 -0700
From: Greg KH <greg@kroah.com>
To: Andreas Hartmann <andihartmann@01019freenet.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux 3.0: broken ums_eneub6250
Message-ID: <20110809033919.GB13283@kroah.com>
References: <hjXX6-Ee-55@gated-at.bofh.it>
 <hk6nE-6kT-5@gated-at.bofh.it>
 <hk7Wq-mZ-1@gated-at.bofh.it>
 <j1mm4l$55a$1@ID-44327.news.uni-berlin.de>
 <20110808042231.GA6248@kroah.com>
 <4E3F9B71.7040206@01019freenet.de>
 <20110808153302.GA8637@kroah.com>
 <4E403837.6040902@01019freenet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E403837.6040902@01019freenet.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 08, 2011 at 09:25:43PM +0200, Andreas Hartmann wrote:
> Greg KH schrieb:
> > On Mon, Aug 08, 2011 at 10:16:49AM +0200, Andreas Hartmann wrote:
> >> Greg KH schrieb:
> >>> On Sun, Aug 07, 2011 at 08:39:20PM +0200, Andreas Hartmann wrote:
> >>>> Hi,
> >>>>
> >>>> obviously, nobody seems to be interested to work on this bug. Until it's
> >>>> fixed: There is a workaround to get the device working again with 2.6.39
> >>>> and 3.0 - just remove the unusable ums-eneub6250.ko and replace it with
> >>>> the complete old and fine keucr-module - staging but working :-)
> >>>>
> >>>> https://bugzilla.novell.com/show_bug.cgi?id=709243#c1
> >>>
> >>> How about working on a patch for the in-kernel version of the code to
> >>> get it to work properly so we can resolve this?
> >>
> >> If I would be able do this, I would have done it! On the other side: Why
> >> should I do it, if there is a module, which works just fine?
> > 
> > Because I'm guessing that you wish to see the in-kernel code work
> > properly, right?
> > 
> >> But you could send me patches which I could test.
> > 
> > Have you emailed the developers of this driver these questions?  I'm
> > sure they could help you out as they do have the hardware and they wrote
> > the patches in the first place.
> > 
> >>>  Given that very few
> >>> people actually have this hardware,
> >>
> >> It's a MSI CR620 notebook. I don't think, that there are just very few
> >> out there :-).
> >>
> >>> it's hard for us to work on the
> >>> driver.
> >>
> >> Why did you remove a working module if you can't ensure, that the
> >> replacement will cover the old module 100%?
> > 
> > Because I trusted the original developers of that patch, that's the way
> > kernel development works.
> > 
> > So please contact them and they would be glad to work with you to
> > resolve this issue.
> 
> They have been already connected prior in this thread. I didn't get any
> answer right now.
> 
> Obviously they are not interested in fixing the problem.

That's rude, perhaps they were busy, or, the driver works for them on
their hardware, but something is different with your device that is
different here.

good luck,

greg k-h
