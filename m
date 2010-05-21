Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758591Ab0EUUtf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 16:49:35 -0400
Received: from kroah.org ([198.145.64.141]:33528 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751534Ab0EUUte (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 16:49:34 -0400
Date: Fri, 21 May 2010 13:37:16 -0700
From: Greg KH <greg@kroah.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.35 merge window is over for USB
Message-ID: <20100521203716.GA8434@kroah.com>
References: <20100521152141.GA18603@kroah.com>
 <4BF6EC5D.6080005@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BF6EC5D.6080005@ru.mvista.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 22, 2010 at 12:26:05AM +0400, Sergei Shtylyov wrote:
> Hello.
> 
> Greg KH wrote:
> 
> >Hi all,
> 
> >If you haven't noticed, all of the new features for USB are now merged
> >in Linus's tree for the .35 kernel version.  At this point in time, I'm
> >only expecting there to be minor bugfixes and new device ids for the .35
> >kernel for the USB subsystem.  Anything else, will be gladly accepted by
> >me at any time, but note that I will be queueing it up for the .36
> >kernel release.
> 
> >If anyone has any questions, please let me know.
> 
>    How about the new drivers (or new glue layers) and the
> "new-driver-can't-break-anything" rule? ;-)

Perhaps, but a glue layer does not sound very "stand alone", especially
in the musb space.

Brand new drivers would be easy to be merged, as always.

thanks,

greg k-h
