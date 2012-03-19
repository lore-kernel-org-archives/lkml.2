Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758836Ab2CSRDd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 13:03:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37553 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756327Ab2CSRDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 13:03:31 -0400
Subject: Re: [PATCH] Added backlight driver for Acer Aspire 4736
From: Pradeep Subrahmanion <subrahmanion.pradeep@gmail.com>
To: joeyli <jlee@suse.com>
Cc: Matthew Garrett <mjg@redhat.com>, rpurdie@rpsys.net,
        FlorianSchandinat@gmx.de, akpm@linux-foundation.org,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1332122514.10557.270.camel@linux-s257.site>
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
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Mar 2012 17:03:13 +0530
Message-ID: <1332156793.2964.3.camel@debian.Gayathri>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> For the maximum level causes blank screen...
> 
> Please kindly help to identify which driver handle the brightness
> change, run the following 2 commands:
> 
> # echo 5 > /sys/class/backlight/acer-wmi/brightness 
> # echo 5 > /sys/class/backlight/intel_backlight/brightness 
> 
> Which one works to change brightness on your machine?

	Both  of them do not work for me.Only hot keys are working. 

Writing to /sys/class/backlight/acer-wmi/brightness 

and /sys/class/backlight/intel_backlight/brightness do not cause any 

change in brightness.


Regards , 

Pradeep Subrahmanion

> 
> 
> Thanks a lot!
> Joey Lee




