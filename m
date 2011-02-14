Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057Ab1BNQak (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 11:30:40 -0500
Received: from xes-mad.com ([216.165.139.218]:40733 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755957Ab1BNQah (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 11:30:37 -0500
X-Greylist: delayed 2487 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Feb 2011 11:30:35 EST
Subject: Re: [PATCH 1/3] gpiolib: Add ability to get GPIO pin direction
From: Peter Tyser <ptyser@xes-inc.com>
To: linux-kernel@vger.kernel.org
Cc: Alek Du <alek.du@intel.com>, Samuel Ortiz <sameo@linux.intel.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Eric Miao <eric.y.miao@gmail.com>,
        Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Joe Perches <joe@perches.com>,
        "grant.likely" <grant.likely@secretlab.ca>
In-Reply-To: <1294343654-20354-1-git-send-email-ptyser@xes-inc.com>
References: <1294343654-20354-1-git-send-email-ptyser@xes-inc.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Feb 2011 09:48:13 -0600
Message-ID: <1297698493.965.5475.camel@petert>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-06 at 13:54 -0600, Peter Tyser wrote:
> Add a new get_direction() function to the gpio_chip structure.  This is
> useful so that the direction of a pin can be determined when its
> exported.  Previously, the direction defaulted to 'in' regardless of the
> actual configuration of the GPIO pin which resulted in the 'direction'
> sysfs file often being incorrect.
> 
> If a GPIO driver implements get_direction(), it is called in
> gpio_request() to set the initial direction of the pin accurately.

I see Grant was just added as a GPIO maintainer, so added him on CC.

Anything gating getting these 3 patches being picked up?

Thanks,
Peter

