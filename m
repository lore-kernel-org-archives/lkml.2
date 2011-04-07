Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051Ab1DGW02 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 18:26:28 -0400
Received: from gate.crashing.org ([63.228.1.57]:52154 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754696Ab1DGW00 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 18:26:26 -0400
Subject: Re: [PATCH] x86/ce4100: add reg property to bridges
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-pci@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net, monstr@monstr.eu,
        tglx@linutronix.de
In-Reply-To: <20110407121315.GA9204@linutronix.de>
References: <1302146796-26825-1-git-send-email-benh@kernel.crashing.org>
	 <1302146796-26825-2-git-send-email-benh@kernel.crashing.org>
	 <20110407121315.GA9204@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Apr 2011 07:52:39 +1000
Message-ID: <1302213159.2458.43.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-07 at 14:13 +0200, Sebastian Andrzej Siewior wrote:
> without the reg property Ben's new code won't find the PCI & ISA bridge
> and the devices won't get the DT-node attached.
> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
> 
> This patch can be applied independently of Ben's series but without it
> we have almost no devices :).

Thanks. Are you sending that independently or do you want me to put it
in my series before the patch that would "break" it ?

Cheers,
Ben.

>  arch/x86/platform/ce4100/falconfalls.dts |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/platform/ce4100/falconfalls.dts b/arch/x86/platform/ce4100/falconfalls.dts
> index dc701ea..2d6d226 100644
> --- a/arch/x86/platform/ce4100/falconfalls.dts
> +++ b/arch/x86/platform/ce4100/falconfalls.dts
> @@ -74,6 +74,7 @@
>  				compatible = "intel,ce4100-pci", "pci";
>  				device_type = "pci";
>  				bus-range = <1 1>;
> +				reg = <0x0800 0x0 0x0 0x0 0x0>;
>  				ranges = <0x2000000 0 0xdffe0000 0x2000000 0 0xdffe0000 0 0x1000>;
>  
>  				interrupt-parent = <&ioapic2>;
> @@ -412,6 +413,7 @@
>  				#address-cells = <2>;
>  				#size-cells = <1>;
>  				compatible = "isa";
> +				reg = <0xf800 0x0 0x0 0x0 0x0>;
>  				ranges = <1 0 0 0 0 0x100>;
>  
>  				rtc@70 {


