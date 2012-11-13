Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204Ab2KMFGY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 00:06:24 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:44455 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722Ab2KMFGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 00:06:23 -0500
Message-ID: <50A1D54E.2090406@wwwdotorg.org>
Date: Mon, 12 Nov 2012 22:06:22 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Jonas Gorski <jonas.gorski@gmail.com>
CC: linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>,
        John Crispin <blogic@openwrt.org>, Maxime Bizon <mbizon@freebox.fr>,
        Florian Fainelli <florian@openwrt.org>,
        Kevin Cernekee <cernekee@gmail.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] MIPS: BCM63XX: register GPIO controller through Device
 Tree
References: <1352638249-29298-1-git-send-email-jonas.gorski@gmail.com> <1352638249-29298-12-git-send-email-jonas.gorski@gmail.com>
In-Reply-To: <1352638249-29298-12-git-send-email-jonas.gorski@gmail.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2012 05:50 AM, Jonas Gorski wrote:
> Register the GPIO controller through Device Tree and add the
> appropriate values in the include files.
> 
> Since we can't register a platform driver at this early stage move the
> direct call to bcm63xx_gpio_init from prom_init to an arch initcall.

> diff --git a/Documentation/devicetree/bindings/gpio/bcm63xx-gpio.txt b/Documentation/devicetree/bindings/gpio/bcm63xx-gpio.txt

> +- #gpio-cells: Must be <2>. The first cell is the GPIO pin, and
> +  the second one the standard linux flags.

Also here, I think you want to explicitly document the flag values here
so the bindings don't rely on the Linux kernel code. I don't think
there's a standard central file which documents them though, although I
vaguely recall some discussion to create add them to gpio.txt?
