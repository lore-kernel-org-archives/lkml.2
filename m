Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930Ab1AEL0n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 06:26:43 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:41804 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591Ab1AEL0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 06:26:42 -0500
Date: Wed, 5 Jan 2011 11:26:38 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: Lukasz Majewski <l.majewski@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Alessandro Zummo <a.zummo@towertech.it>,
        ?????? <kyungmin.park@samsung.com>, ?????? <jy0922.shim@samsung.com>,
        "myungjoo.ham@gmail.com" <myungjoo.ham@gmail.com>
Subject: Re: Re: [PATCH v4 2/3] regulator MAX8998/LP3974: Support DVS-GPIO.
Message-ID: <20110105112638.GB10317@sirena.org.uk>
References: <24564862.361211294188865120.JavaMail.weblogic@epml11>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24564862.361211294188865120.JavaMail.weblogic@epml11>
X-Cookie: APL hackers do it in the quad.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 05, 2011 at 12:54:25AM +0000, MyungJoo Ham wrote:

> Yes, it is supposed to be faster to set GPIO pins rather than sending
> values thru I2C busses. And some boards require all the four BUCK1
> voltages and two BUCK2 voltages; e.g., S5PC110-Universal.

Obviously the expectation there would be that the automatic stuff would
figure out the set of voltages that are in use and end up using the
GPIOs almost all the time anyway.
