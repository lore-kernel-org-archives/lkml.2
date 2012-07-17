Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025Ab2GQM2I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 08:28:08 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:53160 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510Ab2GQM2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 08:28:04 -0400
Message-ID: <50055A21.5010206@mvista.com>
Date: Tue, 17 Jul 2012 16:27:13 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux@arm.linux.org.uk, gregkh@linuxfoundation.org, b-cousson@ti.com,
        rnayak@ti.com, tony@atomide.com, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, balbi@ti.com,
        linux-omap@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH v2 02/11] arm/dts: omap: Add omap-usb2 dt data
References: <1342512611-20529-1-git-send-email-kishon@ti.com> <1342512611-20529-3-git-send-email-kishon@ti.com>
In-Reply-To: <1342512611-20529-3-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 17-07-2012 12:10, Kishon Vijay Abraham I wrote:

> Add omap-usb2 data node in omap4 device tree file.

> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>   arch/arm/boot/dts/omap4.dtsi |    5 +++++
>   1 files changed, 5 insertions(+), 0 deletions(-)
>
> diff --git a/arch/arm/boot/dts/omap4.dtsi b/arch/arm/boot/dts/omap4.dtsi
> index bda5df3..4d2dcc1 100644
> --- a/arch/arm/boot/dts/omap4.dtsi
> +++ b/arch/arm/boot/dts/omap4.dtsi
> @@ -279,6 +279,11 @@
>   			#size-cells = <1>;
>   			ranges;
>   			ti,hwmods = "ocp2scp_usb_phy";
> +			usb2phy@0x4a0ad080 {

    There should be no "0x" prefix here.

WBR, Sergei
