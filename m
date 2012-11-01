Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761900Ab2KAPEP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 11:04:15 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:36672 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761880Ab2KAPEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 11:04:10 -0400
MIME-Version: 1.0
In-Reply-To: <20121101144635.55687287@pyramind.ukuu.org.uk>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com>
	<2548314.3caaFsMVg6@linux-lqwf.site>
	<50919EED.3020601@genband.com>
	<36538307.gzWq1oO7Kg@linux-lqwf.site>
	<1351760905.2391.19.camel@dabdike.int.hansenpartnership.com>
	<alpine.LNX.2.00.1211011017230.6606@pobox.suse.cz>
	<1351762703.2391.31.camel@dabdike.int.hansenpartnership.com>
	<alpine.LNX.2.00.1211011044290.6606@pobox.suse.cz>
	<1351763954.2391.37.camel@dabdike.int.hansenpartnership.com>
	<CACLa4puzLR2om6SHw3wVnfZ1nezVsKOp8+705AdHZ4_=JamYfw@mail.gmail.com>
	<20121101144635.55687287@pyramind.ukuu.org.uk>
Date: Thu, 1 Nov 2012 11:04:08 -0400
Message-ID: <CACLa4pswM2V2Y+b-GViBdZocREjHnhDeczDZvWJZZCY5cTdMnQ@mail.gmail.com>
Subject: Re: [RFC] Second attempt at kernel secure boot support
From: Eric Paris <eparis@parisplace.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jiri Kosina <jkosina@suse.cz>, Oliver Neukum <oneukum@suse.de>,
        Chris Friesen <chris.friesen@genband.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Josh Boyer <jwboyer@gmail.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 1, 2012 at 10:46 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> Imagine you run windows and you've never heard of Linux.
>
> To those people I think you mean "never heard of Ubuntu" ;-)

:-)

> With all the current posted RH patches I can still take over
> the box as root trivially enough and you seem to have so far abolished
> suspend to disk, kexec and a pile of other useful stuff. To actually lock
> it down you'll have to do a ton more of this.

I'm guessing those writing the patches would like to hear about these.
 Suspend to disk and kexec can probably both be fixed up to work...

> Actually from what I've seen on
> the security front there seems to a distinct view that secure boot is
> irrelevant because Windows 8 is so suspend/resume focussed that you might
> as well just trojan the box until the next reboot as its likely to be a
> couple of weeks a way.

Bit of a straw man isn't it?  Hey, don't fix A, I can do B!  I'm not
saying you're wrong, nor that maybe online attacks which don't persist
across reboot wouldn't be more likely, but they aren't attacking the
same problem.  (I haven't heard any progress on what you point out,
but at least we have some progress on some small class of boot time
persistent attacks)
