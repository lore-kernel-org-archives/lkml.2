Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933700Ab2JXMsI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 08:48:08 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:48681 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932517Ab2JXMsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 08:48:06 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <CAKi4VA+tW30=8c18kNXVrw+v2x9=kQEYoF7Yjck6C98wHpNs0A@mail.gmail.com>
References: <CAKgNAkgp1er3-3nvge9_aVObuuxBatGRur8DtiTzyWK4w+4hrA@mail.gmail.com>
 <87txu17lss.fsf@rustcorp.com.au> <CAKgNAkib2RZaHWP9bM0hC62=Nm5sBisQf_D9BAKNomjEPvCWbA@mail.gmail.com>
 <CAKgNAkghLrh61FvxcuQ3xKfX7=o-PhV390RN+9Ni+3fgJzMFJA@mail.gmail.com> <CAKi4VA+tW30=8c18kNXVrw+v2x9=kQEYoF7Yjck6C98wHpNs0A@mail.gmail.com>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Wed, 24 Oct 2012 14:47:43 +0200
Message-ID: <CAKgNAki5NbXWU8i7DtCEqAt=3pG+OtZe9E+Wm3xjJGD-sDbO6Q@mail.gmail.com>
Subject: Re: [Request for review] Revised delete_module(2) manual page
To: Lucas De Marchi <lucas.de.marchi@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org, linux-man <linux-man@vger.kernel.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Jon Masters <jonathan@jonmasters.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lucas,

On Wed, Oct 24, 2012 at 7:27 AM, Lucas De Marchi
<lucas.de.marchi@gmail.com> wrote:
> Hi Michael,
>
>
> On Sun, Oct 21, 2012 at 5:36 AM, Michael Kerrisk (man-pages)
> <mtk.manpages@gmail.com> wrote:
>> Ping!
>>
>> Rusty (et al.) I'm pretty sure the new page text is okay, but I would
>> like someone knowledgeable to confirm.
>
> One more thing:
>
>> .SH "SEE ALSO"
>> .BR create_module (2),
>> .BR init_module (2),
>> .BR query_module (2),
>> .BR lsmod (8),
>> .BR rmmod (8)
>
> Shouldn't we remove the reference to query_module(2) and
> create_module(2)? They don't exist anymore (and I miss a bigger
> warning on their man pages).

I think the SEE ALSO links should be kept, but you are right that the
warnings that query_module(2) and create_module(2) no longer exist
should be more prominent on those pages. By chance, I'd already made
that change.

> Last, I think there should be a ref here to modprobe (because of -r
> flag), not lsmod. The rest looks good.

I'll add modprobe(8); I think lsmod(8) is worth keeping.

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
