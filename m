Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941Ab1HBOpk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 10:45:40 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48353 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664Ab1HBOpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 10:45:33 -0400
Message-ID: <4b1d9f7714d8b7e26365720f4338f9cc.squirrel@www.firstfloor.org>
In-Reply-To: <20110802111117.10a73b89@lxorguk.ukuu.org.uk>
References: <20110802005206.GA3832@tassilo.jf.intel.com>
    <20110801183207.cea89a96.akpm@linux-foundation.org>
    <CA+55aFw=wX1CormdOAnsoK2ruDLp9SaEVh1EcTj8wvt+Kq2gAg@mail.gmail.com>
    <alpine.DEB.2.00.1108011916480.15596@chino.kir.corp.google.com>
    <20110802101614.009cdf42@lxorguk.ukuu.org.uk>
    <alpine.DEB.2.00.1108020249560.18935@chino.kir.corp.google.com>
    <20110802111117.10a73b89@lxorguk.ukuu.org.uk>
Date: Tue, 2 Aug 2011 16:45:28 +0200
Subject: Re: Revert needed: udev spewing warnons on common systems in 3.0
From: "Andi Kleen" <andi@firstfloor.org>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Cc: "David Rientjes" <rientjes@google.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Andi Kleen" <andi@firstfloor.org>, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.21
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> That's obviously wrong since all of the applications that I've cited
>> that have been fixed to date have been the result of users actually
>> noticing the printk_once() and emailing me directly to pass it along to
>> the appropriate parties.  I've also found other cases where bugzilla
>> entries were created based on that single line warning by users, who in
>> turn get distros and maintainers to convert to the new interface.
>
> And what did the users do - they complained to the distribution.

I don't think that's how distributions work. Usually they won't fix
an old udev, but just eventually update to a new udev version when
they release a new version of themselves.

But the old release with the old udev will just stay around and people
will continue to use it for many years.

And that's fine because nothing is fundamentally broken here that
needs urgent fixing (except for that bogus backtrace of course)

The kernel has always done a great job in supporting old userland,
this is just one of the rare exceptions.

> Perhaps the right way to do it would be to file the bugzillas in the key
> distros instead

The right way is to add a one linker printk_once and then just wait
for a few years.

> Actually this raises a more interesting question - would it make sense to
> have a moderated notification list for poking all the distributions about
> things like old API expiry

And? Even if the distributions scramble to follow you -- which
is unlikely for old versions -- their users won't do it.

-Andi

