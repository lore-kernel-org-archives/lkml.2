Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837Ab2AQP0w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 10:26:52 -0500
Received: from imr4.ericy.com ([198.24.6.9]:41341 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754613Ab2AQP0v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 10:26:51 -0500
Date: Tue, 17 Jan 2012 07:24:34 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Ashish Jangam <ashish.jangam@kpitcummins.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dajun <dajun.chen@diasemi.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [lm-sensors] [PATCH 00/07] DA9052 patch series
Message-ID: <20120117152433.GA12653@ericsson.com>
References: <1326806748.3542.338.camel@dhruva>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1326806748.3542.338.camel@dhruva>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 08:25:48AM -0500, Ashish Jangam wrote:
> The following patch series adds support for the features of Dialog Semiconductor
> DA9052/53 PMICs.
> 
> The DA9052/53 PMICs support many functionalities like GPIOs, regulators,
> power-supply, touchscreen, rtc, backlight, etc. So these patches are applicable
> to different sub-systems of the kernel separately.
> 
> This patch series adds support for RTC, HWMON, Watchdog, Touch screen interface,
> Backlight, LEDs and On-Key.
> 
> All of these patches depend on the MFD module for DA9052/53. There is no
> other interdependence of patches.
> 
> Ashish Jangam (7):
> 	[RTC]: RTC module of DA9052/53 PMICs with time and alarm support.
> 	[HWMON]: Support for ADC of DA9052/53 PMICs.
> 	[Watchdog]: Watchdog support for DA9052/53 PMICs.
> 	[Touchscreen]: Driver for touch screen interface of DA9052/53 PMICs.
> 	[Backlight]: Backlight module for DA9052/53 PMICs.
> 	[LEDS]: Support for DA9052/53 LEDs.
> 	[On-Key]: Support for DA9052/53 on-key.
> 
Where are the patches ? I see some of them on the kernel kernel mailing list,
but not the hwmon driver.

Guenter
