Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479Ab2IDRgm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 13:36:42 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:40201 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752112Ab2IDRgl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 13:36:41 -0400
Date: Tue, 4 Sep 2012 19:35:20 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: linus.walleij@linaro.org
Cc: arnd@arndb.de, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, lee.jones@linaro.org,
        robherring2@gmail.com, swarren@nvidia.com,
        linus.walleij@stericsson.com, linux-kernel@vger.kernel.org,
        w.sang@pengutronix.de, linux-i2c@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com,
        devicetree-discuss@lists.ozlabs.org,
        Davide Ciminaghi <ciminaghi@gnudd.com>
Subject: Re: [PATCH 3/3] i2c: nomadik: Add Device Tree support to the
 Nomadik I2C driver
Message-ID: <20120904173520.GA18209@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <CACRpkdZESujO=2BU3jeKiX3Cm+JY2UPEXwGkro75FWa5Gio5YQ@mail.gmail.com>
References: <CACRpkdZESujO=2BU3jeKiX3Cm+JY2UPEXwGkro75FWa5Gio5YQ@mail.gmail.com>
  <20120831122323.GC5962@gmail.com>  <5044C82E.5060207@gmail.com>
  <20120903152012.GH31163@gmail.com>  <201209041428.21409.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Alessandro Rubini is actively working on bridging this (and
> other amba_device primecells) to PCI, that is the reason why it
> was recently converted to an amba_device.

Yes, I've been inactive for a while but I'm on it right now.

> How is he then supposed to get the proper parameters into the
> driver? Note that the PCI ID is no help at all since the parameters
> depend on what is connected to the I2C bus, not on what it itself is
> connected to. Isn't platform data used in such cases?

I'm using platform data currently, but Davide Ciminaghi is actively
working to convert the configuration to device-tree: the way we pass
platform data to the pci device (and thus amba) is not considered
acceptable by Peter Anvin.

I'm thus asking Davide if he's happy to remove the platform data
configuration path right now (I personally wouldn't be very happy, but
I acknowledge it should happen, sooner or later).

/alessandro
