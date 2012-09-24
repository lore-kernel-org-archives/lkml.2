Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757818Ab2IXTEx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 15:04:53 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:35873 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757597Ab2IXTEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 15:04:52 -0400
MIME-Version: 1.0
In-Reply-To: <20120924190034.GF2492@redhat.com>
References: <1348011407-24108-1-git-send-email-jim.cromie@gmail.com>
	<1348011407-24108-4-git-send-email-jim.cromie@gmail.com>
	<20120924190034.GF2492@redhat.com>
Date: Mon, 24 Sep 2012 21:04:51 +0200
X-Google-Sender-Auth: sD1t6iPbAOMK847kBRDzlGp0MgI
Message-ID: <CAMuHMdVFSH5W=xStG5b3O=7vkVY78LLnnURPP7igCdMct27tFg@mail.gmail.com>
Subject: Re: [PATCH 3/6] dyndbg: add more info to -E2BIG log warning
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jason Baron <jbaron@redhat.com>
Cc: Jim Cromie <jim.cromie@gmail.com>, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 9:00 PM, Jason Baron <jbaron@redhat.com> wrote:
>> -             pr_warn("expected <%d bytes into control\n", USER_BUF_PAGE);

%u?

>> +             pr_warn("expected <%d bytes into control, you wrote %d\n",
>> +                     USER_BUF_PAGE, (int) len);
>
> The style here, I think, is generally to leave out the space, ie: (int)len.

Better, remove the cast and use "%zu" to properly format the size_t.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
