Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756407Ab1CVRG4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 13:06:56 -0400
Received: from kroah.org ([198.145.64.141]:53679 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753602Ab1CVRGz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 13:06:55 -0400
Date: Tue, 22 Mar 2011 10:01:39 -0700
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: balbi@ti.com, Stefan Bigler <stefan.bigler@keymile.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: TTY loosing data with u_serial gadget
Message-ID: <20110322170139.GA16244@kroah.com>
References: <4D8121F6.9060600@keymile.com>
 <20110317000408.GA18911@kroah.com>
 <4D8389EC.5030704@keymile.com>
 <20110318170801.GA2857@legolas.emea.dhcp.ti.com>
 <20110318180657.11570887@lxorguk.ukuu.org.uk>
 <20110321093255.GE1837@legolas.emea.dhcp.ti.com>
 <20110322085344.GN1837@legolas.emea.dhcp.ti.com>
 <20110322110412.3d374b48@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110322110412.3d374b48@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 11:04:12AM +0000, Alan Cox wrote:
> > Patch attached, please give it a good round of test as I don't have how
> > to exercise all line disciplines. I ran 100 randconfigs over night and
> > no warnings or erros on that area, at least not that I could see (so
> > many warning while compiling the kernel :-( )
> 
> n_tty is I believe the only ldisc which assets throttling - the others
> actually prefer to lose data on an overflow not get further blockages.
> 
> 
> Greg - can we get this into -next once -rc1 is out and see who screams ?

Yes, I will do that.

thanks,

greg k-h
