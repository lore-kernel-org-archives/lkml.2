Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545Ab1LNBVr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 20:21:47 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:45609 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753655Ab1LNBVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 20:21:46 -0500
X-Sasl-enc: wVvep6RTFjK+r6jvZxeUbJBBpTSWlNbfSBkFaOqyxef9 1323825705
Date: Tue, 13 Dec 2011 17:21:41 -0800
From: Greg KH <greg@kroah.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel@vger.kernel.org, ak@linux.intel.com, trenn@suse.de,
        davej@redhat.com
Subject: Re: [PATCH-WIP] convert CPU sysdev class to a real subsytem (needed
 for CPU modaliases)
Message-ID: <20111214012141.GA18215@kroah.com>
References: <1323309517.979.8.camel@mop>
 <20111209001145.GB9550@kroah.com>
 <CAPXgP12tds9gPKie+B6358XkhyP1K2fLFGw698-wwsuKx_bcew@mail.gmail.com>
 <1323444321.979.39.camel@mop>
 <20111209223454.GA24987@kroah.com>
 <CAPXgP11fwJ=9E-K4ZpZ-nhf-Ry9=+oX4r7F1mLchxLMmvj_8ZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPXgP11fwJ=9E-K4ZpZ-nhf-Ry9=+oX4r7F1mLchxLMmvj_8ZA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 01:50:57AM +0100, Kay Sievers wrote:
> On Fri, Dec 9, 2011 at 23:34, Greg KH <greg@kroah.com> wrote:
> > On Fri, Dec 09, 2011 at 04:25:21PM +0100, Kay Sievers wrote:
> >> Greg, would be nice, if you can take a quick look a the driver core (not
> >> the sysdev) bits in core.c, bus.c, device.h, ... and its interaction, if
> >> they look sane to you. I'll then split the driver core stuff out, so we
> >> can merge that before we port the individual drivers over.
> >
> > Yes, it looks sane to me, thanks again for doing this work.
> 
> Split-up patches are here:
>   http://git.kernel.org/?p=linux/kernel/git/kay/patches.git;a=tree
> 
> That's the size of it:
>   60 files changed, 1170 insertions(+), 1421 deletions(-)

Very nice.

> The current state and the list of the remaining non-x86 files is here:
>   http://git.kernel.org/?p=linux/kernel/git/kay/patches.git;a=blob;f=README;hb=HEAD
> 
> We need a plan now. :)

If I take those patches, none of those other ones will break their
build, right?  Or will the cpu ones?

I'll look at this tomorrow, gotta go now, I'm burnt out by badly written
staging patches that must have been created by someone who is bent on
driving me crazy.

thanks so much for doing this.

greg k-h
