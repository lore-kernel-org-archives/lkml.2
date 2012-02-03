Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756952Ab2BCQiU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 11:38:20 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:58069 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756875Ab2BCQiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 11:38:15 -0500
Date: Fri, 3 Feb 2012 17:38:07 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Vinod Koul <vinod.koul@intel.com>
cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        linux-mmc@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-serial@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 1/7 v2] dmaengine: add a simple dma library
In-Reply-To: <1328074726.1610.1.camel@vkoul-udesk3>
Message-ID: <Pine.LNX.4.64.1202031736090.6211@axis700.grange>
References: <1327589784-4287-1-git-send-email-g.liakhovetski@gmx.de> 
 <1327589784-4287-2-git-send-email-g.liakhovetski@gmx.de> 
 <1327912346.1527.13.camel@vkoul-udesk3>  <Pine.LNX.4.64.1201300944360.7932@axis700.grange>
  <1327992090.1527.116.camel@vkoul-udesk3>  <Pine.LNX.4.64.1201310746470.31226@axis700.grange>
 <1328074726.1610.1.camel@vkoul-udesk3>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:4WZ8KaDjo33NzPRQR/746HQOKBcK4I1n2z5u23RCnv9
 XGxSH5YTcJvnhSYjXZ+T/GjRRsPKjuIYp4fCeMgSYNWcTFcgHm
 Ox52oZ8zSNumF46/5RP5oBb38Zt1+m1N4Y68zpq6omVg//v2GX
 mac0Z0gGwo9p8Mzlpqc5AotOH8l+hc8f8aYu1XhR7IJso2YFRK
 PCOpjXFWACqJxPcaXyD16kHP0asymmC9NWvANYUKfMg4YoMuWS
 PIAztJ1z2qkMOaz7h6fLAJNb8C358YW0umGDlUtjYFdo1JyYRl
 p+G0yCTAWC8uTcKN7KW2WKnitOvWymGDmIE+HvPUIrVDjOK7MX
 /QXwTfTaWNKycJFDP3eZ/YzNG1118U2kbUbRUEljNDam86GoaI
 fmEWFuMVK9aaw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vinod

On Wed, 1 Feb 2012, Vinod Koul wrote:

> On Tue, 2012-01-31 at 09:59 +0100, Guennadi Liakhovetski wrote:
> > Hi Vinod
> > 
> > Thanks for your reply.
> > 
> > On Tue, 31 Jan 2012, Vinod Koul wrote:
> > 
> > > On Mon, 2012-01-30 at 10:34 +0100, Guennadi Liakhovetski wrote:

[snip]

> > > > How would you like to do this? Don't you think, it would be good to allow 
> > > > both: either implement a dmaengine driver directly, exactly as all drivers 
> > > > are doing now, or use the additional helper library for suitable (simple) 
> > > > hardware types? I see it similar to I2C, where you either implement an I2C 
> > > > driver directly, or you use the bitbanging abstraction for simpler 
> > > > hardware.
> > > I think it would be good to have both, this can be used by folks who
> > > don't have sg support available.
> > 
> > Ok, so, should I just rename the driver to sgsoft? Is this the only 
> > change, that you'd like to see?
> That would be one :)
> Also, I would review the other patch patches by today/tomorrow, you can
> add any changes in next version as well

Do I understand it right, that I'm waiting for your review before 
submitting the next version?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
