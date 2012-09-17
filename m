Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872Ab2IQLP4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 07:15:56 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38352 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755837Ab2IQLPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 07:15:54 -0400
Date: Mon, 17 Sep 2012 07:15:51 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
Cc: Liam Girdwood <lrg@ti.com>, Guenter Roeck <linux@roeck-us.net>,
        Jean Delvare <khali@linux-fr.org>, Randy Dunlap <rdunlap@xenotime.net>,
        LKML <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Subject: Re: [NEW DRIVER V3 8/8] DA9058 REGULATOR driver
Message-ID: <20120917111550.GE5401@opensource.wolfsonmicro.com>
References: <201208151518.q7FFILAM011604@latitude.olech.com>
 <20120827165057.GK4339@opensource.wolfsonmicro.com>
 <24DF37198A1E704D9811D8F72B87EB51032CC96A@NB-EX-MBX02.diasemi.com>
 <20120917104017.GB5401@opensource.wolfsonmicro.com>
 <24DF37198A1E704D9811D8F72B87EB51032CC993@NB-EX-MBX02.diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24DF37198A1E704D9811D8F72B87EB51032CC993@NB-EX-MBX02.diasemi.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 10:49:22AM +0000, Opensource [Anthony Olech] wrote:

> I thought that the set_voltage_sel = regulator_set_voltage_sel_regmap callback first
> set the target voltage, and that the set_voltage_time_sel = da9058_buck_ramp_voltage
> callback was called afterwards?

> was I wrong?

That will currently happen but we might also decide to query the ramp
time first, or we might decide to query the ramp time totally separately
to actually changing the voltage (to decide when we will want to change
the voltage in DVFS situations for example).
