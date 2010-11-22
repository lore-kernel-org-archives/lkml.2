Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098Ab0KVSYQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 13:24:16 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39553 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab0KVSYO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 13:24:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=NK03VKv+nuayaOfjDzlYAiTnnJODTYDzZcToG8HWlEqdcWKXWhC1ex5bIUgwrlG5UA
         1P4suWSIBH4W9nep2NP0AfMGhBVVtGnfgh3++cQx8WqUFndQ/X91az34yjyS0bHHpG5C
         DXG3zlTtXGAtzq65jz9GhX2PYxhf6/tW2warY=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=fNH4-VjLh1zzk-UdEQevR16_K8igdLeodw6yL@mail.gmail.com>
References: <4ce85e437577ae827@agluck-desktop.sc.intel.com>
	<1290391175.2903.132.camel@yhuang-dev>
	<AANLkTi=fNH4-VjLh1zzk-UdEQevR16_K8igdLeodw6yL@mail.gmail.com>
Date: Mon, 22 Nov 2010 19:24:12 +0100
X-Google-Sender-Auth: XlAYqiPUFy7unBQxZnxRjOQlpFc
Message-ID: <AANLkTimqn+qS5RxETz1DznsMDS4gZBGxkLkdCgTQ7qG-@mail.gmail.com>
Subject: Re: [RFC] persistent store
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Tony Luck <tony.luck@intel.com>
Cc: Huang Ying <ying.huang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>, "greg@kroah.com" <greg@kroah.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 22, 2010 at 17:55, Tony Luck <tony.luck@intel.com> wrote:
> On Sun, Nov 21, 2010 at 5:59 PM, Huang Ying <ying.huang@intel.com> wrote:
>> This patch provides a general "read" interface for kmsg_dumper and some
>> other persistent storage users. Another possible choice is to just
>> extend the original interface to add persistent store support. For
>> example, we can add a "read" function in kmsg_dumper, and output the
>> content of persistent store via extend /dev/kmsg via prefix every line
>> comes from persistent store or adding some "ioctl" to do that. (But it
>> seems that nobody likes "ioctl").
>
> In Linux (and Unix before it) "everything is a file" ... but this
> doesn't work very well if the file has internal structure (e.g.
> is made of records that can be individually changed or
> deleted).  A filesystem seems a much better model.

Any tangents with "pramfs: persistent and protected RAM filesystem"
on linux-embedded?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
