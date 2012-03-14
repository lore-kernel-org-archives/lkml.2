Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896Ab2CMPsl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 11:48:41 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:46883 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927Ab2CMPsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 11:48:39 -0400
Subject: Re: [PATCH] Added backlight driver for Acer Aspire 4736
From: Pradeep Subrahmanion <subrahmanion.pradeep@gmail.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: rpurdie@rpsys.net, FlorianSchandinat@gmx.de, akpm@linux-foundation.org,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20120313133458.GA11574@srcf.ucam.org>
References: <1331608337.2267.67.camel@debian.Gayathri>
	 <20120312175130.GA18002@srcf.ucam.org>
	 <1331640592.3485.50.camel@debian.Gayathri>
	 <20120313124738.GB10822@srcf.ucam.org>
	 <CABNxG=Dqg26EHmC3vibf3-SjVhby1qgQfMniQObUeh9eJ6SwEw@mail.gmail.com>
	 <20120313133458.GA11574@srcf.ucam.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Mar 2012 21:24:54 -0400
Message-ID: <1331688294.2577.19.camel@debian.Gayathri>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-13 at 13:34 +0000, Matthew Garrett wrote:
> On Tue, Mar 13, 2012 at 06:56:16PM +0530, Pradeep Subrahmanion wrote:
> > I tried giving acpi_backlight = vendor . In that case hot key for
> > brightness control is working. But i think  , it is not calculating the
> > correct value for brightness because increasing brightness after maximum
> > level gives blank screen .
> 
> Which backlight device appears then?
> 

'intel_backlight' appears when i gave option acpi_backlight = vendor. Writing to /sys/class/backlight/intel_backlight/brightness

does not cause any change in brightness.

> > By ' ACPI interface' , I mean 'acpi_video0' inside the
> > /sys/class/backlight. I havn't tried the /sys/class/backlight interface
> > directly . I will try that also.
> 
> So writing values into /sys/class/backlight/acpi_video0/brightness does 
> nothing?


No change in value when writing
to /sys/class/backlight/acpi_video0/brightness.

Another thing is that when i did boot with acpi_backlight = 'acer_wmi' ,
in new kernel (3.3.0-rc7) , it shows following messages , 

[    8.350825] wmi: Mapper loaded
[   10.363975] acer_wmi: Acer Laptop ACPI-WMI Extras
[   10.396186] acer_wmi: Function bitmap for Communication Device: 0x91
[   10.396385] acer_wmi: Brightness must be controlled by generic video
driver

Also there was no interface inside /sys/class/backlight for acer_wmi. 

I also tried writing directly to Embedded controller register .But no
change.

----

Thanks , 

Pradeep Subrahmanion
  


