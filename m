Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab1CKA55 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 19:57:57 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52479 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753051Ab1CKA54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 19:57:56 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTikiy+hNgG=BRWKkHEHCdvJnffWP6nhp1XxsEEO+@mail.gmail.com>
References: <20110310.153444.115930379.davem@davemloft.net>
 <AANLkTimnHtVS=SFopgyjAAQDW8bXDKDXf+YvEtPdpPsA@mail.gmail.com>
 <20110310.155556.48513201.davem@davemloft.net> <AANLkTik3AyFTNoytebmOOZ=JSFMkt0bw7au-CSncUHJu@mail.gmail.com>
 <AANLkTiktUsR1vXo84H2m_tLZRgDGee+JdvxGZjX7hYMq@mail.gmail.com> <AANLkTikiy+hNgG=BRWKkHEHCdvJnffWP6nhp1XxsEEO+@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 10 Mar 2011 16:57:04 -0800
Message-ID: <AANLkTi=F=za4OaNbiT71oTj+HKZG1sJE=YrrjpUb4AS7@mail.gmail.com>
Subject: Re: [GIT] Networking
To: Dave Airlie <airlied@gmail.com>
Cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 4:40 PM, Dave Airlie <airlied@gmail.com> wrote:
>
> I didn't realise we weren't meant to --no-ff, I've been lately using
> --no-ff --log
> so I can keep track of what I merged easier, when someone bases something on my
> tree and I haven't moved it in a while.

Well, the whole "--no-ff --log" is really designed for exactly that.
It's the "I'm the upstream maintainer, and I want that nice merge
summary". And it really is useful for that.

So I don't know about "weren't meant to". It very much is why those
flags exist (I don't personally use "--log", but that's because since
I'm the very top maintainer I've just set the flag in my .git/config
flag that makes _all_ my merges logging merges).

It's just that when I started doing git, the fast-forward merge was
very much a design decision. But I have to admit that I really like my
merge summaries too, and the main reason I have never really
considered using --no-ff is that _my_ tree moves so often that
practically speaking, I never fast-forward. If I get a fast-forward
merge, it almost always means that some submaintainer did something
iffy (like rebase his tree), and that the commits from that
submaintainer haven't been around for very long.

So no, I don't think you've been wrong in using "--no-ff --log". It
does make sense.

I just have my own private hang-ups about why I'm not personally a
huge fan of --no-ff.

But now that I've done it once, maybe I'm hooked. It's like coke to
Charlie Sheen.

                          Linus
