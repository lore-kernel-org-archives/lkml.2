Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264Ab1K0BkJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 20:40:09 -0500
Received: from imr4.ericy.com ([198.24.6.9]:58713 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755232Ab1K0BkG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 20:40:06 -0500
Date: Sat, 26 Nov 2011 17:37:35 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Axel Lin <axel.lin@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Donggeun Kim <dg77.kim@samsung.com>, Simon Guinot <sguinot@lacie.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        MyungJoo Ham <myungjoo.ham@samsung.com>, Ben Dooks <ben@simtec.co.uk>,
        Hans de Goede <hdegoede@redhat.com>, J Keerthy <j-keerthy@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jean Delvare <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH] hwmon: convert drivers/hwmon/* to use
 module_platform_driver()
Message-ID: <20111127013735.GA24906@ericsson.com>
References: <1322206260.11718.4.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1322206260.11718.4.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 25, 2011 at 02:31:00AM -0500, Axel Lin wrote:
> This patch converts the drivers in drivers/hwmon/* to use the
> module_platform_driver() macro which makes the code smaller and a bit
> simpler.
> 
> Cc: Donggeun Kim <dg77.kim@samsung.com>
> Cc: Simon Guinot <sguinot@lacie.com>
> Cc: Lars-Peter Clausen <lars@metafoo.de>
> Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
> Cc: Ben Dooks <ben@simtec.co.uk>
> Cc: Hans de Goede <hdegoede@redhat.com>
> Cc: J Keerthy <j-keerthy@ti.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied. I'll let it rest in linux-next for a couple of days and send it to Linus
if there are no problems.

Guenter
