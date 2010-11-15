Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933501Ab0KOTLA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 14:11:00 -0500
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:1303 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932217Ab0KOTK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 14:10:58 -0500
Message-ID: <4CE185AE.6000805@xs4all.nl>
Date: Mon, 15 Nov 2010 20:10:38 +0100
From: Jim Bos <jim876@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101106 Thunderbird/3.1.6
MIME-Version: 1.0
To: Jakub Jelinek <jakub@redhat.com>
CC: Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        James Cloos <cloos@jhcloos.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andreas Schwab <schwab@redhat.com>, Michael Matz <matz@suse.de>,
        Dave Korn <dave.korn.cygwin@gmail.com>,
        Richard Guenther <richard.guenther@gmail.com>, gcc@gcc.gnu.org
Subject: Re: gcc 4.5.1 / as 2.20.51.0.11 miscompiling drivers/char/i8k.c ?
References: <m31v6nmmr3.fsf@jhcloos.com> <AANLkTim2rCuF4p0719YQ3=0s7jhk5FOuTHHAeBWBhvR=@mail.gmail.com> <20101115085605.GE2583@sunsite.ms.mff.cuni.cz> <20101115100331.GG2583@sunsite.ms.mff.cuni.cz> <20101115105446.GD7269@basil.fritz.box> <20101115111642.GU29412@tyan-ft48-01.lab.bos.redhat.com> <20101115113739.GH7269@basil.fritz.box> <4CE16F86.40808@xs4all.nl> <20101115174449.GW29412@tyan-ft48-01.lab.bos.redhat.com> <4CE1793B.2010109@xs4all.nl> <20101115182627.GH2583@sunsite.ms.mff.cuni.cz>
In-Reply-To: <20101115182627.GH2583@sunsite.ms.mff.cuni.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2010 07:26 PM, Jakub Jelinek wrote:
> On Mon, Nov 15, 2010 at 07:17:31PM +0100, Jim Bos wrote:
>>  # gcc -v
>> Reading specs from /usr/lib/gcc/i486-slackware-linux/4.5.1/specs
>> COLLECT_GCC=gcc
>> COLLECT_LTO_WRAPPER=/usr/libexec/gcc/i486-slackware-linux/4.5.1/lto-wrapper
>> Target: i486-slackware-linux
>> Configured with: ../gcc-4.5.1/configure --prefix=/usr --libdir=/usr/lib
>> --mandir=/usr/man --infodir=/usr/info --enable-shared --enable-bootstrap
>> --enable-languages=ada,c,c++,fortran,java,objc --enable-threads=posix
>> --enable-checking=release --with-system-zlib
>> --with-python-dir=/lib/python2.6/site-packages
>> --disable-libunwind-exceptions --enable-__cxa_atexit --enable-libssp
>> --with-gnu-ld --verbose --with-arch=i486 --target=i486-slackware-linux
>> --build=i486-slackware-linux --host=i486-slackware-linux
>> Thread model: posix
>> gcc version 4.5.1 (GCC)
> 
> Does it have any patches applied?  The gcc options look the same as what
> I've been already trying earlier.
> Thus, can you run gcc with those options on i8k.i and add -fverbose-asm
> to make it easier to read and post i8k.s you get?
> 
> 	Jakub
> 

Slackware is typically not patching much (and I'm just using the
pre-compiled binary).  Here is the link to how it's built:
 http://slackware.osuosl.org/slackware-current/source/d/gcc/
there doesn't appear to be anything relevant changed.

I already posted the .s files, plain 2.6.36 and the one with working
patch, I =think= that's already using -fverbose-asm, at least that shows
in the output.

_
Jim



