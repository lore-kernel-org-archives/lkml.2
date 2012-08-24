Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760176Ab2HXTxa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 15:53:30 -0400
Received: from mail1-hoer.fullrate.dk ([89.150.129.84]:49260 "EHLO
	smtp.fullrate.dk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760132Ab2HXTx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 15:53:27 -0400
From: Martin Nybo Andersen <tweek@tweek.dk>
To: wbrana <wbrana@gmail.com>
Subject: Re: Drop support for x86-32
Date: Fri, 24 Aug 2012 21:53:24 +0200
User-Agent: KMail/1.13.7 (Linux/3.6.0-rc1+; KDE/4.8.4; x86_64; ; )
Cc: Chris Friesen <chris.friesen@genband.com>,
        Bernd Petrovitsch <bernd@petrovitsch.priv.at>,
        Ondrej Zary <linux@rainbow-software.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
References: <CAJ7jCmmbiR7Kzwtc4x++Z+onvSMN5ZyVrORiux6TuZ6=gCBH9Q@mail.gmail.com> <201208242035.38733.tweek@tweek.dk> <CAJ7jCmmuxiWegxkdAsbtCbv-zXgmt--V2bVdENkupGTwj=3HSg@mail.gmail.com>
In-Reply-To: <CAJ7jCmmuxiWegxkdAsbtCbv-zXgmt--V2bVdENkupGTwj=3HSg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201208242153.24638.tweek@tweek.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 August 2012 20:59:33 wbrana wrote:
> On 8/24/12, Martin Nybo Andersen <tweek@tweek.dk> wrote:
> > I want to use *my* old machines (hey, I payed for them) on whatever new
> > hardware I can plug into them. I'm not an oracle and can't see into the
> > future, however USB has evolved, for instance, and will probably still do
> > --
> 
> Your 32-bit machines will be likely dead in 2015. If it didn't happen
> you will able to buy very cheap old 64-bit machine.
I don't think so. My trusty old Amiga 4000 from '93 still works, and I don't 
think it'll die within the next three years. :-) 

> >> I can't find any e-mail where Chris Friesen mentioned exact legacy apps.
> > 
> > Have a look in your inbox or one of the mailarchives. If that doesn't
> > work,
> > 
> > then stop deleting half of the mails before replying.
> 
> I don't delete e-mails. Can you copy-paste or give link?
You delete part of them. Here's a link to Friesens mail:
https://lkml.org/lkml/2012/8/24/300

Quote:
"You might also want to run legacy apps (which can't be recompiled) on new 
hardware."

I know he's not giving any names, however he's specific enough: Apps which 
can't be recompiled. Ie. software for which you haven't got the source code or 
a working compiler.

> > The source code for Firefox and Chromium is available online. Go fetch
> > and compile. If they don't compile or execute as intended, I'm sure they
> > would like seeing a patch from you fixing the problem.
> 
> Firefox and Chromium are large applications and can't be fixed by one user.
Try telling Torvalds he couldn't create Linux, or Stallman that he couldn't 
create GNU.

Seriously: Announce your work and people will help you if they feel that it is 
worthwhile.

> > NVIDIA, on the other hand, is yet another reason for using nouveau.
> 
> nouveau is useless garbage as most open source graphics drivers.
Quite the opposite. You should try it some day. The only thing I miss is 
VDPAU. But then again, I use another computer for watching movies. It has a 
Radeon card installed (using the open radeon driver -- not the flgrx). Full HD 
and sound via HDMI running flawlessly. As does the integrated Intel GPU on my 
eeepc 900 (the CPU seems to be the fastest chip on that netbook ... ;-) ...).

-- 
Cheers,
Martin
