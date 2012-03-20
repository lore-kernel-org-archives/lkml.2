Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758083Ab2CTVpa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 17:45:30 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:37767 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755245Ab2CTVp3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 17:45:29 -0400
MIME-Version: 1.0
In-Reply-To: <4F68F2FB.60401@xenotime.net>
References: <1332277125-10785-1-git-send-email-geert@linux-m68k.org>
	<4F68F2FB.60401@xenotime.net>
Date: Tue, 20 Mar 2012 22:45:27 +0100
X-Google-Sender-Auth: Wz-AZmkkawqUDNaVLJld02Iz2gY
Message-ID: <CAMuHMdVpxW4oD2HOpLcBYd9NJGqW-xG3s47zx7ZSSp_S9rqfNA@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.3
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2012 at 22:13, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On 03/20/2012 01:58 PM, Geert Uytterhoeven wrote:
> > Below is the list of build error/warning regressions/improvements in
> > v3.3[1] compared to v3.2[2].
> >
> > Summarized:
> >   - build errors: +956/-112
> >   - build warnings: +3135/-617
> >
> > JFYI, when comparing v3.3 to v3.3-rc7[3], the summaries are:
> >   - build errors: +927/-91
> >   - build warnings: +2464/-505
>
> This is with the newly built tools, right?

Yep.

> Where is the WARNINGS section?

Not included due to size, cfr. below.

> > Note that there may be false regressions:
> >   - The number of configs increased from 106 to 116,
> >   - The new toolchains emit a lot more warnings,
> >   - The new toolchains add information about which warning option
> >     triggered a warning. I postprocessed the logs to remove these
> >     annotations, but there may still be slight differences left.
> > As a consequence, I only kept the build error regressions in the report
> > below. 412 KiB was just too much for lkml.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
