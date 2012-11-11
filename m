Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093Ab2KKJrE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 04:47:04 -0500
Received: from mga14.intel.com ([143.182.124.37]:51060 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496Ab2KKJrC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 04:47:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,756,1344236400"; 
   d="scan'208";a="216074466"
Date: Sun, 11 Nov 2012 11:50:11 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>,
        linux-kernel@vger.kernel.org, lenb@kernel.org,
        rafael.j.wysocki@intel.com, broonie@opensource.wolfsonmicro.com,
        linus.walleij@linaro.org, khali@linux-fr.org, ben-linux@fluff.org,
        w.sang@pengutronix.de, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 1/3] gpio / ACPI: add ACPI support
Message-ID: <20121111095011.GJ16012@intel.com>
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com>
 <1351928793-14375-2-git-send-email-mika.westerberg@linux.intel.com>
 <CACxGe6tVcqoSg03JtcTdLP5GakyKM-24D8uK2mQj+1iiSE8Yog@mail.gmail.com>
 <20121108193808.GB16012@intel.com>
 <509D0F1F.70001@linux.intel.com>
 <CACxGe6sgNEqEhiXC_EoBuAg+QaaRis_4eRb7s5k0MKtfZF-3dA@mail.gmail.com>
 <509D1BC5.7020208@linux.intel.com>
 <CACxGe6uBqSZfHTDPAr3xTXTjOYrrn-AAM5kRkZ=nfVPGCT6z=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACxGe6uBqSZfHTDPAr3xTXTjOYrrn-AAM5kRkZ=nfVPGCT6z=Q@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 09, 2012 at 03:46:58PM +0000, Grant Likely wrote:
> > I guess It's possible to write a driver like that.
> > The only acpi enumerated driver with the acpi_handle set (soon coming to
> > upstream) is not done like that.
> >
> > Do you think this is a case that should be solved now?  or just expect acpi
> > gpio device driver to not use several gpiochips in one driver?
> 
> Look at what the DT code does. It is actually pretty easy to solve. I
> would do it now, but I won't block the changes if you do not.

I think for now we just implement the single gpiochip solution and once (if
ever) there emerges need for multiple gpiochips in a single driver, we add
the support then.
