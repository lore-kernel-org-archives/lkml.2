Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271Ab0LDXci (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Dec 2010 18:32:38 -0500
Received: from mail.lang.hm ([64.81.33.126]:55902 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755060Ab0LDXch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Dec 2010 18:32:37 -0500
Date: Sat, 4 Dec 2010 15:31:59 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Colin Walters <walters@verbum.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
        Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] sched: automated per session task groups
In-Reply-To: <AANLkTinmgsBQ624habviTTj7khCdZH_p2m5mX24_SV9j@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1012041530280.16807@asgard.lang.hm>
References: <1289783580.495.58.camel@maggy.simson.net> <1289811438.2109.474.camel@laptop> <1289820766.16406.45.camel@maggy.simson.net> <1289821590.16406.47.camel@maggy.simson.net> <20101115125716.GA22422@redhat.com> <1289856350.14719.135.camel@maggy.simson.net>
 <20101116130413.GA29368@redhat.com> <1289917109.5169.131.camel@maggy.simson.net> <20101116150319.GA3475@redhat.com> <1289922108.5169.185.camel@maggy.simson.net> <20101116172804.GA9930@elte.hu> <1290281700.28711.9.camel@maggy.simson.net>
 <AANLkTinz12n9OKkCV8XRF8n1vKytO_aj26i-ytcAhFgN@mail.gmail.com> <AANLkTinWQkiadp7NCVt401bFiATJeqTK1g81RcP2awCv@mail.gmail.com> <AANLkTinmgsBQ624habviTTj7khCdZH_p2m5mX24_SV9j@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 4 Dec 2010, Colin Walters wrote:

> Speaking of the scheduler documentation - note that its sample shell
> code contains exactly the problem showing what's wrong with
> auto-grouping-by-tty, which is:
>
> # firefox &	# Launch firefox and move it to "browser" group
>
> As soon as you do that from the same terminal that you're going to
> launch the "make" from, you're back to total lossage.  Are you going
> to explain to a student that "oh, you need to create a new
> gnome-terminal tab and launch firefox from that"?

as someone who starts firefox from a terminal session all the time, I 
always want to start it from it's own dedicated session, if for no other 
reason that it spits out a TON of error messages over time, and I don't 
want them popping up in a window where I'm doing something else.

so this is a very bad example.

David Lang
