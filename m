Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760559Ab0FQRww (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 13:52:52 -0400
Received: from kroah.org ([198.145.64.141]:48814 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760534Ab0FQRwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 13:52:45 -0400
Date: Thu, 17 Jun 2010 10:52:21 -0700
From: Greg KH <greg@kroah.com>
To: Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: linux-usb@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Xiaofan Chen <xiaofanc@gmail.com>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCHv5 00/11] g_multi & other improvements and cleanpus
Message-ID: <20100617175221.GE3644@kroah.com>
References: <20100615185527.GA22803@kroah.com>
 <cover.1276681840.git.m.nazarewicz@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1276681840.git.m.nazarewicz@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 16, 2010 at 12:07:55PM +0200, Michal Nazarewicz wrote:
> On Tue, 15 Jun 2010 20:55:27 +0200, Greg KH <greg@kroah.com> wrote:
> > Can you resend this the 5th time so I know I have all of the proper
> > versions?
> 
> As requested resending the whole patchset again.
> 
> 
> Compared to the previous comments in RNDIS and CDC ACM INF files have
> been updated (the RNDIS fix was previously sent as v4.1 but this
> patchset includes a bit updated version) and a little fix to patch 01
> has been applied (already sent as version v4.1).
> 
> The g_multi "more configuration" and install mode has been exluded
> from this patches -- they weren't ment for inclusien in the kernel in
> th elast patchset (just to show them), so no point in including here
> (if aynone interested refer to v4 patches 10/13 and 13/13).
> 
> 
> I wasn't sure 100% sure what wording to use in the CDC ACM INF file so
> I put something that is likely to be true and safe. ;) I posted
> on m.p.d.d.d and contactec Microchip so maybe there will be some more
> info.

I've applied the first 5 patches, as I had a question about the 6th one,
and David doesn't seem happy with the 7th.

Care to resolve those issues and just resend the remaining?

thanks,

greg k-h
