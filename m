Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab0DUWht (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 18:37:49 -0400
Received: from kroah.org ([198.145.64.141]:40828 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753362Ab0DUWhf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 18:37:35 -0400
Date: Wed, 21 Apr 2010 15:37:09 -0700
From: Greg KH <greg@kroah.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Stefan Bader <stefan.bader@canonical.com>, pingc@wacom.com,
       stable-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
       Anton@anikin.name, stable@kernel.org
Subject: Re: [stable] patch
 input-wacom-switch-mode-upon-system-resume.patch added to 2.6.33-stable
 tree
Message-ID: <20100421223709.GA27829@kroah.com>
References: <1271697023113@kroah.org>
 <201004191024.43397.dmitry.torokhov@gmail.com>
 <20100419172856.GA6965@suse.de>
 <4BCE34CC.9030506@canonical.com>
 <20100421053958.GB4364@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100421053958.GB4364@core.coreip.homeip.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 20, 2010 at 10:39:58PM -0700, Dmitry Torokhov wrote:
> On Tue, Apr 20, 2010 at 04:12:12PM -0700, Stefan Bader wrote:
> > Greg KH wrote:
> > > On Mon, Apr 19, 2010 at 10:24:41AM -0700, Dmitry Torokhov wrote:
> > >> Greg,
> > >>
> > >> On Monday 19 April 2010 10:10:23 am gregkh@suse.de wrote:
> > >>> This is a note to let you know that we have just queued up the patch titled
> > >>>
> > >>>     Subject: Input: wacom - switch mode upon system resume
> > >>>
> > >>> to the 2.6.33-stable tree.  Its filename is
> > >>>
> > >>>     input-wacom-switch-mode-upon-system-resume.patch
> > >>>
> > >> Could you add this to .32 as well, please?
> > > 
> > > I looked, and it didn't seem to apply at all.  Can someone backport it
> > > to .32 and I will be glad to apply it.
> > > 
> > 
> > That would be my backport for .32, maybe Ping or Dmitry can sanity check.
> > 
> 
> Yep, that exactly what Ping sent earlier, but since she favors wierd
> mailers with HTML I guess her patch was dropped by vger filters ;)

Yes, thanks, but I got Ping's email first, and I just applied her
version.

thanks,

greg k-h
