Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932297Ab0D1XIT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 19:08:19 -0400
Received: from kroah.org ([198.145.64.141]:51642 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752470Ab0D1XIR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 19:08:17 -0400
Date: Wed, 28 Apr 2010 15:50:10 -0700
From: Greg KH <greg@kroah.com>
To: Lars Lindley <lindley@coyote.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, greg KH <gregkh@suse.de>,
       Pavel Machek <pavel@ucw.cz>, devel@driverdev.osuosl.org,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: winbond: localpara.h whitespace and
 indentation fixes.
Message-ID: <20100428225010.GC24604@kroah.com>
References: <1268727716-20422-1-git-send-email-lindley@coyote.org>
 <4BA25348.1080308@cs.helsinki.fi>
 <4BA2B0AB.4070607@coyote.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA2B0AB.4070607@coyote.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 19, 2010 at 12:00:59AM +0100, Lars Lindley wrote:
> On 2010-03-18 17:22, Pekka Enberg wrote:
> > Lars Lindley wrote:
> >> +/* refer Bitmap2RateValue table */
> >> +#define LOCAL_ALL_SUPPORTED_RATES_BITMAP    0x130c1a66 /*
> >> +                                * the bitmap value
> >> +                                * of all the H/W
> >> +                                * supported rates:
> >> +                                * 1, 2, 5.5, 11,
> >> +                                * 6, 9, 12, 18,
> >> +                                * 24, 36, 48, 54
> >> +                                */
> > 
> > The comments look funny. You might want to move them above the #defines.
> >
> >> +    u8    region;        /* real region setting of the device */
> >> +    u8    Reserved_1[2];
> >> +
> >> +/* power-save variables */
> > 
> > I think this wants to be moved one indentation level to the right.
> > 
> Ok here's a patch that applies over the old one to fix this..
> Hope it looks all right.. :)

Can you merge the two of them together and resend?

thanks,

greg k-h
