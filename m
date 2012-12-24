Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191Ab2LXOfQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 09:35:16 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:45724 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572Ab2LXOfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 09:35:13 -0500
MIME-Version: 1.0
In-Reply-To: <50CFD786.5010101@asianux.com>
References: <50CAA1F2.9000003@asianux.com>
	<50CFD786.5010101@asianux.com>
Date: Mon, 24 Dec 2012 08:27:03 -0600
Message-ID: <CAJ6Av5NtM06aTsGzE+4cYH-TM2fkN3Ek0f=OuR=_abDtta1FDA@mail.gmail.com>
Subject: Re: [Suggestion] drivers/staging/tidspbridge: strcpy and strncpy, src
 length checking issue.
From: Omar Ramirez Luna <omar.ramirez@copitl.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gchen,

On Mon, Dec 17, 2012 at 8:40 PM, Chen Gang <gang.chen@asianux.com> wrote:
> Hello Omar Ramirez Luna:
>
>   excuse me to bother you (maybe you are busy in these days).
>   please help checking this suggestion when you have free time.

Yes, I'm checking your suggestions, I was a little busy last week, for
the compile breaks I had a patch but I was waiting for them to show on
staging 3.8-rc1.

> By the way:
>   this week, I need work for 2 patches which relative with usb sub-system.
>   if still get no reply for tidspbridge until next week.
>     I should work for it, it is my duty (since I have provided 'suggestion' to it).
>     "work for it" means:
>        if tidspbridge is still useful
>          I need construct relative environments for unit test.
>          then provide relative patches.
>        else (useless)
>          I need delete it from Open Source.
>          (since it can not pass compiling, and no response from *@ti.com, it almost means useless)

Please DON'T assume it's useless if you don't get replies from @ti.com .

>          (at least, fix the 2 compiling issues which I have suggested, can pass compiling)

Done.

Cheers,

Omar
