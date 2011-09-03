Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125Ab1ICQmV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Sep 2011 12:42:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53160 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752606Ab1ICQmT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Sep 2011 12:42:19 -0400
References: <4E582577.2060805@zytor.com> <CAMe9rOpP9Dt0FvHb0FDbHha0-fv2q4ahfMB_CejqcbWqxuYe8Q@mail.gmail.com> <4E61BB42.4090301@zytor.com> <8179020.mG8hWW8BRr@wuerfel> <14427.1315058668@turing-police.cc.vt.edu>
User-Agent: K-9 Mail for Android
In-Reply-To: <14427.1315058668@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: RFD: x32 ABI system call numbers
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sat, 03 Sep 2011 09:40:55 -0700
To: Valdis.Kletnieks@vt.edu, Arnd Bergmann <arnd@arndb.de>
CC: "H.J. Lu" <hjl.tools@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Kuo <rkuo@codeaurora.org>, Mark Salter <msalter@redhat.com>,
        Jonas Bonn <jonas@southpole.se>, Tobias Klauser <tklauser@distanz.ch>
Message-ID: <9b6a2b8e-365f-4155-85ca-5f72b46a7f3e@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:

>On Sat, 03 Sep 2011 10:41:16 +0200, Arnd Bergmann said:
>
>(Admittedly, I'm tuning in late on this discussion, but...)
>
>> For the ioctl interface however, the __u64/__s64 type in the x32 ABI
>> must be defined with __attribute__((packed,aligned(4))) to match what
>> the kernel implements because it emulates the x86-32 ABI.
>
>Is this a cast-in-stone issue, or is it still not too late to change
>that?
>And if we change that, can we simplify anything?

The complexity of changing that would be enormous.
-- 
Sent from my mobile phone. Please excuse my brevity and lack of formatting.
