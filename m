Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152Ab2KQULT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 15:11:19 -0500
Received: from mail.wdtv.com ([66.118.69.84]:54771 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752099Ab2KQULT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 15:11:19 -0500
From: Gene Heskett <gheskett@wdtv.com>
To: Andreas Herrmann <herrmann.der.user@googlemail.com>
Subject: Re: [PATCH] x86, microcode, AMD: Add support for family 16h processors
Date: Sat, 17 Nov 2012 15:11:12 -0500
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Boris Ostrovsky <boris.ostrovsky@amd.com>, hpa@zytor.com,
        mingo@elte.hu, tglx@linutronix.de, bp@alien8.de,
        linux-kernel@vger.kernel.org
References: <1353004910-2204-1-git-send-email-boris.ostrovsky@amd.com> <201211151801.23160.gheskett@wdtv.com> <20121117195438.GB2375@tweety>
In-Reply-To: <20121117195438.GB2375@tweety>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1256"
Content-Transfer-Encoding: 7bit
Message-Id: <201211171511.13183.gheskett@wdtv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 17 November 2012, Andreas Herrmann wrote:
>On Thu, Nov 15, 2012 at 06:01:22PM -0500, Gene Heskett wrote:
>> On Thursday 15 November 2012, Henrique de Moraes Holschuh wrote:
>> >On Thu, 15 Nov 2012, Boris Ostrovsky wrote:
>> >> Add valid patch size for family 16h processors
>> >> 
>> >> Signed-off-by: Boris Ostrovsky <boris.ostrovsky@amd.com>
>> >
>> >Is this something that needs to go to -stable ?
>> 
>> IMO, and if I had an oar in this water, yes.  Its been missing since
>> the Intel folks started playing with it a couple years back up the
>> log.  I have the amd_ucode files in my /lib/firmware tree,
>> 
>> root@coyote:/opt/os9# ls -l /lib/firmware/amd-ucode/
>> total 76
>> -rw-r--r-- 1 root root   642 2012-01-17 11:50 INSTALL
>> -rw-r--r-- 1 root root  9987 2012-01-17 11:50 LICENSE
>> -rw-r--r-- 1 root root 12404 2012-01-17 11:50 microcode_amd.bin
>> -rw-r--r-- 1 root root  1526 2012-01-17 11:50 microcode_amd.bin.README
>> -rw-r--r-- 1 root root  2644 2012-01-17 11:50 microcode_amd_fam15h.bin
>> -rw-r--r-- 1 root root   510 2012-01-17 11:50
>> microcode_amd_fam15h.bin.README
>> -rw-r--r-- 1 root root  2012 2009-01-20 04:48 microcode_amd.phenom-V83
>> -rw-r--r-- 1 root root 15020 2012-01-17 11:50 microcode_amd_solaris.bin
>> -rw-r--r-- 1 root root  1685 2012-01-17 11:50
>> microcode_amd_solaris.bin.README
>> -rw-r--r-- 1 root root  6227 2012-01-17 11:50 README
>> 
>> but I can't recall the last time I saw the code sign in during dmesg.
>
>Is the microcode module actually loaded on your system?
>If yes,
>	is CONFIG_MICROCODE_AMD set?
>	If yes, please provide dmesg.
No clue, I didn't build it.

>If not, please load manually (modprobe microcode) and what's your
>distro?

I did, it worked and I have now put it in rc.local for the next reboot.

root@coyote:/var/spool/mail# cat /etc/issue
Ubuntu 10.04.4 LTS \n \l

Thank you Andreas.

Cheers, Gene
-- 
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
My web page: <http://coyoteden.dyndns-free.com:85/gene> is up!
He who laughs last usually had to have joke explained.
