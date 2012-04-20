Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757115Ab2DTPBv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 11:01:51 -0400
Received: from smtp-out-028.synserver.de ([212.40.185.28]:1042 "EHLO
	smtp-out-012.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756767Ab2DTPBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 11:01:50 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 9511
Message-ID: <4F917AE3.7050808@metafoo.de>
Date: Fri, 20 Apr 2012 17:04:03 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: Roland Stigge <stigge@antcom.de>
CC: jic23@cam.ac.uk, gregkh@linuxfoundation.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v3] iio: Add device tree support to LPC32xx ADC
References: <1334932713-19231-1-git-send-email-stigge@antcom.de>
In-Reply-To: <1334932713-19231-1-git-send-email-stigge@antcom.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> [...]
> 
> --- /dev/null
> +++ linux-2.6/Documentation/devicetree/bindings/staging/iio/adc/lpc32xx-adc.txt
> @@ -0,0 +1,16 @@
> +* NXP LPC32xx SoC ADC controller
> +
> +Required properties:
> +- compatible: must be "nxp,lpc32xx-adc"
> +- reg: physical base address of the controller and length of memory mapped
> +  region.
> +- interrupts: The ADC interrupt
> +
> +Example:
> +
> +	adc@40048000 {
> +		compatible = "nxp,lpc32xx-adc";

In my opinion it seems to be a bad idea to use wildcard names in devicetree
compatible strings.

> +		reg = <0x40048000 0x1000>;
> +		interrupt-parent = <&mic>;
> +		interrupts = <39 0>;
> +	};

