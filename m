Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760062Ab0KSBLz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 20:11:55 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41348 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754896Ab0KSBLy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 20:11:54 -0500
MIME-Version: 1.0
In-Reply-To: <20101119005942.GL6024@const.famille.thibault.fr>
References: <1289916171.5169.117.camel@maggy.simson.net> <AANLkTimC_TWzKET-aabYK0TPG6fUUW06HDej6iOzYtKo@mail.gmail.com>
 <20101116211431.GA15211@tango.0pointer.de> <201011182333.48281.hpj@urpla.net>
 <20101118231218.GX6024@const.famille.thibault.fr> <1290123351.18039.49.camel@maggy.simson.net>
 <20101118234339.GA6024@const.famille.thibault.fr> <AANLkTimTNxLYGLgnS9TUT_YiMnmDVrqseByGGogj+A4Z@mail.gmail.com>
 <20101119000204.GE6024@const.famille.thibault.fr> <AANLkTi=n4r9STKsx76t--HbK7EiUWaaPm7tUN2nXtqxA@mail.gmail.com>
 <20101119005942.GL6024@const.famille.thibault.fr>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 18 Nov 2010 17:11:00 -0800
Message-ID: <AANLkTimm4TgK9_z3ZiLwUd84aPGzKUXwoMCf_JUunoot@mail.gmail.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>, Hans-Peter Jansen <hpj@urpla.net>,
        linux-kernel@vger.kernel.org,
        Lennart Poettering <mzxreary@0pointer.de>, david@lang.hm,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Vivek Goyal <vgoyal@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 4:59 PM, Samuel Thibault
<samuel.thibault@ens-lyon.org> wrote:
>
> All right.  I believe that should already work quite well both for
> desktop and servers indeed.  "Per one graphical application" will most
> probably require desktop panel patching, however.

Sure. As mentioned somewhere earlier in this thread, I don't think
this whole grouping thing is some "either or" black-or-white thing.

So I personally like the kernel patch because it's simple, and it
"just works", regardless of what user space you happen to run. But
that doesn't mean that user space couldn't easily give additional
hints (to the point that if you end up having a distro that does
hinting for everything, you could just turn off the kernel side
entirely).

               Linus
