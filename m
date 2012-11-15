Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767885Ab2KON7u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 08:59:50 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:50310 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767850Ab2KON7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 08:59:47 -0500
MIME-Version: 1.0
In-Reply-To: <201211150914.22835.arnd@arndb.de>
References: <201211141218.02105.arnd@arndb.de>
	<50A3C631.8010301@zytor.com>
	<201211150914.22835.arnd@arndb.de>
Date: Thu, 15 Nov 2012 05:59:46 -0800
Message-ID: <CAMe9rOpziKa6QLfjX9iXtfj_X2QAyDAV2p8NEd8Wd7yFwTrpNg@mail.gmail.com>
Subject: Re: new architectures, time_t __kernel_long_t
From: "H.J. Lu" <hjl.tools@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org,
        Vineet.Gupta1@synopsys.com, linux-kernel@vger.kernel.org,
        James Hogan <james.hogan@imgtec.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2012 at 1:14 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Wednesday 14 November 2012, H. Peter Anvin wrote:
>> On 11/14/2012 04:18 AM, Arnd Bergmann wrote:
>> > Since we are in the review phase for two new architectures that we
>> > should be merging into the mainline kernel, I think we need to
>> > come up with a solution for making them use a proper 64-bit time_t.
>> >
>> > Right now, the only 32-bit user space interface we have to use 64-bit
>> > time_t is the x32 side of x86-64, and that works by overriding all
>> > "long" sized types to be 64 bit at the ABI level, which we don't
>> > want for pure 32 bit architectures.
>>
>> Sort of.  Either way, the kernel headers aren't really x32-clean yet, so
>> we have an opportunity to do things more cleanly as we are implementing
>> this.
>
> Ah, I didn't know that. How does one build an x32 libc then?

Glibc has been providing its own types for years.
Kernel provided types used to be wrong for ia32
on x86-64.

-- 
H.J.
