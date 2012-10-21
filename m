Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594Ab2JUB5Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 21:57:25 -0400
Received: from smtprelay0003.b.hostedemail.com ([64.98.42.3]:47860 "EHLO
	smtprelay.b.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752242Ab2JUB5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 21:57:23 -0400
X-Panda: scanned!
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,t.artem@lycos.com,:::::::::::::,RULES_HIT:152:355:379:541:582:599:601:966:967:973:988:989:1152:1260:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2196:2199:2393:2525:2553:2561:2564:2682:2685:2693:2857:2859:2901:2933:2937:2939:2942:2945:2947:2951:2954:3022:3027:3138:3139:3140:3141:3142:3167:3302:3354:3865:3866:3867:3868:3869:3870:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4385:5007:6119:6261:7679:7689:7875:7903:8957:9025:10004:10400:10848:11658:11914:12043:12295:12350:12517:12519:12740,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-Session-Marker: 742E617274656D406C79636F732E636F6D
X-Filterd-Recvd-Size: 3396
Date: Sun, 21 Oct 2012 01:57:21 +0000 (GMT)
From: "Artem S. Tashkinov" <t.artem@lycos.com>
To: bp@alien8.de
Cc: pavel@ucw.cz, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        security@kernel.org, linux-media@vger.kernel.org,
        linux-usb@vger.kernel.org
Message-ID: <1798605268.19162.1350784641831.JavaMail.mail@webmail17>
References: <2104474742.26357.1350734815286.JavaMail.mail@webmail05>
 <20121020162759.GA12551@liondog.tnic>
 <966148591.30347.1350754909449.JavaMail.mail@webmail08>
 <20121020203227.GC555@elf.ucw.cz> <20121020225849.GA8976@liondog.tnic>
 <1781795634.31179.1350774917965.JavaMail.mail@webmail04>
 <20121021002424.GA16247@liondog.tnic>
Subject: Re: Re: Re: Re: A reliable kernel panic (3.6.2) and system crash
 when visiting a particular website
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: Webmail
X-Originating-IP: [5.166.178.220]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Oct 21, 2012, Borislav Petkov wrote: 
> 
> On Sat, Oct 20, 2012 at 11:15:17PM +0000, Artem S. Tashkinov wrote:
> > You don't get me - I have *no* VirtualBox (or any proprietary) modules
> > running
> 
> Ok, good. We got that out of the way - I wanted to make sure after you
> replied with two other possibilities of the system freezing.
> 
> > - but I can reproduce this problem using *the same system running
> > under* VirtualBox in Windows 7 64.
> 
> That's windoze as host and linux as a guest, correct?

Exactly.

> If so, that's virtualbox's problem, I'd say.

I can reproduce it on my host *alone* as I said in the very first message - never
before I tried to run my Linux in a virtual machine. Please, just forget about
VirtualBox - it has nothing to do with this problem.

> > It's almost definitely either a USB driver bug or video4linux driver
> > bug:
> 
> And you're assuming that because the freeze happens when using your usb
> webcam, correct? And not otherwise?

Yes, like I said earlier - only when I try to access its settings using Adobe Flash the
system crashes/freezes.

> Maybe you can describe in more detail what exactly you're doing so that
> people could try to reproduce your issue.

I don't think many people have the same webcam so it's going to be a problem. It
can be reproduced easily - just open Flash "Settings" in Google Chrome 22. The
crash will occur immediately.

> > I'm CC'ing linux-media and linux-usb mailing lists, the problem is described here:
> > https://lkml.org/lkml/2012/10/20/35
> > https://lkml.org/lkml/2012/10/20/148
> 
> Yes, good idea. Maybe the folks there have some more ideas how to debug
> this.
> 
> I'm leaving in the rest for reference.
> 
> What should be pointed out, though, is that you don't have any more
> random corruptions causing oopses now that virtualbox is gone. The
> freeze below is a whole another issue.

The freeze happens on my *host* Linux PC. For an experiment I decided to
check if I could reproduce the freeze under a virtual machine - it turns out the
Linux kernel running under it also freezes.

Artem
