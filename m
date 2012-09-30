Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751150Ab2I3Jfo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 05:35:44 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:54169 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab2I3Jfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 05:35:42 -0400
MIME-Version: 1.0
In-Reply-To: <20120930112052.733ce361@endymion.delvare>
References: <CAMuHMdXqsPgfToNyjbxJ-WM=-kEEvAweE03wb3vtkwVO+-RR3A@mail.gmail.com>
	<20120927115134.GA5654@osiris.de.ibm.com>
	<CAMuHMdUqXnY5ZNgjYN0YMpLkPw0j41MXM18H9qiLoEk-BzKYMg@mail.gmail.com>
	<20120930105350.16e54037@endymion.delvare>
	<CAMuHMdV=mcVuVuJaWrVjwxLz0+gkBoC=NUq6=C176B3W7j8Yag@mail.gmail.com>
	<20120930112052.733ce361@endymion.delvare>
Date: Sun, 30 Sep 2012 11:35:41 +0200
X-Google-Sender-Auth: vC8yLlrmzcVm-787rbazG7hMgd8
Message-ID: <CAMuHMdVV5F148RrqyGgD7q9y_C5tTnGi8S9hC4tus6wu-mLPxw@mail.gmail.com>
Subject: Re: [-next]: s390 *_irq() link errors
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Peter Huewe <peterhuewe@gmx.de>, linux-s390@vger.kernel.org,
        Linux-Next <linux-next@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 30, 2012 at 11:20 AM, Jean Delvare <khali@linux-fr.org> wrote:
> On Sun, 30 Sep 2012 11:08:41 +0200, Geert Uytterhoeven wrote:
>> On Sun, Sep 30, 2012 at 10:53 AM, Jean Delvare <khali@linux-fr.org> wrote:
>> > I thought we were trying to move away from explicit arch exclusions,
>> > but if S390 is special then fine with me. I've folded Heiko's fix into
>>
>> "depends on GENERIC_HARDIRQS" is the alternative...
>
> That would make even less sense to me, I2C can work just fine without
> IRQs.

For the individual drivers that need it...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
