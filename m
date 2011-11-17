Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756342Ab1KQJwN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 04:52:13 -0500
Received: from imr4.ericy.com ([198.24.6.9]:42846 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756185Ab1KQJwL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 04:52:11 -0500
Date: Thu, 17 Nov 2011 01:50:17 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Donggeun Kim <dg77.kim@samsung.com>
CC: Paul Bolle <pebolle@tiscali.nl>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7] hwmon: Add driver for EXYNOS4 TMU
Message-ID: <20111117095017.GA22540@ericsson.com>
References: <1315388948-20346-1-git-send-email-dg77.kim@samsung.com>
 <1321389279.20271.241.camel@x61.thuisdomein>
 <1321392253.2309.379.camel@groeck-laptop>
 <4EC4999F.8030604@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4EC4999F.8030604@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 17, 2011 at 12:20:31AM -0500, Donggeun Kim wrote:
[ ... ]
> >>>  
> >>> +config SENSORS_EXYNOS4_TMU
> >>> +	tristate "Temperature sensor on Samsung EXYNOS4"
> >>> +	depends on EXYNOS4_DEV_TMU
> >>
> >> It doesn't look like that Kconfig symbol is part of the tree just yet.
> >> That means people will not be able to build this driver from the
> >> mainline tree. Why is this dependency needed? In a (rather quick) scan
> >> of the code of this driver I couldn't spot anything not yet available in
> >> the tree.
> >>
> > I have to defer to the driver author for that. Maybe the dependency was
> > renamed at some point, or removed altogether.
> > 
> The dependency will be renamed to 'ARCH_EXYNOS4'.
> 
Please submit a patch.

Thanks,
Guenter
