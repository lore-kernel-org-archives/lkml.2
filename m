Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011Ab2KTNyE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 08:54:04 -0500
Received: from mga11.intel.com ([192.55.52.93]:37582 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876Ab2KTNyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 08:54:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,285,1352102400"; 
   d="scan'208";a="249980733"
Date: Tue, 20 Nov 2012 15:57:17 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: grant.likely@secretlab.ca, linus.walleij@linaro.org, w.sang@pengutronix.de,
        rafael.j.wysocki@intel.com, linux-kernel@vger.kernel.org,
        lenb@kernel.org, broonie@opensource.wolfsonmicro.com,
        khali@linux-fr.org, ben-linux@fluff.org, bhelgaas@google.com,
        mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v3 3/3] i2c / ACPI: add ACPI enumeration support
Message-ID: <20121120135717.GA3867@intel.com>
References: <1352977397-2280-1-git-send-email-mika.westerberg@linux.intel.com>
 <1353407384-26880-1-git-send-email-mika.westerberg@linux.intel.com>
 <1353407384-26880-4-git-send-email-mika.westerberg@linux.intel.com>
 <2231474.figQz3Mgq6@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2231474.figQz3Mgq6@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 02:06:46PM +0100, Rafael J. Wysocki wrote:
> On Tuesday, November 20, 2012 12:29:44 PM Mika Westerberg wrote:
> > ACPI 5 introduced I2cSerialBus resource that makes it possible to enumerate
> > and configure the I2C slave devices behind the I2C controller. This patch
> > adds helper functions to support I2C slave enumeration.
> > 
> > An ACPI enabled I2C controller driver only needs to call acpi_i2c_register_devices()
> > in order to get its slave devices enumerated, created and bound to the
> > corresponding ACPI handle.
> 
> My comments from the SPI patch apply here too almost verbatim. :-)

OK.

Thanks for the comments. I'll wait a bit to get comments from other
subsystem maintainers (I hope they comment something) and then do v4 with
all comments addressed.
