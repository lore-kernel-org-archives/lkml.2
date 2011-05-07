Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986Ab1EGLmG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 07:42:06 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60741 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256Ab1EGLmB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 07:42:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=hyupXGNk8IBxppB9aQx9D7BQi9BgDXMX9pSnqG6PWHxrnLLEbNwN2x+CnkNIMgQzht
         BWKJrWfJ53eFqhe2R5bjZmMYVy3XIH22zqlQDXktHJVGhZyLbvKCetuW2TBfBALni6SV
         CVuNfdGi1Wr1feNVYvtIwM5KjEM7uT3UbB/pM=
MIME-Version: 1.0
In-Reply-To: <1304749754.2821.712.camel@edumazet-laptop>
References: <1304743740-3405-1-git-send-email-xiaosuo@gmail.com>
	<1304748394.2821.654.camel@edumazet-laptop>
	<BANLkTi=tZf1uQig8A-WiXUpSWcuqaqV=fg@mail.gmail.com>
	<1304749754.2821.712.camel@edumazet-laptop>
Date: Sat, 7 May 2011 13:41:59 +0200
X-Google-Sender-Auth: ropujRA0v1WCs-I_YCW3XqMRsF4
Message-ID: <BANLkTiktdStx1e5vHk7AqO+pYVXm-PjsQg@mail.gmail.com>
Subject: Re: [PATCH] fs: add FD_CLOFORK and O_CLOFORK
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Changli Gao <xiaosuo@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Matthew Wilcox <matthew@wil.cx>, Arnd Bergmann <arnd@arndb.de>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 7, 2011 at 08:29, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> I am sure the following idea already was discussed in the past :
>
> Embed the close_on_exec / close_on_close bits in the low order bits of
> file pointers.

How many low order bits do you expect to have in file pointers?
Are files allocated using kmalloc(), or do they just obey the alignment of the
individual members of a file struct? In the latter case, you'll have onlyv1 low
order bit to play with on m68k.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
