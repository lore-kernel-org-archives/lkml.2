Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104Ab2E1UQO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 16:16:14 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:48042 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755032Ab2E1UQN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 16:16:13 -0400
MIME-Version: 1.0
In-Reply-To: <CAPM=9tzcAW=zhMcS4daBEeFyh5TffcYud8Lo-ooA6zuoeT-yjQ@mail.gmail.com>
References: <20120420020013.GA19964@windriver.com>
	<CAPM=9tzcAW=zhMcS4daBEeFyh5TffcYud8Lo-ooA6zuoeT-yjQ@mail.gmail.com>
Date: Mon, 28 May 2012 22:16:11 +0200
X-Google-Sender-Auth: AwiwSVbkFr7SMu09VjCRCxx9tG4
Message-ID: <CAMuHMdWPgA46=hp+gVR9Je9rjO7-x0AXRtUdpS_TqfP5kEtQSg@mail.gmail.com>
Subject: Re: linux-next: triage for April 19, 2012
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Dave Airlie <airlied@gmail.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 28, 2012 at 4:56 PM, Dave Airlie <airlied@gmail.com> wrote:
> On Fri, Apr 20, 2012 at 3:00 AM, Paul Gortmaker
> <paul.gortmaker@windriver.com> wrote:
>> The "undefined reference to `vga_default_device'" stuff appears to
>> still be unresolved, as it was in the Apr 19 fails still.     :-(
>> [ https://lkml.org/lkml/2012/4/18/157 ]
>>
>
> Can you say what arch/logs had this fail in it?
>
> If its only m68k then hopefully Geert merges his patch to fix it.

I never saw this happen on m68k.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
