Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751833Ab2IKIZ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 04:25:57 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:55622 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab2IKIZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 04:25:54 -0400
Message-ID: <504EF587.3080903@ti.com>
Date: Tue, 11 Sep 2012 10:25:43 +0200
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

On 09/11/2012 08:36 AM, Kishon Vijay Abraham I wrote:
> No major change from the previous version. Just removed the
> omap-usb2 dt data and sent that as a separate patch.

Well, I think you'd better keep them in the same series :-)

> Rebased on
> git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git musb

Since it is DTS stuf, you should rebase that on top of the latest
lo/devel-dt branch. All the latest DTS patches an in there for 3.7.

While you are there, could you please rename the patches with "ARM: dts"
prefix. It seems that this is the new convention :-)

Regards,
Benoit

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

