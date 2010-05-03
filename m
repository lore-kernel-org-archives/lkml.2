Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275Ab0ECTLh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 15:11:37 -0400
Received: from kroah.org ([198.145.64.141]:49347 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756158Ab0ECTLg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 15:11:36 -0400
Date: Mon, 3 May 2010 11:47:03 -0700
From: Greg KH <greg@kroah.com>
To: Lars Lindley <lindley@coyote.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Pavel Machek <pavel@ucw.cz>,
       gregkh@suse.de, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: winbond: mlmetxrx.c Coding style fixes.
Message-ID: <20100503184703.GC10778@kroah.com>
References: <1269018531-18891-1-git-send-email-lindley@coyote.org>
 <20100320001048.GA1477@ucw.cz>
 <4BA4829D.3060600@coyote.org>
 <4BA61437.5080303@cs.helsinki.fi>
 <20100428225747.GF24604@kroah.com>
 <4BDD3A62.3070502@coyote.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BDD3A62.3070502@coyote.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 02, 2010 at 10:40:02AM +0200, Lars Lindley wrote:
> 
> 
> On 2010-04-29 00:57, Greg KH wrote:
> > On Sun, Mar 21, 2010 at 02:42:31PM +0200, Pekka Enberg wrote:
> >> Lars Lindley wrote:
> >>> [PATCH] staging: winbond: mlmetxrx.c func. argument name change.
> >>>
> >>> I changed some function argument names to make them more readable.
> >>>
> >>> Signed-off-by: Lars Lindley <lindley@coyote.org>
> >>
> >> I'd much rather see a new version of the patch that squashes the fixlet but:
> >>
> >> Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>a
> > 
> > Yes, can you merge both of these together into one patch?
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> 
> OK, same thing here. Rebase doesnt work for med but here's a diff of mlmetxrx.c that includes
> both patches.

This didn't apply to the linux-next tree :(

thanks,

greg k-h
