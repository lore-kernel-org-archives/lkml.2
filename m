Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353Ab1AFPWo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 10:22:44 -0500
Received: from imr4.ericy.com ([198.24.6.8]:48863 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753121Ab1AFPWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 10:22:43 -0500
Date: Thu, 6 Jan 2011 07:21:52 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
CC: Urs Fleisch <urs.fleisch@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LM Sensors <lm-sensors@lm-sensors.org>,
        Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH V4] hwmon: driver for Sensirion SHT21 humidity and
 temperature sensor
Message-ID: <20110106152152.GB9053@ericsson.com>
References: <4D1DF097.1080200@cam.ac.uk>
 <20110103081448.f96c413e.urs.fleisch@gmail.com>
 <4D21ADCB.4070206@cam.ac.uk>
 <1294078159.9786.9.camel@groeck-laptop>
 <4D230ED0.8060008@cam.ac.uk>
 <20110104152837.GA32138@ericsson.com>
 <20110104200001.3328dae3.urs.fleisch@gmail.com>
 <1294170132.9786.52.camel@groeck-laptop>
 <20110106084338.d31624e3.urs.fleisch@gmail.com>
 <4D25A04F.7070304@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4D25A04F.7070304@cam.ac.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 06, 2011 at 05:58:23AM -0500, Jonathan Cameron wrote:
> On 01/06/11 07:43, Urs Fleisch wrote:
> > Thanks for the review, Jonathan and Guenter.
> > 
> > Changes:
> > - removed user register related sysfs attributes, keeping only temp1_input and
> >   humidity1_input
> > - cleaned up code flow when returning errors for better readability
> Short and clean. I do wonder if you want some of those users register
> bits available via platform data though.  Perhaps that can be added in
> a later patch as and when someone needs them.

Only thing missing is Documentation/hwmon/sht21.

Urs, can you add that ? 

Thanks,
Guenter
