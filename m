Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631Ab1F3Pcv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 11:32:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34535 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751190Ab1F3Pct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 11:32:49 -0400
Date: Thu, 30 Jun 2011 08:32:45 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
Cc: "jic23@cam.ac.uk" <jic23@cam.ac.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dajun <dajun.chen@diasemi.com>,
        "grant@secretlab.ca" <grant@secretlab.ca>
Subject: Re: [PATCH 02/11] GPIO: DA9052 GPIO module v1
Message-ID: <20110630152852.GC3249@opensource.wolfsonmicro.com>
References: <1309355591.2344.4.camel@L-0532.kpit.com>
 <20110630053711.GB796@opensource.wolfsonmicro.com>
 <E2CAE7F7B064EA49B5CE7EE9A4BB167D152EB8925D@KCINPUNHJCMS01.kpit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E2CAE7F7B064EA49B5CE7EE9A4BB167D152EB8925D@KCINPUNHJCMS01.kpit.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 05:10:31PM +0530, Ashish Jangam wrote:

> > Why insist on platform data?  gpiolib can dynamically allocate a GPIO
> > range to the device.

> Do you mean to use gpiochip_reserve() in machine file and not to have
> ngpio and base defined in GPIO platform driver but, this will fail the
> call to gpiochip_add()?

No, I mean that you should allow gpiolib to allocate a GPIO range if one
is not already allocated like other gpiolib drivers do by supplying -1
as the base.
