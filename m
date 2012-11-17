Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257Ab2KQUnI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 15:43:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44193 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752149Ab2KQUnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 15:43:06 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <201211171507.41289.gheskett@wdtv.com>
References: <1353004910-2204-1-git-send-email-boris.ostrovsky@amd.com> <201211171334.34239.gheskett@wdtv.com> <50A7E850.6070708@zytor.com> <201211171507.41289.gheskett@wdtv.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] x86, microcode, AMD: Add support for family 16h processors
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sat, 17 Nov 2012 12:42:30 -0800
To: Gene Heskett <gheskett@wdtv.com>
CC: Borislav Petkov <bp@alien8.de>, Boris Ostrovsky <boris.ostrovsky@amd.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>, mingo@elte.hu,
        tglx@linutronix.de, herrmann.der.user@googlemail.com,
        linux-kernel@vger.kernel.org
Message-ID: <46f2e1f5-1762-4863-acad-ba1d83db1109@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's too old, that's the problem.

Gene Heskett <gheskett@wdtv.com> wrote:

>On Saturday 17 November 2012, H. Peter Anvin wrote:
>>On 11/17/2012 10:34 AM, Gene Heskett wrote:>
>>
>>> And I don't see anything there that looks like a 'patch level'.
>>> The ucode obviously can, which is what counts in this game of
>>> horseshoes. Perhaps something in that very long 'flags' string?
>>
>>What kernel version is this?
>>
>>	-hpa
>
># uname -a
>Linux coyote 2.6.32-122-rtai #rtai SMP Tue Jul 27 12:44:07 CDT 2010
>i686 
>GNU/Linux
>
>This is a custom made rtai patched kernel used ATM by LinuxCNC (was
>emc), 
>built for driving machinery in the robot, lathe and milling machine 
>categories.  With low latency motherboards such as the intel D525MW, it
>is 
>capable of running higher powered stepper motors at quite impressive
>speeds 
>as it can output, thru the std parport, step and dir signals every 20
>to 25 
>microseconds.
>
>That of course is not on this exact machine, but used in order to
>maintain 
>write it here and nfs it to the box running the lathe or milling
>machine 
>after doing "air" cuts on this machine to prove the code works.  Same 
>ubuntu-10.04.4 LTS install on 4 boxes here.
>
>The code carvers for LinuxCNC have working patched 3.4.xx kernels
>running 
>now, but have not yet assembled a new OS install CD release based on
>these 
>patches, with the possibly the Xenomai patchset for user threads will
>be 
>used for the Next Gen release of the install CD.  That seems to be
>winning 
>the performance battle ATM.
>
>Probably more than you wanted to know.  I'm just explaining why the old
>
>kernel version.  Its all GPLed and can be pulled from links on the 
>wiki.linuxcnc.org site.
>
>Thanks hpa.
>
>Cheers, Gene

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
