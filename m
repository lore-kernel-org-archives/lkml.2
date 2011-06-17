Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756460Ab1FQBFr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 21:05:47 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:3832 "EHLO
	VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754765Ab1FQBFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 21:05:45 -0400
X-SpamScore: -3
X-BigFish: VS-3(zz98dKzz1202hzzz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 0,
Date: Fri, 17 Jun 2011 09:11:16 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Grant Likely <grant.likely@secretlab.ca>
CC: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 11/11] arm/versatile: Add device tree support
Message-ID: <20110617011115.GC10154@S2100-06.ap.freescale.net>
References: <20110616042653.29371.2052.stgit@ponder>
 <20110616044311.29371.49018.stgit@ponder>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110616044311.29371.49018.stgit@ponder>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 10:43:18PM -0600, Grant Likely wrote:
[...]
> diff --git a/arch/arm/boot/dts/versatile-ab.dts b/arch/arm/boot/dts/versatile-ab.dts
> new file mode 100644
> index 0000000..0e31dc9
> --- /dev/null
> +++ b/arch/arm/boot/dts/versatile-ab.dts
> @@ -0,0 +1,185 @@
> +/dts-v1/;
> +/include/ "skeleton.dtsi"
> +
> +/ {
> +	model = "ARM Versatile AB";
> +	compatible = "arm,versatile-ab";
> +	#address-cells = <1>;
> +	#size-cells = <1>;

We already have above two line in skeleton.dtsi.

> +	interrupt-parent = <&vic>;

-- 
Regards,
Shawn

