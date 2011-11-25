Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595Ab1KYRbv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 12:31:51 -0500
Received: from imr4.ericy.com ([198.24.6.9]:54334 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751883Ab1KYRbu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 12:31:50 -0500
Date: Fri, 25 Nov 2011 09:29:50 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Lars-Peter Clausen <lars@metafoo.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jean Delvare <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH 04/11] hwmon: Remove redundant spi driver bus
 initialization
Message-ID: <20111125172950.GA12324@ericsson.com>
References: <1322148561-25138-1-git-send-email-lars@metafoo.de>
 <1322148561-25138-4-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1322148561-25138-4-git-send-email-lars@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 24, 2011 at 10:29:14AM -0500, Lars-Peter Clausen wrote:
> In ancient times it was necessary to manually initialize the bus field of an
> spi_driver to spi_bus_type. These days this is done in spi_driver_register(),
> so we can drop the manual assignment.
> 
> The patch was generated using the following coccinelle semantic patch:
> // <smpl>
> @@
> identifier _driver;
> @@
> struct spi_driver _driver = {
> 	.driver = {
> -		.bus = &spi_bus_type,
> 	},
> };
> // </smpl>
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> Cc: Jean Delvare <khali@linux-fr.org>
> Cc: Guenter Roeck <guenter.roeck@ericsson.com>
> Cc: lm-sensors@lm-sensors.org

Applied.

Thanks,
Guenter
