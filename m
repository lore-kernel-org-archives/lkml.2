Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158Ab1AXVNw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 16:13:52 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50004 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753139Ab1AXVNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 16:13:51 -0500
MIME-Version: 1.0
In-Reply-To: <20110124203802.GC29975@ghostprotocols.net>
References: <20110124133400.GA1228@elte.hu> <AANLkTinsVNy9a1bR0AgD7=Vupoujt03RuZ32v39XSknx@mail.gmail.com>
 <20110124200738.GA10833@elte.hu> <AANLkTi=C0L=21zhH_L+cRPv2ZCRE9L93tKtC9ELrcTBW@mail.gmail.com>
 <AANLkTi=V61L6vgFZ_4u20dZvv2=tvi-XJMc2HqOnjMo4@mail.gmail.com> <20110124203802.GC29975@ghostprotocols.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 25 Jan 2011 07:13:28 +1000
Message-ID: <AANLkTikGAg9KtTwiM0eago-BLvnWsWnSfuv+zBjBE6VH@mail.gmail.com>
Subject: Re: [GIT PULL] perf fixes
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 6:38 AM, Arnaldo Carvalho de Melo
<acme@redhat.com> wrote:
>
> Was this on a freshly installed machine? Or on a freshly updated one?

It is. And the machine is slow too.

> Probably its the build-id collecting at the end of a session, on the
> first run you had a cold cache and it had to figure out which binaries
> to cache on ~/.debug, second time it was already cached so it was fast.

That sounds like a reasonable explanation.

So just ignore this report,

             Linus
