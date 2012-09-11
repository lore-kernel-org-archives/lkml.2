Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147Ab2IKIuR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 04:50:17 -0400
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:38802 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752544Ab2IKIuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 04:50:13 -0400
MIME-Version: 1.0
In-Reply-To: <504EF4FD.2080001@ti.com>
References: <1347343932-3656-1-git-send-email-kishon@ti.com>
	<504EF4FD.2080001@ti.com>
Date: Tue, 11 Sep 2012 14:20:11 +0530
Message-ID: <CAAe_U6+8MAUAZgLZq8+Yc6SxOCJ0xQ4NFO-R4p2kgiSOXHZL2w@mail.gmail.com>
Subject: Re: [PATCH] arm/dts: omap: Add omap-usb2 dt data
From: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
To: Benoit Cousson <b-cousson@ti.com>
Cc: balbi@ti.com, arnd@arndb.de, akpm@linux-foundation.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com, rnayak@ti.com,
        tony@atomide.com, gregkh@linuxfoundation.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-usb@vger.kernel.org, rob@landley.net,
        linux@arm.linux.org.uk, ohad@wizery.com, linus.walleij@linaro.org,
        myungjoo.ham@samsung.com, rusty@rustcorp.com.au, swarren@nvidia.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Sep 11, 2012 at 1:53 PM, Benoit Cousson <b-cousson@ti.com> wrote:
> Hi Kishon,
>
> On 09/11/2012 08:12 AM, Kishon Vijay Abraham I wrote:
>> Add omap-usb2 data node in omap4 device tree file. Since omap-usb2 is
>> connected to ocp2scp, omap-usb2 dt data is added as a child node
>> of ocp2scp.
>
> Could you add more details about the omap-usb2?
I think information about omap-usb2 driver is added in
 *usb: phy: add a new driver for omap usb2 phy.*.
Do you want the same thing to be added here?
>
> You must update the Documentation binding with that compatible name.
Yes. It's part of *usb: phy: add a new driver for omap usb2 phy.*
> Is it already part of the driver serie? The MUSB driver is referring to
> "ti,musb-omap2430" only.

Will correct the Documentation for MUSB.

Thanks
Kishon
