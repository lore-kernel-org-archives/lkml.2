Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932992Ab2AEXEg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 18:04:36 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37493 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932235Ab2AEXEe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 18:04:34 -0500
MIME-Version: 1.0
In-Reply-To: <20120106084701.8f704542754db826deda318a@canb.auug.org.au>
References: <20120105145836.GA2751@redhat.com>
	<20120106083141.9c14a8d2d09539c6a6c0db75@canb.auug.org.au>
	<20120106083916.9588034bde22a6803e327aa9@canb.auug.org.au>
	<20120106084701.8f704542754db826deda318a@canb.auug.org.au>
Date: Fri, 6 Jan 2012 00:04:33 +0100
X-Google-Sender-Auth: mis9yJqEhNWFYU0MXDnRdjfyon4
Message-ID: <CAMuHMdX9x-dTju4YB9yY7mt2-DNV7=y2oW2pSfuSdfPkEhzraA@mail.gmail.com>
Subject: Re: [GIT PULL] use generic pci_iomap on all architectures
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 5, 2012 at 22:47, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> On Fri, 6 Jan 2012 08:39:16 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>
>> So why does you pull request refer to "commit
>> 805a6af8dba5dfdd35ec35dc52ec0122400b2610", I wonder?  Is that just what
>> "git request-pull" produced?
>
> I see, "git request-pull" just puts in whatever you specify on the
> command line rather than the merge-base ...

Yep, I noticed the samething, for

|git request-pull v3.2
ra.kernel.org:/pub/scm/linux/kernel/git/geert/linux-m68k.git for-linus

while for-linus is based on v3.2-rc5, not v3.2.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
