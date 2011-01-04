Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869Ab1ADTAI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 14:00:08 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50577 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab1ADTAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 14:00:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=OZ1EZxujv5ztNVQZQoD7bjvzxCPT/PPqKjhGj0Zsj4RpF/e0Ok4KQTjHnu/Qm21GTX
         VF8UlYvk+zsAXGvPs0g5A0FTwZbDtIRfzkRw6HB7fhGMTM79n2h2X+MSDSGwRqjcjbnF
         QDHzIixg0Jl/LhSJI3GjCCt1kFslymDM/EIF4=
Date: Tue, 4 Jan 2011 20:00:01 +0100
From: Urs Fleisch <urs.fleisch@gmail.com>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Jonathan Cameron <jic23@cam.ac.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LM Sensors <lm-sensors@lm-sensors.org>,
        Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH] hwmon: driver for Sensirion SHT21 humidity and
 temperature sensor
Message-Id: <20110104200001.3328dae3.urs.fleisch@gmail.com>
In-Reply-To: <20110104152837.GA32138@ericsson.com>
References: <20101229134511.cc466ac0.urs.fleisch@gmail.com>
	<4D1DF097.1080200@cam.ac.uk>
	<20110103081448.f96c413e.urs.fleisch@gmail.com>
	<4D21ADCB.4070206@cam.ac.uk>
	<1294078159.9786.9.camel@groeck-laptop>
	<4D230ED0.8060008@cam.ac.uk>
	<20110104152837.GA32138@ericsson.com>
X-Mailer: Sylpheed 3.1.0beta2 (GTK+ 2.22.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Uses I know of are indeed more general environment monitoring.
> Not seen one of these in conventional hardware monitoring but could be wrong.
> I guess, Urs will have a better idea of where these tend to be used?

Mobile phones could be a promising market for humidity sensors in a Linux system. Fujitsu already sells a mobile phone with built-in temperature and humidity sensors. So we hope to see also Linux-based mobile phones (e.g. Android, MeGoo) with a humidity sensor. Such a sensor could be used to monitor environmental conditions, but there could be other applications too, some of them may not make sense and others can not be foreseen. The humidity sensor could also be used to monitor the hardware of the phone, in this situation, hwmon makes sense. If a sensor can be used for various application, there is probably not one true category. There may be other sensors in hwmon, which can be used for applications other than hardware monitoring. I chose the hwmon directory because the sht15 was already there.

> Highly unusual way of detecting and returning errors.

If this is a problem, I can alter the code. I could also drop all user-register related attributes if they cause problems with the ABI.

Regards,
Urs
