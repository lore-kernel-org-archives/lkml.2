Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417Ab2DQTvH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 15:51:07 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:63822 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472Ab2DQTvF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 15:51:05 -0400
MIME-Version: 1.0
In-Reply-To: <878vhufcrk.fsf@turtle.gmx.de>
References: <CA+55aFzsjpJt09b6e4NA0T50M3w0xtASSYXz_=UWVDqKRywo=A@mail.gmail.com>
 <87pqb6fkji.fsf@turtle.gmx.de> <CA+55aFxhb6hriqHHwVtNeYHmtcy5JCEJX-zABBcG2Zjw_gawPw@mail.gmail.com>
 <878vhufcrk.fsf@turtle.gmx.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 17 Apr 2012 12:50:43 -0700
X-Google-Sender-Auth: Qnw7k5LoaHxbchFEBQlXaZR8cqw
Message-ID: <CA+55aFychSQgAG8raDq9rvXm3Lq7GFdByCd3-NZERieyTdAc2g@mail.gmail.com>
Subject: Re: kernel panic after suspend/resume
To: Sven Joachim <svenjoac@gmx.de>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 11:12 AM, Sven Joachim <svenjoac@gmx.de> wrote:
>
> So far, it has repeated itself every time I suspended with 3.4-rc3,
> i.e. three times.  That's a small sample, so the bisection might not be
> reliable (especially since the crashes happened with delay), but I can
> try.
>
>>  - how sure are you that rc2 is fine?
>
> Reasonably sure, I had been running rc2 for the whole last week and
> suspended about 20 times without any problems whatsoever.

Ok, that sounds very hopeful for bisection. If it has happened three
out of three times, it doesn't sound like it's some subtle timing
race.

                       Linus
