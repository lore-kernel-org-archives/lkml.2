Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755704Ab0HCJPh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 05:15:37 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:45455 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755665Ab0HCJPf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 05:15:35 -0400
Message-ID: <1280826924.4c57de2c3a6b0@imp.free.fr>
Date: Tue, 03 Aug 2010 11:15:24 +0200
From: damien.wyart@free.fr
To: Zeno Davatz <zdavatz@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Damien Wyart <damien.wyart@free.fr>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        mingo@elte.hu, yinghai@kernel.org
Subject: Re: kmemleak, cpu usage jump out of nowhere
References: <AANLkTinGoUml9PQ8w7flukqwF9V1ae-YafiDVQy6Q8gC@mail.gmail.com> <AANLkTimgn1Xa0YIwjC6xOfNDjlqJSQYy65ZvqCtlMWHD@mail.gmail.com> <1279100846.8592.53.camel@e102109-lin.cambridge.arm.com> <4C3D89AC.4040303@cs.helsinki.fi> <1279205891.6664.46.camel@e102109-lin.cambridge.arm.com> <AANLkTikJeA-bZEk652QwwT4iY21v5tr6RCzcZAZGgS8D@mail.gmail.com> <4C3F2F52.2050101@cs.helsinki.fi> <20100715162805.GA10240@brouette> <20100715191638.GA3694@brouette> <AANLkTim7SURv8DPTLC2JwOJvv1WMAR4mmyBp9XqXw_Py@mail.gmail.com> <20100715200012.GA4175@brouette> <AANLkTilnLXVSkWfnaPtpzxH-C3-5h1mnBz3O0vAFHG32@mail.gmail.com> <1280826359.1923.440.camel@laptop> <AANLkTi=VuLwcmjTpOeK-OzgiWeycu14hJpfUuH9cKnUj@mail.gmail.com>
In-Reply-To: <AANLkTi=VuLwcmjTpOeK-OzgiWeycu14hJpfUuH9cKnUj@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) 3.2.8
X-Originating-IP: 193.252.149.197
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Vacation.. but now I'm back ;-)
> >
> > Even something simple as: perf top -r 1 (make sure you're root in order
> > to run with real-time prios) could give a clue as to what is consuming
> > all your cpu-time.
> >
> > Or did the issue get sorted already?
>
> Thank you for the hint.
>
> I am on 2.6.35 now and all seems to be fine again.

Are you 100% sure you compiled it with CONFIG_NO_BOOTMEM enabled?

I did not test 2.6.35 yet but I did not see anything related to this bug
commited since the discussion so I am very surprised the problem disappeared by
itself...

Will be on vacation very soon, so not sure I will have time to test 2.6.35
before leaving.

Damien
