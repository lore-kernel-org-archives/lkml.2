Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052Ab2KGNDc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 08:03:32 -0500
Received: from mga02.intel.com ([134.134.136.20]:1394 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955Ab2KGNDa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 08:03:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,730,1344236400"; 
   d="scan'208";a="216293015"
Date: Wed, 7 Nov 2012 15:05:48 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        lenb@kernel.org, rafael.j.wysocki@intel.com,
        broonie@opensource.wolfsonmicro.com, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, khali@linux-fr.org, ben-linux@fluff.org,
        w.sang@pengutronix.de, mathias.nyman@linux.intel.com,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 2/3] spi / ACPI: add ACPI enumeration support
Message-ID: <20121107130548.GZ24532@intel.com>
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com>
 <2584820.Vd5p0uzRAK@vostro.rjw.lan>
 <20121107095842.GY24532@intel.com>
 <1493573.krE1QVlUux@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1493573.krE1QVlUux@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2012 at 12:14:31PM +0100, Rafael J. Wysocki wrote:
> > So is the idea now that the ACPI core parses the resources and passes them
> > forward via struct acpi_device? I'm just wondering how to proceed with
> > these I2C and SPI enumeration patches.
> 
> Well, we definitely don't want to duplicate what drivers/pnp/pnpacpi/rsparser.c
> does, so the idea is to move the code from there to the core in such a way that
> both the SPI/I2C patches and the PNP layer can use it.

Ok.

> I'll have some prototype code ready shortly, hopefully, and I'll post it
> in that form for comments (and so that you know what to expect).

Sounds good. Thanks!
