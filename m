Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932366Ab0D1XIX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 19:08:23 -0400
Received: from kroah.org ([198.145.64.141]:51660 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932309Ab0D1XIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 19:08:19 -0400
Date: Wed, 28 Apr 2010 15:57:47 -0700
From: Greg KH <greg@kroah.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Lars Lindley <lindley@coyote.org>, Pavel Machek <pavel@ucw.cz>,
       gregkh@suse.de, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: winbond: mlmetxrx.c Coding style fixes.
Message-ID: <20100428225747.GF24604@kroah.com>
References: <1269018531-18891-1-git-send-email-lindley@coyote.org>
 <20100320001048.GA1477@ucw.cz>
 <4BA4829D.3060600@coyote.org>
 <4BA61437.5080303@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA61437.5080303@cs.helsinki.fi>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 21, 2010 at 02:42:31PM +0200, Pekka Enberg wrote:
> Lars Lindley wrote:
> >[PATCH] staging: winbond: mlmetxrx.c func. argument name change.
> >
> >I changed some function argument names to make them more readable.
> >
> >Signed-off-by: Lars Lindley <lindley@coyote.org>
> 
> I'd much rather see a new version of the patch that squashes the fixlet but:
> 
> Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>a

Yes, can you merge both of these together into one patch?

thanks,

greg k-h
