Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760138Ab1EOQ2j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 12:28:39 -0400
Received: from kroah.org ([198.145.64.141]:38830 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760043Ab1EOQ2i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 12:28:38 -0400
Date: Sun, 15 May 2011 09:29:50 -0700
From: Greg KH <greg@kroah.com>
To: Chris Frey <cdfrey@foursquare.net>
Cc: matt mooney <mfmooney@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/14] staging: usbip: add userspace code
Message-ID: <20110515162950.GD1315@kroah.com>
References: <cover.1305369175.git.mfm@muteddisk.com>
 <7dce7775af890105a685b67408f38fbef99cbdfe.1305369176.git.mfm@muteddisk.com>
 <20110515034608.GA8484@foursquare.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110515034608.GA8484@foursquare.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 14, 2011 at 11:46:08PM -0400, Chris Frey wrote:
> On Sat, May 14, 2011 at 03:55:07AM -0700, matt mooney wrote:
> > +0fca  Research In Motion, Ltd.
> > +	0001  Blackberry Handheld
> 
> For Barry, we recognize the following product ID's under the RIM Vendor ID:
> 
> 	0001	The original ID, sometimes we call it Classic
> 	0004	The old Pearl dual-endpoint mode.  Had both Mass Storage
> 		and Database endpoints
> 	0006	Pearl in database-only endpoint mode
> 	8001	The 8200 series Pearl Flip
> 	8004	The 8120 Pearl (and some other new models I think)
> 	8007	The Storm

Are these in the "real" usb.ids file?  If not, care to enter them in on
the linux-usb.org site so we can sync up there?

This file will be removed from the in-kernel tree as soon as possible,
it's just there as part of the original import of the usbip userspace
tools.  No one should ever have to have 2 copies of this file on their
system, that's madness.

thanks,

greg k-h
