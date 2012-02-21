Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086Ab2BUWH4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 17:07:56 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:50405 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755859Ab2BUWHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 17:07:54 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus971@gmail.com designates 10.216.136.200 as permitted sender) smtp.mail=linus971@gmail.com; dkim=pass header.i=linus971@gmail.com
MIME-Version: 1.0
In-Reply-To: <1329850714.1419.2.camel@localhost.localdomain>
References: <CA+55aFy2pnoNhpTstAMTs+dtm5iRaGCGKLwW6ScCLhEkWtHXGw@mail.gmail.com>
 <FE1DCD87-0055-4C3E-B06A-251055E1492F@m3y3r.de> <CA+55aFzUWDEuj85sOKjwk8ufy+1rbS7hgstw0cCWpjTgu=7B4A@mail.gmail.com>
 <1329850714.1419.2.camel@localhost.localdomain>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 21 Feb 2012 14:07:32 -0800
X-Google-Sender-Auth: OrBxJ4Momotc51-qbAbwt4Eq6x0
Message-ID: <CA+55aFzNdESjFuN9PS8RcwfmLQK3DrB8Cfzx5jJk0ZjJCy8xcg@mail.gmail.com>
Subject: Re: Linux 3.3-rc4
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Ian Kent <raven@themaw.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 21, 2012 at 10:58 AM, Thomas Meyer <thomas@m3y3r.de> wrote:
> Am Sonntag, den 19.02.2012, 10:45 -0800 schrieb Linus Torvalds:
>>
>> Does this fix it?
>
> yes, it does!

Do  you know if anybody ever applied that disgusting (and incorrect -
the 4-byte off thing *only* happens in 32-bit mode with an x86-64
kernel - so the other architecture strcmp's are wrong, and even the
x86-64 strcmp is valid only when compiling as a legacy 32-bit x86 app)
patch of yours?

Because if that actually did happen, there are i386 binaries that are
now broken and know of the kernel bug as Ian was afraid there would
be.

But hopefully that patch never got anywhere, and we could still fix
this in the kernel with my suggested patch.

Not to say that *my* patch isn't also disgusting, of course. But at
least my patch fixes a real compat task problem.

                     Linus
