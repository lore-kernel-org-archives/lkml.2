Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751752Ab3AJNzZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 08:55:25 -0500
Received: from mga02.intel.com ([134.134.136.20]:57346 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800Ab3AJNzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 08:55:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,444,1355126400"; 
   d="scan'208";a="270478553"
Date: Thu, 10 Jan 2013 15:58:52 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        grant.likely@secretlab.ca, linus.walleij@linaro.org,
        eric.y.miao@gmail.com, linux@arm.linux.org.uk,
        haojian.zhuang@gmail.com, chao.bi@intel.com,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH 05/11] spi/pxa2xx: make clock rate configurable from
 platform data
Message-ID: <20130110135852.GS13897@intel.com>
References: <1357555480-24022-1-git-send-email-mika.westerberg@linux.intel.com>
 <2921304.SsX3sQo2BU@vostro.rjw.lan>
 <20130110125159.GQ20956@opensource.wolfsonmicro.com>
 <90529114.hOo9bzgA6o@vostro.rjw.lan>
 <20130110133319.GT20956@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130110133319.GT20956@opensource.wolfsonmicro.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2013 at 01:33:19PM +0000, Mark Brown wrote:
> On Thu, Jan 10, 2013 at 02:18:08PM +0100, Rafael J. Wysocki wrote:
> > On Thursday, January 10, 2013 12:51:59 PM Mark Brown wrote:
> 
> > > Sounds sensible, yes - about what I'd expect.  Is it possible to match
> > > on CPUID or similar information (given that this is all in the SoC)
> > > instead of ACPI, that might be more robust I guess?
> 
> > This particular part may be present in different SoCs.
> 
> Right, but I'd expect you could enumerate the SoCs?  Someone might
> decide to change the clock configuration for future SoCs anyway.

Well, they can use the same LPSS block with a different CPU but then we
expect the ACPI IDs to change as well (so we can then make another set of
clocks for those).
