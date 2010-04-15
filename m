Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746Ab0DOEdn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 00:33:43 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:39707 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876Ab0DOEdm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 00:33:42 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 2.6.34-rc4 7/8] mx5: Add USB to Freescale MX51 Babbage
Date: Wed, 14 Apr 2010 21:33:31 -0700
Message-ID: <86A0E76937111F4C92FABEC0A2098851047331E1@az33exm21>
In-Reply-To: <4BC561B5.1020006@canonical.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2.6.34-rc4 7/8] mx5: Add USB to Freescale MX51 Babbage
Thread-Index: AcrbnGh0U7muycEgS4ibnVLnlSCIHAAuCraw
References: <1271175030-3635-1-git-send-email-Dinh.Nguyen@freescale.com> <1271175030-3635-2-git-send-email-Dinh.Nguyen@freescale.com> <1271175030-3635-3-git-send-email-Dinh.Nguyen@freescale.com> <1271175030-3635-4-git-send-email-Dinh.Nguyen@freescale.com> <1271175030-3635-5-git-send-email-Dinh.Nguyen@freescale.com> <1271175030-3635-6-git-send-email-Dinh.Nguyen@freescale.com> <1271175030-3635-7-git-send-email-Dinh.Nguyen@freescale.com> <4BC561B5.1020006@canonical.com>
From: "Nguyen Dinh-R00091" <R00091@freescale.com>
To: <bryan.wu@canonical.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
       <linux@arm.linux.org.uk>, <s.hauer@pengutronix.de>,
       <valentin.longchamp@epfl.ch>, <daniel@caiaq.de>,
       <grant.likely@secretlab.ca>,
       "Herring Robert-RA7055" <RA7055@freescale.com>,
       <amit.kucheria@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 8th patch was for a USB timeout change that was sent to the USB
maintainer. Thanks everyone for their comments, I am almost ready with
another set with review comments taken into consideration.

Dinh 

-----Original Message-----
From: Bryan Wu [mailto:bryan.wu@canonical.com] 
Sent: Wednesday, April 14, 2010 1:33 AM
To: Nguyen Dinh-R00091
Cc: linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
linux@arm.linux.org.uk; s.hauer@pengutronix.de;
valentin.longchamp@epfl.ch; daniel@caiaq.de; grant.likely@secretlab.ca;
Herring Robert-RA7055; amit.kucheria@canonical.com
Subject: Re: [PATCH 2.6.34-rc4 7/8] mx5: Add USB to Freescale MX51
Babbage

This patch looks OK for me, but I failed to find the 8th patch of this
patchset.
Did you forget to send it out?

-Bryan

On 04/13/2010 09:10 AM, Dinh.Nguyen@freescale.com wrote:
> From: Dinh Nguyen<Dinh.Nguyen@freescale.com>
>
> Updade mx51_defconfig to include USB host support.
> This patch applies to 2.6.34-rc4.
>
> Signed-off-by: Dinh Nguyen<Dinh.Nguyen@freescale.com>
> ---
>   arch/arm/configs/mx51_defconfig |   17 ++++++++++++++++-
>   1 files changed, 16 insertions(+), 1 deletions(-)
>
> diff --git a/arch/arm/configs/mx51_defconfig 
> b/arch/arm/configs/mx51_defconfig index c88e952..a708fd6 100644
> --- a/arch/arm/configs/mx51_defconfig
> +++ b/arch/arm/configs/mx51_defconfig
> @@ -809,7 +809,22 @@ CONFIG_SSB_POSSIBLE=y
>   CONFIG_DUMMY_CONSOLE=y
>   # CONFIG_SOUND is not set
>   # CONFIG_HID_SUPPORT is not set
> -# CONFIG_USB_SUPPORT is not set
> +CONFIG_USB_SUPPORT=y
> +CONFIG_USB_ARCH_HAS_HCD=y
> +# CONFIG_USB_ARCH_HAS_OHCI is not set CONFIG_USB_ARCH_HAS_EHCI=y 
> +CONFIG_USB=y
> +
> +#
> +# USB Host Controller Drivers
> +#
> +# CONFIG_USB_C67X00_HCD is not set
> +CONFIG_USB_EHCI_HCD=y
> +CONFIG_USB_EHCI_ROOT_HUB_TT=y
> +# CONFIG_USB_EHCI_TT_NEWSCHED is not set CONFIG_USB_EHCI_MXC=y
> +
> +
>   CONFIG_MMC=y
>   # CONFIG_MMC_DEBUG is not set
>   # CONFIG_MMC_UNSAFE_RESUME is not set


