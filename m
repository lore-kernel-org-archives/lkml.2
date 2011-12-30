Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838Ab1L3BfQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 20:35:16 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59988 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754171Ab1L3BfN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 20:35:13 -0500
MIME-Version: 1.0
In-Reply-To: <20111227194444.GV23376@infomag.iguana.be>
References: <20111227194444.GV23376@infomag.iguana.be>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 29 Dec 2011 17:34:49 -0800
X-Google-Sender-Auth: _nolua8Jup29b6sVIf-SZr0h5cw
Message-ID: <CA+55aFzk_3VqxbOaAphbVacmi1fBFqxA-nSYLpXDztbihJ3U5Q@mail.gmail.com>
Subject: Re: [GIT PULL REQUEST] watchdog - v3.1-rc7 - Fixes
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Mingarelli@infomag.iguana.be, Thomas <Thomas.Mingarelli@hp.com>,
        Nick Bowler <nbowler@elliptictech.com>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 27, 2011 at 11:44 AM, Wim Van Sebroeck <wim@iguana.be> wrote:
> Hi Linus,
>
> Please pull from 'master' branch of
>        git://www.linux-watchdog.org/linux-watchdog.git
>
> This will update the following files:

You have done something absolutely horrible with that git repository.

The default HEAD does not actually point to the master branch, so the
thing you asked me to pull
("git://www.linux-watchdog.org/linux-watchdog.git" without any branch
name) does not actually result in what you claimed it would result in.

It looks like HEAD points to "linux-next".

Sure, the above is technically a valid git repository, but (a) it's
crazy and (b) if you really want to do that, then you had better
actually mention the branch explicitly in the pull line too, ie

  Please pull ..

     git://www.linux-watchdog.org/linux-watchdog.git master

so that when I cut-and-paste, I actually get the right branch.

As it is, it's just horribly confusing.

                     Linus
