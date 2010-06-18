Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933827Ab0FRRRb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 13:17:31 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:41051 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933739Ab0FRRR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 13:17:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=JfB/iR7mJfyHbT0MEviPsUrIPiTw4iYy7kaNLWXQ0JB4Hho6Fl3Py1Zj0yue76UaTb
         jyNKH7NtUaoV3yBcRWIcKupv75PlY+gSGkEljIEbyoBl2FYP1t5Z/fJGPyjQcE6xxV0a
         SGVGUFL18Y9uYY9riwhoQUXy3HsRzkzkXdfNc=
MIME-Version: 1.0
In-Reply-To: <AANLkTim4Tn74BSTqpXMfZeAG9eLDYEKUbcN_wiw2HpBY@mail.gmail.com>
References: <alpine.DEB.1.10.1001041421450.4942@dr-wily.mit.edu>
	<AANLkTinji7n8Hd1Ldci_ruH0r8qglGjC00YQkb-MEwoV@mail.gmail.com>
	<AANLkTilcHe8jnIBcTC_FjLPGxIbuZV3snU4u0FtdoeDi@mail.gmail.com>
	<AANLkTim4Tn74BSTqpXMfZeAG9eLDYEKUbcN_wiw2HpBY@mail.gmail.com>
Date: Fri, 18 Jun 2010 19:17:27 +0200
X-Google-Sender-Auth: bHHaUzlNUDAPGPeYaXGXidyJbDQ
Message-ID: <AANLkTikU23ID2LWjAOAeGnnhhV5wulXeRghVG20PFPje@mail.gmail.com>
Subject: Re: [RESEND][REGRESSION] um: CONFIG_STATIC_LINK=y broken
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: akpm@linux-foundation.org, tabbott@ksplice.com,
       linux-kernel@vger.kernel.org, Jeff Dike <jdike@addtoit.com>,
       user-mode-linux-devel@lists.sourceforge.net, stable@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 18, 2010 at 17:22, richard -rw- weinberger
<richard.weinberger@gmail.com> wrote:
> On Fri, Jun 18, 2010 at 4:27 PM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
>> On Fri, Jun 18, 2010 at 15:49, richard -rw- weinberger
>> <richard.weinberger@gmail.com> wrote:
>>> Andrew, Linus, Jeff, ... anyone?
>>> Please apply this patch.
>>>
>>> CONFIG_STATIC_LINK is still broken. :(
>>
>> I wanted to verify Tim's patch, but after enabling CONFIG_STATIC_LINK,
>> it fails to link
>> (with or without your patch):
>>
>
> BTW: Does CONFIG_STATIC_LINK work for you when you revert commit
> 5d150a97f9391f5bcd7ba0d59d7a11c3de3cea80 (um: Clean up linker script
> using standard macros)?

Still the same linking errors ;-(

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
