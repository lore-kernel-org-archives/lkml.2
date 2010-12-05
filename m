Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513Ab0LEAcj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Dec 2010 19:32:39 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38383 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754372Ab0LEAci convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Dec 2010 19:32:38 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTikrc+_r1KE477c-NeD-9PWDOXx1ExHGm08Lm6wM@mail.gmail.com>
References: <1289783580.495.58.camel@maggy.simson.net> <1289811438.2109.474.camel@laptop>
 <1289820766.16406.45.camel@maggy.simson.net> <1289821590.16406.47.camel@maggy.simson.net>
 <20101115125716.GA22422@redhat.com> <1289856350.14719.135.camel@maggy.simson.net>
 <20101116130413.GA29368@redhat.com> <1289917109.5169.131.camel@maggy.simson.net>
 <20101116150319.GA3475@redhat.com> <1289922108.5169.185.camel@maggy.simson.net>
 <20101116172804.GA9930@elte.hu> <1290281700.28711.9.camel@maggy.simson.net>
 <AANLkTinz12n9OKkCV8XRF8n1vKytO_aj26i-ytcAhFgN@mail.gmail.com>
 <AANLkTinWQkiadp7NCVt401bFiATJeqTK1g81RcP2awCv@mail.gmail.com>
 <AANLkTinmgsBQ624habviTTj7khCdZH_p2m5mX24_SV9j@mail.gmail.com>
 <AANLkTikFXv042qg4uzXF--9_co6-b_UgJF7Jeo2bVA=f@mail.gmail.com> <AANLkTikrc+_r1KE477c-NeD-9PWDOXx1ExHGm08Lm6wM@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 4 Dec 2010 16:31:42 -0800
Message-ID: <AANLkTin1PkoBtsXjipce5kUPMoEvRdaBomYjijC4goVM@mail.gmail.com>
Subject: Re: [PATCH v4] sched: automated per session task groups
To: Colin Walters <walters@verbum.org>
Cc: Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
        Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 4, 2010 at 3:43 PM, Colin Walters <walters@verbum.org> wrote:
> On Sat, Dec 4, 2010 at 5:39 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>
>> And it doesn't hurt you. If you're happy with "nice", go on and use
>> it. Why are you even discussing it?
>
> Because it seems to me like a bug if it isn't as good as group
> scheduling?  Most of your message is saying it's worthless, and I
> don't disagree that it's not very good *right now*.  I guess where we
> disagree is whether it's worth fixing.

It's not worth 'fixing", because it works exactly like it's designed -
and supposed - to work.

There really isn't anything to fix. 'nice' is what it is. It's a
simple legacy interface to scheduler priority. The fact that it's also
almost totally useless is irrelevant. It's like male nipples. We
wouldn't be better off lactating, and they look like some odd wart
that doesn't do much good. But it would be worse to remove it.

'nice' is a bad idea. It's a bad idea that has perfectly
understandable historical reasons for it, but it's an _unfixably_ bad
idea.

                      Linus
