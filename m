Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758644Ab2IKKTR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 06:19:17 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53218 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753311Ab2IKKTP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 06:19:15 -0400
Message-ID: <504F101B.2020804@ti.com>
Date: Tue, 11 Sep 2012 12:19:07 +0200
From: Benoit Cousson <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <balbi@ti.com>, <linux@arm.linux.org.uk>, <rob.herring@calxeda.com>,
        <grant.likely@secretlab.ca>, <tony@atomide.com>, <rnayak@ti.com>,
        <hvaibhav@ti.com>, <peter.ujfalusi@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/3] arm/dts: omap: add dt data for MUSB
References: <1347345381-4390-1-git-send-email-kishon@ti.com>
In-Reply-To: <1347345381-4390-1-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kishon,

Beside minor comments and the lack of explicit changelog to explain what
part of the HW you are addressing, this series looks good.

I guess that series should be rebased on top of lo/devel-dt without much
trouble.

On 09/11/2012 08:36 AM, Kishon Vijay Abraham I wrote:
> No major change from the previous version. Just removed the
> omap-usb2 dt data and sent that as a separate patch.

Indeed that one will be trickier to merge properly, so my second thought
is it is better to have it separated.

Regards,
Benoit

> 
> Rebased on
> git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git musb
> 
> Kishon Vijay Abraham I (3):
>   arm/dts: Add twl6030-usb data
>   arm/dts: Add twl4030-usb data
>   arm/dts: omap: Add usb_otg and glue data
> 
>  arch/arm/boot/dts/omap3-beagle.dts |    6 ++++++
>  arch/arm/boot/dts/omap3-evm.dts    |    6 ++++++
>  arch/arm/boot/dts/omap3.dtsi       |    8 ++++++++
>  arch/arm/boot/dts/omap4-panda.dts  |   10 ++++++++++
>  arch/arm/boot/dts/omap4-sdp.dts    |   10 ++++++++++
>  arch/arm/boot/dts/omap4.dtsi       |    8 ++++++++
>  arch/arm/boot/dts/twl4030.dtsi     |   21 +++++++++++++++++++++
>  arch/arm/boot/dts/twl6030.dtsi     |    5 +++++
>  8 files changed, 74 insertions(+)
> 

