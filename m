Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933627Ab2GFWJt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 18:09:49 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:38604 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933477Ab2GFWJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 18:09:48 -0400
MIME-Version: 1.0
In-Reply-To: <CAGoecWxymi-jrTO5AdeYRMkbqdrk6je9xaUKmBry=LGqNC-D0w@mail.gmail.com>
References: <CAGoecWyMKF4gC7FaoBCrBs+rD=u6oJRHS5Q2qVkkwoZZ1_4RCg@mail.gmail.com>
 <20120706203825.20ce3e47@pyramind.ukuu.org.uk> <CAGoecWxymi-jrTO5AdeYRMkbqdrk6je9xaUKmBry=LGqNC-D0w@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 6 Jul 2012 15:09:23 -0700
X-Google-Sender-Auth: 9abI9sTN6JjwXalnXjy8VMF9qus
Message-ID: <CA+55aFwnLJ+0sjx92EGREGTWOx84wwKaraSzpTNJwPVV8edw8g@mail.gmail.com>
Subject: Re: Regression - /proc/kmsg does not (always) block for 1-byte reads
To: Jukka Ollila <jiiksteri@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        kay@vrfy.org, jbeulich@novell.com, greg@kroah.com, joey@debian.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 6, 2012 at 3:05 PM, Jukka Ollila <jiiksteri@gmail.com> wrote:
>
> Now this got me wondering if Debian _unstable_ actually qualifies as a
> standard distro userspace.

Oh, if the kernel breaks some standard user space, that counts. Tons
of people run Debian unstable (and from my limited interactions with
it, for damn good reasons: -stable tends to run so old versions of
everything that you have to sometimes deal with cuneiform writing when
using it)

                    Linus
