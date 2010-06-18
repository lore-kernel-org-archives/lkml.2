Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933889Ab0FRRuV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 13:50:21 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:41682 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754832Ab0FRRuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 13:50:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=c0oJDnpr0S4vz3J05Rn8URlSgWGF/AnyJz4Xncq9eNnpyZ0aaryuXtkOT+YFv/kv/T
         cBgQHxGZRvOevL0fINugrS+D+JN5U4+x+h8CEjf5YznyMp6F7JoFPovu9exXqMsHohSZ
         AGA9rpQ9lxchbOZtriM7k0Pmfg/4tYUlUI090=
MIME-Version: 1.0
In-Reply-To: <AANLkTikU23ID2LWjAOAeGnnhhV5wulXeRghVG20PFPje@mail.gmail.com>
References: <alpine.DEB.1.10.1001041421450.4942@dr-wily.mit.edu>
	<AANLkTinji7n8Hd1Ldci_ruH0r8qglGjC00YQkb-MEwoV@mail.gmail.com>
	<AANLkTilcHe8jnIBcTC_FjLPGxIbuZV3snU4u0FtdoeDi@mail.gmail.com>
	<AANLkTim4Tn74BSTqpXMfZeAG9eLDYEKUbcN_wiw2HpBY@mail.gmail.com>
	<AANLkTikU23ID2LWjAOAeGnnhhV5wulXeRghVG20PFPje@mail.gmail.com>
Date: Fri, 18 Jun 2010 19:50:17 +0200
Message-ID: <AANLkTilqSSfV3vR-fI1LxrsuSMt_M7_zaeT_xQuNVJL4@mail.gmail.com>
Subject: Re: [RESEND][REGRESSION] um: CONFIG_STATIC_LINK=y broken
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: akpm@linux-foundation.org, tabbott@ksplice.com,
       linux-kernel@vger.kernel.org, Jeff Dike <jdike@addtoit.com>,
       user-mode-linux-devel@lists.sourceforge.net, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 18, 2010 at 7:17 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> On Fri, Jun 18, 2010 at 17:22, richard -rw- weinberger
> <richard.weinberger@gmail.com> wrote:
>> On Fri, Jun 18, 2010 at 4:27 PM, Geert Uytterhoeven
>> <geert@linux-m68k.org> wrote:
>>> On Fri, Jun 18, 2010 at 15:49, richard -rw- weinberger
>>> <richard.weinberger@gmail.com> wrote:
>>>> Andrew, Linus, Jeff, ... anyone?
>>>> Please apply this patch.
>>>>
>>>> CONFIG_STATIC_LINK is still broken. :(
>>>
>>> I wanted to verify Tim's patch, but after enabling CONFIG_STATIC_LINK,
>>> it fails to link
>>> (with or without your patch):
>>>
>>
>> BTW: Does CONFIG_STATIC_LINK work for you when you revert commit
>> 5d150a97f9391f5bcd7ba0d59d7a11c3de3cea80 (um: Clean up linker script
>> using standard macros)?
>
> Still the same linking errors ;-(
>

Are you using a non-x86 environment?
Maybe CONFIG_STATIC_LINK is more broken than i thought.

Cheers,
//richard
