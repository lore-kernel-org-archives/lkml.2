Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615Ab2JAOaL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 10:30:11 -0400
Received: from mga14.intel.com ([143.182.124.37]:21429 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751993Ab2JAOaG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 10:30:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,517,1344236400"; 
   d="scan'208";a="151108210"
From: "Zhang, Rui" <rui.zhang@intel.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@lists.linux-foundation.org>,
        linux-i2c <linux-i2c@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Len, Brown" <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Grant Likely <grant.likely@secretlab.ca>,
        Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: RE: [RFC PATCH 0/6] ACPI: ACPI 5.0 device enumeration proposal
Thread-Topic: [RFC PATCH 0/6] ACPI: ACPI 5.0 device enumeration proposal
Thread-Index: AQHNnUwVG9E3zHKzN0+Mz9+HuQO38pejf7mAgAEFx6A=
Date: Mon, 1 Oct 2012 14:30:00 +0000
Message-ID: <744357E9AAD1214791ACBA4B0B90926322D989@SHSMSX101.ccr.corp.intel.com>
References: <1348817863.10877.320.camel@rui.sh.intel.com>
 <20121001064433.GF15548@intel.com>
In-Reply-To: <20121001064433.GF15548@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Mika Westerberg [mailto:mika.westerberg@linux.intel.com]
> Sent: Monday, October 01, 2012 2:45 PM
> To: Zhang, Rui
> Cc: LKML; linux-pm; linux-i2c; linux-acpi@vger.kernel.org; Len, Brown;
> Rafael J. Wysocki; Grant Likely; Dirk Brandewie
> Subject: Re: [RFC PATCH 0/6] ACPI: ACPI 5.0 device enumeration proposal
> Importance: High
> 
> On Fri, Sep 28, 2012 at 03:37:43PM +0800, Zhang Rui wrote:
> >
> > the main idea is that, for Serial Buses like I2C and SPI, we
> enumerate
> > the controller as a platform device, and then enumerate the slaves
> via
> > i2c/spi_register_board_info. And then, when the controller is really
> > probed and enabled in the platform driver, the SPI/I2C bus code will
> > enumerate I2C/SPI slaves automatically.
> > And for the other devices, we will enumerate all of them as platform
> > devices, which is not covered in this patch set yet.
> 
> Can you show some example how we could use this new code for example
> with an existing I2C/SPI slave driver?

This is just prototype patch set that I want to illustrate my idea
on ACPI device enumeration, to get more thoughts on this.
So no example driver so far.

> Let's say the device uses few
> GPIOs, one for interrupt and other for triggering firmware download. In
> addition to that it needs a special parameters that can be extracted
> running the "_DSM" method of the device.
> 
> Normally the driver would get this stuff from the platform data or from
> Device Tree but how it is done with these patches?

Can you show me an example driver that gets the special parameters from Device Tree?

Thanks,
rui
