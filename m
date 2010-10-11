Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626Ab0JKIji (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 04:39:38 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38505 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753434Ab0JKIj2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 04:39:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=s0kks2PwdzouAEZaWcSFrh9/os06sDu4SVgDkvlPX2WzVle1Ma0cjIJAokLgBrNxE2
         eYPAWgMf5be5V8tnDEtX6myl2GClWQchEgzoyFTjyxyP2SKD2KbEfQcxrOz5zY3X3nfV
         9Z/nZ8c98O+h3nNyCT7HNY4ZP4RSG9BqlY9XI=
MIME-Version: 1.0
In-Reply-To: <20101010235256.GG19804@ZenIV.linux.org.uk>
References: <20101007174948.GT19804@ZenIV.linux.org.uk>
	<AANLkTin4886D+-yo=zrf2Yj2R5NM9qdRkc3M9cG2rN_F@mail.gmail.com>
	<20101010144952.GF19804@ZenIV.linux.org.uk>
	<AANLkTinuA3AzMoJ82pvCuhmo59DZxL2F1j3xhXUkjj7z@mail.gmail.com>
	<20101010235256.GG19804@ZenIV.linux.org.uk>
Date: Mon, 11 Oct 2010 10:39:25 +0200
X-Google-Sender-Auth: 173Z76bS3pdSppLs-hvXvZzIFKc
Message-ID: <AANLkTinL7yVt7s+Ame_rK4sVWyRBjCQ2_7=5DZu2pWx4@mail.gmail.com>
Subject: Re: aranym bug, manifests as "ida_remove called for id=13" on recent kernels
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 11, 2010 at 01:52, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Sun, Oct 10, 2010 at 10:18:03PM +0200, Geert Uytterhoeven wrote:
>> >> This is on aranym-0.9.9-1 from Ubuntu/amd64.
>> >
>> > stat -L /proc/2/exec, otherwise you'll hit lstat() instead of stat().
>> > And FWIW 0.9.10-1 squeeze/amd64 also triggers here...
>>
>> Still, just "stat: cannot stat `proc/2/exe': No such file or directory" here...
>
> Interesting...  Which gcc version is used?

Good old gcc version 4.1.2 20061115 (prerelease) (Ubuntu 4.1.1-21)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
