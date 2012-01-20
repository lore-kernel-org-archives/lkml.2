Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722Ab2ATKAJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 05:00:09 -0500
Received: from imr4.ericy.com ([198.24.6.9]:40481 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752447Ab2ATKAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 05:00:07 -0500
Date: Fri, 20 Jan 2012 01:57:42 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Axel Lin <axel.lin@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sonic Zhang <sonic.zhang@analog.com>,
        Marc Pignat <marc.pignat@hevs.ch>, Paul Thomas <pthomas8589@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>, Jean Delvare <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH 2/2] hwmon: convert drivers/hwmon/* to use
 module_spi_driver()
Message-ID: <20120120095742.GB31838@ericsson.com>
References: <1327046027.2411.0.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1327046027.2411.0.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 20, 2012 at 02:53:47AM -0500, Axel Lin wrote:
> This patch converts the drivers in drivers/hwmon/* to use the
> module_spi_driver() macro which makes the code smaller and a bit simpler.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> Cc: Sonic Zhang <sonic.zhang@analog.com>
> Cc: Marc Pignat <marc.pignat@hevs.ch>
> Cc: Paul Thomas <pthomas8589@gmail.com>
> Cc: Eric Miao <eric.y.miao@gmail.com>
> Acked-by: Sonic Zhang <sonic.zhang@analog.com>
> ---
>  drivers/hwmon/ad7314.c  |   12 +-----------
>  drivers/hwmon/adcxx.c   |   13 +------------
>  drivers/hwmon/ads7871.c |   13 +------------
>  drivers/hwmon/lm70.c    |   13 +------------
>  drivers/hwmon/max1111.c |   12 +-----------
>  5 files changed, 5 insertions(+), 58 deletions(-)
> 
Applied.

Thanks,
Guenter
