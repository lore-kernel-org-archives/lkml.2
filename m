Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701Ab0ERLXH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 07:23:07 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:46389 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271Ab0ERLXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 07:23:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=TYcTGYKeFA0LKHBMLo/bi+vwtP7gNXmjorwsYE2oZ08m+zlYEMg7t/7CZAcG28/2io
         J6tWLMK5JgkoNyOn+X44QlFzRTWvkhqGSUAesCMJ2oXNMynT2jnXBboDp1Fq6fCcL7SZ
         NV7CK4xAci/sfhdG13CnAyVCZDJig9ssX41D8=
MIME-Version: 1.0
In-Reply-To: <AANLkTindMQ3Clk_qVnwUNYbbWcXjsUyyy4fQsjdDflFt@mail.gmail.com>
References: <20100518092532.GA3050@linux-sh.org>
	 <AANLkTim6t8oG-vdLKE918Sd2TFKJpSf5Bw2PTtSsD_Fh@mail.gmail.com>
	 <20100518101500.GA3156@linux-sh.org>
	 <AANLkTinIVjwrQ9gza2FIvZN5w4nm8ZjSUe836oRmWYG7@mail.gmail.com>
	 <AANLkTindMQ3Clk_qVnwUNYbbWcXjsUyyy4fQsjdDflFt@mail.gmail.com>
Date: Tue, 18 May 2010 16:46:12 +0530
Message-ID: <AANLkTilNQwo1YYT2pNJN5X0ae98iMKCdsBkcogjKZm-f@mail.gmail.com>
Subject: Re: [GIT PULL] sh updates for 2.6.35-rc1
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: Paul Mundt <lethal@linux-sh.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
       Russell King - ARM Linux <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello magnus,

On Tue, May 18, 2010 at 4:35 PM, Magnus Damm <magnus.damm@gmail.com> wrote:
> Hi Jaswinder,
>
> On Tue, May 18, 2010 at 7:51 PM, Jaswinder Singh Rajput
> <jaswinderlinux@gmail.com> wrote:
>> Hmm, so still it is between ARM and SH, so better option will be :
>>
>> include/linux/sh_clk.h -> include/sh/clk.h
>> include/linux/sh_dma.h -> include/sh/dma.h
>> include/linux/sh_intc.h -> include/sh/intc.h
>>
>> So when arm files will come then, then we can make it like this :
>>
>> include/arm/clk.h
>> include/arm/dma.h
>> include/arm/intc.h
>>
>> So user will program like this :
>>
>> #include <arm/dma.h>
>> #include <sh/dma.h>
>
> Right now the SH code does
>
> #include <linux/sh_intc.h>
>
> and the ARM code does
>
> #include <linux/sh_intc.h>
>
> Hope this clarifies!
>

I am looking at the future, where multiple architecture will use each
other files.

I am just worried about the file count. Currently :

$ ls include/linux/ | wc -l
1029

If other architecture will also start adding the files in
include/linux like you did then ?

So better make another directory in include.

Thanks,
--
Jaswinder Singh.
