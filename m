Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563Ab0EWNPV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 09:15:21 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:46172 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754424Ab0EWNPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 09:15:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=k6mwktvb7INOA5E+pVr04p8Nbpsv2hmsXRNCWbd0Aoy4zk3Ruis1VJFoFi+HyQrX4h
         qDYTzR0xzGsCysWXVH+2QL4m24Fx76T83XIhJiOhyWcApyOAw2GZYc0f/H4Alay9K4fA
         ZemLLK5baZO3oNbA3JhGH0Gtu1e3j+Okn5WW8=
MIME-Version: 1.0
In-Reply-To: <alpine.OSX.2.00.1004161206300.271@localhost>
References: <l2k10f740e81004151234t3004275az36e7873493067a8a@mail.gmail.com>
	 <alpine.OSX.2.00.1004161206300.271@localhost>
Date: Sun, 23 May 2010 15:15:16 +0200
X-Google-Sender-Auth: Ei9AePAK3gnr1uOy_Ank2NugPsY
Message-ID: <AANLkTikexlmuunBQ-ydNaD8fkKcLmrsfJSEgvyMJdNqU@mail.gmail.com>
Subject: Re: [PATCH] net: mac8390 - Sort out memory/MMIO accesses and casts 
	(was: Re: drivers/net/mac8390.c: Remove useless memcpy casting)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Finn Thain <fthain@telegraphics.com.au>
Cc: Joe Perches <joe@perches.com>, "David S. Miller" <davem@davemloft.net>,
       netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Linux/m68k" <linux-m68k@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 16, 2010 at 04:14, Finn Thain <fthain@telegraphics.com.au> wrote:
> On Thu, 15 Apr 2010, Geert Uytterhoeven wrote:
>> On Mon, Mar 8, 2010 at 18:16, Joe Perches <joe@perches.com> wrote:
>> > Thanks, I'll submit a patch to fix it by tomorrow or so.
>>
>> It hasn't been fixed yet.
>
> Thanks for taking care of this, Geert.
>
>> But here's a better solution. I do not have the hardware to test it,
>> though. Finn, does it {look OK,work}?
>
> It looks fine. I can't test it right now, but I will do so when I get the
> opportunity.

Any news from the test front?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
