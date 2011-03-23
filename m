Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613Ab1CWRrY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 13:47:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:11322 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753055Ab1CWRrW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 13:47:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,232,1299484800"; 
   d="scan'208";a="616919052"
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@kernel.org>,
        Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Daniel Lezcano <daniel.lezcano@free.fr>,
        Eric Paris <eparis@redhat.com>, Roman Zippel <zippel@linux-m68k.org>,
        linux-kbuild@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: PATCH][RFC][resend] CC_OPTIMIZE_FOR_SIZE should default to N
References: <alpine.LNX.2.00.1103212105490.15815@swampdragon.chaosbits.net>
	<AANLkTinmAJsXy=iJ5Fq-+CLTAGXTtLGhULRUf=Q1rkY1@mail.gmail.com>
	<20110322102741.GA4448@elte.hu>
	<AANLkTikz+vJGFuysDXAdVb33q1q3L547dXNJa9NmeqeM@mail.gmail.com>
Date: Wed, 23 Mar 2011 10:45:48 -0700
In-Reply-To: <AANLkTikz+vJGFuysDXAdVb33q1q3L547dXNJa9NmeqeM@mail.gmail.com>
	(Linus Torvalds's message of "Tue, 22 Mar 2011 09:59:59 -0700")
Message-ID: <m21v1x91df.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Tue, Mar 22, 2011 at 3:27 AM, Ingo Molnar <mingo@elte.hu> wrote:
>>
>> If that situation has changed - if GCC has regressed in this area then a commit
>> changing the default IMHO gains a lot of credibility if it is backed by careful
>> measurements using perf stat --repeat or similar tools.
>
> Also, please don't back up any numbers for the "-O2 is faster than
> -Os" case with some benchmark that is hot in the caches.

Haven't done it recently, but some time last year -O2 vs -Os
made a measurable difference in large OLTP benchmarks.

(-Os being worse of course -- friends don't let friends use -Os)

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
