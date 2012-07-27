Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011Ab2G0HbA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 03:31:00 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:11787 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab2G0Ha7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 03:30:59 -0400
Date: Fri, 27 Jul 2012 09:30:37 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Wei Ni <wni@nvidia.com>
Cc: Zhang Rui <rui.zhang@intel.com>, "R, Durgadoss" <durgadoss.r@intel.com>,
        "Brown, Len" <len.brown@intel.com>, akpm@linux-foundation.org,
        joe@perches.com, linux-kernel@vger.kernel.org,
        linux-tegra@ger.kernel.org, Alex Courbot <acourbot@nvidia.com>
Subject: Re: How to use the generic thermal sysfs.
Message-ID: <20120727093037.094335eb@endymion.delvare>
In-Reply-To: <1343357901.4042.70.camel@tegra-chromium-2>
References: <1342088573.27605.101.camel@tegra-chromium-2>
	<4D68720C2E767A4AA6A8796D42C8EB5915287C@BGSMSX101.gar.corp.intel.com>
	<1342144273.1682.237.camel@rui.sh.intel.com>
	<1342164616.27605.129.camel@tegra-chromium-2>
	<1342165278.1682.259.camel@rui.sh.intel.com>
	<1343295094.4042.24.camel@tegra-chromium-2>
	<1343352098.1682.447.camel@rui.sh.intel.com>
	<1343357901.4042.70.camel@tegra-chromium-2>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jul 2012 10:58:21 +0800, Wei Ni wrote:
> On Fri, 2012-07-27 at 09:21 +0800, Zhang Rui wrote:
> > is it possible to program the sensor at this time, in your own thermal
> > driver?
> 
> Since we are using the generic thermal driver lm90.c, I'm not sure if we
> could program these limits in the generic driver, I think it's better to
> have a generic interface to set the limits, so I wish to add a
> callback .set_limits() in the generic thermal framework.

I can confirm that hwmon drivers do not set limits, it is up to
user-space to do it if they want. So if there is a need to do so in the
kernel itself, a proper interface at the generic thermal framework
level seems appropriate.

-- 
Jean Delvare
