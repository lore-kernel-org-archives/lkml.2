Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400Ab0FSJyJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 05:54:09 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48364 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755290Ab0FSJyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 05:54:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=VZ9ndNRYQIIDdUi+LCSbyvILwx6lqH5tVLl4ecs+ZoY238CwyAGNN8wwOpbmD6+Pn0
         4oE0t/ZCNS4KTPrcrG6f+TPCVMHgu3Gwy5t5eyzkwQx3ztpgAuCYdkwb3dk4k45G/phL
         VJMSaEfyx0+u9teGnb+TmwsUETkgQ6LkoCCjE=
MIME-Version: 1.0
In-Reply-To: <AANLkTimce-yUWW9uXNNGYO48wEgzJuFn8UWzJuhhUy3C@mail.gmail.com>
References: <alpine.DEB.1.10.1001041421450.4942@dr-wily.mit.edu>
	<AANLkTinji7n8Hd1Ldci_ruH0r8qglGjC00YQkb-MEwoV@mail.gmail.com>
	<AANLkTilcHe8jnIBcTC_FjLPGxIbuZV3snU4u0FtdoeDi@mail.gmail.com>
	<AANLkTim4Tn74BSTqpXMfZeAG9eLDYEKUbcN_wiw2HpBY@mail.gmail.com>
	<AANLkTikU23ID2LWjAOAeGnnhhV5wulXeRghVG20PFPje@mail.gmail.com>
	<AANLkTilqSSfV3vR-fI1LxrsuSMt_M7_zaeT_xQuNVJL4@mail.gmail.com>
	<AANLkTilrk4mzoKIGIWTElkdMnoWwEjXgAMOEZpdLvuz0@mail.gmail.com>
	<AANLkTikzj9PTDnKHXtwLEet1AFZc_uKj8dUm2wXh7Txo@mail.gmail.com>
	<AANLkTimce-yUWW9uXNNGYO48wEgzJuFn8UWzJuhhUy3C@mail.gmail.com>
Date: Sat, 19 Jun 2010 11:54:02 +0200
Message-ID: <AANLkTim1X5nlYtFxajkWCJOPubEkOGciqlCWeGDKQdQV@mail.gmail.com>
Subject: Re: [RESEND][REGRESSION] um: CONFIG_STATIC_LINK=y broken
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: akpm@linux-foundation.org, tabbott@ksplice.com,
       linux-kernel@vger.kernel.org, Jeff Dike <jdike@addtoit.com>,
       user-mode-linux-devel@lists.sourceforge.net, stable@kernel.org,
       maurer@ugcs.caltech.edu
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 19, 2010 at 10:59 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> On Sat, Jun 19, 2010 at 00:23, richard -rw- weinberger
> <richard.weinberger@gmail.com> wrote:
>> On Fri, Jun 18, 2010 at 10:01 PM, Geert Uytterhoeven
>> <geert@linux-m68k.org> wrote:
>>> On Fri, Jun 18, 2010 at 19:50, richard -rw- weinberger
>>> <richard.weinberger@gmail.com> wrote:
>>>> On Fri, Jun 18, 2010 at 7:17 PM, Geert Uytterhoeven
>>>> <geert@linux-m68k.org> wrote:
>>>>> On Fri, Jun 18, 2010 at 17:22, richard -rw- weinberger
>>>>> <richard.weinberger@gmail.com> wrote:
>>>>>> On Fri, Jun 18, 2010 at 4:27 PM, Geert Uytterhoeven
>>>>>> <geert@linux-m68k.org> wrote:
>>>>>>> On Fri, Jun 18, 2010 at 15:49, richard -rw- weinberger
>>>>>>> <richard.weinberger@gmail.com> wrote:
>>>>>>>> Andrew, Linus, Jeff, ... anyone?
>>>>>>>> Please apply this patch.
>>>>>>>>
>>>>>>>> CONFIG_STATIC_LINK is still broken. :(
>>>>>>>
>>>>>>> I wanted to verify Tim's patch, but after enabling CONFIG_STATIC_LINK,
>>>>>>> it fails to link
>>>>>>> (with or without your patch):
>>>>>>>
>>>>>>
>>>>>> BTW: Does CONFIG_STATIC_LINK work for you when you revert commit
>>>>>> 5d150a97f9391f5bcd7ba0d59d7a11c3de3cea80 (um: Clean up linker script
>>>>>> using standard macros)?
>>>>>
>>>>> Still the same linking errors ;-(
>>>>>
>>>>
>>>> Are you using a non-x86 environment?
>>>> Maybe CONFIG_STATIC_LINK is more broken than i thought.
>>>
>>> I'm using amd64 on Ubuntu 10.04.
>>>
>>
>> Can please you test this patch?
>> http://groups.google.com/group/fa.linux.kernel/browse_thread/thread/03cd264b00551949?pli=1
>
> Matthew's patch fixes the linking problem for me.
>
> Interestingly, CONFIG_STATIC_LINK=y now boots fine for me, with and
> without Tim's patch?

Tim's patch fixes the issue on x86 and Matthew's patch fixes it on amd64.
I'll combine both patches and test them also on some other archs.

-- 
Cheers,
//richard
