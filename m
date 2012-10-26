Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757170Ab2JZRRK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 13:17:10 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:61717 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756440Ab2JZRRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 13:17:06 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/BZ1nHUQPosPAVNn4rWeoR
Date: Fri, 26 Oct 2012 10:16:55 -0700
From: Tony Lindgren <tony@atomide.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>, linux@arm.linux.org.uk,
        b-cousson@ti.com, arnd@arndb.de, olof@lixom.net, rdunlap@xenotime.net,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] drivers: bus: ocp2scp: add pdata support
Message-ID: <20121026171655.GI11908@atomide.com>
References: <1349675983-23803-1-git-send-email-kishon@ti.com>
 <1349675983-23803-2-git-send-email-kishon@ti.com>
 <20121016165043.GS15569@atomide.com>
 <20121025004806.GK11928@atomide.com>
 <20121025061722.GB4449@arwen.pp.htv.fi>
 <20121025174446.GT11928@atomide.com>
 <20121026064736.GA22206@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121026064736.GA22206@arwen.pp.htv.fi>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Felipe Balbi <balbi@ti.com> [121025 23:55]:
> On Thu, Oct 25, 2012 at 10:44:47AM -0700, Tony Lindgren wrote:
> > * Felipe Balbi <balbi@ti.com> [121024 23:24]:
> > > Hi,
> > > 
> > > On Wed, Oct 24, 2012 at 05:48:07PM -0700, Tony Lindgren wrote:
> > > > * Tony Lindgren <tony@atomide.com> [121016 09:53]:
> > > > > * Kishon Vijay Abraham I <kishon@ti.com> [121007 23:01]:
> > > > > > ocp2scp was not having pdata support which makes *musb* fail for non-dt
> > > > > > boot in OMAP platform. The pdata will have information about the devices
> > > > > > that is connected to ocp2scp. ocp2scp driver will now make use of this
> > > > > > information to create the devices that is attached to ocp2scp.
> > > > > > 
> > > > > > Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> > > > > 
> > > > > This fixes the regression on my panda es for musb port:
> > > > > 
> > > > > Acked-by: Tony Lindgren <tony@atomide.com>
> > > > 
> > > > Looks like nobody has picked this one up and we need it to
> > > > fix the musb regression on omap, so I'll queue these up.
> > > 
> > > I don't seem to have the patches around in any mailbox :-(
> > 
> > Bounced them to you. Do you have any better ideas for the
> > -rc cycle to fix the MUSB regression on omap4?
> 
> Well, there are two regressions that I know of. One is caused by the
> mode1 DMA changes, which I'll just revert, and the other is the
> missing platform_data support on the new PHY driver which these patches
> are supposed to solve, right ?

Yes that's it AFAIK.

Regards,

Tony
