Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932169Ab1HaRFw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 13:05:52 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:65251 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932158Ab1HaRFu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 13:05:50 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFxfmwfB7jbbrXxa=K7VBYPfAvmu3XOkGrLbB1UFjX1+Ew@mail.gmail.com>
References: <4E582577.2060805@zytor.com>
	<201108301409.27527.arnd@arndb.de>
	<4E5D1153.5030908@zytor.com>
	<201108311814.54906.arnd@arndb.de>
	<CA+55aFxfmwfB7jbbrXxa=K7VBYPfAvmu3XOkGrLbB1UFjX1+Ew@mail.gmail.com>
Date: Wed, 31 Aug 2011 10:05:49 -0700
Message-ID: <CAMe9rOpGxNWD=gdvyVpi7V7BrwwWrpLTWdkmTjPqJ1+SUvhA0A@mail.gmail.com>
Subject: Re: RFD: x32 ABI system call numbers
From: "H.J. Lu" <hjl.tools@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Kuo <rkuo@codeaurora.org>, Mark Salter <msalter@redhat.com>,
        Jonas Bonn <jonas@southpole.se>, Tobias Klauser <tklauser@distanz.ch>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 31, 2011 at 9:46 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I really think that "x32" should try to aim *VERY* hard at using the
> 64-bit system calls, and seeing itself as being a "32-bit application
> in a 64-bit world".  That's not just true for time_t (which I think
> should be 64-bit on anything new that expects to survive for any
> amount of time), but in general.
>

I have been making x32 to use 64bit system calls as much as possible.
Hopefully, I will get it to work in a week or 2.

-- 
H.J.
