Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805Ab2KMFCM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 00:02:12 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:45021 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804Ab2KMFCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 00:02:11 -0500
Message-ID: <50A1D452.2020904@wwwdotorg.org>
Date: Mon, 12 Nov 2012 22:02:10 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Jonas Gorski <jonas.gorski@gmail.com>
CC: linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>,
        John Crispin <blogic@openwrt.org>, Maxime Bizon <mbizon@freebox.fr>,
        Florian Fainelli <florian@openwrt.org>,
        Kevin Cernekee <cernekee@gmail.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] MIPS: BCM63XX: add Device Tree clock definitions
References: <1352638249-29298-1-git-send-email-jonas.gorski@gmail.com> <1352638249-29298-10-git-send-email-jonas.gorski@gmail.com>
In-Reply-To: <1352638249-29298-10-git-send-email-jonas.gorski@gmail.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2012 05:50 AM, Jonas Gorski wrote:
> Add definitions for the clocks found and used in all supported SoCs.

> diff --git a/arch/mips/bcm63xx/dts/bcm6328.dtsi b/arch/mips/bcm63xx/dts/bcm6328.dtsi

> +			clocks {
> +				#address-cells = <1>;
> +				#size-cells = <0>;
> +
> +				periph: pll {
> +					compatible = "brcm,bcm63xx-clock";
> +					#clock-cells = <0>;
> +					clock-frequency = <50000000>;
> +					clock-output-names = "periph";
> +				};

Here too, it seems like some reg properties would be required.
