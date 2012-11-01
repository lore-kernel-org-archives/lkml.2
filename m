Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761641Ab2KAO3W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 10:29:22 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:55266 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761607Ab2KAO3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 10:29:19 -0400
MIME-Version: 1.0
In-Reply-To: <1351763954.2391.37.camel@dabdike.int.hansenpartnership.com>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com>
	<2548314.3caaFsMVg6@linux-lqwf.site>
	<50919EED.3020601@genband.com>
	<36538307.gzWq1oO7Kg@linux-lqwf.site>
	<1351760905.2391.19.camel@dabdike.int.hansenpartnership.com>
	<alpine.LNX.2.00.1211011017230.6606@pobox.suse.cz>
	<1351762703.2391.31.camel@dabdike.int.hansenpartnership.com>
	<alpine.LNX.2.00.1211011044290.6606@pobox.suse.cz>
	<1351763954.2391.37.camel@dabdike.int.hansenpartnership.com>
Date: Thu, 1 Nov 2012 10:29:17 -0400
Message-ID: <CACLa4puzLR2om6SHw3wVnfZ1nezVsKOp8+705AdHZ4_=JamYfw@mail.gmail.com>
Subject: Re: [RFC] Second attempt at kernel secure boot support
From: Eric Paris <eparis@parisplace.org>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Oliver Neukum <oneukum@suse.de>,
        Chris Friesen <chris.friesen@genband.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Josh Boyer <jwboyer@gmail.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 1, 2012 at 5:59 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:

> But that doesn't really help me: untrusted root is an oxymoron.

Imagine you run windows and you've never heard of Linux.  You like
that only windows kernels can boot on your box and not those mean
nasty hacked up malware kernels.  Now some attacker manages to take
over your box because you clicked on that executable for young models
in skimpy bathing suits.  That executable rewrote your bootloader to
launch a very small carefully crafted Linux environment.  This
environment does nothing but launch a perfectly valid signed Linux
kernel, which gets a Windows environment all ready to launch after
resume and goes to sleep.  Now you have to hit the power button twice
every time you turn on your computer, weird, but Windows comes up, and
secureboot is still on, so you must be safe!

In this case we have a completely 'untrusted' root inside Linux.  From
the user PoV root and Linux are both malware.  Notice the EXACT same
attack would work launching rootkit'd Linux from Linux.  So don't
pretend not to care about Windows.  It's just that launching malware
Linux seems like a reason to get your key revoked.  We don't want
signed code which can be used as an attack vector on ourselves or on
others.

That make sense?

-Eric
