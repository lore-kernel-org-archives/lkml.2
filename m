Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552Ab0EXSuL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 14:50:11 -0400
Received: from kroah.org ([198.145.64.141]:33945 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754619Ab0EXSuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 14:50:09 -0400
Date: Mon, 24 May 2010 11:50:00 -0700
From: Greg KH <greg@kroah.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-usb@vger.kernel.org, Felipe Balbi <felipe.balbi@nokia.com>,
       Cliff Cai <cliff.cai@analog.com>, Ian Jeffray <ian@jeffray.co.uk>,
       linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       stable-review@kernel.org, stable@kernel.org
Subject: Re: [stable] [PATCH] USB: musb: fix Blackfin building after power
 updates
Message-ID: <20100524185000.GB8627@kroah.com>
References: <1274582948-11499-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274582948-11499-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 22, 2010 at 10:49:08PM -0400, Mike Frysinger wrote:
> From: Ian Jeffray <ian@jeffray.co.uk>
> 
> The new MUSB power code needs musb_read_txhubport() to return a value (so
> stub it as 0 like the other Blackfin hub funcs).  It also needs new helper
> functions for saving/restoring context, so change the apparently unused
> musb_platform_{suspend,resume} to musb_platform_{save,restore}_context in
> the Blackfin code.
> 
> Signed-off-by: Ian Jeffray <ian@jeffray.co.uk>
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---
> Note: this is for 2.6.34.x and 2.6.35
> Note: i believe this is what we want, but Cliff is free to correct me ;)
> 
>  drivers/usb/musb/blackfin.c  |   12 ++++++++++++
>  drivers/usb/musb/musb_regs.h |    3 ++-


Note, I'm refusing to take any musb patch unless it comes from Felipe
due to the constant bickering from a number of the musb developers,
which is starting to really annoy me and contemplate warming up my kill
file...

So please work with him to get this agreed apon and have him forward it
to me when ready, that's the only way I'm going to accept it.

thanks,

greg k-h
