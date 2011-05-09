Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185Ab1EIHKa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 03:10:30 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60852 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006Ab1EIHKT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 03:10:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ZtBwosznah34nC4BcdaBDv5n9yZOXWFejdo5E6bh08sFRmcLJ3XlXCh1WdT0XSLcPi
         34VKgi1A8DooALjgrimGBPdwc8xCPbJzZ3r0vaVwrT5TRsZoe6ywD/WreAhUtpQowWTE
         E3HiGHZ73wBLNal4YTRAicDzA8s9H7XhpxpE4=
MIME-Version: 1.0
In-Reply-To: <20110509060048.GA27577@core.coreip.homeip.net>
References: <1304846247-12401-1-git-send-email-geert@linux-m68k.org>
	<20110509060048.GA27577@core.coreip.homeip.net>
Date: Mon, 9 May 2011 09:10:17 +0200
X-Google-Sender-Auth: FtR8Ov6ELa5Ymu7dONusWE2gKCo
Message-ID: <BANLkTi=CMAJrkAsKP4_QEaDVSw8Cz_RJfQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] Atari input patches
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On Mon, May 9, 2011 at 08:00, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> On Sun, May 08, 2011 at 11:17:24AM +0200, Geert Uytterhoeven wrote:
>> Here are 3 patches to fix keyboard and mouse on Atari, after conversion to
>> the "new" (several years old) input framework.
>>
>>   [1/3] input/atari: Use the correct mouse interrupt hook
>>   [2/3] input/atari: Fix atarimouse init
>>   [3/3] input/atari: Fix mouse movement and button mapping
>>
>> Will you take them for 2.6.40, or can I get them in through my m68k tree?
>
> I can either take them or you can push them. I do not really have a
> preference. There is nothing in my tree that would conflict with these
> as far as I know.

In that case I'll push them myself. Thx again!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
