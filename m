Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520Ab1AXUSQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 15:18:16 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50312 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752346Ab1AXUSO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 15:18:14 -0500
MIME-Version: 1.0
In-Reply-To: <20110124200738.GA10833@elte.hu>
References: <20110124133400.GA1228@elte.hu> <AANLkTinsVNy9a1bR0AgD7=Vupoujt03RuZ32v39XSknx@mail.gmail.com>
 <20110124200738.GA10833@elte.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 25 Jan 2011 06:17:01 +1000
Message-ID: <AANLkTi=C0L=21zhH_L+cRPv2ZCRE9L93tKtC9ELrcTBW@mail.gmail.com>
Subject: Re: [GIT PULL] perf fixes
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 6:07 AM, Ingo Molnar <mingo@elte.hu> wrote:
>>
>>     perf report -agf sleep 10
>
> (that's perf record i guess?)

Eh. Yes,

>> Is it just me?
>
> We used to have such bugs recently so i'm quite sure what you see is real.
>
> The above test is almost the same what i did before sending you the pull request, so
> it's not occuring all the time and on all boxes.

It only happens for me with "g". With "perf record -af sleep 10" it worked.

> The distro version on that box you are using would be helpful, plus the build output
> you get when you build 'tools/perf'. (I.e. which libraries are there. If it comes up
> empty with no complaints you have all the devel libraries.)

It's up-to-date Fedora 14 on x86-32.

And there's no build output at all, except for the trivial:

  [torvalds@eeepc perf]$ make
  PERF_VERSION = 2.6.38.rc2.62.gec30f3.dirty
      GEN common-cmds.h
      * new build flags or prefix
      CC perf.o
      CC builtin-annotate.o
      CC builtin-bench.o
      ...

so I have everything installed.

                    Linus
