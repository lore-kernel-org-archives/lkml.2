Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960Ab0IRUC7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 16:02:59 -0400
Received: from mail-da-3.dns-solutions.net ([69.12.112.3]:56765 "HELO
	mail-da-3.dns-solutions.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753633Ab0IRUC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 16:02:58 -0400
From: "Joshua Hintze" <joshh@imsar.com>
To: "'Randy Dunlap'" <rdunlap@xenotime.net>
Cc: "'Maxim Levitsky'" <maximlevitsky@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-ide@vger.kernel.org>
References: <00d401cb55f7$33a78210$9af68630$@com>	<20100917154732.330c4b1b@varda>	<010901cb5754$ae6735a0$0b35a0e0$@com>	<1284837774.12425.1.camel@localhost.localdomain>	<010d01cb5769$cbca3380$635e9a80$@com> <20100918124750.393a64a8.rdunlap@xenotime.net>
In-Reply-To: <20100918124750.393a64a8.rdunlap@xenotime.net>
Subject: RE: PATA IDE is slower in newer versions of kernel
Date: Sat, 18 Sep 2010 14:02:50 -0600
Message-ID: <010e01cb576c$7909c900$6b1d5b00$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: ActXamJy0z4norJ7Q62dpuB137KH7gAAg+gw
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got you. 

Thanks.


-----Original Message-----
From: Randy Dunlap [mailto:rdunlap@xenotime.net] 
Sent: Saturday, September 18, 2010 1:48 PM
To: Joshua Hintze
Cc: 'Maxim Levitsky'; linux-kernel@vger.kernel.org;
linux-ide@vger.kernel.org
Subject: Re: PATA IDE is slower in newer versions of kernel

On Sat, 18 Sep 2010 13:43:40 -0600 Joshua Hintze wrote:

> Thanks,
> 
> I'm not sure what you mean by bisect, other than just the definition of
the word. I am breaking this problem down adding printks etc.  I think I'm
finally beginng to understand how this works :)
> 

http://www.kernel.org/pub/software/scm/git/docs/git-bisect.html
http://www.kernel.org/pub/software/scm/git/docs/user-manual.html#using-bisec
t


> 
> 
> -----Original Message-----
> From: linux-ide-owner@vger.kernel.org
[mailto:linux-ide-owner@vger.kernel.org] On Behalf Of Maxim Levitsky
> Sent: Saturday, September 18, 2010 1:23 PM
> To: Joshua Hintze
> Cc: linux-kernel@vger.kernel.org; linux-ide@vger.kernel.org
> Subject: RE: PATA IDE is slower in newer versions of kernel
> 
> On Sat, 2010-09-18 at 11:12 -0600, Joshua Hintze wrote:
> > Some updated information. I created a screen capture of what I am
seeing. First is the logic analyzer when the newer linux kernel is writing
slow to the PATA port.
> > 
> > http://i56.tinypic.com/oqhrug.png
> > 
> > Notice in the above link how there is a lot of activating and then large
gaps of no activity. After about 9 mS the STOP line is strobed a few times
and then DMARQ finally returns to normal operating. The link below shows the
picture of an old 2.6.10 kernel where write speeds are much faster.
> > 
> > http://i51.tinypic.com/a9wiur.png
> > 
> > In the above image notice how the wait time is considerable less 100's
of microseconds before the stop lines get strobed.
> > 
> > I'm dedicated to continue working on the problem, I just need to advice
from the linux community. I've tried different I/O schedulers such as noop
and anticipatory and I'm studying the ide-dma code but still lost to where
this is happening.
> > 
> > Thanks!
> > 
> Maybe you can just bisect this?
> Just a general advice, I don't know ide subsystem at all.
> 
> Best regards,
> 	Maxim Levitsky


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

No virus found in this incoming message.
Checked by AVG - www.avg.com 
Version: 9.0.851 / Virus Database: 271.1.1/3132 - Release Date: 09/18/10
00:34:00

