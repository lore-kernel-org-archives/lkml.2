Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481Ab2KGJ4h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 04:56:37 -0500
Received: from mga02.intel.com ([134.134.136.20]:17676 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754159Ab2KGJ4f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 04:56:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,728,1344236400"; 
   d="scan'208";a="238449748"
Date: Wed, 7 Nov 2012 11:58:42 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        lenb@kernel.org, rafael.j.wysocki@intel.com,
        broonie@opensource.wolfsonmicro.com, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, khali@linux-fr.org, ben-linux@fluff.org,
        w.sang@pengutronix.de, mathias.nyman@linux.intel.com,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 2/3] spi / ACPI: add ACPI enumeration support
Message-ID: <20121107095842.GY24532@intel.com>
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com>
 <CAErSpo44pWUJmRAP6eR9T+2WvO5hJPFOC=Nn-WPXDtCY0v0EDw@mail.gmail.com>
 <1996776.cC14CHafyR@vostro.rjw.lan>
 <2584820.Vd5p0uzRAK@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2584820.Vd5p0uzRAK@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2012 at 11:36:08PM +0100, Rafael J. Wysocki wrote:
> > 
> > OK, but then we need to pass the information obtained from _CRS
> > (presumably after some adjustments through _SRS) to drivers, or rather to
> > things like the SPI core, I2C core etc. so that they can create device
> > objects for drivers to bind to and quite frankly I don't see why not to use
> > ACPI resources for that.
> 
> Nevertheless, the routines for parsing those resources should belong
> to the ACPI core, mostly to avoid code duplication.

Rafael,

So is the idea now that the ACPI core parses the resources and passes them
forward via struct acpi_device? I'm just wondering how to proceed with
these I2C and SPI enumeration patches.

Thanks.
