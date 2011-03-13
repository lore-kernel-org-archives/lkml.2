Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932116Ab1CMQRl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 12:17:41 -0400
Received: from kroah.org ([198.145.64.141]:41494 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754299Ab1CMQRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 12:17:23 -0400
Date: Sun, 13 Mar 2011 09:15:28 -0700
From: Greg KH <greg@kroah.com>
To: andy.green@linaro.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@linaro.org
Subject: Re: [RFC PATCH 3/4] PLATFORM: Introduce async platform_data attach
 api
Message-ID: <20110313161528.GB10718@kroah.com>
References: <20110312222633.27020.19543.stgit@otae.warmcat.com>
 <201103131141.07380.rjw@sisk.pl>
 <4D7CB15A.6030203@linaro.org>
 <201103131353.54612.rjw@sisk.pl>
 <4D7CC4D0.90305@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D7CC4D0.90305@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 13, 2011 at 01:21:20PM +0000, Andy Green wrote:
> On 03/13/2011 12:53 PM, Somebody in the thread at some point said:
> 
> >>>>This _really_ should just use the device tree stuff, that is what it is
> >>>>for, please don't duplicate it here in a not-as-flexible way.
> >>>
> >>>I agree.
> >>>
> >>>@Andy: If it doesn't work for you for some reason, please let us know the
> >>>usage case that is not covered (in detail).
> >>
> >>The device tree stuff does not yet exist in a workable way,
> >>platform_data is established everywhere except USB bus.  Device tree
> >>brings in bootloader version as a dependency: this method doesn't.
> >
> >It is not the same device tree we are talking about. :-)
> >
> >I mean device hierarchy (and I guess Greg meant the same).
> 
> I see.  Elsewhere on the previous thread people were proposing to
> use New Shiny Device Tree, hence the confusion.

Yes, I meant the "new shiny device tree" work from Grant, who in an
earlier message, said that this could all be done using that instead of
your proposal.

thanks,

greg k-h
