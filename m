Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045Ab1EPMie (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 08:38:34 -0400
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:41388 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753638Ab1EPMic convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 08:38:32 -0400
MIME-Version: 1.0
In-Reply-To: <1305538430-20957-1-git-send-email-keshava_mgowda@ti.com>
References: <1305538430-20957-1-git-send-email-keshava_mgowda@ti.com>
Date: Mon, 16 May 2011 18:08:30 +0530
Message-ID: <BANLkTin6SMZ_osDV8cxw7O1u9bHTtHfRyw@mail.gmail.com>
Subject: Re: [RESEND][PATCH 0/5] arm: omap: usb: Runtime PM support for EHCI
 and OHCI drivers
From: "Munegowda, Keshava" <keshava_mgowda@ti.com>
To: balbi@ti.com
Cc: Keshava Munegowda <keshava_mgowda@ti.com>, gadiyar@ti.com,
        sameo@linux.intel.com, parthab@india.ti.com, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 16, 2011 at 3:03 PM, Keshava Munegowda
<keshava_mgowda@ti.com> wrote:
> From: Keshava Munegowda <Keshava_mgowda@ti.com>
>
> The Hwmod structures and Runtime PM features are implemented
> For EHCI and OHCI drivers of OMAP3 and OMAP4.
> The global suspend/resume of EHCI and OHCI
> is validated on OMAP3430 sdp board with these patches.
>
> Keshava Munegowda (5):
>  arm: omap: usb: ehci and ohci hwmod structures for omap3 and omap4
>  arm: omap: usb: register hwmods of usbhs
>  arm: omap: usb: device name change for the clk names of usbhs
>  arm: omap: usb: Runtime PM support
>  arm: omap: usb: global Suspend and resume support of ehci and ohci
>
>  arch/arm/mach-omap2/clock3xxx_data.c       |   28 ++--
>  arch/arm/mach-omap2/clock44xx_data.c       |   10 +-
>  arch/arm/mach-omap2/omap_hwmod_3xxx_data.c |  184 ++++++++++++++++++++++
>  arch/arm/mach-omap2/omap_hwmod_44xx_data.c |  153 ++++++++++++++++++
>  arch/arm/mach-omap2/usb-host.c             |   99 ++++--------
>  drivers/mfd/omap-usb-host.c                |  236 +++++++++++++---------------
>  6 files changed, 504 insertions(+), 206 deletions(-)
>

balbi

need your decision (ACK / review comments) on this series too.


Regards
Keshava
