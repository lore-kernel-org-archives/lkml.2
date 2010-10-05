Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757595Ab0JEXsh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 19:48:37 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:41491 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756205Ab0JEXsg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 19:48:36 -0400
From: "Savoy, Pavan" <pavan_savoy@ti.com>
To: Greg KH <greg@kroah.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Date: Wed, 6 Oct 2010 05:17:20 +0530
Subject: RE: [PATCH 0/4] move TI_ST driver out of staging
Thread-Topic: [PATCH 0/4] move TI_ST driver out of staging
Thread-Index: Actk5EX6+UfHKG47SeiCE4kbpf45vgAA2Esy
Message-ID: <19F8576C6E063C45BE387C64729E739404A9F4CEC3@dbde02.ent.ti.com>
References: <1286323717-2925-1-git-send-email-pavan_savoy@ti.com>,<20101005232258.GA17277@kroah.com>
In-Reply-To: <20101005232258.GA17277@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


OK. all in 1 it is.
________________________________________
From: Greg KH [greg@kroah.com]
Sent: Wednesday, October 06, 2010 4:52 AM
To: Savoy, Pavan
Cc: gregkh@suse.de; linux-kernel@vger.kernel.org; alan@lxorguk.ukuu.org.uk; devel@driverdev.osuosl.org
Subject: Re: [PATCH 0/4] move TI_ST driver out of staging

On Tue, Oct 05, 2010 at 08:08:33PM -0400, pavan_savoy@ti.com wrote:
> From: Pavan Savoy <pavan_savoy@ti.com>
>
> Texas Instrument's WiLink 7 chipset packs wireless technologies like
> Bluetooth, FM, GPS and WLAN into a single die.
> Among these the Bluetooth, FM Rx/Tx and GPS are interfaced to a apps processor
> over a single UART.
>
> This line discipline driver allows various protocol drivers such as Bluetooth
> BlueZ driver, FM V4L2 driver and GPS simple character device driver
> to communicate with its relevant core in the chip.
>
> The following patches,
> 1. removes the driver from staging
> 2. adds the driver to drivers/misc/ directory since it really doesn't
> belong anywhere else
> 3. adds in the Kconfig and Makefile for the driver
> 4. modifies the drivers/misc/Kconfig and drivers/misc/Makefile for the
> driver to be available to be built along with rest of the kernel.
>
> Pavan Savoy (4):
>   drivers:staging:ti-st: remove TI_ST from staging
>   drivers:misc: ti-st: sources for TI_ST driver

These two should be together, so we see an obvious "move the files" type
patch, not a "delete and then add" set of stuff.

>   drivers:misc: ti-st: Kconfig & Makefile for TI_ST
>   drivers:misc: modify Kconfig & Makefile for TI_ST

So this really could just be one patch all at once, care to redo?

thanks,

greg k-h
