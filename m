Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783Ab2GOX1j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 19:27:39 -0400
Received: from unicorn.mansr.com ([78.86.181.103]:34348 "EHLO
	unicorn.mansr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab2GOX1g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 19:27:36 -0400
X-Greylist: delayed 352 seconds by postgrey-1.27 at vger.kernel.org; Sun, 15 Jul 2012 19:27:36 EDT
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
	<CAOesGMiCexiqA3L5GdNgyHhSD-5Bpqbb02YJrZPr8yMYa0afjA@mail.gmail.com>
	<201207071927.13135.arnd@arndb.de> <20120710071023.GA10456@gmail.com>
	<20120710101018.GE15120@arm.com>
Date: Mon, 16 Jul 2012 00:21:42 +0100
In-Reply-To: <20120710101018.GE15120@arm.com> (Catalin Marinas's message of
	"Tue, 10 Jul 2012 11:10:18 +0100")
Message-ID: <yw1x8vekd309.fsf@unicorn.mansr.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Catalin Marinas <catalin.marinas@arm.com> writes:

> On Tue, Jul 10, 2012 at 08:10:23AM +0100, Ingo Molnar wrote:
>> * Arnd Bergmann <arnd@arndb.de> wrote:
>> > On Saturday 07 July 2012, Olof Johansson wrote:
>> > > > ARM introduced AArch64 as part of the ARMv8 architecture
>> > > 
>> > > With the risk of bikeshedding here, but I find the name awkward. How
>> > > about just naming the arch port arm64 instead? It's considerably more
>> > > descriptive in the context of the kernel.  For reference, we didn't
>> > > name ppc64, nor powerpc, after what the IBM/power.org marketing people
>> > > were currently calling the architecture at the time either.
>> > 
>> > I agree the name sucks, [...]
>> 
>> So why not change it now, when it only bothers a few dozen 
>> people and it is only present in 36 patches? Why go full steam 
>> ahead to annoy thousands of people with it and why spread the 
>> naming madness to thousands of commits?
>
> Changing the arch/ dir name is easy at this point. My preference is for
> consistency with the official name (that cannot be changed) and the gcc
> triplet. I also don't think it annoys thousands of people, most don't
> really care. The few reactions I've seen is pretty much because people
> were expecting arm64 and it came as something else.

FWIW, I'd prefer naming the directory either arm64 or armv8 for a few
reasons:

- Those are the names people actually use to refer to the architecture
- They are more descriptive.
- I think the official name is rather silly.

Note, these are my personal opinions.

-- 
Måns Rullgård
mans@mansr.com
