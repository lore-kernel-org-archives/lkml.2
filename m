Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030987Ab2CVQQ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 12:16:57 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:48455 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030783Ab2CVQQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 12:16:54 -0400
Subject: Re: [PATCH] Added backlight driver for Acer Aspire 4736
From: Pradeep Subrahmanion <subrahmanion.pradeep@gmail.com>
To: joeyli <jlee@suse.com>
Cc: Matthew Garrett <mjg@redhat.com>, rpurdie@rpsys.net,
        FlorianSchandinat@gmx.de, akpm@linux-foundation.org,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1332408881.10557.416.camel@linux-s257.site>
References: <1331608337.2267.67.camel@debian.Gayathri>
	 <20120312175130.GA18002@srcf.ucam.org>
	 <1331640592.3485.50.camel@debian.Gayathri>
	 <20120313124738.GB10822@srcf.ucam.org>
	 <CABNxG=Dqg26EHmC3vibf3-SjVhby1qgQfMniQObUeh9eJ6SwEw@mail.gmail.com>
	 <20120313133458.GA11574@srcf.ucam.org>
	 <1331688294.2577.19.camel@debian.Gayathri>
	 <1331680373.10557.169.camel@linux-s257.site>
	 <1331692996.3052.8.camel@debian.Gayathri>
	 <1331704278.10557.190.camel@linux-s257.site>
	 <CABNxG=D3y2GQqS1XN=+B0QRScXpufBkPQtP5-SSNEjSavhtW7g@mail.gmail.com>
	 <1331798740.10557.245.camel@linux-s257.site>
	 <1332047432.6304.13.camel@debian.Gayathri>
	 <1332122514.10557.270.camel@linux-s257.site>
	 <1332241764.10557.329.camel@linux-s257.site>
	 <1332269710.3921.31.camel@debian.Gayathri>
	 <1332298845.10557.343.camel@linux-s257.site>
	 <1332356993.3103.23.camel@debian.Gayathri>
	 <1332380037.10557.398.camel@linux-s257.site>
	 <1332383623.2622.6.camel@debian.Gayathri>
	 <1332386725.10557.402.camel@linux-s257.site>
	 <1332387122.2622.9.camel@debian.Gayathri>
	 <1332388489.10557.406.camel@linux-s257.site>
	 <CABNxG=D-JJgD72Wv3hpui0CiprW25MvBzCKcNt-+twAD72+Eyg@mail.gmail.com>
	 <1332408881.10557.416.camel@linux-s257.site>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Mar 2012 21:47:19 +0530
Message-ID: <1332433039.2777.4.camel@debian.Gayathri>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-22 at 17:34 +0800, joeyli wrote:
> 於 四，2012-03-22 於 11:26 +0530，Pradeep Subrahmanion 提到：
> > >From acer acpi ,I came to know that the 4730 series uses new wmi interface .
> > 
> > http://code.google.com/p/aceracpi/wiki/SupportedHardware
> > 
> 
> I am not sure what is the WMIDv2, but it's not the current WMI v2 in
> acer-wmi driver.
> 
> > Thanks ,
> > 
> > Pradeep Subrahmanion
> > 
> > On Thu, Mar 22, 2012 at 9:24 AM, joeyli <jlee@suse.com> wrote:
> > > 於 四，2012-03-22 於 09:02 +0530，Pradeep Subrahmanion 提到：
> > >> On Thu, 2012-03-22 at 11:25 +0800, joeyli wrote:
> > >> > 於 四，2012-03-22 於 08:03 +0530，Pradeep Subrahmanion 提到：
> > >> > > On Thu, 2012-03-22 at 09:33 +0800, joeyli wrote:
> > >> > > > 於 四，2012-03-22 於 00:39 +0530，Pradeep Subrahmanion 提到：
> > >> > > > > > This new patch should remove acpi_video0 interface on your machine.
> > >> > > > > > Please kindly provide your dmidecode:
> > >> > > > > >  dmidecode > dmidecode.log
> > >> > > > > >
> > >> > > > > > And,
> > >> > > > > > please make should the patch really applied, you can do a bit change on
> > >> > > > > > pr_info message by yourself.
> > >> > > > >
> > >> > > > >    Sorry . I think there was some mistake . I tried the patch again. Now
> > >> > > > > I see only intel_backlight inside /sys/class/backlight. There is no
> > >> > > > > acer-wmi interface . Is this the expected behavior ? . Or am I missing
> > >> > > > > anything ?
> > >> > > > >
> > >> > > >
> > >> > > > Yes, this is the expected behavior! But, now I doubt your issue was
> > >> > > > workaround by acpi_osi=Linux but not intel_backlight.
> > >> > > >
> > >> > >
> > >> > > > >
> > >> > > > >
> > >> > > > > >
> > >> > > > > > > echo 5 > /sys/class/backlight/acpi_video0/brightness
> > >> > > > > > > echo 5 > /sys/class/backlight/intel_backlight/brightness
> > >> > > > > > >
> > >> > > > > > > But it doesn't make any change .
> > >> > > > > > >
> > >> > > > > > > In my case  , 'acpi_backlight = vendor' does not make any difference since the hot key control
> > >> > > > > > >
> > >> > > > > > > already starts working with 'acpi_osi=Linux' option.
> > >> > > > > > >
> > >> > > > > > > cat /proc/cmdline gives ,
> > >> > > > > > >
> > >> > > > > > > BOOT_IMAGE=/boot/vmlinuz-3.3.0+
> > >> > > > > > > root=UUID=f0197a59-c067-4fd8-ad90-c4d721816077 ro acpi_osi=Linux
> > >> > > > > > >
> > >> > > > > > >
> > >> > > > > > > Thanks ,
> > >> > > > > > >
> > >> > > > > > > Pradeep Subrahmanion
> > >> > > > > > >
> > >> > > > > >
> > >> > > > > > OK, that's more clearly, please remove acpi_osi=Linux then re-test, I
> > >> > > > > > think the hotkey of backlight control only works with acpi_osi=Linux ?
> > >> > > > > >
> > >> > > >
> > >> > > > Does your backlight control still work if you remove acpi_osi=Linux ?
> > >> > >
> > >> > >    If I remove acpi_osi=Linux , the hot key control stops working .
> > >> > >
> > >> >
> > >> > What is the preload OS in your machine when you bought it? Windows XP,
> > >> > Vista or Windows 7?
> > >>
> > >>    It was Windows XP.
> > >>
> > >
> > > The WDDM driver didn't support by Windows XP, the brightness control on
> > > XP should works with _BCM or OpRegion.
> > >
> > > Wonder how does brightness control work on XP with your machine.
> > >
> > > I will dig more in your dsdt...
> > >
> > >
> 
> Please kindly try acpi_osi="!Windows 2006", I think it also works to
> you.

   I tried giving this option . It gives me a blank screen while
booting. Hot keys are not working .


> 
> 
> Thanks
> Joey Lee
> 


Regards, 

Pradeep Subrahmanion.


