Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337Ab1CJRHk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 12:07:40 -0500
Received: from usmamail.tilera.com ([206.83.70.70]:32874 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685Ab1CJRHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 12:07:39 -0500
Message-ID: <4D790557.1030000@tilera.com>
Date: Thu, 10 Mar 2011 12:07:35 -0500
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.15) Gecko/20110303 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: <linasvepstas@gmail.com>
CC: Arnd Bergmann <arnd@arndb.de>, GLIBC Devel <libc-alpha@sourceware.org>,
        <linux-kernel@vger.kernel.org>, <libc-ports@sourceware.org>
Subject: Re: asm-generic/unistd.h and glibc use of NR_ipc
References: <AANLkTi=33kimswSJ1tYsnG-PVs6Z4dVBtnqq65GN8Vxw@mail.gmail.com> <201009281040.09728.arnd@arndb.de> <4CA1E809.5010103@tilera.com> <AANLkTikRvGO_xrk85eegh_PeGrkOOkpN-rjkhJCW7n74@mail.gmail.com>
In-Reply-To: <AANLkTikRvGO_xrk85eegh_PeGrkOOkpN-rjkhJCW7n74@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/10/2011 11:46 AM, Linas Vepstas wrote:
> Hi Chris,
>
> A question, and a patch follow:
>
> On 28 September 2010 08:05, Chris Metcalf <cmetcalf@tilera.com> wrote:
>>  (Adding libc-ports to the cc list.)
>>
>> On 9/28/2010 4:40 AM, Arnd Bergmann wrote:
>>> Chris Metcalf is using the generic unistd.h file on the tile architecture
>>> and has a glibc port that should be easily portable to all future
>>> architectures. There are a few of them getting ready to be merged
>>> now (c6x, lm32, nios2, and some people have contacted me privately
>>> for architectures I cannot name).
>>>
>>> I expect that all of them will just use the same syscall ABI and glibc
>>> port.
>> [...]
> I note that this hasn't been merged into glibc-2.13, any particular
> explaintation for that?

Just that I haven't had the time -- I've been more focused on the kernel
community rather than glibc.  I'm still planning to do it when I have some
time!

> Anyway, it seems that pthread cancellation pints are missing
> from a couple of the functions.  e.g. for send, recv, one needs
> the following:

Thanks, that seems very plausible.  I'll update my copy of those sources so
it will be in the eventual submission to libc-ports.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

