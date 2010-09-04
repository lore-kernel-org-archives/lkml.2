Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783Ab0IDJRt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 05:17:49 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60515 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215Ab0IDJRs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 05:17:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=D+HFtgBLz4MD9KQnKHoNrFp1ci5cXF8gmiM/Y1swxVvtq7c5QNNwHlIeqZM/JbrcUQ
         f9X0AuvGJJkQh8sNJUZUVXJU0BdAQqiSq9QKQ21oMh48jPUOyaj1nes6ZmhG9h2ao+AW
         MlK9QdhEBNyz2191n8tVnmpeywm0Zsm9wwt1w=
MIME-Version: 1.0
In-Reply-To: <1283590584.1685.39.camel@steven>
References: <AANLkTimjO7sBzR55XkPB7dmZvxXqc8PS4UDsgptXVt90@mail.gmail.com>
 <1283504768.2100.43.camel@steven> <AANLkTik=0wMHh9fg8_vK_Aor40J43mNojvfHadhHObKA@mail.gmail.com>
 <1283590584.1685.39.camel@steven>
From: Hui Zhu <teawater@gmail.com>
Date: Sat, 4 Sep 2010 17:17:27 +0800
Message-ID: <AANLkTimYgMotZBbGTvPGSzfo3jjZ_-TeXftVQ6bBzHrT@mail.gmail.com>
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

On Sat, Sep 4, 2010 at 16:56, Steven <mqyoung@gmail.com> wrote:
> On Sat, 2010-09-04 at 11:41 +0800, Hui Zhu wrote:
>> BTW, looks GCC and GDB don't want handle the optimization debug
>> trouble (all they want is rewrite the GCC in C++ :P).
>> So I think make linux kernel can close optimization is better idea, do
>> you know some way or some patch to do it?
>>
>
> Just disable CONFIG_CC_OPTIMIZE_FOR_SIZE and modify the Makefile of
> kernel:
> KBUILD_CFLAGS   += -O2
> to
> KBUILD_CFLAGS   += -O0

Cool,  :)

I try just change the compile option of readdir.c to without -O2, it
works OK.  I think maybe it's a GDB bug too.
Could you try the second issue with gdb 7.2?

BTW, I think I need add some words let all the KGTP user use gdb 7.2
with KGTP in howto.  :)

Thanks for help me with this big issue.  :)

Best,
Hui

>
> Sometime gcc will still optimize out some variables even I compile a
> program with -O0, so volatile is required sometimes.
>
> Thanks,
> Steven
>
>
