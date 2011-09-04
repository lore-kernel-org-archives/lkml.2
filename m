Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab1IDTb3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 15:31:29 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:53893 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124Ab1IDTbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 15:31:23 -0400
MIME-Version: 1.0
In-Reply-To: <CAMe9rOqJoy=S4-=tZXrti7w_GtSqaTgX9i69FR92Tv6pPfSDRQ@mail.gmail.com>
References: <4E582577.2060805@zytor.com>
	<19229.1315070217@turing-police.cc.vt.edu>
	<4E62638E.40308@zytor.com>
	<3546423.kFMPx0aPCi@wuerfel>
	<CAMe9rOqJoy=S4-=tZXrti7w_GtSqaTgX9i69FR92Tv6pPfSDRQ@mail.gmail.com>
Date: Sun, 4 Sep 2011 21:31:22 +0200
Message-ID: <CAFLxGvw3wB_fTqbZrKw69HxQ5OeNPOOwVQiFqgWvBDXjLqXALQ@mail.gmail.com>
Subject: Re: RFD: x32 ABI system call numbers
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: "H.J. Lu" <hjl.tools@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Valdis.Kletnieks@vt.edu,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Kuo <rkuo@codeaurora.org>, Mark Salter <msalter@redhat.com>,
        Jonas Bonn <jonas@southpole.se>, Tobias Klauser <tklauser@distanz.ch>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 4, 2011 at 8:40 PM, H.J. Lu <hjl.tools@gmail.com> wrote:
> #define __NR_x32__sysctl

Do we really want sysctl?

Some quotes from it's man-page:
"Do not use this system call!  See NOTES."

"Glibc does not provide a wrapper for this system call; call it using
syscall(2).

 Or rather... don't call it: use of this system call has long been
discouraged, and it is so unloved that it
 is likely to disappear in a future kernel version.  Remove it from
your programs  now;  use  the  /proc/sys
 interface instead."

-- 
Thanks,
//richard
