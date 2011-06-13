Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448Ab1FMX47 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 19:56:59 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:37412 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755397Ab1FMX45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 19:56:57 -0400
X-Sasl-enc: iY8895B4gejfJ/qonDoSe5bjdh765zjdrXDSDm2/N262 1308009416
Date: Mon, 13 Jun 2011 16:55:49 -0700
From: Greg KH <greg@kroah.com>
To: Jason Stubbs <jasonbstubbs@gmail.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] platform: fix samsung brightness min/max calculations
Message-ID: <20110613235549.GA14762@kroah.com>
References: <201104201358.50443.jasonbstubbs@gmail.com>
 <201105121214.00015.jasonbstubbs@gmail.com>
 <20110512164402.GD26585@kroah.com>
 <201105132044.25928.jasonbstubbs@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201105132044.25928.jasonbstubbs@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 08:44:25PM +1000, Jason Stubbs wrote:
> On Fri, 13 May 2011 02:44:02 Greg KH wrote:
> > On Thu, May 12, 2011 at 12:13:59PM +1000, Jason Stubbs wrote:
> > > On Wed, 11 May 2011 23:51:14 Greg KH wrote:
> > > > On Wed, May 11, 2011 at 02:47:49PM +1000, Jason Stubbs wrote:
> > > > > The patch doesn't apply cleanly on top of the nc210/nc110 patch
> > > > > though as they both modify set_brightness(). It might apply with a
> > > > > higher fuzz factor as the changes don't actually clash. Should I
> > > > > redo the patch?
> > > > 
> > > > Please do.
> > > 
> > > Will send seperately. Doing this though, I found a problem with the
> > > nc210/nc110 patch in that (user_level == read_brightness()) check should
> > > actually be (user_brightness == read_brightness()). What should I do
> > > about this?
> > 
> > I don't know, as you seem to understand this better than I do at this
> > point, I'll trust your changes :)
> 
> I meant that patch A is broken but (working) patch B applies on top of patch
> A so should I submit a patch C to fix patch A, submit a fixed patch A and
> then resubmit a patch B against that, or... I'm just unsure of the
> development process.
> 
> As far as I can tell, the patches aren't applied to any trees yet and are
> just sitting in .../gregkh/patches.git. If that's the case, what I would like
> is for fix-samsung-brightness-min-max-calculations.patch to be replaced with
> the version in https://lkml.org/lkml/2011/4/20/1 and I resubmit a fixed (and
> enhanced) add-support-for-samsung-nc210-nc110.patch that applies on top of
> it. That way an enhancement patch won't hold up a bugfix patch should there
> be any further issues.

Ok, I'll drop this one, but can you resend the above referenced patch so
I can apply it?

I'll also update your last patch you sent as well.

Sorry for the delay in working on this, my access to a samsung laptop is
now gone, and I've been swamped with other stuff.

Any chance you want to take over maintaining this driver now yourself?
You seem to have a much better understanding of it in places than I do
at the moment, combined with a strong need to keep it working properly
:)

thanks,

greg k-h
