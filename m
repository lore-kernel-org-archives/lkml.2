Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994Ab2DQSM4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 14:12:56 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:44569 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754793Ab2DQSMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 14:12:54 -0400
X-Authenticated: #28250155
X-Provags-ID: V01U2FsdGVkX1/+RYlUtK/+rSHgRjw+HxBck9kAb97bEkbRiDpFml
	BBnaaytJg+FNQx
From: Sven Joachim <svenjoac@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kernel panic after suspend/resume
References: <CA+55aFzsjpJt09b6e4NA0T50M3w0xtASSYXz_=UWVDqKRywo=A@mail.gmail.com>
	<87pqb6fkji.fsf@turtle.gmx.de>
	<CA+55aFxhb6hriqHHwVtNeYHmtcy5JCEJX-zABBcG2Zjw_gawPw@mail.gmail.com>
Date: Tue, 17 Apr 2012 20:12:47 +0200
In-Reply-To: <CA+55aFxhb6hriqHHwVtNeYHmtcy5JCEJX-zABBcG2Zjw_gawPw@mail.gmail.com>
	(Linus Torvalds's message of "Tue, 17 Apr 2012 09:00:48 -0700")
Message-ID: <878vhufcrk.fsf@turtle.gmx.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-04-17 18:00 +0200, Linus Torvalds wrote:

> Two questions:
>
>  - if it is reasonably repeatable, can you try to bisect it?

So far, it has repeated itself every time I suspended with 3.4-rc3,
i.e. three times.  That's a small sample, so the bisection might not be
reliable (especially since the crashes happened with delay), but I can
try.

>  - how sure are you that rc2 is fine?

Reasonably sure, I had been running rc2 for the whole last week and
suspended about 20 times without any problems whatsoever.

Cheers,
       Sven
