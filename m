Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934161Ab1D2XTp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 19:19:45 -0400
Received: from kroah.org ([198.145.64.141]:55289 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934102Ab1D2XTf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 19:19:35 -0400
Date: Fri, 29 Apr 2011 16:19:17 -0700
From: Greg KH <greg@kroah.com>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Allow setting of number of raw devices as a module parameter
Message-ID: <20110429231917.GA24588@kroah.com>
References: <1304029469-19672-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304029469-19672-1-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 29, 2011 at 12:24:29AM +0200, Jan Kara wrote:
> Allow setting of maximal number of raw devices as a module parameter. This
> requires changing of static array into a vmalloced one (the array is going to
> be too large for kmalloc).
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> 
> ---
>  drivers/char/Kconfig |    2 +-
>  drivers/char/raw.c   |   33 +++++++++++++++++++++++++++------
>  2 files changed, 28 insertions(+), 7 deletions(-)
> 
>   We are carrying this patch in SUSE kernels for a few years already (some
> customer requested this feature). Can it be merged upstream? I'm not sure
> who'd be the right maintainer though...

I've touched the raw driver a number of times over the years. I tried to
get rid of it in the past, and was told that it had to stay.

So, as the driver isn't going anywhere any year soon we should apply
this patch, I'll queue it up and take it through my tree unless someone
strongly objects?

thanks,

greg k-h
