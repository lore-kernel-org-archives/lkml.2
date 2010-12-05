Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131Ab0LETWT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 14:22:19 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45495 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176Ab0LETWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 14:22:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=xOcUvjUMg6ZLH4j2vqYnt8NJwLulz1q0PQnBeUUh65feJj78spLX6bgBqdJQ2RkRVM
         Re85bo4pypovrbEidtF+CTa29dmpVH5m8FgtY0hDcnnfYHIrgBZIYr+1iXAxQaSmHxZv
         JO8XEsS5ElRcqargu8KfQagKePXoUBOzHDjxk=
MIME-Version: 1.0
In-Reply-To: <AANLkTiniEUdADMHUE1a9Fs1bGsWn6F6yeJX_NO4L94JK@mail.gmail.com>
References: <1289783580.495.58.camel@maggy.simson.net>
	<1289811438.2109.474.camel@laptop>
	<1289820766.16406.45.camel@maggy.simson.net>
	<1289821590.16406.47.camel@maggy.simson.net>
	<20101115125716.GA22422@redhat.com>
	<1289856350.14719.135.camel@maggy.simson.net>
	<20101116130413.GA29368@redhat.com>
	<1289917109.5169.131.camel@maggy.simson.net>
	<20101116150319.GA3475@redhat.com>
	<1289922108.5169.185.camel@maggy.simson.net>
	<20101116172804.GA9930@elte.hu>
	<1290281700.28711.9.camel@maggy.simson.net>
	<AANLkTinz12n9OKkCV8XRF8n1vKytO_aj26i-ytcAhFgN@mail.gmail.com>
	<AANLkTinWQkiadp7NCVt401bFiATJeqTK1g81RcP2awCv@mail.gmail.com>
	<AANLkTinmgsBQ624habviTTj7khCdZH_p2m5mX24_SV9j@mail.gmail.com>
	<AANLkTikFXv042qg4uzXF--9_co6-b_UgJF7Jeo2bVA=f@mail.gmail.com>
	<AANLkTikrc+_r1KE477c-NeD-9PWDOXx1ExHGm08Lm6wM@mail.gmail.com>
	<AANLkTiniEUdADMHUE1a9Fs1bGsWn6F6yeJX_NO4L94JK@mail.gmail.com>
Date: Sun, 5 Dec 2010 14:22:17 -0500
X-Google-Sender-Auth: SfPJQaCuHZX27xm6euOghpi-0Ow
Message-ID: <AANLkTi=7FRCK9R2PVCTdtSqKo9FZemD5cXQTFoOKLEFB@mail.gmail.com>
Subject: Re: [PATCH v4] sched: automated per session task groups
From: Colin Walters <walters@verbum.org>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
        Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 5, 2010 at 2:47 AM, Ray Lee <ray-lk@madrabbit.org> wrote:
> On Sat, Dec 4, 2010 at 3:43 PM, Colin Walters <walters@verbum.org> wrote:
>> So if it's a heuristic the OS can get wrong, wouldn't it be a good
>> idea to support a way for programs and/or interactive users to
>> explicitly specify things?
>
> Consider a multi-user machine. `nice` is an orthogonal concern in that
> case. Therefore, fixing nice doesn't address all issues.

For the purposes of this discussion again, let's say "fixing nice"
means say "group schedule each nice level above 0".  There are
obviously many possibilities here, but let's consider this one
precisely.

How, exactly, under what scenario in a "multi-user machine" does this
break?  How exactly is it orthogonal?

Two people logged in would get their "make" jobs group scheduled
together.  What is the problem?

Since Linus appears to be more interested in talking about nipples
than explaining exactly what it would break, but you appear to agree
with him, hopefully you'll be able to explain...
