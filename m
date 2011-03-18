Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932657Ab1CRWre (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 18:47:34 -0400
Received: from gate.crashing.org ([63.228.1.57]:38479 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932176Ab1CRWra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 18:47:30 -0400
Subject: Re: RFC: Platform data for onboard USB assets
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: andy.green@linaro.org, Greg KH <greg@kroah.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <201103182106.13888.arnd@arndb.de>
References: <20110311165642.GA9996@kroah.com>
	 <201103181600.09877.arnd@arndb.de> <4D839BCD.6030202@linaro.org>
	 <201103182106.13888.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 19 Mar 2011 09:47:09 +1100
Message-ID: <1300488429.22236.1291.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-18 at 21:06 +0100, Arnd Bergmann wrote:
> 
> In a perfect world, we would need neither the device tree nor
> any platform data at all, because we'd be able to ask the hardware
> or the fictionary correct firmware about what the properties
> of the hardware are. This works to a surprisingly large extent
> on server hardware, but much less so on typical embedded systems.

Properties of the HW per-se but also binding information, ie, what is
connected to what outside of the main bus path (think clock/power
control etc...). Even server / desktop is affected here, and nobody sane
thinks ACPI is a -good- solution here tho it works mostly on x86 :-)

Cheers,
Ben.


