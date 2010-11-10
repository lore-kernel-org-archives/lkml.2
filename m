Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751Ab0KJIPk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 03:15:40 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41507 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734Ab0KJIPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 03:15:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=IPIrSV//+h8LV/l6hPcP76QxZvmHzuDr0qa/s7tRnN1dw11GxaS7InxpyrgRFPH0A+
         Goe1KpuZXqwPEE5H28bRvEfTIIMIItwyphcx+AjhFXhr5Wh2N14Lb3Y/4w48fAydrxz3
         v2JVkleSEOkVp2GNZgqtc1nMmz+5n/j0WbdAE=
MIME-Version: 1.0
In-Reply-To: <AANLkTiky0LLnipJN3tCwcW6F2LEK-REEd=Ovo0ewMubR@mail.gmail.com>
References: <4CD518C5.6000509@gmail.com>
	<4CD7076D.80507@bluewatersys.com>
	<AANLkTinJJG0K=BPS0CPzDWcgpRn_yPxZ819N408SwD6d@mail.gmail.com>
	<4CD85489.8000503@bluewatersys.com>
	<AANLkTim8rAQnVYpZdykd2VuL1N9CvkGj88Kf5qpSuJsC@mail.gmail.com>
	<4CD9B09F.5090707@bluewatersys.com>
	<AANLkTiky0LLnipJN3tCwcW6F2LEK-REEd=Ovo0ewMubR@mail.gmail.com>
Date: Wed, 10 Nov 2010 09:15:36 +0100
Message-ID: <AANLkTik+Vx8W1qXEZ=AqedRSj_D4-k70Xa4h-bnW2MRH@mail.gmail.com>
Subject: Re: [PATCH 08/16 v2] pramfs: headers
From: Marco Stornelli <marco.stornelli@gmail.com>
To: Ryan Mallon <ryan@bluewatersys.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/9 Geert Uytterhoeven <geert@linux-m68k.org>:
> On Tue, Nov 9, 2010 at 21:35, Ryan Mallon <ryan@bluewatersys.com> wrote:
>> You can still do all of those things without having a fixed endianess.
>> You just have to have one extra step of telling the external tools what
>> the endianess is. IMHO, it is better to have the overhead of the endian
>> conversion in the tools since it is less costly there than an the
>> embedded system.
>>
>> I'm just trying to understand why the fixed endianess rule cannot be
>> bent for such a specialised filesystem.
>
> When it was decided that filesystems should be fixed-endian and support for
> big-endian ext2 was dropped, the overhead of doing the fixed conversions was
> deetermined negligible due to compiler optimization.
> That was ages ago, and current embedded systems run circles around the
> machines of those days.
>
> Note that this is about metadata only. Actual file contents are always just
> byte streams.
>

I can add that the penalties in this case are  negligible due to the
compensation of the very fast access of the media. In addition, from
performance point of view I'm pretty happy (you can see the some
benchmark on the project web site).

Marco
