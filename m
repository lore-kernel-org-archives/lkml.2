Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449Ab2EGHnl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 03:43:41 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34547 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021Ab2EGHnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 03:43:40 -0400
Date: Mon, 7 May 2012 08:42:28 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Hiroshi DOYU <hdoyu@nvidia.com>
Cc: swarren@wwwdotorg.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Felipe Balbi <balbi@ti.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv5 1/3] ARM: tegra: Add Tegra AHB driver
Message-ID: <20120507074228.GK26481@n2100.arm.linux.org.uk>
References: <1336373032-16881-1-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336373032-16881-1-git-send-email-hdoyu@nvidia.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2012 at 09:43:45AM +0300, Hiroshi DOYU wrote:
> diff --git a/drivers/Makefile b/drivers/Makefile
> index 5870322..d97e2e2 100644
> --- a/drivers/Makefile
> +++ b/drivers/Makefile
> @@ -18,7 +18,7 @@ obj-$(CONFIG_SFI)		+= sfi/
>  # PnP must come after ACPI since it will eventually need to check if acpi
>  # was used and do nothing if so
>  obj-$(CONFIG_PNP)		+= pnp/
> -obj-$(CONFIG_ARM_AMBA)		+= amba/
> +obj-$(CONFIG_ARM)		+= amba/

NAK.  This makes amba only buildable for ARM which is not the intention.
Other architectures do have Primecells.
