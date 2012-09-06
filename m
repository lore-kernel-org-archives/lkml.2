Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881Ab2IFMPk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 08:15:40 -0400
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:51152 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753137Ab2IFMPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 08:15:35 -0400
MIME-Version: 1.0
In-Reply-To: <1344258480-4304-2-git-send-email-kishon@ti.com>
References: <1344258480-4304-1-git-send-email-kishon@ti.com>
	<1344258480-4304-2-git-send-email-kishon@ti.com>
Date: Thu, 6 Sep 2012 17:45:33 +0530
Message-ID: <CAAe_U6KBNZpT03xATmPTNTgxm5hj+wJdsShdnm08EmF4Q=hTCw@mail.gmail.com>
Subject: Re: [PATCH v7 1/7] drivers: usb: phy: add a new driver for omap usb2 phy
From: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
To: Greg KH <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>,
        Felipe Balbi <balbi@ti.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, rob@landley.net, linux@arm.linux.org.uk,
        b-cousson@ti.com, rnayak@ti.com, tony@atomide.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Aug 6, 2012 at 6:37 PM, Kishon Vijay Abraham I <kishon@ti.com> wrote:
> All phy related programming like enabling/disabling the clocks, powering
> on/off the phy is taken care of by this driver. It is also used for OTG
> related functionality like srp.
>
> This also includes device tree support for usb2 phy driver and
> the documentation with device tree binding information is updated.
>
> Currently writing to control module register is taken care in this
> driver which will be removed once the control module driver is in place.
>
> Cc: Felipe Balbi <balbi@ti.com>
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  .../devicetree/bindings/bus/omap-ocp2scp.txt       |    3 +
>  Documentation/devicetree/bindings/usb/omap-usb.txt |   17 ++
>  drivers/usb/phy/Kconfig                            |   10 +
>  drivers/usb/phy/Makefile                           |    1 +
>  drivers/usb/phy/omap-usb2.c                        |  271 ++++++++++++++++++++
>  include/linux/usb/omap_usb.h                       |   46 ++++
>  include/linux/usb/phy_companion.h                  |   34 +++
>  7 files changed, 382 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/usb/omap-usb.txt
>  create mode 100644 drivers/usb/phy/omap-usb2.c
>  create mode 100644 include/linux/usb/omap_usb.h
>  create mode 100644 include/linux/usb/phy_companion.h
>
> diff --git a/Documentation/devicetree/bindings/bus/omap-ocp2scp.txt b/Documentation/devicetree/bindings/bus/omap-ocp2scp.txt
> index d2fe064..bb0c7f4 100644
> --- a/Documentation/devicetree/bindings/bus/omap-ocp2scp.txt
> +++ b/Documentation/devicetree/bindings/bus/omap-ocp2scp.txt
> @@ -8,3 +8,6 @@ properties:
>
>  Sub-nodes:
>  All the devices connected to ocp2scp are described using sub-node to ocp2scp
> +- usb2phy :
> +   The binding details of usb2phy can be found in:
> +   Documentation/devicetree/bindings/usb/omap-usb.txt

The above two lines should be added in omap-ocp2scp.txt (this file was
added as part of omap: add ocp2scp as a bus driver and is in
linux-next). However this file is still not in Felipe's xceiv branch.
So I'm not sure how I can get this patch merged in Felipe's tree
without conflict.

Thanks
Kishon
