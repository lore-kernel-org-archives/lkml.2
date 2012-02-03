Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206Ab2BCJRr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 04:17:47 -0500
Received: from mail.biatv.hu ([82.141.138.162]:39342 "EHLO mail.biatv.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753952Ab2BCJRm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 04:17:42 -0500
X-Greylist: delayed 1515 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Feb 2012 04:17:42 EST
From: =?iso-8859-1?Q?M=FCller_Keve?= <keve@irb.hu>
To: "'Edward Donovan'" <edward.donovan@numble.net>,
        "'Jeroen Van den Keybus'" <jeroen.vandenkeybus@gmail.com>
Cc: "'Linus Torvalds'" <torvalds@linux-foundation.org>,
        "'Chris Palmer'" <chris.palmer@pobox.com>,
        "'Robert Hancock'" <hancockrwd@gmail.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Len Brown'" <lenb@kernel.org>, <ghost3k@ghost3k.net>,
        <linux-kernel@vger.kernel.org>, <bjorn.ottervik@gmail.com>,
        <kaneda@freemail.hu>, <clemens@ladisch.de>,
        "'Thomas Gleixner'" <tglx@linutronix.de>,
        "'Ingo Molnar'" <mingo@elte.hu>
References: <4E68A6E8.9020700@pobox.com> <20110908165155.f661a738.akpm@linux-foundation.org> <4F26B162.4050000@pobox.com> <4F274E28.2010200@gmail.com> <4F27D9AD.1020806@pobox.com> <CADdbW+Eaab4ucATwX+ao-P+kcms-AJKQMGZr2E6g73gLACZSZg@mail.gmail.com> <CA+55aFytBRZiQUcnWtSYnxqXUJCfVuS4f5tq=QUNG2GfbF1mhA@mail.gmail.com> <CADdbW+EmBWiz=3UDvN+UtXZ-io7iJsDfia6xWPm+MrrH+xXA3w@mail.gmail.com> <CAPRPZsB8MakxizGJuT7E9mEvdH6QT6fVzuckE0-yxi4RLD0xKQ@mail.gmail.com> <20120203015925.GA14359@Brahman>
In-Reply-To: <20120203015925.GA14359@Brahman>
Subject: RE: ASM1083 PCIx-PCI bridge interrupts - widespread problems
Date: Fri, 3 Feb 2012 09:51:49 +0100
Message-ID: <005701cce251$13ffa090$3bfee1b0$@irb.hu>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQKhMVndLkuoH8tA2uhGziqyOBjS5QHoi1O8A1NyoVwB/0cFsAGmS4/jAUN+7w4ASaDgUgLrmU7wALTTEpEBBiAw9ZQJketQ
Content-Language: en-us
X-Host-Lookup-Failed: Reverse DNS lookup failed for 94.248.175.48 (failed)
X-Spam-Score: -4.3 (----)
X-Scan-Signature: ed0a186e817c80813a35c7b7e3b67bba
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gentlemen, 

Below  is a comment of AsMedia. I will continue now with ASUS, but they are
known to just say "the system is not supporting Linux".

As evidence is growing that the chip might have a severe timing issue, I
believe that all related kernel bug reports should be rooted under 1 major
bug only naming the chipset. Can somebody please advise on how I could
perform this re-routing and whether that makes sense. I would simply take
all PCI related kernel bug reports with a system having a ASM1083 and make
them dependent on a newly created (empty) report.

IMO the bridge should finally get a human readable tag by the kernel (so far
it is numeric only: 1b21:1080) possibly including a note in the tag saying
"buggy". This should raise attention at others running into problems and
channel them to the appropriate place.

Having the hardware and plenty of different PCI cards I am open to test any
suggestion you have and gather data/evidence that sheds light on how to best
treat the issue in the kernel. 

Thank you for your continuing support!

Best regards,

Keve
 

Here is the mail from AsMedia (an ASUS dependency...) .

Dear Keve,
Thanks for your valuable opinion. We are glad to receive the opinion form
the end-user. However, we are sorry to inform you that Asmedia is an IC
design house and so far we only provide direct support to the manufacturer,
OEM/ODM, and brand companies. Because most of software is customerized and
our IC is one of the parts in the system and we even don’t know if that
system supports Linux….Actually we are not authorized to release those
software by ourselves. We are afraid that we are not able to provide the
appropriate solution to you, so we suggest that you contact the service
department of that product and they might provide the appropriate support to
you. We also thank you for purchasing the product on which our IC is used. 

Best Regards,
Asmedia Service
 

-----Original Message-----
From: Edward Donovan [mailto:ed@numble.net] On Behalf Of Edward Donovan
Sent: Friday, February 03, 2012 2:59 AM
To: Jeroen Van den Keybus
Cc: Linus Torvalds; Chris Palmer; Robert Hancock; Andrew Morton; Len Brown;
ghost3k@ghost3k.net; linux-kernel@vger.kernel.org; keve@irb.hu;
bjorn.ottervik@gmail.com; kaneda@freemail.hu; clemens@ladisch.de; Thomas
Gleixner; Ingo Molnar
Subject: Re: ASM1083 PCIx-PCI bridge interrupts - widespread problems

Clemens and Jeroen - um, wow, that is a lot of strong thinking.  I don't
have any code in mind, to match, yet.  Especially given your set of
questions, Jeroen.  I'll try to get time to think and read the code.
Hopefully the group will be ahead of my pace. :)

(I have a more minor patch for spurious.c, that I need to resubmit, too, and
I should probably get that over with, first.  So if you see me post about
"better error messages for spurious IRQs", it won't be directly related to
this.)

Thanks, 

Ed

