Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249Ab1AGL4k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 06:56:40 -0500
Received: from imr3.ericy.com ([198.24.6.13]:45745 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751595Ab1AGL4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 06:56:38 -0500
Date: Fri, 7 Jan 2011 03:55:41 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Urs Fleisch <urs.fleisch@gmail.com>
CC: Jonathan Cameron <jic23@cam.ac.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LM Sensors <lm-sensors@lm-sensors.org>,
        Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH V5] hwmon: driver for Sensirion SHT21 humidity and
 temperature sensor
Message-ID: <20110107115541.GA14095@ericsson.com>
References: <20110103081448.f96c413e.urs.fleisch@gmail.com>
 <4D21ADCB.4070206@cam.ac.uk>
 <1294078159.9786.9.camel@groeck-laptop>
 <4D230ED0.8060008@cam.ac.uk>
 <20110104152837.GA32138@ericsson.com>
 <20110104200001.3328dae3.urs.fleisch@gmail.com>
 <1294170132.9786.52.camel@groeck-laptop>
 <20110106084338.d31624e3.urs.fleisch@gmail.com>
 <20110106155641.GA9319@ericsson.com>
 <20110107081539.df496517.urs.fleisch@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110107081539.df496517.urs.fleisch@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 07, 2011 at 02:15:39AM -0500, Urs Fleisch wrote:
> > Only thing missing is Documentation/hwmon/sht21.
> >
> > Urs, can you add that ?
> I have added a file Documentation/hwmon/sht21 to the patch.
> 
> > what tree is your patch based on ? I am having trouble applying it.
> I used the 2.6.32 kernel from the rowboat project
> (http://code.google.com/p/rowboat/) because my sensor is connected to an
> OMAP3EVM board. To make the patch applicable for the latest kernel, I added
> a line to the Makefile patch. I could apply the patch without problems to
> the linux-next kernel, although patch reported fuzz with Kconfig. The patch
> below is now based on linux-next, so there should be no longer problems.
> 
> Thanks,
> Urs
> 
> Signed-off-by: Urs Fleisch <urs.fleisch@sensirion.com>

Applied to -next, with Jonathan's Acked-by and multi-line comments changed
to adhere to Documentation/CodingStyle.

Thanks,
Guenter
