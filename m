Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933263Ab1KCRGR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 13:06:17 -0400
Received: from imr4.ericy.com ([198.24.6.9]:34542 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755293Ab1KCRGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 13:06:16 -0400
Subject: Re: [lm-sensors] Hardware running hot and without the fan
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: Jean Delvare <khali@linux-fr.org>
CC: "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Lars =?ISO-8859-1?Q?Nood=E9n?= <lars.nooden@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1320339328.2309.78.camel@groeck-laptop>
References: <4EB1108F.6070009@gmail.com>
	 <20111103020301.GA22333@ericsson.com>	<4EB250FD.3070000@gmail.com>
	 <20111103134902.GA26121@ericsson.com>	<4EB2A46B.8080600@gmail.com>
	 <1320332801.2309.60.camel@groeck-laptop>	<4EB2B0FD.309@gmail.com>
	 <1320334322.2309.68.camel@groeck-laptop>
	 <20111103174321.37274532@endymion.delvare>
	 <1320339328.2309.78.camel@groeck-laptop>
Content-Type: text/plain; charset="UTF-8"
Organization: Ericsson
Date: Thu, 3 Nov 2011 10:04:30 -0700
Message-ID: <1320339870.2309.79.camel@groeck-laptop>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-03 at 12:55 -0400, Guenter Roeck wrote:
> On Thu, 2011-11-03 at 12:43 -0400, Jean Delvare wrote:
> > On Thu, 3 Nov 2011 08:32:02 -0700, Guenter Roeck wrote:
> > > On Thu, 2011-11-03 at 11:19 -0400, Lars Noodén wrote:
> > > > I can set the fan speed manually.  e.g.:
> > > > 
> > > >  echo 3500 > /sys/class/hwmon/hwmon0/device/fan1_output
> > > > 
> > > > That helps some.
> > > > 
> > > If you can do that, you should be able to set up fancontrol to
> > > automatically control fan speed based on system temperatures.
> > 
> > This won't work, as fancontrol wants pwmX attributes which the applesmc
> > driver doesn't implement.
> > 
> Yes, you are right - it won't work without patching it to use
> fanX_output and to accept larger values for the limits.
> 
> Wonder how this works for other Apple systems. Maybe there is an
> Apple-specific script out there to control fan speed.
> 
> > > There is another sysfs attribute - fanX_manual. I don't find driver
> > > documentation, so I have no idea what it is doing. The name indicates
> > > that it might set manual vs. automatic fan control. What is it set to in
> > > your system ? From the code, looks like it should be 0 or 1. Try to
> > > toggle it and see what happens - after all, it can not get worse ;).
> > 
> > Might be worth looking at files fanX_min, _max and _safe too. Too bad
> > there doesn't seem to be any documentation available for all these
> > non-standard attributes :(
> > 
> Here is some info from the web about the problem. See
> http://ubuntuforums.org/archive/index.php/t-981280.html.
> 
The above link points to

https://wiki.ubuntu.com/MacBookPro/SantaRosaFanControl

which provides a script to control fan speed on MAC systems.

Guenter


