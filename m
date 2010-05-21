Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473Ab0EUOsJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 10:48:09 -0400
Received: from bamako.nerim.net ([62.4.17.28]:63220 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756214Ab0EUOsA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 10:48:00 -0400
Date: Fri, 21 May 2010 16:47:57 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>
Cc: "Datta, Shubhrajyoti" <shubhrajyoti@ti.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       LM Sensors <lm-sensors@lm-sensors.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: Re: [RFC] [PATCH] TMP105 : Driver support for the  temperature
 sensor
Message-ID: <20100521164757.50186c8f@hyperion.delvare>
In-Reply-To: <4BF687DC.7090108@jic23.retrosnub.co.uk>
References: <0680EC522D0CC943BC586913CF3768C003B32B3AC4@dbde02.ent.ti.com>
	<4BF687A0.4040203@jic23.retrosnub.co.uk>
	<4BF687DC.7090108@jic23.retrosnub.co.uk>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 May 2010 14:17:16 +0100, Jonathan Cameron wrote:
> cc'ing lm-sensors (where this should have gone, this has nothing to do with input).
> > On 05/21/10 13:17, Datta, Shubhrajyoti wrote:
> >>
> >> Adds the driver support for the TMP105 temperature sensor device. The interface is I2C.The driver supports the read of the temperature values.
> >>
> >> Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
> > This device looks at first glance to be pretty similar to the TMP101 as supported
> > by the lm75 driver.  Would it make more sense to merge this support into that
> > driver?
> > 
> > I've not read the data sheets that closely so may have missed something!

We also have a brand new driver for the TMP102, so it might be worth
comparing with that one too.

-- 
Jean Delvare
