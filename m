Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530Ab2GIMT0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 08:19:26 -0400
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:53418 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753472Ab2GIMTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 08:19:22 -0400
Message-ID: <4FFACC55.4060106@ti.com>
Date: Mon, 09 Jul 2012 14:19:33 +0200
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0
MIME-Version: 1.0
To: Russell King <linux@arm.linux.org.uk>, Benoit Cousson <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@secretlab.ca>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-omap@vger.kernel.org,
        Rajendra Nayak <rnayak@ti.com>, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 0/7] arm/dts: Audio support for OMAP4 devices (SDP, PandaBoard)
References: <1339164125-32534-1-git-send-email-peter.ujfalusi@ti.com>
In-Reply-To: <1339164125-32534-1-git-send-email-peter.ujfalusi@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 06/08/2012 04:01 PM, Peter Ujfalusi wrote:
> Hello,
> 
> The following series enable the audio functionality on OMAP4 based devices using
> twl6040 as audio codec.
> 
> The series adds the needed bindings in the dts for the OMAP IPs, twl6040 MFD
> device and for the audio connection on the board.
> 
> To be able to differentiate between PandaBoard and PandaBoardES (they have a bit
> different audio configuration) a new dts file has been created which only
> changes the audio properties different between the two boards.
> 
> Patches for the drivers involved and the documentation related to dts sections
> has been either in 3.5 or heading for 3.6.

Probably this series has been overlooked, since I have not received feedback
on it.
Should I resend the series? Which tree should I use to rebase it?

Thank you,
Péter

> 
> Regards,
> Peter
> ---
> Peter Ujfalusi (7):
>   arm/dts: omap4: Add entry for OMAP McPDM IP
>   arm/dts: omap4: Add entry for OMAP DMIC IP
>   arm/dts: omap4-sdp: Add fixed regulator to represent VBAT
>   arm/dts: omap4-sdp: Add support for twl6040
>   arm/dts: omap4-sdp: Enable audio support via device tree
>   arm/dts: omap4-panda: Audio support for PandaBoard 4430
>   arm/dts: New dts file for PandaBoardES (4460)
> 
>  arch/arm/boot/dts/omap4-panda.dts   |   37 +++++++++++++++++++
>  arch/arm/boot/dts/omap4-pandaES.dts |   24 ++++++++++++
>  arch/arm/boot/dts/omap4-sdp.dts     |   68 +++++++++++++++++++++++++++++++++++
>  arch/arm/boot/dts/omap4.dtsi        |   18 +++++++++
>  4 files changed, 147 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/boot/dts/omap4-pandaES.dts
> 


