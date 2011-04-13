Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757342Ab1DMKB7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 06:01:59 -0400
Received: from gra-lx1.iram.es ([150.214.224.41]:46490 "EHLO gra-lx1.iram.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755434Ab1DMKB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 06:01:57 -0400
Date: Wed, 13 Apr 2011 12:01:51 +0200
From: Gabriel Paubert <paubert@iram.es>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>,
        Greg KH <greg@kroah.com>, linuxppc-dev@lists.ozlabs.org,
        dri-devel@lists.freedesktop.org, LKML <linux-kernel@vger.kernel.org>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Dave Airlie <airlied@gmail.com>
Subject: Re: Revert 737a3bb9416ce2a7c7a4170852473a4fcc9c67e8 ?
Message-ID: <20110413100151.GA3066@iram.es>
References: <20110406204327.GA11148@iram.es> <1302185075.24704.143.camel@thor.local> <20110411133128.GA24344@iram.es> <1302535963.24704.268.camel@thor.local> <20110412113033.GA16649@iram.es> <1302608770.27054.36.camel@thor.local> <20110412120055.GA7995@iram.es> <1302629362.15520.25.camel@thor.local> <20110413075943.GA27996@iram.es> <1302682573.28876.78.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302682573.28876.78.camel@pasglop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 06:16:13PM +1000, Benjamin Herrenschmidt wrote:
> On Wed, 2011-04-13 at 09:59 +0200, Gabriel Paubert wrote:
> > 
> > Well, X is dead, or rather in an infinite ioctl loop as described
> > above.
> > IIRC, the display enters a power-down mode and there is nothing to
> > see.
> 
> So basically the card crashed. There's about an infinite amount of
> reasons why radeons do so, sometimes it has to do with them not liking
> what you ate that day...
> 
> The only thing I can see that could be of use would be a bisect

Bisecting for something which I have never got to work (radeon with
KMS) on this machine is something I don't know how to do...

Note that radeon without KMS also always ends up crashing, but it
may take hours. The only case where the machine works reliably is 
when glxinfo claims that it is using software rendering.
 
	Regards,
	Gabriel
