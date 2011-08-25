Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647Ab1HYTz4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 15:55:56 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:63786 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816Ab1HYTzy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 15:55:54 -0400
MIME-Version: 1.0
In-Reply-To: <4E56A7DC.5090805@zytor.com>
References: <20110722154219.GA25694@elte.hu>
	<CACqU3MUxUBzu9frjHLVoHUEKtaDEP+Gn7txm1wbxq=Qkv12ssw@mail.gmail.com>
	<CAObL_7HXMQxf+kYVMutdfAFNrSGYKJF2WPkSeWGK230r_zwskA@mail.gmail.com>
	<CACqU3MUbafosBVsycwFjH9sSq8GJumaeq+MKmeUPKD_zyHdGgw@mail.gmail.com>
	<CAObL_7Hi7du37D0PiRVFZZ5=yYGLm4oaGNYqQCeVoab5aJ_2NQ@mail.gmail.com>
	<CACqU3MXpihKOV_4whbi8_CSU4uFpFzbNFaXvSN75ChdYhZ0A5A@mail.gmail.com>
	<4E56A7DC.5090805@zytor.com>
Date: Thu, 25 Aug 2011 15:55:53 -0400
Message-ID: <CACqU3MW3qkj1TN8O62mvQTTAwHuXGUdDxM=T0Ki4iwWagrJ8YQ@mail.gmail.com>
Subject: Re: [GIT PULL] x86/vdso changes for v3.1
From: Arnaud Lacombe <lacombar@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Lutomirski <luto@mit.edu>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Aug 25, 2011 at 3:51 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 08/25/2011 12:47 PM, Arnaud Lacombe wrote:
>>
>> CPU: Intel QEMU Virtual CPU version 0.14.50 stepping 03
>> About to apply_alternatives
>> start=c13bee88 a=0 instr_offset=-3922530 instr=cpu_idle+0x26/0x60
>> repl_offset=2336 repl=__alt_instructions_end+0x0/0x29f instrlen=5
>> repllen=3
>>   done
>
> Since this is a QEMU setup, could you share enough of the setup to
> reproduce?
>
pretty trivial:

% qemu -nographic \
   -kernel obj/next-bisect/arch/x86/boot/bzImage
   -append 'root=/dev/sda2 rootfstype=ext4 rootwait console=ttyS0
init=/etc/preinit loglevel=8'
   -hda openwrt-x86-generic-combined-ext4.img

The root filesystem is openwrt snapshot from August 19th.

 - Arnaud

>        -hpa
>
>
