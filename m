Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928Ab2L1Tom (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:44:42 -0500
Received: from mail-vc0-f173.google.com ([209.85.220.173]:57378 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754682Ab2L1Tog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:44:36 -0500
MIME-Version: 1.0
In-Reply-To: <20121228193613.GB4939@ZenIV.linux.org.uk>
References: <1356722870-18325-1-git-send-email-geert@linux-m68k.org>
	<20121228193613.GB4939@ZenIV.linux.org.uk>
Date: Fri, 28 Dec 2012 20:44:35 +0100
X-Google-Sender-Auth: C3eKU00lukDCiFgV9G_R7JfZBJs
Message-ID: <CAMuHMdWPVJr=v0ByKD1FMyWn=c_cmUaSHSFq6AiD_wi1oVeWHw@mail.gmail.com>
Subject: Re: [PATCH] get_maintainer.pl: Find maintainers for removed files
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 28, 2012 at 8:36 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Fri, Dec 28, 2012 at 08:27:50PM +0100, Geert Uytterhoeven wrote:
>> For removed files, get_maintainer.pl doesn't find any maintainers (besides
>> the default linux-kernel@vger.kernel.org), as it only looks at the "+++"
>> lines, which are "/dev/null" for removals.
>> Fix this by extending the parsing to the "---" lines.
>>
>> E.g. for the two line test patch below the real score maintainers will now
>> be found:
>
> *snort*
>
> I'm afraid that finding anybody matching that description would reqiure
> a functioning time machine.  AFAICT, arch/score has been orphaned for
> several years.

;-)

Sorry, I meant the maintainers listed in MAINTAINERS.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
