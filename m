Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933759Ab0FRUS1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 16:18:27 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54128 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933515Ab0FRUSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 16:18:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=taHuvLpCBPg9sHjlAhvSBpHH9UPtcgLI22hXwlm2GeDZURGHF+NsaponksTeiL0/Ch
         JWXcNmuABlznz5gAl5T8xwWRB3Zk2Bpjm3/0aWo7Wk5/xozIkeOCzbIgmh6zxsGlaRCB
         uxfdRToHgzK8zehY+yzEqd8R1qAlUlQKW+OiE=
MIME-Version: 1.0
In-Reply-To: <AANLkTilrk4mzoKIGIWTElkdMnoWwEjXgAMOEZpdLvuz0@mail.gmail.com>
References: <alpine.DEB.1.10.1001041421450.4942@dr-wily.mit.edu>
	<AANLkTinji7n8Hd1Ldci_ruH0r8qglGjC00YQkb-MEwoV@mail.gmail.com>
	<AANLkTilcHe8jnIBcTC_FjLPGxIbuZV3snU4u0FtdoeDi@mail.gmail.com>
	<AANLkTim4Tn74BSTqpXMfZeAG9eLDYEKUbcN_wiw2HpBY@mail.gmail.com>
	<AANLkTikU23ID2LWjAOAeGnnhhV5wulXeRghVG20PFPje@mail.gmail.com>
	<AANLkTilqSSfV3vR-fI1LxrsuSMt_M7_zaeT_xQuNVJL4@mail.gmail.com>
	<AANLkTilrk4mzoKIGIWTElkdMnoWwEjXgAMOEZpdLvuz0@mail.gmail.com>
Date: Fri, 18 Jun 2010 22:18:22 +0200
Message-ID: <AANLkTikQXNFVJY4ZKEhS3ZHu7KSRPpOU5PdvACjRkx_7@mail.gmail.com>
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

On Fri, Jun 18, 2010 at 10:01 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> On Fri, Jun 18, 2010 at 19:50, richard -rw- weinberger
> <richard.weinberger@gmail.com> wrote:
>> On Fri, Jun 18, 2010 at 7:17 PM, Geert Uytterhoeven
>> <geert@linux-m68k.org> wrote:
>>> On Fri, Jun 18, 2010 at 17:22, richard -rw- weinberger
>>> <richard.weinberger@gmail.com> wrote:
>>>> On Fri, Jun 18, 2010 at 4:27 PM, Geert Uytterhoeven
>>>> <geert@linux-m68k.org> wrote:
>>>>> On Fri, Jun 18, 2010 at 15:49, richard -rw- weinberger
>>>>> <richard.weinberger@gmail.com> wrote:
>>>>>> Andrew, Linus, Jeff, ... anyone?
>>>>>> Please apply this patch.
>>>>>>
>>>>>> CONFIG_STATIC_LINK is still broken. :(
>>>>>
>>>>> I wanted to verify Tim's patch, but after enabling CONFIG_STATIC_LINK,
>>>>> it fails to link
>>>>> (with or without your patch):
>>>>>
>>>>
>>>> BTW: Does CONFIG_STATIC_LINK work for you when you revert commit
>>>> 5d150a97f9391f5bcd7ba0d59d7a11c3de3cea80 (um: Clean up linker script
>>>> using standard macros)?
>>>
>>> Still the same linking errors ;-(
>>>
>>
>> Are you using a non-x86 environment?
>> Maybe CONFIG_STATIC_LINK is more broken than i thought.
>
> I'm using amd64 on Ubuntu 10.04.
>

On my CentOS 5 x86_64 i get no linking error.
Sadly I don't have a 64bits Ubuntu machine.

-- 
Cheers,
//richard
