Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091Ab1CCQFV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 11:05:21 -0500
Received: from kroah.org ([198.145.64.141]:39146 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754244Ab1CCQFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 11:05:20 -0500
Date: Thu, 3 Mar 2011 08:02:09 -0800
From: Greg KH <greg@kroah.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Anand Gadiyar <gadiyar@ti.com>,
        Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        Keshava Munegowda <keshava_mgowda@ti.com>
Subject: Re: linux-next: manual merge of the usb tree with the omap tree
Message-ID: <20110303160209.GB13709@kroah.com>
References: <20110302165755.b45124c8.sfr@canb.auug.org.au>
 <20110303084829.GB2644@legolas.emea.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110303084829.GB2644@legolas.emea.dhcp.ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 03, 2011 at 10:48:29AM +0200, Felipe Balbi wrote:
> On Wed, Mar 02, 2011 at 04:57:55PM +1100, Stephen Rothwell wrote:
> > Hi Greg,
> > 
> > Today's linux-next merge of the usb tree got a conflict in
> > arch/arm/mach-omap2/board-4430sdp.c between commit
> > 1dbea0f5e23b6c647db72fa4a048cb7140625e13 ("arm: omap4: 4430sdp: drop ehci
> > support") from the omap tree and commit
> > 181b250cf53233a7a7c6d7e1e9df402506712e93 ("arm: omap: usb: create common
> > enums and structures for ehci and ohci") from the usb tree.
> > 
> > The former removed the code modified by the latter, so I did that.
> 
> This can be fixed if Greg applies this patch:
> 
> commit 076bfacd5bba0f2e419474488c8f8c060c7799d8
> Author: Anand Gadiyar <gadiyar@ti.com>
> Date:   Wed Feb 16 16:47:19 2011 +0530

Care to provide it to me in a format that I can apply it?  :)

thanks,

greg k-h
