Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807Ab3AJNF2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 08:05:28 -0500
Received: from mga03.intel.com ([143.182.124.21]:10381 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753998Ab3AJNF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 08:05:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,444,1355126400"; 
   d="scan'208";a="242277278"
Date: Thu, 10 Jan 2013 15:08:43 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, eric.y.miao@gmail.com,
        linux@arm.linux.org.uk, haojian.zhuang@gmail.com, chao.bi@intel.com,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH 05/11] spi/pxa2xx: make clock rate configurable from
 platform data
Message-ID: <20130110130843.GQ13897@intel.com>
References: <1357555480-24022-1-git-send-email-mika.westerberg@linux.intel.com>
 <20130110095803.GJ13897@intel.com>
 <20130110123837.GO13897@intel.com>
 <2921304.SsX3sQo2BU@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2921304.SsX3sQo2BU@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2013 at 01:54:41PM +0100, Rafael J. Wysocki wrote:
> > 
> > I'm not sure about the LPSS PCI case. Maybe we can forget that for now
> > (except the CE4100 case which obviously must work)? Or add similar quirk to
> > the PCI side that creates the platform device for clocks.
> 
> I would wait for now until we have evidence that the LPSS PCI will be used in
> practice at all.  Then we can add a PCI quirk along the above lines, I think.

Sounds good to me. Thanks!
