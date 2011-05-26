Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758307Ab1EZSsT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 14:48:19 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:49351 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755482Ab1EZSsS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 14:48:18 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-7.tower-131.messagelabs.com!1306435676!25771982!32
X-StarScan-Version: 6.2.17; banners=-,-,-
X-Originating-IP: [216.166.12.69]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Mika Westerberg <mika.westerberg@iki.fi>,
        Linus Walleij <linus.walleij@linaro.org>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Vinod Koul <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ryan@bluewatersys.com" <ryan@bluewatersys.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        spi mailing list <spi-devel-general@lists.sourceforge.net>
Date: Thu, 26 May 2011 13:48:12 -0500
Subject: RE: [PATCH 1/5] dmaengine: add ep93xx DMA support
Thread-Topic: [PATCH 1/5] dmaengine: add ep93xx DMA support
Thread-Index: Acwb1FWbkgwYzaFORuSCd5huHhXeagAALG/g
Message-ID: <0D753D10438DA54287A00B027084269764D3319EC4@AUSP01VMBX24.collaborationhost.net>
References: <cover.1306082097.git.mika.westerberg@iki.fi>
 <e6777eb9f7228ee1dadec1f0c9f16c3afc44c307.1306082097.git.mika.westerberg@iki.fi>
 <BANLkTi=3z3kO5VEe2up8Mfm+bNXkY3baUw@mail.gmail.com>
 <20110525195413.GC2996@acer>
 <BANLkTin8Trn-44Op+GbxrgocFrnPuXUZ2w@mail.gmail.com>
 <20110526043344.GA2749@acer>
 <BANLkTikzrXRmdnv_v_nmJw7Nvsr6TY-5RQ@mail.gmail.com>
 <20110526183800.GE2957@acer>
In-Reply-To: <20110526183800.GE2957@acer>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 26, 2011 11:38 AM, Mika Westerberg wrote:
> On Thu, May 26, 2011 at 09:15:25AM +0200, Linus Walleij wrote:
>> On Thu, May 26, 2011 at 6:33 AM, Mika Westerberg <mika.westerberg@iki.fi> wrote:
>> 
>>> Do you think that we can go forward with this patch series if I drop the last
>>> patch (spi/ep93xx: add DMA support)? This way we will have dmaengine
>>> implementation in place, whatever SPI driver we choose to use with ep93xx.
>> 
>> Yes and you don't have to drop any DMA support for the existing driver
>> for me alone, now that it's in the tree it should be maintained. I only
>> wanted to raise the issue of code duplication, not block any patches.
>
> Ok, so I'll keep the last patch for now.
>
> BTW: if we get amba-pl022 driver to work with ep93xx, do you have any ideas
> how to proceed from there? I mean, should we convert existing users to use
> that driver instead and finally remove the ep93xx_spi driver?

I think the biggest hurdle with using the amba-pl022 driver is that the ep93xx
spi peripheral does not have the registers with the pid and cid id's.  Without
those I don't think the amba bus driver will be able to match the device to
the driver.

Regards,
Hartley
