Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab1HPDlP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 23:41:15 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:20554
	"EHLO AM1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751404Ab1HPDlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 23:41:13 -0400
X-SpamScore: -6
X-BigFish: VS-6(z37d5kz1432N98dKzz1202hzz8275bhz2dh2a8h668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Tue, 16 Aug 2011 11:48:27 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Stephen Warren <swarren@nvidia.com>
CC: Grant Likely <grant.likely@secretlab.ca>, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-tegra@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Belisko Marek <marek.belisko@gmail.com>,
        Jamie Iles <jamie@jamieiles.com>,
        Sergei Shtylyov <sshtylyov@mvista.com>
Subject: Re: [RFC PATCH v2 06/13] docs/dt: Document nvidia,tegra20-pinmux
 binding
Message-ID: <20110816034827.GH8044@S2100-06.ap.freescale.net>
References: <1313440100-17131-1-git-send-email-swarren@nvidia.com>
 <1313440100-17131-7-git-send-email-swarren@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1313440100-17131-7-git-send-email-swarren@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 15, 2011 at 02:28:13PM -0600, Stephen Warren wrote:
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
>  .../devicetree/bindings/pinmux/pinmux_nvidia.txt   |  294 ++++++++++++++++++++
>  1 files changed, 294 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/pinmux/pinmux_nvidia.txt
> 
[...]
> +
> +Example of a gpio-controller node:
> +

You meant pinmux node instead of gpio.

Regards,
Shawn

> +	pinmux: pinmux@70000000 {
> +		compatible = "nvidia,tegra20-pinmux";
> +		reg = < 0x70000000 0xc00 >;
> +		nvidia,mux-groups {
> +			cdev1 {
> +				nvidia,function = "plla_out";
> +			};
> +			cdev2 {
> +				nvidia,function = "pllp_out4";
> +				nvidia,pull-down;
> +				nvidia,tristate;
> +			};
> +		};
> +		nvidia,drive-groups {
> +			sdio1 {
> +				nvidia,schmitt;
> +				nvidia,drive-power = <1>;
> +				nvidia,pull-down-strength = <31>;
> +				nvidia,pull-up-strength = <31>;
> +				nvidia,slew-rate-rising = <3>;
> +				nvidia,slew-rate-falling = <3>;
> +			};
> +		};
> +	};
> +
> -- 
> 1.7.0.4
> 
> 

