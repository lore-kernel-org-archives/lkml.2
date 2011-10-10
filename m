Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723Ab1JJRho (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 13:37:44 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:39131 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750893Ab1JJRhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 13:37:42 -0400
X-Sasl-enc: 465rUFdPCXEe6TaGAfWYAVbPq4wruu568PkEAbfOTw4M 1318268261
Date: Mon, 10 Oct 2011 10:16:45 -0700
From: Greg KH <greg@kroah.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Nazarewicz <mina86@mina86.com>
Subject: Re: [PATCH -next] usb gadget: fix langwell_udc.c build error
Message-ID: <20111010171645.GA24628@kroah.com>
References: <20111007174230.702f4a0bf1fe71dab5e10961@canb.auug.org.au>
 <4E8F67C6.5020603@xenotime.net>
 <20111008100326.GA24633@legolas.emea.dhcp.ti.com>
 <4E91DF00.8060107@xenotime.net>
 <20111009223638.GA29776@legolas.emea.dhcp.ti.com>
 <4E9228CA.1060904@xenotime.net>
 <20111010050959.GA30935@legolas.emea.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111010050959.GA30935@legolas.emea.dhcp.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 10, 2011 at 08:10:01AM +0300, Felipe Balbi wrote:
> Hi,
> 
> On Sun, Oct 09, 2011 at 04:05:46PM -0700, Randy Dunlap wrote:
> > On 10/09/11 15:36, Felipe Balbi wrote:
> > > git log --pretty=oneline -S'lpm_device_speed' HEAD --	\
> > > 	drivers/usb/gadget/langwell_udc.c
> > 
> > e538dfdae85244fd2c4231725d82cc1f1bc4942c usb: Provide usb_speed_string() function
> 
> Aha, now I know why, that went straight througth Greg.
> 
> Greg, can you pick this patch ? It's clearly needed. Meanwhile, I'll
> cherry-pick that commit from your tree and apply Randy's fix too.
> 
> Here's my ack for $SUBJECT:
> 
> Acked-by: Felipe Balbi <balbi@ti.com>

Um, pick what patch?

Randy, care to resend it to me with Felipe's ack?

thanks,

greg k-h
