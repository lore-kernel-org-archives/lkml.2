Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933093Ab2EWBQH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 21:16:07 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:45073 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756837Ab2EWBQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 21:16:03 -0400
X-AuditID: 9c930197-b7be2ae000000ebb-15-4fbc3a4b2912
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 2/2] perf tools: Always try to build libtraceevent
References: <1337677434-4881-1-git-send-email-namhyung.kim@lge.com>
	<1337677434-4881-2-git-send-email-namhyung.kim@lge.com>
	<20120522153648.GD19247@infradead.org>
Date: Wed, 23 May 2012 10:13:55 +0900
In-Reply-To: <20120522153648.GD19247@infradead.org> (Arnaldo Carvalho de
	Melo's message of "Tue, 22 May 2012 12:36:48 -0300")
Message-ID: <87k4031yy4.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 22 May 2012 12:36:48 -0300, Arnaldo Carvalho de Melo wrote:
> Em Tue, May 22, 2012 at 06:03:54PM +0900, Namhyung Kim escreveu:
>> While at it, silence annoying directory change messages.
>
> Applied, have you seen these?
>
> make[1]: Entering directory `/home/git/linux/tools/lib/traceevent'
> make[2]: warning: jobserver unavailable: using -j1.  Add `+' to parent make rule.
> make[2]: `libtraceevent.a' is up to date.

Yes, but I didn't know how to handle them properly. And the first line
looks like a bug of QUIET_SUBDIR stuff. Did you build it out of the
kernel tree?

Thanks,
Namhyung
