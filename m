Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759365Ab2DKPia (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 11:38:30 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:46013 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758973Ab2DKPiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 11:38:15 -0400
Date: Wed, 11 Apr 2012 08:38:11 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, mingo@elte.hu,
        linux-kernel@vger.kernel.org, Jonathan Cameron <jic23@kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
Subject: Re: [PATCH RESEND] x86, intel_mid: ADC management
Message-ID: <20120411153811.GA28101@kroah.com>
References: <20120410133339.GK7499@opensource.wolfsonmicro.com>
 <20120410144235.1e05efd4@pyramind.ukuu.org.uk>
 <20120410140749.GL7499@opensource.wolfsonmicro.com>
 <20120410151529.5bcc5ce6@pyramind.ukuu.org.uk>
 <20120410151943.GM7499@opensource.wolfsonmicro.com>
 <20120410175632.5c11c36e@pyramind.ukuu.org.uk>
 <20120410175846.GQ7499@opensource.wolfsonmicro.com>
 <4F848C7C.5040703@cam.ac.uk>
 <20120410223722.GY7499@opensource.wolfsonmicro.com>
 <e65fbfb8-1169-46dc-aad9-1dc9dbb91e8f@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e65fbfb8-1169-46dc-aad9-1dc9dbb91e8f@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 07:19:01AM +0100, Jonathan Cameron wrote:
> 
> 
> Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:
> 
> >On Tue, Apr 10, 2012 at 08:39:40PM +0100, Jonathan Cameron wrote:
> >
> >> 1)  Review of code.  This is crucial. If people have a little time
> >> ripping holes in the core IIO code is what we need.  Arnd did a good
> >job
> >> of this a while back. Others have done bits of it since.
> >
> >> 2) Getting the push code tidied up and pushed out.  I'll post it as
> >an
> >> updated rfc to linux-iio shortly.  All I had left that definitely
> >> wanted doing here was cleaning up the example iio to input bridge
> >> driver.  That can happen later.
> >
> >For these two can we refactor in place?  That's pretty much what seems
> >to have been happening anyway...
> >
> I guess it comes down to whether Linus will pull.  2 should be there
> within a week or so anyway depending mostly on analog testing I
> haven't broken any of their drivers.

Hm, shouldn't I be the one that moves this out of staging?  :)

Anyway, all I care about to get this code out of staging is that you
feel your userspace api is "sane" and not going to change.  Your
in-kernel stuff can radically change every kernel release with no
objection from me at all.

And from what I can tell, your userspace stuff looks pretty stable now,
right?  So, I don't mind moving this all out of staging for 3.5 as-is.

If so, I'll be glad to make the change to my repo so it starts to show
up in linux-next in the "correct" place whenever you want me to.

thanks,

greg k-h
