Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757159Ab0ICOru (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 10:47:50 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59789 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964Ab0ICOrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 10:47:48 -0400
Date: Fri, 3 Sep 2010 16:47:42 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Li Zefan <lizf@cn.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [ANNOUNCEMENT] LTTng tracer re-packaged as stand-alone modules
Message-ID: <20100903164742.087da8f4@basil.nowhere.org>
In-Reply-To: <20100903131213.GA3230@Krystal>
References: <20100903131213.GA3230@Krystal>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Sep 2010 09:12:13 -0400
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> Here is a news that should please Linux distributions which have been
> overwhelmed by the size of the LTTng patchset. I have extracted the
> LTTng tracer patches from the LTTng kernel tree and repackaged it
> into a new "lttng-modules" package. There is still a dependency on
> the LTTng kernel tree at the moment, but the objective is to
> gradually reduce the size of this 5 years long mainline fork.

Efforts to get rid of forks are always good.

Could you perhaps elaborate a bit what changes you need
in mainline (ideally separated in "essential" and "nice to
have") and how big the left over patches are?

Or rather how difficult would it be to simply run
the LTT userland on top of the tracing code that is
in mainline, even at loss of some functionality?

Thanks,

-Andi
