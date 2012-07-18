Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809Ab2GRRZq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 13:25:46 -0400
Received: from unicorn.mansr.com ([78.86.181.103]:39592 "EHLO
	unicorn.mansr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749Ab2GRRZn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 13:25:43 -0400
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dennis Gilmore <dennis@ausil.us>, Jon Masters <jonathan@jonmasters.org>,
        Joe Perches <joe@perches.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
        Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
References: <CAOesGMiCexiqA3L5GdNgyHhSD-5Bpqbb02YJrZPr8yMYa0afjA@mail.gmail.com>
	<201207071927.13135.arnd@arndb.de> <20120710071023.GA10456@gmail.com>
	<20120710101018.GE15120@arm.com> <yw1x8vekd309.fsf@unicorn.mansr.com>
	<CA+55aFxL6uEre-c=JrhPfts=7BGmhb2Js1c2ZGkTH8F=+rEWDg@mail.gmail.com>
	<20120717221839.GA4856@arm.com> <1342564536.1898.1.camel@joe2Laptop>
	<5006207D.1010708@jonmasters.org>
	<20120718102712.46b8d7ff@adria.ausil.us>
	<20120718171426.GA4240@arm.com>
Date: Wed, 18 Jul 2012 18:25:41 +0100
In-Reply-To: <20120718171426.GA4240@arm.com> (Catalin Marinas's message of
	"Wed, 18 Jul 2012 18:14:26 +0100")
Message-ID: <yw1x7gu19e22.fsf@unicorn.mansr.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Catalin Marinas <catalin.marinas@arm.com> writes:

> On Wed, Jul 18, 2012 at 04:27:12PM +0100, Dennis Gilmore wrote:
>> El Tue, 17 Jul 2012 22:33:33 -0400
>> Jon Masters <jonathan@jonmasters.org> escribió:
>> > On 07/17/2012 06:35 PM, Joe Perches wrote:
>> > > On Tue, 2012-07-17 at 23:18 +0100, Catalin Marinas wrote:
>> > > 
>> > >> The uname will still report
>> > >> "aarch64" to match the compiler triplet and also avoid confusion of
>> > >> existing 32-bit ARM scripts that simply check for "arm*" in the
>> > >> machine name.
>> 
>> that means that the yum base arch will need to be aarch64 and the arch
>> used in rpm will be aarch64 also. its throwing something weird and
>> confusing right in the face of users. I urge you to change it all to
>> arm64 just changing the directory in the kernel is pointless as it still
>> exposes all the weirdness of the name to users and will result in a
>> large amount of education and a constant stream of the same question
>> "Where do i find the arm64 bits?" until such time as the users learn
>> that arm64 is aarch64. All the tooling uses "uname -m" to determine the
>> package architecture.
>
> The directory name change is just to avoid some word duplication in
> arch/aarch64/. It can be a64 (as per the ISA) or aa64 or whatever else.
> The "arm64" got most votes so far. I still prefer "aarch64" for
> consistency but I'm can change the directory name, it doesn't matter
> much.
>
> As for the "aarch64" name, whether we like it were not, it was chosen by
> ARM Ltd to describe the new execution mode. It is one of the few
> constants in the changing world of architecture versions and CPU
> numbers. It's also a clear separation from the multitude of ARM* names
> which I agree, is confusing (and, BTW, we had ARM6 processors as well).
>
> People that have been involved with this architecture don't find the
> name impossible (and not all of them are based in Cambridge ;). It may
> not be as aesthetic and easy to pronounce as "arm64" but you get used to
> it. I personally find it easier to pronounce (and type) than "x86_64".
>
> Just to be clear, I'm not trying to defend the "beauty" of this name (I
> have my own opinion) but we spend too much time arguing about it. This
> name has implications beyond the technical arguments of some script or
> another and it will be found in all the technical documents produced by
> ARM Ltd (including the next ARM Architecture Reference Manual).

Maybe it would help if someone explained _why_ the aarch64 name was
chosen.  Assuming it wasn't handed down by a supreme being, there has
to be some reasoning behind the choice.

-- 
Måns Rullgård
mans@mansr.com
