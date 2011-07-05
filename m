Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932290Ab1GELiH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 07:38:07 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37646 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932242Ab1GELiF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 07:38:05 -0400
MIME-Version: 1.0
In-Reply-To: <201107051331.15504.richard@nod.at>
References: <1309821341.4527.5.camel@vitaliy-Vostro-1400>
	<201107051128.25262.richard@nod.at>
	<CAGTPOqcAETWHG3DEOwDZkMG8_qd-opf90psCi=+U+tYcGV=7=A@mail.gmail.com>
	<201107051331.15504.richard@nod.at>
Date: Tue, 5 Jul 2011 13:38:05 +0200
X-Google-Sender-Auth: h1t3yAubezGPUnBcWwtcnPsgdbk
Message-ID: <CAMuHMdWWPiFTwQ+0Et8eZZbCy-DtzRMeK=-rFY_NfEWWjYrZ2Q@mail.gmail.com>
Subject: Re: [PATCH 1/4] uml: cow_user.c warning corrections
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Richard Weinberger <richard@nod.at>
Cc: Vitaliy Ivanov <vitalivanov@gmail.com>, Jeff Dike <jdike@addtoit.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        user-mode-linux-devel@lists.sourceforge.net,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 5, 2011 at 13:31, Richard Weinberger <richard@nod.at> wrote:
> Am Dienstag 05 Juli 2011, 13:10:34 schrieb Vitaliy Ivanov:
>> On Tue, Jul 5, 2011 at 12:28 PM, Richard Weinberger <richard@nod.at> wrote:
>> > Am Dienstag 05 Juli 2011, 01:15:41 schrieb Vitaliy Ivanov:
>> >> From 6201d3e862fca8670b206338dc90303ea0acc77d Mon Sep 17 00:00:00 2001
>> >> From: Vitaliy Ivanov <vitalivanov@gmail.com>
>> >> Date: Tue, 5 Jul 2011 01:57:51 +0300
>> >> Subject: [PATCH 1/4] uml: cow_user.c warning corrections
>> >> MIME-Version: 1.0
>> >> Content-Type: text/plain; charset=UTF-8
>> >> Content-Transfer-Encoding: 8bit
>> >>
>> >> arch/um/drivers/cow_user.c: In function ‘absolutize’:
>> >> arch/um/drivers/cow_user.c:189:7: warning: ignoring return value of
>> >> ‘chdir’, declared with attribute warn_unused_result
>> >
>> > What compiler flags are you using?
>> > Using the default settings this warning does not show up.
>> > Most of the "ignoring return value" are totally useless.
>>
>> chdir is defined with warn_unused_result attribute and my gcc on
>> Ubuntu 11.04 issues warnings.
>> I don't use any additional flags on compiling UML.
>
> Ah, because of -D_FORTIFY_SOURCE=2, right?
> Then your patches makes sense.

I also saw it, with gcc version 4.4.3 (Ubuntu 4.4.3-4ubuntu5).
I never used FORTIFY_SOURCE.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
