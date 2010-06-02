Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932866Ab0FBRcW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 13:32:22 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42052 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758191Ab0FBRcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 13:32:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=VXYbWhVN4p79r/LYIslVycDgZitI+OfPVP/H3AJnRkNvnoTuki5mTTxajn4O8rTL6r
         nJuRFaVu/Fz+CT85/wmQyYa8FrEN/LEe7LTZ1zFCz+YTB8fJDit/fUKfbfyE6Vel29QA
         YE0LlW3dZB2o1ydc8awfnT/C4z5A91xsk6k1A=
MIME-Version: 1.0
In-Reply-To: <AANLkTilLXOSb2P_m4uUubmJar2VMFXizzpa_mQ1j8GPz@mail.gmail.com>
References: <l2k10f740e81004151234t3004275az36e7873493067a8a@mail.gmail.com>
	<alpine.OSX.2.00.1004161206300.271@localhost>
	<AANLkTikexlmuunBQ-ydNaD8fkKcLmrsfJSEgvyMJdNqU@mail.gmail.com>
	<alpine.OSX.2.00.1005290312230.691@localhost>
	<AANLkTilLXOSb2P_m4uUubmJar2VMFXizzpa_mQ1j8GPz@mail.gmail.com>
Date: Wed, 2 Jun 2010 19:24:08 +0200
X-Google-Sender-Auth: cikoQKi9kVLnvBksyTZU9Wg3Wvo
Message-ID: <AANLkTilqknhgBCXd-5Yxj9U8gDzDfMmmZdwDOvf-8kbH@mail.gmail.com>
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

On Sat, May 29, 2010 at 10:03, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Fri, May 28, 2010 at 19:21, Finn Thain <fthain@telegraphics.com.au> wrote:
>> On Sun, 23 May 2010, Geert Uytterhoeven wrote:
>>> >> But here's a better solution. I do not have the hardware to test it,
>>> >> though. Finn, does it {look OK,work}?
>>> >
>>> > It looks fine. I can't test it right now, but I will do so when I get
>>> > the opportunity.
>>>
>>> Any news from the test front?
>>
>> This is commit ba0f916ca7ac79356e2ed32a85c3aa8255b104e7, right?
>
> Yep.
>
>> If so, it tests OK here.
>
> Thanks for testing!

David, will you take this one too?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
