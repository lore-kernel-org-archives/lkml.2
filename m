Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086Ab2IEGlO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 02:41:14 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:57884 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886Ab2IEGlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 02:41:12 -0400
Date: Wed, 5 Sep 2012 07:41:07 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Alessandro Rubini <rubini@gnudd.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@nvidia.com>, linus.walleij@stericsson.com,
        linux-kernel@vger.kernel.org, Wolfram Sang <w.sang@pengutronix.de>,
        linux-i2c@vger.kernel.org, STEricsson_nomadik_linux@list.st.com,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 3/3] i2c: nomadik: Add Device Tree support to the Nomadik
 I2C driver
Message-ID: <20120905064106.GA4233@gmail.com>
References: <20120831122323.GC5962@gmail.com>
 <5044C82E.5060207@gmail.com>
 <20120903152012.GH31163@gmail.com>
 <201209041428.21409.arnd@arndb.de>
 <CACRpkdZESujO=2BU3jeKiX3Cm+JY2UPEXwGkro75FWa5Gio5YQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdZESujO=2BU3jeKiX3Cm+JY2UPEXwGkro75FWa5Gio5YQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2012 at 07:27:10PM +0200, Linus Walleij wrote:
> On Tue, Sep 4, 2012 at 4:28 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> 
> > In this particular case, we don't have a single board file providing a
> > struct nmk_i2c_controller definition for platform data, so the best way
> > to handle this IMHO is to remove the header file with the platform
> > data definition, and just encode the defaults in the driver.
> 
> Alessandro Rubini is actively working on bridging this (and
> other amba_device primecells) to PCI, that is the reason why it
> was recently converted to an amba_device. How is he then supposed to
> get the proper parameters into the driver? Note that the PCI ID
> is no help at all since the parameters depend on what is connected
> to the I2C bus, not on what it itself is connected to. Isn't platform data
> used in such cases?

So why can't Alessandro continue to use Platform Data in the normal way?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
