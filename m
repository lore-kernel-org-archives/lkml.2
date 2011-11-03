Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756434Ab1KCRhL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 13:37:11 -0400
Received: from smtprelay-h21.telenor.se ([195.54.99.196]:57692 "EHLO
	smtprelay-h21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755186Ab1KCRhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 13:37:09 -0400
X-SENDER-IP: [85.230.170.217]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq1dAOHQsk5V5qrZPGdsb2JhbAAqGqhggSAZAQEBATcygXIBAQUyASMjEAgDGC4UJQoaiBcGI7RlEoM1hHZiBJlXjCc
X-IronPort-AV: E=Sophos;i="4.69,451,1315173600"; 
   d="scan'208";a="66286935"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Thu, 3 Nov 2011 18:46:35 +0100
To: Lars =?iso-8859-1?Q?Nood=E9n?= <lars.nooden@gmail.com>
Cc: guenter.roeck@ericsson.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: Hardware running hot and without the fan
Message-ID: <20111103174635.GA12229@polaris.bitmath.org>
References: <4EB1108F.6070009@gmail.com>
 <20111103020301.GA22333@ericsson.com>
 <4EB250FD.3070000@gmail.com>
 <20111103134902.GA26121@ericsson.com>
 <4EB2A46B.8080600@gmail.com>
 <1320332801.2309.60.camel@groeck-laptop>
 <4EB2B0FD.309@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4EB2B0FD.309@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 03, 2011 at 05:19:25PM +0200, Lars Noodén wrote:
> On 11/03/2011 05:06 PM, Guenter Roeck wrote:
> > On Thu, 2011-11-03 at 10:25 -0400, Lars Noodén wrote:
> [snip]
> >> The one machine reports one fan and the other two fans.  I haven't found
> >> a way to set the fan speed manually.  The output from sensors
> >> is
> >>  https://bugs.launchpad.net/ubuntu/+source/linux/+bug/881593/comments/44
> >> and here
> >>  https://bugs.launchpad.net/ubuntu/+source/linux/+bug/881593/comments/47
> > 
> > Do the fans actually turn, or is the output bogus ?
> 
> The output is bogus, the fans are not turning.  On #47 there above, I
> think the temperatures might be inaccurate, too.  Since they'll go up
> and down as much as 8 degrees in a few seconds.
> 
> > You should be able to set the fan speed by writing into the fanX_input
> > and/or fanX_output sysfs attributes. You find those
> > in /sys/class/hwmon/hwmon0/device (assuming there is only one hwmon
> > device).
> 
> I can set the fan speed manually.  e.g.:
> 
>  echo 3500 > /sys/class/hwmon/hwmon0/device/fan1_output
> 
> That helps some.

I am confused.

>From what I gather, the fans work, and it should be possible to run
the macfanctld daemon (not fancontrol) to tune the fans.

If there really is a problem with the applesmc, following
http://ubuntuforums.org/showthread.php?t=924096 is a good idea.

However, the root problem is most likely the GPU consuming too much
power. Depending on the exact laptop model, there may or may not be a
viable workaround. If you model is very new, there is most likely and
active thread about it on the ubuntu forums.

After checking around on the forums, if you find that this is still a
fan or temperature sensor problem, and not a GPU problem, then please
restate the problem as exactly as you can.

Thanks.
Henrik
