Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861Ab1L3UNF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Dec 2011 15:13:05 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40585 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab1L3UNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Dec 2011 15:13:02 -0500
MIME-Version: 1.0
In-Reply-To: <20111230094733.GY23376@infomag.iguana.be>
References: <20111227194444.GV23376@infomag.iguana.be> <CA+55aFzk_3VqxbOaAphbVacmi1fBFqxA-nSYLpXDztbihJ3U5Q@mail.gmail.com>
 <20111230094733.GY23376@infomag.iguana.be>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 30 Dec 2011 12:12:40 -0800
X-Google-Sender-Auth: HLRyUkxT96IrwOK833lw_Rs6ZUo
Message-ID: <CA+55aFw3DJXs1Y74M0bGqC90t3Lgo+e37=XqCseuuswMg5ZCwg@mail.gmail.com>
Subject: Re: [GIT PULL REQUEST] watchdog - v3.1-rc7 - Fixes
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Mingarelli@infomag.iguana.be, Thomas <Thomas.Mingarelli@hp.com>,
        Nick Bowler <nbowler@elliptictech.com>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 30, 2011 at 1:47 AM, Wim Van Sebroeck <wim@iguana.be> wrote:
>
> I'll make sure that you get future requests in this format.

So if HEAD points to master now, I actually do prefer the version that
doesn't even mention it so that the merge commit message doesn't
contain noise that doesn't actually tell you anything remotely
interesting.

Of course, I should in fact just make git not even say that whole
"branch 'master'" thing if it's the default HEAD, and then it wouldn't
matter.

It's only if you do something odd and make HEAD point to a non-master
branch in a public repository (switching branches in a bare repository
is certainly possible, but why would you do that?) that the explicit
"master" suddenly becomes relevant.

                   Linus
