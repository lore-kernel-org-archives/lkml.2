Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760Ab1EWTIc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 15:08:32 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:43559 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756212Ab1EWTIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 15:08:31 -0400
X-Sasl-enc: QFOqjavWkWfZyKvtOAizvqX4KgoWejjwBVsKElyKvjxn 1306177710
Date: Mon, 23 May 2011 12:09:26 -0700
From: Greg KH <greg@kroah.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        torvalds <torvalds@linux-foundation.org>,
        Vikram Narayanan <vikram186@gmail.com>
Subject: Re: [PATCH 5/5] Documentation: update GregKH links
Message-ID: <20110523190926.GA18092@kroah.com>
References: <20110523115542.dcf23f5d.randy.dunlap@oracle.com>
 <20110523120125.2d15da7e.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110523120125.2d15da7e.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 12:01:25PM -0700, Randy Dunlap wrote:
> From: Vikram Narayanan <vikram186@gmail.com>
> 
> Fixed the broken links in the SubmittingPatches file.
> 
> Signed-off-by: Vikram Narayanan <vikram186@gmail.com>
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
> ---
>  Documentation/SubmittingPatches |    9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> --- linux-2.6.39-git6.orig/Documentation/SubmittingPatches
> +++ linux-2.6.39-git6/Documentation/SubmittingPatches
> @@ -714,10 +714,11 @@ Jeff Garzik, "Linux kernel patch submiss
>    <http://linux.yyz.us/patch-format.html>
>  
>  Greg Kroah-Hartman, "How to piss off a kernel subsystem maintainer".
> -  <http://www.kroah.com/log/2005/03/31/>
> -  <http://www.kroah.com/log/2005/07/08/>
> -  <http://www.kroah.com/log/2005/10/19/>
> -  <http://www.kroah.com/log/2006/01/11/>
> +  <http://www.kroah.com/log/linux/maintainer.html>
> +  <http://www.kroah.com/log/linux/maintainer-02.html>
> +  <http://www.kroah.com/log/linux/maintainer-03.html>
> +  <http://www.kroah.com/log/linux/maintainer-04.html>
> +  <http://www.kroah.com/log/linux/maintainer-05.html>
>  

I have no real objection to this, but the original links are not broken
at all, and still work just fine for me here, don't they for you as
well?

So why are they being changed?

confused,

greg k-h
