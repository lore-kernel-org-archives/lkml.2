Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761739Ab2KAOlo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 10:41:44 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:34725 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761539Ab2KAOll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 10:41:41 -0400
Date: Thu, 1 Nov 2012 14:46:35 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Eric Paris <eparis@parisplace.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jiri Kosina <jkosina@suse.cz>, Oliver Neukum <oneukum@suse.de>,
        Chris Friesen <chris.friesen@genband.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Josh Boyer <jwboyer@gmail.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org
Subject: Re: [RFC] Second attempt at kernel secure boot support
Message-ID: <20121101144635.55687287@pyramind.ukuu.org.uk>
In-Reply-To: <CACLa4puzLR2om6SHw3wVnfZ1nezVsKOp8+705AdHZ4_=JamYfw@mail.gmail.com>
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
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Imagine you run windows and you've never heard of Linux.

To those people I think you mean "never heard of Ubuntu" ;-)

> In this case we have a completely 'untrusted' root inside Linux.  From
> the user PoV root and Linux are both malware.  Notice the EXACT same
> attack would work launching rootkit'd Linux from Linux.  So don't
> pretend not to care about Windows.  It's just that launching malware
> Linux seems like a reason to get your key revoked.  We don't want
> signed code which can be used as an attack vector on ourselves or on
> others.
> 
> That make sense?

Not really but it keeps some of the Red Hat security people happy and out
of harms way. With all the current posted RH patches I can still take over
the box as root trivially enough and you seem to have so far abolished
suspend to disk, kexec and a pile of other useful stuff. To actually lock
it down you'll have to do a ton more of this. I suspect folks who know
windows innards well are probably thinking the same about Windows 8 8)

Almost anyone attacking a secure boot box will do it via windows or more
likely via EFI. EFI because its large, new and doesn't a great history,
windows because its the larger target. Actually from what I've seen on
the security front there seems to a distinct view that secure boot is
irrelevant because Windows 8 is so suspend/resume focussed that you might
as well just trojan the box until the next reboot as its likely to be a
couple of weeks a way.

Alan




