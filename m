Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113Ab2AREgG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 23:36:06 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53731 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757008Ab2AREgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 23:36:04 -0500
Date: Wed, 18 Jan 2012 12:47:18 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Dong Aisheng-B29396 <B29396@freescale.com>
Cc: Stephen Warren <swarren@nvidia.com>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "Simon Glass (sjg@chromium.org)" <sjg@chromium.org>,
        Dong Aisheng <dongas86@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: Pinmux bindings proposal
Message-ID: <20120118044716.GD563@S2101-09.ap.freescale.net>
References: <74CDBE0F657A3D45AFBB94109FB122FF17801D202F@HQMAIL01.nvidia.com>
 <7FE21149F4667147B645348EC6057885091DEA@039-SN2MPN1-013.039d.mgd.msft.net>
 <20120117082334.GA31295@S2101-09.ap.freescale.net>
 <7FE21149F4667147B645348EC6057885092D56@039-SN2MPN1-013.039d.mgd.msft.net>
 <20120117141322.GA31687@S2101-09.ap.freescale.net>
 <7FE21149F4667147B645348EC6057885093AD9@039-SN2MPN1-013.039d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7FE21149F4667147B645348EC6057885093AD9@039-SN2MPN1-013.039d.mgd.msft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 18, 2012 at 03:44:59AM +0000, Dong Aisheng-B29396 wrote:
...
> > > The real problem is do we need to support individual pin mux Or still
> > > using virtual pin group?
> > > For the way Stephen proposed, we can only support individual pin mux
> > > Since IMX pins are not grouped together in HW.
> > >
> > I do not see any problem here.  If you look at the first column of 'mux'
> > property of node pinmux-usdhc1, it is a group of pins for usdhc1.
> > Isn't it one virtual pin group for usdhc1?
> > 
> If we treat the whole pins in 'mux' property as a group,
> There may be potential inconsistent issue since Tegra will treat each
> One in the list of 'mux' as a group.
> And it would be a problem for pinctrl core to parse it in a standard way.
> 
Based on my understanding, the 'group' given by 'mux' property may be
a group of pin/group defined by hardware, or mixing of the two.

-- 
Regards,
Shawn
