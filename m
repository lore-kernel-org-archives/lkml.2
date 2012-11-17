Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142Ab2KQUHp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 15:07:45 -0500
Received: from mail.wdtv.com ([66.118.69.84]:53239 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752065Ab2KQUHo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 15:07:44 -0500
From: Gene Heskett <gheskett@wdtv.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86, microcode, AMD: Add support for family 16h processors
Date: Sat, 17 Nov 2012 15:07:40 -0500
References: <1353004910-2204-1-git-send-email-boris.ostrovsky@amd.com> <201211171334.34239.gheskett@wdtv.com> <50A7E850.6070708@zytor.com>
In-Reply-To: <50A7E850.6070708@zytor.com>
Cc: Borislav Petkov <bp@alien8.de>, Boris Ostrovsky <boris.ostrovsky@amd.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>, mingo@elte.hu,
        tglx@linutronix.de, herrmann.der.user@googlemail.com,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1256"
Content-Transfer-Encoding: 7bit
Message-Id: <201211171507.41289.gheskett@wdtv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 17 November 2012, H. Peter Anvin wrote:
>On 11/17/2012 10:34 AM, Gene Heskett wrote:>
>
>> And I don't see anything there that looks like a 'patch level'.
>> The ucode obviously can, which is what counts in this game of
>> horseshoes. Perhaps something in that very long 'flags' string?
>
>What kernel version is this?
>
>	-hpa

# uname -a
Linux coyote 2.6.32-122-rtai #rtai SMP Tue Jul 27 12:44:07 CDT 2010 i686 
GNU/Linux

This is a custom made rtai patched kernel used ATM by LinuxCNC (was emc), 
built for driving machinery in the robot, lathe and milling machine 
categories.  With low latency motherboards such as the intel D525MW, it is 
capable of running higher powered stepper motors at quite impressive speeds 
as it can output, thru the std parport, step and dir signals every 20 to 25 
microseconds.

That of course is not on this exact machine, but used in order to maintain 
write it here and nfs it to the box running the lathe or milling machine 
after doing "air" cuts on this machine to prove the code works.  Same 
ubuntu-10.04.4 LTS install on 4 boxes here.

The code carvers for LinuxCNC have working patched 3.4.xx kernels running 
now, but have not yet assembled a new OS install CD release based on these 
patches, with the possibly the Xenomai patchset for user threads will be 
used for the Next Gen release of the install CD.  That seems to be winning 
the performance battle ATM.

Probably more than you wanted to know.  I'm just explaining why the old 
kernel version.  Its all GPLed and can be pulled from links on the 
wiki.linuxcnc.org site.

Thanks hpa.

Cheers, Gene
-- 
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
My web page: <http://coyoteden.dyndns-free.com:85/gene> is up!
World War Three can be averted by adherence to a strictly enforced dress 
code!
