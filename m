Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484Ab0IDJKY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 05:10:24 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33583 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab0IDJKX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 05:10:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=wR6jdNzr0R7s/wFgMllWNexwGLSuR4DWTKcoCMG+j/fp3eP6c/NZLKtGV4GZbcsDs3
         33NPHeRoDWkmf0LLvNrjqXu5axEFS2wGJ2NNgSMAehqvChoYF/5svqgsmDbHHWpQRU17
         SNsP11LSJpMY0pZ1w5T8ZYvuJE62ryoThDCE4=
MIME-Version: 1.0
In-Reply-To: <1283590891.1685.41.camel@steven>
References: <AANLkTimjO7sBzR55XkPB7dmZvxXqc8PS4UDsgptXVt90@mail.gmail.com>
 <1283504768.2100.43.camel@steven> <AANLkTik=0wMHh9fg8_vK_Aor40J43mNojvfHadhHObKA@mail.gmail.com>
 <AANLkTi=o0HXcgEAhmyZRN7mVPys55Bc5CGncchSAKL6i@mail.gmail.com> <1283590891.1685.41.camel@steven>
From: Hui Zhu <teawater@gmail.com>
Date: Sat, 4 Sep 2010 17:10:02 +0800
Message-ID: <AANLkTimLL-3i5oSiNCd239fPrjTEL=mbauK+hEYhkbFp@mail.gmail.com>
Subject: Re: Linux Kernel GDB tracepoint module 2010-8-30 release
To: Steven <mqyoung@gmail.com>
Cc: "gdb@sourceware.org" <gdb@sourceware.org>, linux-kernel@vger.kernel.org,
        Michael Snyder <msnyder@vmware.com>,
        Marc Khouzam <marc.khouzam@ericsson.com>,
        Thiago Jung Bauermann <thiago.bauermann@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 4, 2010 at 17:01, Steven <mqyoung@gmail.com> wrote:
> Dear Hui,
>
> Thank you verch much!
> My board is 64-bit MIPS, is KGTP available on 64-bit MIPS?
>
>

The code is done.  But it isn't be tested.  Maybe you can be the first
mips64 user.  :)

Thanks,
Hui


> Best Regards,
> Steven
>
>
> On Sat, 2010-09-04 at 15:47 +0800, Hui Zhu wrote:
>> > The MIPS support that you interest is check in to the KGTP truck.  I
>> > just try it with a mips32el board.
>> > To cross-compile it, you need set the CROSS_COMPILE ,KERNELDIR and
>> > ARCH in Makefile.
>>
>> Forgot 1 thing, if you want remote debug the MIPS board, you can use
>> call netcat in board for example:
>> nc -l -p 1234 < /proc/gtp > /proc/gtp
>>
>> And debug with GDB command:
>> target remote board_ip:1234
>
>
