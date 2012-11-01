Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761967Ab2KAPRS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 11:17:18 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:58450 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761915Ab2KAPRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 11:17:15 -0400
MIME-Version: 1.0
In-Reply-To: <1351782390.2391.69.camel@dabdike.int.hansenpartnership.com>
References: <2548314.3caaFsMVg6@linux-lqwf.site>
	<50919EED.3020601@genband.com>
	<36538307.gzWq1oO7Kg@linux-lqwf.site>
	<1351760905.2391.19.camel@dabdike.int.hansenpartnership.com>
	<alpine.LNX.2.00.1211011017230.6606@pobox.suse.cz>
	<1351762703.2391.31.camel@dabdike.int.hansenpartnership.com>
	<alpine.LNX.2.00.1211011044290.6606@pobox.suse.cz>
	<1351763954.2391.37.camel@dabdike.int.hansenpartnership.com>
	<CACLa4puzLR2om6SHw3wVnfZ1nezVsKOp8+705AdHZ4_=JamYfw@mail.gmail.com>
	<1351780935.2391.58.camel@dabdike.int.hansenpartnership.com>
	<20121101144912.GA10269@srcf.ucam.org>
	<1351782390.2391.69.camel@dabdike.int.hansenpartnership.com>
Date: Thu, 1 Nov 2012 11:17:14 -0400
Message-ID: <CACLa4psR5Q37tBG__0Vf-+9jmygejkYVRNKCAueF3L2Z3FcxLA@mail.gmail.com>
Subject: Re: [RFC] Second attempt at kernel secure boot support
From: Eric Paris <eparis@parisplace.org>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Jiri Kosina <jkosina@suse.cz>,
        Oliver Neukum <oneukum@suse.de>,
        Chris Friesen <chris.friesen@genband.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Josh Boyer <jwboyer@gmail.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 1, 2012 at 11:06 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:

> But surely that's fanciful ... you've already compromised windows to get
> access to the ESP.  If you've done it once, you can do it again until
> the exploit is patched.

You work under the assumption that any bad operation was done by means
of a compromised kernel.  Admins install things all the time,
sometimes, things which they shouldn't.  (This statement is OS
agnostic)

> There are likely many easier ways of ensuring
> persistence than trying to install a full linux kernel with a
> compromised resume system.

I'm sure lots of us would love to hear the ideas.  And the attack is
on the suspend side, nothing about resume has to be malicious (not
really relevant I guess)...
