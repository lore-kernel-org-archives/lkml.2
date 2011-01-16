Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585Ab1APS4a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 13:56:30 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46032 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510Ab1APS42 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 13:56:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=F8jM69xGSmxVyt5+AyNTY8ynq09VQdTiNXgDjC9zscV/QKe2/lKFQmdUsQhPbhvQxT
         OqpT4HhDRj1FbeCDqhd6tPEo2qemEoYgSzapLiCazQVC/H64cJhFiVeMWFcKHF2Lwqje
         0omKNstkUC5ZWOHRSPHgEKk6oyUw1k1EA9CRU=
MIME-Version: 1.0
In-Reply-To: <4D01C770.1080301@lougher.demon.co.uk>
References: <4D007315.1090704@lougher.demon.co.uk>
	<AANLkTimUYrb8EMomgmsW+v7ttbkUH0P57SBD5M4_AGmU@mail.gmail.com>
	<4D01C770.1080301@lougher.demon.co.uk>
Date: Sun, 16 Jan 2011 19:56:26 +0100
X-Google-Sender-Auth: NOZ1Hc3L7bUY5NxRWjC_EtBrEyw
Message-ID: <AANLkTinfFk-mkzgt_qw2+Y5GxkuPVC9S63reuG=GQ84=@mail.gmail.com>
Subject: Re: [PATCH 2/2] Squashfs: Add XZ compression configuration option
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org,
        Linux Embedded Maillist <linux-embedded@vger.kernel.org>,
        Lasse Collin <lasse.collin@tukaani.org>,
        Andy Whitcroft <apw@canonical.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 10, 2010 at 07:23, Phillip Lougher
<phillip@lougher.demon.co.uk> wrote:
> Geert Uytterhoeven wrote:
>> On Thu, Dec 9, 2010 at 07:11, Phillip Lougher
>> <phillip@lougher.demon.co.uk> wrote:
>>>
>>> --- a/fs/squashfs/Kconfig
>>> +++ b/fs/squashfs/Kconfig
>>> @@ -53,6 +53,22 @@ config SQUASHFS_LZO
>>>
>>>         If unsure, say N.
>>>
>>> +config SQUASHFS_XZ
>>> +       bool "Include support for XZ compressed file systems"
>>> +       depends on SQUASHFS
>>> +       default n
>>
>> "default n" is the default, no reason to specify it.
>>
>
> Yes, thanks for pointing that out.
>
> It seems there's a lot of "default n"s in the mainline kernel
>
> % find . -name "Kconfig"| xargs grep "default n" | wc
>    485    1535   18753
>
> including two in arch/m68k ;-)

Thanks, fixed.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
