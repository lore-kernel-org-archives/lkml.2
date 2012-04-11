Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965582Ab2DKXql (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:46:41 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:34083 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965177Ab2DKXqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:46:36 -0400
Date: Wed, 11 Apr 2012 16:46:32 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, mingo@elte.hu,
        linux-kernel@vger.kernel.org, Jonathan Cameron <jic23@kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
Subject: Re: [PATCH RESEND] x86, intel_mid: ADC management
Message-ID: <20120411234632.GA11113@kroah.com>
References: <20120410140749.GL7499@opensource.wolfsonmicro.com>
 <20120410151529.5bcc5ce6@pyramind.ukuu.org.uk>
 <20120410151943.GM7499@opensource.wolfsonmicro.com>
 <20120410175632.5c11c36e@pyramind.ukuu.org.uk>
 <20120410175846.GQ7499@opensource.wolfsonmicro.com>
 <4F848C7C.5040703@cam.ac.uk>
 <20120410223722.GY7499@opensource.wolfsonmicro.com>
 <e65fbfb8-1169-46dc-aad9-1dc9dbb91e8f@email.android.com>
 <20120411153811.GA28101@kroah.com>
 <43cfe506-e7ca-44f6-8225-1476e7a88003@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43cfe506-e7ca-44f6-8225-1476e7a88003@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 05:30:47PM +0100, Jonathan Cameron wrote:
> >Anyway, all I care about to get this code out of staging is that you
> >feel your userspace api is "sane" and not going to change.  Your
> >in-kernel stuff can radically change every kernel release with no
> >objection from me at all.
> >
> >And from what I can tell, your userspace stuff looks pretty stable now,
> >right?  So, I don't mind moving this all out of staging for 3.5 as-is.
> 
> There are corners of the userspace abi that aren't but they aren't
> related to the core so we can break the abi docs in two and just move
> the good stuff...

Ok, that sounds like a good first step.

> >If so, I'll be glad to make the change to my repo so it starts to show
> >up in linux-next in the "correct" place whenever you want me to.
> 
> Will clear current queue under review then that would be great.
> 
> Note we will need to leave a lot of drivers in staging for now so move
> may require a few sed scripts to link up headers etc...  quite a lot
> of drivers are way off.

Why would some drivers stay?  It should only be because of the userspace
api, not because they don't work properly, that's never stopped drivers
from entering the main part of the kernel before :)

> Lets start a fresh thread on the move to make sure everyone agrees on
> what is ready!

Sounds good.

greg k-h
