Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682Ab1AFP5a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 10:57:30 -0500
Received: from imr4.ericy.com ([198.24.6.8]:43344 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753665Ab1AFP52 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 10:57:28 -0500
Date: Thu, 6 Jan 2011 07:56:41 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Urs Fleisch <urs.fleisch@gmail.com>
CC: Jonathan Cameron <jic23@cam.ac.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LM Sensors <lm-sensors@lm-sensors.org>,
        Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH V4] hwmon: driver for Sensirion SHT21 humidity and
 temperature sensor
Message-ID: <20110106155641.GA9319@ericsson.com>
References: <20101229134511.cc466ac0.urs.fleisch@gmail.com>
 <4D1DF097.1080200@cam.ac.uk>
 <20110103081448.f96c413e.urs.fleisch@gmail.com>
 <4D21ADCB.4070206@cam.ac.uk>
 <1294078159.9786.9.camel@groeck-laptop>
 <4D230ED0.8060008@cam.ac.uk>
 <20110104152837.GA32138@ericsson.com>
 <20110104200001.3328dae3.urs.fleisch@gmail.com>
 <1294170132.9786.52.camel@groeck-laptop>
 <20110106084338.d31624e3.urs.fleisch@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110106084338.d31624e3.urs.fleisch@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 06, 2011 at 02:43:38AM -0500, Urs Fleisch wrote:
> Thanks for the review, Jonathan and Guenter.
> 
> Changes:
> - removed user register related sysfs attributes, keeping only temp1_input and
>   humidity1_input
> - cleaned up code flow when returning errors for better readability
> 
> Regards,
> Urs
> 
> Signed-off-by: Urs Fleisch <urs.fleisch@sensirion.com>

Urs,

what tree is your patch based on ? I am having trouble applying it.

Guenter
